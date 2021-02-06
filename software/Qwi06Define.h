//*****************************************************************************
// Qwi06Define.h
//
// This module is the global defines of Qwi06SdpHdmi project.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 19, 2020     Initial Release
//*****************************************************************************

#ifndef QWI06_DEFINE
#define QWI06_DEFINE

//*****************************************************************************
// Includes
//*****************************************************************************
#include "xil_printf.h"
#include "xil_io.h"

//*****************************************************************************
// Defines
//*****************************************************************************
#define XRegRead32  Xil_In32
#define XRegWrite32 Xil_Out32

#define printf xil_printf
#define u32b u32

#define false 1
#define true 0

#endif
