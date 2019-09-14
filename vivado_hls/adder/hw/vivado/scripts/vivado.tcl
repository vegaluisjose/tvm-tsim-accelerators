set src_dir [lindex $argv 2]

open_project vadd
set_top vadd
add_files $src_dir/vadd.cc
open_solution "soln"
set_part "xc7z020clg400-1"
csynth_design
close_project
exit
