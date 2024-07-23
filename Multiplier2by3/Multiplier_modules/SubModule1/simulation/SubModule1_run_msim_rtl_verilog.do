transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/FPGA_workspace/Multiplier_modules/SubModule1 {C:/FPGA_workspace/Multiplier_modules/SubModule1/SubModule1.v}

vlog -vlog01compat -work work +incdir+C:/FPGA_workspace/Multiplier_modules/SubModule1/simulation {C:/FPGA_workspace/Multiplier_modules/SubModule1/simulation/SubModule1_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  SubModule1_tb

do C:/FPGA_workspace/Multiplier_modules/SubModule1/simulation/load_sim.tcl
