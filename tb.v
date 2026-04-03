`timescale 1ns/1ps

module gpio_controller_tb;

    // =========================
    // Clock Generation
    // =========================
    reg clk = 0;
    always #5 clk = ~clk;

    // =========================
    // DUT Signals
    // =========================
    reg resetn;

    reg mem_valid;
    reg [31:0] mem_addr;
    reg [31:0] mem_wdata;
    reg [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;
    wire mem_ready;

    reg  [7:0] gpio_in;
    wire [7:0] gpio_out;

    // =========================
    // Instantiate DUT
    // =========================
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

    // =========================
    // MONITOR (KEY PART)
    // =========================
    initial begin
        $monitor("T=%0t | valid=%b addr=%h wdata=%h wstrb=%b | ready=%b rdata=%h | gpio_out=%h",
                  $time, mem_valid, mem_addr, mem_wdata, mem_wstrb,
                  mem_ready, mem_rdata, gpio_out);
    end

    // =========================
    // Test Sequence
    // =========================
    initial begin
        // Initialize
        resetn   = 0;
        mem_valid= 0;
        mem_wstrb= 0;
        mem_addr = 0;
        mem_wdata= 0;
        gpio_in  = 8'hAA;

        // Reset phase
        repeat (3) @(posedge clk);
        resetn = 1;

        // =========================
        // TEST 1: WRITE DIR
        // =========================
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000000;
        mem_wdata = 32'h00FF;
        mem_wstrb = 4'b1111;

        @(posedge clk);
        mem_valid = 0;
        mem_wstrb = 0;

        // =========================
        // TEST 2: WRITE OUTPUT
        // =========================
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000004;
        mem_wdata = 32'h00A5;
        mem_wstrb = 4'b1111;

        @(posedge clk);
        mem_valid = 0;
        mem_wstrb = 0;

        // =========================
        // TEST 3: READ INPUT
        // =========================
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000008;
        mem_wstrb = 4'b0000;

        @(posedge clk);
        mem_valid = 0;

        // =========================
        // TEST 4: READ OUTPUT
        // =========================
        @(posedge clk);
        mem_valid = 1;
        mem_addr  = 32'h10000004;
        mem_wstrb = 4'b0000;

        @(posedge clk);
        mem_valid = 0;

        // Finish
        repeat (5) @(posedge clk);
        $finish;
    end

endmodule