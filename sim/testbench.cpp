#include "Vtop.h" 
#include "verilated.h"
#include <iostream> 

#define MAX_CYCLES 1_000_000

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
 
    Vtop *top = new Vtop;
 
    /* Reset for 5 cycles */
    top->clk    = 0;
    top->resetn = 0;
    for (int i = 0; i < 10; i++) {
        top->clk = !top->clk;
        top->eval();
    }
    top->resetn = 1;
 
    /* Run simulation */
    for (int cycle = 0; cycle < MAX_CYCLES; cycle++) {
        top->clk = 1; top->eval();
        top->clk = 0; top->eval();
    }
 
    std::cout << "\n[sim] reached cycle limit " << MAX_CYCLES << std::endl;
    top->final();
    delete top;
    return 0;
}