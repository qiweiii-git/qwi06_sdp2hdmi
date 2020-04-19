#*****************************************************************************
# makesw.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       Apr. 06, 2020     Initial Release
#*****************************************************************************
#!/bin/bash

BuildDir='.build'
WorkspaceDir='workspace'
ElfDir='Debug'
CopyElfRoute='../../../../../'

PrjName=$1
TclFileDir=$2
SrcFileDir=$3
CopyFileDir=$4
echo "Info: Project Name is $PrjName"

#make dir
if [ -d $BuildDir ]; then
   echo "Warning: Building Directory $BuildDir Exist"
   rm -r $BuildDir
   echo "Info: Old Building Directory $BuildDir Removing"
fi
mkdir $BuildDir
echo "Info: Building Directory $FileSys/$BuildDir Establish"

#copy source files
cp * $BuildDir -r

#copy files
mkdir $BuildDir/$WorkspaceDir
cp $CopyFileDir/$PrjName.hdf $BuildDir/$WorkspaceDir
cp $TclFileDir/runsw.tcl $BuildDir/$WorkspaceDir

#building
cd $BuildDir/$WorkspaceDir
echo "Run $PrjName ../$SrcFileDir $WorkspaceDir" >> runsw.tcl
echo "Info: $PrjName Project is building"
xsdk -batch -source runsw.tcl

#finish building
echo "Info: $PrjName Project finish building"

#copy the elf file
cd $WorkspaceDir/$PrjName/$ElfDir
if [ -f $PrjName.elf ]; then
   cp $PrjName.elf $CopyElfRoute/$CopyFileDir
   echo "Info: $PrjName.elf file moved to $CopyFileDir"
   #clean
   cd $CopyElfRoute
   rm -rf $BuildDir
   echo "Info: $PrjName.elf file finish making"
   echo -e "\n   Success \n"
else
   echo "Error: $PrjName Project built failed"
   echo "Error: $PrjName Project make failed"
   echo -e "\n   Failure \n"
fi
