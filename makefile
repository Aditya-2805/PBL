CROSS   = riscv32-unknown-elf
CFLAGS  = -march=rv32imc -mabi=ilp32 -nostdlib -Os -T sw/link.ld
PICORV32 ?= picorv32.v

sw/hello.hex: sw/hello.elf
	$(CROSS)-objcopy -O verilog $< $@

sw/hello.elf: sw/start.S sw/hello.c sw/link.ld
	$(CROSS)-gcc $(CFLAGS) sw/start.S sw/hello.c -o $@

obj_dir/Vtop: sw/hello.hex new_rtl/top.v new_rtl/memory.v $(PICORV32)
	verilator --cc -Wall -Wno-fatal \
	    --top-module top \
	    $(PICORV32) new_rtl/memory.v new_rtl/top.v \
	    --exe sim/testbench.cpp \
	    --build -j 0 \
	    -o Vtop

sim: obj_dir/Vtop
	./obj_dir/Vtop

all: obj_dir/Vtop sim

clean:
	rm -rf obj_dir sw/hello.elf sw/hello.hex

.PHONY: sim all clean
