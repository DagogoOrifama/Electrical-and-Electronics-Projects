transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/FPGA_workspace/Multiplier_modules/SubModule2 {C:/FPGA_workspace/Multiplier_modules/SubModule2/SubModule2.v}

