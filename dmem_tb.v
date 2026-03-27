`timescale 1ns/1ps

module dmem_tb;

    reg         clk;
    reg         mem_valid;
    reg         mem_wstrb;
    reg [31:0]  mem_addr;
    reg [31:0]  mem_wdata;
    wire [31:0] mem_rdata;
    wire        mem_ready;

    data_mem dut (
        .clk(clk),
        .mem_valid(mem_valid),
        .mem_wstrb(mem_wstrb),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready)
    );

    // clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mem_valid = 0;
        mem_wstrb = 0;
        mem_addr  = 0;
        mem_wdata = 0;

        $display("---- DMEM TB START ----");

        // ================= WRITE @ 0x4 =================
        @(negedge clk);          // <<< KEY
        mem_addr  = 32'h0000_0004;
        mem_wdata = 32'hDEADBEEF;
        mem_wstrb = 1;
        mem_valid = 1;

        @(posedge clk);          // memory samples here
        @(posedge clk);          // wait one cycle

        mem_valid = 0;
        mem_wstrb = 0;

        // ================= READ @ 0x4 =================
        @(negedge clk);
        mem_addr  = 32'h0000_0004;
        mem_valid = 1;

        @(posedge clk);
        @(posedge clk);

        $display("READ @0x00000004 = 0x%08h", mem_rdata);
        mem_valid = 0;

        // ================= WRITE @ 0x8 =================
        @(negedge clk);
        mem_addr  = 32'h0000_0008;
        mem_wdata = 32'hCAFEBABE;
        mem_wstrb = 1;
        mem_valid = 1;

        @(posedge clk);
        @(posedge clk);

        mem_valid = 0;
        mem_wstrb = 0;

        // ================= READ @ 0x8 =================
        @(negedge clk);
        mem_addr  = 32'h0000_0008;
        mem_valid = 1;

        @(posedge clk);
        @(posedge clk);

        $display("READ @0x00000008 = 0x%08h", mem_rdata);
        mem_valid = 0;

        // ================= READ OLD =================
        @(negedge clk);
        mem_addr  = 32'h0000_0004;
        mem_valid = 1;

        @(posedge clk);
        @(posedge clk);

        $display("READ @0x00000004 = 0x%08h", mem_rdata);
        mem_valid = 0;

        $display("---- DMEM TB END ----");
        #20;
        $finish;
    end

endmodule