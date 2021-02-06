//*****************************************************************************
// qwiregctrl.v
//
// This module is the base register control.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 11, 2020     Initial Release
//*****************************************************************************

module qwiregctrl
#(
   parameter REGCNT = 32,
   parameter AWID   = 12,
   parameter DWID   = 32
)
(
   input                        sys_rst,
   input                        reg_ce,
   input                        reg_rst,
   input                        reg_clk,
   input      [DWID/8-1:0]      reg_we,
   input      [AWID-1:0]        reg_addr,
   input      [DWID-1:0]        reg_wrd,
   output     [DWID-1:0]        reg_rdd,

   output     [DWID*REGCNT-1:0] reg_out,
   input      [DWID*REGCNT-1:0] reg_in
);

//*****************************************************************************
// Includes
//*****************************************************************************
`include "Define.vh"

//*****************************************************************************
// Signals
//*****************************************************************************
genvar                 i;
reg  [DWID-1:0]        reg_ram [0:REGCNT-1];

//*****************************************************************************
// Processes
//*****************************************************************************
generate
   for(i=0; i<REGCNT; i=i+1)
   begin:REG_CTRL
      always @(posedge reg_clk)
      begin
         if(sys_rst || reg_rst)
            reg_ram[i] <= REG_INIT[i];
         else if(reg_ce && &reg_we && reg_addr == i)
            reg_ram[i] <= reg_wrd;
         else
            reg_ram[i] <= reg_in[DWID*(i+1)-1 -: DWID];
      end

      assign reg_out[DWID*(i+1)-1 -: DWID] = reg_ram[i];
   end
endgenerate

assign reg_rdd = reg_ram[reg_addr];

endmodule
