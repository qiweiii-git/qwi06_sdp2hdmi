
`timescale 1ns/1ns
module t_axis2native();

reg   rst = 1;
reg   axis_clk = 1;
reg   natv_clk = 1;

if_axi_stream axis_i();
if_native_stream vtg_i();
if_native_stream natv_o();

initial #2000 rst = ~rst;
always #2 axis_clk = ~axis_clk;
always #3 natv_clk = ~natv_clk;

reg [9:0] cnt = 0;

always @(posedge axis_clk)
begin
   if(axis_i.tready)
      cnt <= cnt + 1;
end

assign axis_i.tvalid = axis_i.tready;
assign axis_i.tlast  = &cnt[7:0];
assign axis_i.tuser  = ~|cnt[9:0];
assign axis_i.tdata  = {14'h0, cnt[9:0]};

reg [10:0] cnt1 = 20;
reg        active = 0;
always @(posedge natv_clk)
begin
   active <= vtg_i.vtg_ce;
   if(vtg_i.vtg_ce)
      cnt1 <= cnt1 + 1;
end

assign vtg_i.hblank = ~|cnt1[4:3];
assign vtg_i.vblank = ~|cnt1[9:8];
assign vtg_i.hsync  = vtg_i.hblank;
assign vtg_i.vsync  = vtg_i.vblank;
assign vtg_i.active = active/*!vtg_i.hblank && !vtg_i.vblank*/;

axis2native u_axis2native
(
   .rst       ( rst ),
   .axis_clk  ( axis_clk ),
   .natv_clk  ( natv_clk ),

   .axis_i    ( axis_i ),
   .vtg_i     ( vtg_i ),
   .natv_o    ( natv_o )
);

endmodule
