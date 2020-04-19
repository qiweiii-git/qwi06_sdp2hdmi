//*****************************************************************************
// axis2native.v
//
// This module is the converter of axi-stream to native stream.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 15, 2020     Initial Release
//*****************************************************************************

module axis2native
#(
   parameter               DWID       = 24,
   parameter               BUF_AWID   = 12,
   parameter               VTG_MASTER = "true"
)
(
   input                   rst,
   input                   axis_clk,
   input                   natv_clk,

   if_axi_stream.slave     axis_i,
   if_native_stream.slave  vtg_i,

   if_native_stream.master natv_o
);

//*****************************************************************************
// Signals
//*****************************************************************************
reg                 vtg_gen;
reg                 aligned;
reg                 wait_sync = 1;
wire                vtg_sof;
wire [BUF_AWID-1:0] wrlevel;
wire [BUF_AWID-1:0] rdlevel;
wire                rden;
wire [DWID-1:0]     fifo_tdata;
wire                fifo_tlast;
wire                fifo_tuser;
reg                 vblank_r;
reg                 hblank_r;
reg  [2:0]          init_cnt;

//*****************************************************************************
// Processes
//*****************************************************************************
generate
   if(VTG_MASTER == "true")
   begin
      assign vtg_i.vtg_ce  = 1'b1;
      assign axis_i.tready = ~&wrlevel[BUF_AWID-1-:3];
   end
   else
   begin
      assign vtg_i.vtg_ce  = vtg_gen;
      assign axis_i.tready = 1'b1;
   end
endgenerate

// Buffer read
assign rden = |rdlevel && (((vtg_i.active || !vtg_gen) && aligned) || wait_sync);

always @(posedge natv_clk)
begin
   hblank_r <= vtg_i.hblank;
   if(hblank_r && !vtg_i.hblank)
      vblank_r <= vtg_i.vblank;
end

assign vtg_sof = vblank_r && !vtg_i.vblank && hblank_r && !vtg_i.hblank;

generate
   if(VTG_MASTER == "true")
   begin
      always @(posedge natv_clk)
      begin
         vtg_gen <= 1'b1;

         if(rst)
            wait_sync <= 1'b1;
         else if(fifo_tuser && rden && init_cnt >= 6)
            wait_sync <= 1'b0;

         if(rst)
            init_cnt <= 0;
         else if(fifo_tuser && rden)
            init_cnt <= init_cnt + ~init_cnt;

         if(wait_sync)
            aligned <= 1'b0;
         else if(!wait_sync && vtg_sof)
            aligned <= 1'b1;
      end
   end
   else
   begin
      always @(posedge natv_clk)
      begin
         aligned <= 1'b1;
         if(fifo_tuser)
            vtg_gen <= 1'b1;
         else if(vtg_sof)
            vtg_gen <= 1'b0;
      end
   end
endgenerate

always @(posedge natv_clk)
begin
   natv_o.data   <= fifo_tdata;
   natv_o.hsync  <= vtg_i.hsync;
   natv_o.vsync  <= vtg_i.vsync;
   natv_o.active <= rden;
   natv_o.hblank <= vtg_i.hblank;
   natv_o.vblank <= vtg_i.vblank;
   natv_o.fid    <= vtg_i.fid;
   natv_o.ppl    <= vtg_i.ppl;
   natv_o.lpf    <= vtg_i.lpf;
end

fifo
#(
   .DWID   ( DWID + 2 ),
   .AWID   ( BUF_AWID ),
   .SYNC   ( "false" )
)
u_fifo
(
   .RST    ( rst ),
   .WRCLK  ( axis_clk ),
   .WRENA  ( axis_i.tvalid && axis_i.tready ),
   .WRDAT  ( {axis_i.tuser, axis_i.tlast, axis_i.tdata} ),
   .WRLEV  ( wrlevel ),

   .RDCLK  ( natv_clk),
   .RDENA  ( rden ),
   .RDDAT  ( {fifo_tuser, fifo_tlast, fifo_tdata}),
   .RDLEV  ( rdlevel )
);

endmodule
