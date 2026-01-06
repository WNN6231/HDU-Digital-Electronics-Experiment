transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/Count25 {D:/intelFPGA_lite/Count25/Count25.v}

vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/Count25 {D:/intelFPGA_lite/Count25/Verilog2.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  Count25

add wave *
view structure
view signals
run -all
