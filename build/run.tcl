#******************************************************************************
# run.tcl
#
# This module is the tcl script of building project.
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       Feb. 18, 2019     Initial Release
#  1.1    Qiwei Wu       Mar. 29, 2020     Create the process
#  1.2    Qiwei Wu       Apr. 06, 2020     Add system build
#******************************************************************************

proc Run { buildName chipType } {
   # Set CPU count
   set cores 1
   if {![catch {open "/proc/cpuinfo"} f]} {
      set coreNum [regexp -all -line {^processor\s} [read $f]]
      close $f

      if {$coreNum > 0} {
         set cores $coreNum
      }
   }

   # create project
   create_project $buildName -part $chipType

   # add working path
   set current_path [pwd]

   # add source file to project
   source ./file_list.tcl

   # create embedding subsystem
   source ./system.tcl

   # Generate subsystem
   generate_target -force all [get_files ./$buildName.srcs/sources_1/bd/system/system.bd]

   # set top
   set_property top $buildName [current_fileset]
   update_compile_order -fileset sources_1

   # synthesize
   reset_run synth_1
   launch_runs synth_1 -jobs $cores
   wait_on_run synth_1

   # Generate the HDF for the SDK.
   file mkdir $buildName.sdk
   write_hwdef -force -file $buildName.sdk/$buildName.hdf

   # implement
   launch_runs impl_1 -jobs $cores
   wait_on_run impl_1

   # Generate the bitstream.
   launch_runs impl_1 -to_step write_bitstream -jobs $cores
   wait_on_run impl_1
}

# Run $buildName $chipType
# Run qwi00_led xc7z020clg400-2
