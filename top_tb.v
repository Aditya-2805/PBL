`timescale 1ns/1ps

module top_tb;

    reg clk;
    reg resetn;

    // Instantiate DUT
    top dut (
        .clk(clk),
        .resetn(resetn)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin
        $display("=================================");
        $display("        TOP SIMULATION START     ");
        $display("=================================");

        clk = 0;
        resetn = 0;

        // Hold reset
        #50;
        resetn = 1;

        // Let program execute
        #1000;

        $display("---------------------------------");
        $display(" IMEM CONTENTS ");
        $display("---------------------------------");

        $display("IMEM[0] = %h", dut.imem_inst.mem[0]);
        $display("IMEM[1] = %h", dut.imem_inst.mem[1]);
        $display("IMEM[2] = %h", dut.imem_inst.mem[2]);
        $display("IMEM[3] = %h", dut.imem_inst.mem[3]);
        $display("IMEM[4] = %h", dut.imem_inst.mem[4]);
        $display("IMEM[5] = %h", dut.imem_inst.mem[5]);

        $display("---------------------------------");
        $display(" DMEM CONTENTS AFTER EXECUTION ");
        $display("---------------------------------");

        $display("DMEM[0] = %h", dut.dmem_inst.mem[0]);

        $display("=================================");
        $display("         TOP SIMULATION END      ");
        $display("=================================");

        $finish;
    end

endmodule