#include "Vtop.h"
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vtop *top = new Vtop;

    top->resetn = 0;
    top->clk    = 0;
    for (int i = 0; i < 20; i++) {
        top->clk = !top->clk;
        top->eval();
    }

    top->resetn = 1;
    for (int i = 0; i < 2000000; i++) {
        top->clk = !top->clk;
        top->eval();
        if (Verilated::gotFinish()) break;  // ← stop when $finish fires
    }

    top->final();
    delete top;
    return 0;
}
