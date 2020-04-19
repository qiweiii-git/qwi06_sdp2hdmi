#*****************************************************************************
# makefw.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       May. 4, 2019      Initial Release
#  1.1    Qiwei Wu       Mar.30, 2020      Improvement
#*****************************************************************************
#!/bin/bash

BuildDir='.build'
CompileFileDir='make'
ReturnRoute='../..'
BitFileDir='impl_1/'
CopyBitRoute='../../../..'

PrjName=$1
ChipType=$2
BuildFileDir=$3
CopyBitFileDir=$4
CopyHdf=$5
IverilogCompile=$6
echo "Info: Project Name is $PrjName, ChipType is $ChipType"

#make dir
if [ -d $BuildDir ]; then
   echo "Warning: Building Directory $BuildDir Exist"
   rm -r $BuildDir
   echo "Info: Old Building Directory $BuildDir Removing"
fi
mkdir $BuildDir
echo "Info: Building Directory $BuildDir Establish"

#copy source files
cp * $BuildDir -r

#compiling
if [ $IverilogCompile -eq 1 ]; then
   cd $BuildDir/$CompileFileDir
   echo "Info: $PrjName is compiling"
   ./compile.sh

   if [ ! -e fwCompiled ]; then
      echo "Error: $PrjName Project compile failed"
      exit
   fi
   echo "Info: $PrjName is compiled"
   cd $ReturnRoute
fi

#building
cd $BuildDir/$BuildFileDir
echo "Run $PrjName $ChipType" >> run.tcl
echo "Info: $PrjName $ChipType is building"
vivado -mode batch -source run.tcl

#finish building
echo "Info: $PrjName Project finish building"

#copy the bit file
cd $PrjName.runs/$BitFileDir
if [ -f $PrjName.bit ]; then
   cp $PrjName.bit $CopyBitRoute/$CopyBitFileDir
   echo "Info: $PrjName bit file moved to BIN"
   if [ $CopyHdf -eq 1 ]; then
      cp $CopyBitRoute/$BuildDir/$BuildFileDir/$PrjName.sdk/$PrjName.hdf $CopyBitRoute/$CopyBitFileDir
      echo "Info: $PrjName hdf file moved to BIN"
   fi
   #clean
   cd $CopyBitRoute
   rm -rf $BuildDir
   echo "Info: $PrjName finish building"
   echo -e "\n   Success \n"
else
   echo "Error: $PrjName Project built failed"
   echo "Error: $PrjName Project make failed"
   echo -e "\n   Failure \n"
fi
