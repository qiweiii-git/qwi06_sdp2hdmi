//*****************************************************************************
// qwi06_sdp2hdmi.sv
//
// This module is the top wrapper of qwi06_sdp2hdmi project.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 18, 2020     Initial Release
//*****************************************************************************

module qwi06_sdp2hdmi
(
   //DDR interface
   inout     [14:0]   DDR_addr         ,
	inout     [2:0]    DDR_ba           ,
	inout              DDR_cas_n        ,
	inout              DDR_ck_n         ,
	inout              DDR_ck_p         ,
	inout              DDR_cke          ,
	inout              DDR_cs_n         ,
	inout     [3:0]    DDR_dm           ,
	inout     [31:0]   DDR_dq           ,
	inout     [3:0]    DDR_dqs_n        ,
	inout     [3:0]    DDR_dqs_p        ,
	inout              DDR_odt          ,
	inout              DDR_ras_n        ,
	inout              DDR_reset_n      ,
	inout              DDR_we_n         ,
   //fixed_io interface
	inout              FIXED_IO_ddr_vrn ,
	inout              FIXED_IO_ddr_vrp ,
	inout     [53:0]   FIXED_IO_mio     ,
	inout              FIXED_IO_ps_clk  ,
	inout              FIXED_IO_ps_porb ,
	inout              FIXED_IO_ps_srstb,
   //clock
   input              sys_clk_50m      ,

   //HDMI interface
   input     [0:0]    hdmi_hpd_tri_i   ,
   inout              hdmi_ddc_scl     ,
   inout              hdmi_ddc_sda     ,
	output    [0:0]    HDMI_OEN         ,
	output             TMDS_clk_n       ,
	output             TMDS_clk_p       ,
   output    [2:0]    TMDS_data_n      ,
	output    [2:0]    TMDS_data_p      ,

   //LED
   output             led_indc
);

