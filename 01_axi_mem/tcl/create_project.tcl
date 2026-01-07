# Use this variable for relative paths
set origin_dir .
set force_flag 1
set proj_name axi_mem
set minimum_vivado_version 2025.2

# parse arguments
if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set proj_name [lindex $::argv $i] }
      "-n"             { incr i; set proj_name [lindex $::argv $i] }
      "-f"             { incr i; set force_flag 1}
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Create project
if {$force_flag} {
  create_project $proj_name "[file normalize "$origin_dir/../vivado/$proj_name"]" -part xcau10p-sbvb484-1-i -force
} else {
  create_project $proj_name "[file normalize "$origin_dir/../vivado/$proj_name"]" -part xcau10p-sbvb484-1-i
}
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]

# Add VHDL Files, as a dictionary with the key as the library name

dict set vhdl_files xil_defaultlib [list \
 [file normalize "${origin_dir}/../hdl/TestCtrl_e.vhd"] \
 [file normalize "${origin_dir}/../hdl/basic_rw_test.vhd"] \
 [file normalize "${origin_dir}/../hdl/mem_blk_tb.vhd"] \
]


# Add all simulation files as VHDL-2008 and only used in simulation
foreach lib [dict keys $vhdl_files] {
  set files [dict get $vhdl_files $lib]
  add_files -norecurse $files
  set_property file_type {VHDL 2008} [get_files  $files]
  set_property library $lib [get_files $files]
  set_property used_in_synthesis false [get_files $files]
}


# create block designs and wrappers
source mem_blk.tcl


# make wrappers for block designs
make_wrapper -files [get_files $origin_dir/../vivado/$proj_name/$proj_name\.srcs/sources_1/bd/mem_blk/mem_blk.bd] -top
set_property top mem_blk_wrapper [current_fileset]
update_compile_order -fileset sources_1

# Add the wrappers
set wrapper_files [list \
 [file normalize "${origin_dir}/../vivado/$proj_name/$proj_name\.gen/sources_1/bd/mem_blk/hdl/mem_blk_wrapper.vhd"] \
]
add_files -norecurse $wrapper_files
update_compile_order -fileset sources_1

# run synthesis to get the simulation models for the ip cores
launch_runs synth_1 -jobs 4
wait_on_run synth_1
update_compile_order -fileset sources_1


