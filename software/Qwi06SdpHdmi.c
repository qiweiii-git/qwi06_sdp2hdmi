//*****************************************************************************
// Qwi06SdpHdmi.c
//
// This module is the MAIN files of Qwi06SdpHdmi project.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  1.0    Qiwei Wu       Apr. 19, 2020     Initial Release
//*****************************************************************************

//*****************************************************************************
// Project Defines
//*****************************************************************************
#define PRJ_N "Qwi06SdpHdmi"
#define H_VER 1
#define L_VER 0

//*****************************************************************************
// Includes
//*****************************************************************************
#include "Qwi06Define.h"
#include "xparameters.h"
#include "ff.h"
#include "xil_cache.h"

//*****************************************************************************
// Defines
//*****************************************************************************
#define PIXBYTES 3
#define PIXWIDTH 1920
#define PIXHEIGHT 1080
#define VDMA_BASEADDR XPAR_AXIVDMA_0_BASEADDR
#define REGCTRL_BASEADDR XPAR_AXI_REG_CTRL_S_AXI_BASEADDR
#define BMPFILE "wildhunt.bmp"

//*****************************************************************************
// Variables
//*****************************************************************************
// File object
static FIL file;
static FATFS fatfs;

// BMP
unsigned char lineBuffer[1920 * PIXBYTES];
unsigned int bmpWidth, bmpHeight;

u8  frameBuf[PIXWIDTH*PIXHEIGHT*PIXBYTES] __attribute__ ((aligned(64)));

//*****************************************************************************
// Functions
//*****************************************************************************
int BmpRead(char *bmpFile, u8 *frameBuf);
void XVdmaCfgRead(u32 baseAddress, u8 dest, u32 startAddress);

//*****************************************************************************
// Bmp Read
//*****************************************************************************
int BmpRead(char *bmpFile, u8 *frameBuf)
{
   // File R/W count
   unsigned int br;
   unsigned char BMPBUF[64];
   u32b index;
   u32b x, y, z;

   // Open BMP file
   if(f_open(&file, bmpFile, FA_OPEN_EXISTING|FA_READ) != FR_OK)
   {
      printf("%s:Open %s failed.\r\n", __func__, bmpFile);
      return false;
   }
   printf("%s:Open %s successes.\r\n", __func__, bmpFile);

   if(f_read(&file, BMPBUF, 54, &br) != FR_OK )
   {
      printf("%s:Read %s failed.\r\n", __func__, bmpFile);
      return false;
   }
   printf("%s:Read %s successes.\r\n", __func__, bmpFile);

   bmpWidth = (unsigned int)BMPBUF[19]*256+BMPBUF[18];
   bmpHeight = (unsigned int)BMPBUF[23]*256+BMPBUF[22];
   index = (bmpHeight - 1) * bmpWidth * PIXBYTES;

   printf("%s:Get BMP width:%d, height:%d.\r\n", __func__, bmpWidth, bmpHeight);

   for(y = 0; y < bmpHeight ; y++)
   {
      f_read(&file, lineBuffer, bmpWidth * PIXBYTES, &br);

      for(x = 0; x < bmpWidth; x++)
      {
         for(z = 0; z < PIXBYTES; z++)
         {
            frameBuf[x * PIXBYTES + index + z] = lineBuffer[x * PIXBYTES + z];
         }
      }

      index -= bmpWidth * PIXBYTES;
   }
   f_close(&file);

   printf("%s:Done%x\r\n", __func__, index + bmpWidth * PIXBYTES);

   Xil_DCacheFlushRange((unsigned int) frameBuf, bmpWidth * PIXBYTES * bmpHeight);

   return true;
};

//*****************************************************************************
// VDMA configure
//*****************************************************************************
void XVdmaCfgRead(u32 baseAddress, u8 dest, u32 startAddress)
{
   // Enable run, Circular_Park, GenlockEn, and GenlockSrc
   XRegWrite32(baseAddress + 0x00, 0x8B);

   // Start address
   XRegWrite32(baseAddress + 0x5C + dest * 0x4, startAddress);

   // The number of cache bytes per line
   XRegWrite32(baseAddress + 0x58, bmpWidth * PIXBYTES);

   // The number of pixel bytes per line
   XRegWrite32(baseAddress + 0x54, bmpWidth * PIXBYTES);

   // The number of lines per frame
   XRegWrite32(baseAddress + 0x50, bmpHeight);

   printf("XVdma_CfgRead Done.\r\n");
}

//*****************************************************************************
// Main
//*****************************************************************************
int main()
{
   u32b regValue;

   printf("\r\n========================================\r\n");
   printf("=   Project: %s. Ver:v%d.%d    =\r\n", PRJ_N, H_VER, L_VER);
   printf("=   Date: %s, %s        =\r\n", __DATE__, __TIME__);
   printf("========================================\r\n");

   // Get the FW version
   regValue = XRegRead32(REGCTRL_BASEADDR + 0x0);
   printf("%s:Reg_0x%x:0x%x.\r\n", __func__ , 0x0, regValue);

   // Open a workspace
   if(f_mount(&fatfs, "0:/", 0) != FR_OK)
   {
      printf("%s:Mount file system failed.\r\n", __func__);
   }

   // BMP read
   BmpRead(BMPFILE, frameBuf);

   // Configure the VDMA
   XVdmaCfgRead(VDMA_BASEADDR, 0, (u32)frameBuf);

   return 0;
}
