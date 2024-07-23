transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/FPGA_workspace/Multiplier_modules/FullAdder {C:/FPGA_workspace/Multiplier_modules/FullAdder/FullAdder.v}

vlog -vlog01compat -work work +incdir+C:/FPGA_workspace/Multiplier_modules/FullAdder/simulation {C:/FPGA_workspace/Multiplier_modules/FullAdder/simulation/FullAdder_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  FullAdder_tb

do C:/FPGA_workspace/Multiplier_modules/FullAdder/simulation/load_sim.tcl
