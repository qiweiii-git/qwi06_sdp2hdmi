//*****************************************************************************
// Qwi06RegDef.vh.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 18, 2020     Initial Release
//*****************************************************************************

//*****************************************************************************
// reg defines
//*****************************************************************************
`ifdef SIM
//Vivado 2015.4 did not supported
enum
{
   FW_VER,
   FMT_DEF,
   REG_CNT
}e_regdef;
`else
localparam FW_VER  = 0,
           FMT_DEF = 1,
           REG_CNT = 2;
`endif

//*****************************************************************************
// reg initialized value
//*****************************************************************************
`ifdef SIM
//Vivado 2015.4 did not supported
localparam logic [31:0] REG_INIT [0:REG_CNT-1] =
'{
   32'h0006_0001,// FW_VER
   32'h0000_0003 // FMT_DEF
};
`else
wire [31:0] REG_INIT[0:REG_CNT-1];

assign REG_INIT[FW_VER]  = 32'h0006_0001;
assign REG_INIT[FMT_DEF] = 32'h0000_0003;
`endif
