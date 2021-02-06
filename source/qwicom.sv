// ****************************************************************************
// plus1.sv
// ****************************************************************************
module plus1
#(
   parameter               DWID = 32,
   parameter               LOOP = "true"
)
(
   input                   CLR,
   input                   EN,
   input      [DWID-1:0]   DI,
   output reg [DWID-1:0]   DO
);

wire clear;

generate
   if(LOOP == "true")
   begin
      assign clear = ((DI == {DWID{1'b1}} && EN) || CLR);
   end
   else
   begin
      assign clear = CLR;
   end
endgenerate

always @(*)
begin
   if(clear)
      DO = {DWID{1'b0}};
   else if(EN)
      DO = DI + ~&DI;
   else
      DO = DI;
end

endmodule


// ****************************************************************************
// minus1.sv
// ****************************************************************************
module minus1
#(
   parameter               DWID = 32,
   parameter               LOOP = "true"
)
(
   input                   CLR,
   input                   EN,
   input      [DWID-1:0]   DI,
   output reg [DWID-1:0]   DO
);

wire clear;

generate
   if(LOOP == "true")
   begin
      assign clear = (DI == {DWID{1'b0}} || CLR);
   end
   else
   begin
      assign clear = CLR;
   end
endgenerate

always @(*)
begin
   if(clear)
      DO = {DWID{1'b1}};
   else if(EN)
      DO = DI - |DI;
   else
      DO = DI;
end

endmodule

// ****************************************************************************
// fifo.sv
// ****************************************************************************
module fifo
#(
   parameter               DWID = 32,
   parameter               AWID = 10,
   parameter               SYNC = "true"
)
(
   input                   RST,
   input                   WRCLK,
   input                   WRENA,
   input      [DWID-1:0]   WRDAT,
   output     [AWID-1:0]   WRLEV,

   input                   RDCLK,
   input                   RDENA,
   output     [DWID-1:0]   RDDAT,
   output     [AWID-1:0]   RDLEV
);

reg  [DWID-1:0] mem [0:2**AWID-1];

wire            wr_rst;
wire            rd_rst;
reg  [AWID-1:0] wr_ptr = 0;
wire [AWID-1:0] wr_ptr_plus;
wire [AWID-1:0] wr_ptr_rd;
reg  [AWID-1:0] rd_ptr = 0;
wire [AWID-1:0] rd_ptr_plus;
wire [AWID-1:0] rd_ptr_wr;
reg             wr_full;
reg             rd_empty;

sync_clock #(
   .DWID ( 1 )
) wr_rst_sync (
   .CLK  ( WRCLK ),
   .DI   ( RST ),
   .DO   ( wr_rst )
);

sync_clock #(
   .DWID ( 1 )
) rd_rst_sync (
   .CLK  ( RDCLK ),
   .DI   ( RST ),
   .DO   ( rd_rst )
);

// WR
always @(posedge WRCLK)
begin
   wr_ptr <= wr_ptr_plus;
end

plus1 #(
   .DWID ( AWID ),
   .LOOP ( "true" )
) wr_ptr_plus1 (
   .CLR  ( wr_rst ),
   .EN   ( WRENA && !wr_full ),
   .DI   ( wr_ptr ),
   .DO   ( wr_ptr_plus )
);

always @(posedge WRCLK)
begin
   if(WRENA && !wr_full)
      mem[wr_ptr] <= WRDAT;
end

generate
   if(SYNC == "true")
   begin
      assign rd_ptr_wr = rd_ptr;
      assign wr_ptr_rd = wr_ptr;
   end
   else
   begin
      sync_clock #(
         .DWID ( AWID )
      ) rd_ptr_sync (
         .CLK  ( WRCLK ),
         .DI   ( rd_ptr ),
         .DO   ( rd_ptr_wr )
      );

      sync_clock #(
         .DWID ( AWID )
      ) wr_ptr_sync (
         .CLK  ( RDCLK ),
         .DI   ( wr_ptr ),
         .DO   ( wr_ptr_rd )
      );
   end
endgenerate

load #(
   .DWID    ( AWID + 1 ),
   .DEFAULT ( {1'b1, {AWID{1'b0}}} )
) wr_load (
   .RST     ( wr_rst ),
   .DI      ( {&(wr_ptr - rd_ptr_wr), (wr_ptr - rd_ptr_wr)} ),
   .DO      ( {wr_full, WRLEV} )
);

// RD
always @(posedge RDCLK)
begin
   rd_ptr <= rd_ptr_plus;
end

plus1 #(
   .DWID ( AWID ),
   .LOOP ( "true" )
) rd_ptr_plus1 (
   .CLR  ( rd_rst ),
   .EN   ( RDENA && !rd_empty ),
   .DI   ( rd_ptr ),
   .DO   ( rd_ptr_plus )
);

assign RDDAT = mem[rd_ptr];

load #(
   .DWID    ( AWID + 1 ),
   .DEFAULT ( {1'b1, {AWID{1'b0}}} )
) rd_load (
   .RST     ( rd_rst ),
   .DI      ( {~|(wr_ptr_rd - rd_ptr), (wr_ptr_rd - rd_ptr)} ),
   .DO      ( {rd_empty, RDLEV} )
);

endmodule

/*
// ****************************************************************************
// ram.sv
// ****************************************************************************
module ram
#(

)
(

);

endmodule
*/

// ****************************************************************************
// sync_clock.sv
// ****************************************************************************
module sync_clock
#(
   parameter               DWID = 32
)
(
   input                   CLK,
   input      [DWID-1:0]   DI,
   output reg [DWID-1:0]   DO
);

reg [DWID-1:0] di_r;

genvar i;
generate
   for(i = 0; i < DWID; i = i + 1)
   begin: CLK_SYNC
      always @(posedge CLK)
      begin
         di_r[i] <= DI[i];
         DO[i]   <= di_r[i];
      end
   end
endgenerate

endmodule

// ****************************************************************************
// sync_load.sv
// ****************************************************************************
module sync_load
(
   input                   ICLK,
   input                   OCLK,
   input                   DI,
   output                  DO
);

reg   di_r;
wire  di_ro;
reg   do_r;
wire  do_ri;

sync_clock #(
   .DWID ( 1 )
) osync (
   .CLK  ( ICLK ),
   .DI   ( do_r ),
   .DO   ( do_ri )
);

always @(posedge ICLK)
begin
   if(DI)
      di_r <= 1'b1;
   else if(do_ri)
      di_r <= 1'b0;
end

sync_clock #(
   .DWID ( 1 )
) isync (
   .CLK  ( OCLK ),
   .DI   ( di_r ),
   .DO   ( di_ro )
);

always @(posedge OCLK)
begin
   do_r <= di_ro;
end

assign DO = !do_r && di_ro;

endmodule

// ****************************************************************************
// load.sv
// ****************************************************************************
module load
#(
   parameter               DWID    = 32,
   parameter               DEFAULT = {DWID{1'b0}}
)
(
   input                   RST,
   input      [DWID-1:0]   DI,
   output     [DWID-1:0]   DO
);

assign DO = (RST)? DEFAULT : DI;

endmodule


/*
// ****************************************************************************
// event_meter.sv
// ****************************************************************************
module event_meter
#(

)
(

);

endmodule
*/


