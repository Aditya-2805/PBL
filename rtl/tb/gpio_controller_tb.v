`timescale 1ns/1ps

module gpio_tb;

    // Clock
    reg clk = 0;
    always #5 clk = ~clk;

    // Signals
    reg resetn;

    reg mem_valid;
    reg [31:0] mem_addr;
    reg [31:0] mem_wdata;
    reg [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;
    wire mem_ready;

    reg  [7:0] gpio_in;
    wire [7:0] gpio_out;

    // DUT
    gpio_controller uut (
        .clk(clk),
        .resetn(resetn),
        .mem_valid(mem_valid),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready),
        .gpio_out(gpio_out),
        .gpio_in(gpio_in)
    );

    // Monitor
    initial begin
        $display("===== SIM START =====");
        $monitor("T=%0t | valid=%b addr=%h wdata=%h wstrb=%b | ready=%b rdata=%h | gpio_out=%h",
                  $time, mem_valid, mem_addr, mem_wdata, mem_wstrb,
                  mem_ready, mem_rdata, gpio_out);
    end

    // Test
    initial begin
        resetn    = 0;
        mem_valid = 0;
        mem_wstrb = 0;
        mem_addr  = 0;
        mem_wdata = 0;
        gpio_in   = 8'hAA;

        repeat (3) @(posedge clk);
        resetn = 1;

        // DIR write
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000000;
        mem_wdata = 32'h00FF;
        mem_wstrb = 4'b1111;

        @(posedge clk);
        mem_valid = 0;
        mem_wstrb = 0;

        // OUTPUT write
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000004;
        mem_wdata = 32'h00A5;
        mem_wstrb = 4'b1111;

        @(posedge clk);
        mem_valid = 0;
        mem_wstrb = 0;

        // INPUT read
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000008;
        mem_wstrb = 0;

        @(posedge clk);
        mem_valid = 0;

        // OUTPUT read
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000004;
        mem_wstrb = 0;

        @(posedge clk);
        mem_valid = 0;

        repeat (5) @(posedge clk);
        $display("===== SIM END =====");
        $finish;
    end

endmodule