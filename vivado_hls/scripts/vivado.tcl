set src_dir [lindex $argv 2]

open_project adder
set_top adder
add_files $src_dir/adder.cc
open_solution "soln"
set_part "xc7z020clg400-1"
csynth_design
close_project
exit