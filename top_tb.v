`timescale 1ns/1ps

module tb;

    reg clk;
    reg resetn;

    top uut (
        .clk(clk),
        .resetn(resetn)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        resetn = 0;

        #100;
        resetn = 1;

        #10000000;  // 10 ms

        $display("\n=== Simulation Finished ===");
        $finish;
    end

endmodule