//*****************************************************************************
// Includes
//*****************************************************************************
`include "Define.vh"

//*****************************************************************************
// Signals
//*****************************************************************************
wire        clk_100m;
wire        clk_150m;
wire        base_mmcm_locked;
wire        vid_mmcm_locked;
wire        clk_148p5m;
wire        clk_742p5m;

//*****************************************************************************
// Ifs
//*****************************************************************************
if_axi_stream #(.DATA_WID(24)) axis_i();
if_native_stream vtg_i();
if_native_stream natv_o();

//*****************************************************************************
// Reg control
//*****************************************************************************
wire [12:0] reg_ctrl_addr;
wire        reg_ctrl_clk;
wire [31:0] reg_ctrl_din;
wire [31:0] reg_ctrl_dout;
wire        reg_ctrl_en;
wire        reg_ctrl_rst;
wire [3:0]  reg_ctrl_we;

wire [31:0] reg_fw_ver;
wire [31:0] reg_fmt_def;

//*****************************************************************************
// Debugs
//*****************************************************************************
(* keep="true" *)wire        dbg_vid_active;
(* keep="true" *)wire        dbg_vid_hblank;
(* keep="true" *)wire        dbg_vid_hsync;
(* keep="true" *)wire        dbg_vid_vblank;
(* keep="true" *)wire        dbg_vid_vsync;
(* keep="true" *)wire [11:0] dbg_vid_ppl;
(* keep="true" *)wire [11:0] dbg_vid_lpf;

assign dbg_vid_active = vtg_i.active;
assign dbg_vid_hblank = vtg_i.hblank;
assign dbg_vid_hsync  = vtg_i.hsync;
assign dbg_vid_vblank = vtg_i.vblank;
assign dbg_vid_vsync  = vtg_i.vsync;
assign dbg_vid_ppl    = vtg_i.ppl;
assign dbg_vid_lpf    = vtg_i.lpf;

(* keep="true" *)wire [23:0] dbg_vdma_tdata;
(* keep="true" *)wire        dbg_vdma_tlast;
(* keep="true" *)wire        dbg_vdma_tuser;
(* keep="true" *)wire        dbg_vdma_tvalid;
(* keep="true" *)wire        dbg_vdma_tready;

assign dbg_vdma_tdata  = axis_i.tdata;
assign dbg_vdma_tlast  = axis_i.tlast;
assign dbg_vdma_tuser  = axis_i.tuser;
assign dbg_vdma_tvalid = axis_i.tvalid;
assign dbg_vdma_tready = axis_i.tready;

(* keep="true" *)wire        dbg1_vid_active;
(* keep="true" *)wire [23:0] dbg1_vid_data;
(* keep="true" *)wire        dbg1_vid_hblank;
(* keep="true" *)wire        dbg1_vid_hsync;
(* keep="true" *)wire        dbg1_vid_vblank;
(* keep="true" *)wire        dbg1_vid_vsync;

assign dbg1_vid_active = natv_o.active;
assign dbg1_vid_data   = natv_o.data;
assign dbg1_vid_hblank = natv_o.hblank;
assign dbg1_vid_hsync  = natv_o.hsync;
assign dbg1_vid_vblank = natv_o.vblank;
assign dbg1_vid_vsync  = natv_o.vsync;

//*****************************************************************************
// PS
//*****************************************************************************
clk_wiz_1 base_mmcm
(
   .clk_100m               ( clk_100m ),
   .clk_150m               ( clk_150m ),
   .reset                  ( 1'b0 ),
   .locked                 ( base_mmcm_locked ),
   .clk_50m                ( sys_clk_50m )
);

clk_wiz_0 vid_mmcm
(
   .clk_148p5m             ( clk_148p5m ),
   .clk_742p5m             ( clk_742p5m ),
   .reset                  ( 1'b0 ),
   .mmcm_locked            ( vid_mmcm_locked ),
   .clk_100m               ( clk_100m )
);

system u_system
(
   //DDR interface
   .DDR_addr               ( DDR_addr ),
   .DDR_ba                 ( DDR_ba ),
   .DDR_cas_n              ( DDR_cas_n ),
   .DDR_ck_n               ( DDR_ck_n ),
   .DDR_ck_p               ( DDR_ck_p ),
   .DDR_cke                ( DDR_cke ),
   .DDR_cs_n               ( DDR_cs_n ),
   .DDR_dm                 ( DDR_dm ),
   .DDR_dq                 ( DDR_dq ),
   .DDR_dqs_n              ( DDR_dqs_n ),
   .DDR_dqs_p              ( DDR_dqs_p ),
   .DDR_odt                ( DDR_odt ),
   .DDR_ras_n              ( DDR_ras_n ),
   .DDR_reset_n            ( DDR_reset_n ),
   .DDR_we_n               ( DDR_we_n ),
   //fixed_io interface
   .FIXED_IO_ddr_vrn       ( FIXED_IO_ddr_vrn ),
   .FIXED_IO_ddr_vrp       ( FIXED_IO_ddr_vrp ),
   .FIXED_IO_mio           ( FIXED_IO_mio ),
   .FIXED_IO_ps_clk        ( FIXED_IO_ps_clk ),
   .FIXED_IO_ps_porb       ( FIXED_IO_ps_porb ),
   .FIXED_IO_ps_srstb      ( FIXED_IO_ps_srstb ),

   //Reg control
   .REG_CTRL_addr          ( reg_ctrl_addr ),
   .REG_CTRL_clk           ( reg_ctrl_clk ),
   .REG_CTRL_din           ( reg_ctrl_din ),
   .REG_CTRL_dout          ( reg_ctrl_dout ),
   .REG_CTRL_en            ( reg_ctrl_en ),
   .REG_CTRL_rst           ( reg_ctrl_rst ),
   .REG_CTRL_we            ( reg_ctrl_we ),

   // VDMA
   .axis_clk               ( clk_150m ),
   .axis_rstn              ( base_mmcm_locked ),

   .VDMA_MM2S_tdata        ( axis_i.tdata ),
   .VDMA_MM2S_tkeep        ( axis_i.tkeep ),
   .VDMA_MM2S_tlast        ( axis_i.tlast ),
   .VDMA_MM2S_tready       ( axis_i.tready ),
   .VDMA_MM2S_tuser        ( axis_i.tuser ),
   .VDMA_MM2S_tvalid       ( axis_i.tvalid )
);

//*****************************************************************************
// Reg control
//*****************************************************************************
qwiregctrl
#(
   .REGCNT                 ( REG_CNT ),
   .AWID                   ( 9 ),
   .DWID                   ( 32 )
)
u_qwiregctrl
(  
   .sys_rst                ( 1'b0 ),
   .reg_ce                 ( reg_ctrl_en ),
   .reg_rst                ( reg_ctrl_rst ),
   .reg_clk                ( reg_ctrl_clk ),
   .reg_we                 ( reg_ctrl_we ),
   .reg_addr               ( reg_ctrl_addr[12:4] ),
   .reg_wrd                ( reg_ctrl_din ),
   .reg_rdd                ( reg_ctrl_dout ),

   .reg_out                ( {{ reg_fmt_def },
                              { reg_fw_ver }} ),
   .reg_in                 ( {{ reg_fmt_def },
                              { reg_fw_ver }} )
);

//*****************************************************************************
// VTG
//*****************************************************************************
hdmi_vtg u_hdmi_vtg
(
   .clk                    ( clk_148p5m ),
   .gen_ce                 ( vtg_i.vtg_ce ),
   .fmt_def                ( reg_fmt_def[2:0] ),

   .ppl                    ( vtg_i.ppl ),
   .lpf                    ( vtg_i.lpf ),
   .hsync                  ( vtg_i.hsync ),
   .vsync                  ( vtg_i.vsync ),
   .hblank                 ( vtg_i.hblank ),
   .vblank                 ( vtg_i.vblank ),
   .active                 ( vtg_i.active )
);

//*****************************************************************************
// AXIS2NATV
//*****************************************************************************
axis2native u_axis2native
(
   .rst                    ( !vid_mmcm_locked ),
   .axis_clk               ( clk_150m ),
   .natv_clk               ( clk_148p5m ),

   .axis_i                 ( axis_i ),
   .vtg_i                  ( vtg_i ),
   .natv_o                 ( natv_o )
);

//*****************************************************************************
// HDMI OUT
//*****************************************************************************
assign HDMI_OEN = 1'b1;
rgb2dvi u_rgb2dvi
(
   .PixelClk               ( clk_148p5m ),
   .SerialClk              ( clk_742p5m ),
   .aRst                   ( ),
   .aRst_n                 ( vid_mmcm_locked ),
   .vid_pData              ( natv_o.data ),
   .vid_pVDE               ( natv_o.active ),
   .vid_pHSync             ( natv_o.hsync ),
   .vid_pVSync             ( natv_o.vsync ),
   .TMDS_Clk_p             ( TMDS_clk_p ),
   .TMDS_Clk_n             ( TMDS_clk_n ),
   .TMDS_Data_p            ( TMDS_data_p ),
   .TMDS_Data_n            ( TMDS_data_n )
);

//*****************************************************************************
// LED indicator
//*****************************************************************************
led_indicator	
#(
   .SET_TIME_1S            ( 74_250_000 ),
   .LED_NUM                ( 1 )
)
u_led_indicator							
(
	.clk                    ( clk_148p5m ),
   .rst                    ( 1'b0 ),
	.led                    ( led_indc )
);

endmodule
