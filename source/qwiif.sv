//****************************************************************************
//if_axi_stream.sv
//****************************************************************************
interface if_axi_stream
#(
   DATA_WID = 24,
   DEST_WID = 2,
   KEEP_WID = DATA_WID/8,
   LAST_WID = 1,
   USER_WID = 1
);

   logic [DATA_WID-1:0] tdata;
   logic [DEST_WID-1:0] tdest;
   logic [KEEP_WID-1:0] tkeep;
   logic [LAST_WID-1:0] tlast;
   logic                tready;
   logic [USER_WID-1:0] tuser;
   logic                tvalid;

   modport master
   (
      output tdata,
      output tdest,
      output tkeep,
      output tlast,
      input  tready,
      output tuser,
      output tvalid
   );

   modport slave
   (
      input  tdata,
      input  tdest,
      input  tkeep,
      input  tlast,
      output tready,
      input  tuser,
      input  tvalid
   );

endinterface

//****************************************************************************
//if_native_stream.sv
//****************************************************************************
interface if_native_stream
#(
   DATA_WID = 24,
   PPL_WID  = 12,
   LPF_WID  = 12
);

   logic [DATA_WID-1:0] data;
   logic                hsync;
   logic                vsync;
   logic                active;
   logic                hblank;
   logic                vblank;
   logic                fid;
   logic [PPL_WID-1:0]  ppl;
   logic [LPF_WID-1:0]  lpf;
   logic                vtg_ce;

   modport master
   (
      output data,
      output hsync,
      output vsync,
      output active,
      output hblank,
      output vblank,
      output fid,
      output ppl,
      output lpf,
      input  vtg_ce
   );

   modport slave
   (
      input data,
      input hsync,
      input vsync,
      input active,
      input hblank,
      input vblank,
      input fid,
      input ppl,
      input lpf,
      output vtg_ce
   );

endinterface
