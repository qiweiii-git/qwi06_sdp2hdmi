//*****************************************************************************
// hdmi_vtg.v
//
// This module is the hdmi video timing generator.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 12, 2020     Initial Release
//*****************************************************************************

module hdmi_vtg
(
   input                 clk,
   input                 gen_ce,
   input      [2:0]      fmt_def,

   output reg [11:0]     ppl,
   output reg [11:0]     lpf,
   output reg            hsync,
   output reg            vsync,
   output reg            hblank,
   output reg            vblank,
   output reg            active
);

//*****************************************************************************
// Includes
//*****************************************************************************
`include "Define.vh"

//*****************************************************************************
// Signals
//*****************************************************************************
reg  [11:0]  ppl_gen = 1;
reg  [11:0]  lpf_gen = 1;

//*****************************************************************************
// Processes
//*****************************************************************************
always @(posedge clk)
begin
   if(gen_ce)
   begin
      if(ppl_gen >= FMT_TIMING[fmt_def][`TOLPPL_CNT])
         ppl_gen <= 1;
      else
         ppl_gen <= ppl_gen + 1;
   end
end

always @(posedge clk)
begin
   if(gen_ce)
   begin
      if(ppl_gen >= FMT_TIMING[fmt_def][`TOLPPL_CNT])
      begin
         if(lpf_gen >= FMT_TIMING[fmt_def][`TOLLPF_CNT])
            lpf_gen <= 1;
         else
            lpf_gen <= lpf_gen + 1;
      end
   end
end

always @(posedge clk)
begin
   ppl <= ppl_gen;
   lpf <= lpf_gen;
end

always @(posedge clk)
begin
   if(ppl_gen >= FMT_TIMING[fmt_def][`HSYNC_START] && ppl_gen <= FMT_TIMING[fmt_def][`HSYNC_END])
      hsync <= 1'b1;
   else
      hsync <= 1'b0;
end

always @(posedge clk)
begin
   if(lpf_gen >= FMT_TIMING[fmt_def][`VSYNC_START] && lpf_gen <= FMT_TIMING[fmt_def][`VSYNC_END])
      vsync <= 1'b1;
   else
      vsync <= 1'b0;
end

always @(posedge clk)
begin
   if(ppl_gen >= FMT_TIMING[fmt_def][`HBLAK_START] && ppl_gen <= FMT_TIMING[fmt_def][`HBLAK_END])
      hblank <= 1'b1;
   else
      hblank <= 1'b0;
end

always @(posedge clk)
begin
   if(lpf_gen >= FMT_TIMING[fmt_def][`VBLAK_START] && lpf_gen <= FMT_TIMING[fmt_def][`VBLAK_END])
      vblank <= 1'b1;
   else
      vblank <= 1'b0;
end

always @(posedge clk)
begin
   if(lpf_gen > FMT_TIMING[fmt_def][`VBLAK_END] && ppl_gen > FMT_TIMING[fmt_def][`HBLAK_END])
      active <= 1'b1 & gen_ce;
   else
      active <= 1'b0;
end

endmodule
