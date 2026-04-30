TOP=top

all:
	verilator -binary -j 0 --trace ../rtl/top.sv ../rtl/core/alu.sv ../rtl/core/regfile.sv ../rtl/core/decoder.sv
	./obj_dir/Vtop

clean:
	rm -rf obj_dir

wave:
	gtkwave wave.vcd &
