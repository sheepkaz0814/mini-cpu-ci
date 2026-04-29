TOP=top

all:
	verilator -binary -j 0 ../rtl/top.sv ../rtl/core/alu.sv
	./obj_dir/Vtop

clean:
	rm -rf obj_dir