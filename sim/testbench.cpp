#include "Vtop.h"
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vtop *top = new Vtop;

    // hold reset for 10 cycles
    top->resetn = 0;
    top->clk    = 0;
    for (int i = 0; i < 20; i++) {
        top->clk = !top->clk;
        top->eval();
    }

    // release reset and run
    top->resetn = 1;
    for (int i = 0; i < 2000000; i++) {
        top->clk = !top->clk;
        top->eval();
    }

    top->final();
    delete top;
    return 0;
}