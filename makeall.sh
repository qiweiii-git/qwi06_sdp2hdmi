#*****************************************************************************
# makeall.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       May. 04, 2019     Initial Release
#  1.1    Qiwei Wu       Apr. 06, 2020     Improvement
#*****************************************************************************
#!/bin/bash

PrjName='qwi06_sdp2hdmi'
ChipType='xc7z020clg400-2'
IverilogCompile='0'
SwBuild='1'

source /tools/Xilinx/Vivado/2015.4/settings64.sh

#*****************************************************************************
# Dir defines
#*****************************************************************************
OutpFileDir='bin'
# Fw related
MakeFwFileDir='make'
BuidFwFileDir='build'
# Sw related
MakeSwFileDir='make'
SWTclFileDir='build'
SwSrcFileDir='software'

if [ ! -d $OutpFileDir ]; then
   mkdir $OutpFileDir
   echo "Info: $OutpFileDir created"
fi

#*****************************************************************************
# Build FW
#*****************************************************************************
./$MakeFwFileDir/makefw.sh $PrjName $ChipType $BuidFwFileDir $OutpFileDir $SwBuild $IverilogCompile

#*****************************************************************************
# Build SW
#*****************************************************************************
if [ $SwBuild -eq 1 ]; then
   ./$MakeSwFileDir/makesw.sh $PrjName $SWTclFileDir $SwSrcFileDir $OutpFileDir
fi
