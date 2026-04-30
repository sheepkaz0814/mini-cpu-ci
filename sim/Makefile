TOP_RTL=cpu_top
TOP_TB=test_top

TOPLEVEL_LANG=verilog
SIM=verilator
TOPLEVEL=$(TOP_RTL)
MODULE=$(TOP_TB)
export PYTHONPATH := ../tb/cocotb

VERILOG_SOURCES = ../rtl/top.sv \
				../rtl/core/alu.sv \
				../rtl/core/regfile.sv \
				../rtl/core/decoder.sv

include $(shell cocotb-config --makefiles)/Makefile.sim

#verilog_all:
#	verilator -binary -j 0 --trace ../rtl/top.sv ../rtl/core/alu.sv ../rtl/core/regfile.sv ../rtl/core/decoder.sv
#	./obj_dir/Vtop
#
#clean:
#	rm -rf obj_dir
#
#wave:
#	gtkwave wave.vcd &
