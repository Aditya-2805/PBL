`timescale 1ns/1ps

module imem_tb;

    // Parameters (match DUT)
    localparam DATA_WIDTH  = 32;
    localparam ADDR_WIDTH  = 32;
    localparam MEMORY_SIZE = 4096;

    // Testbench signals
    reg  [ADDR_WIDTH-1:0] instr_addr;
    wire [DATA_WIDTH-1:0] instr;

    // Instantiate DUT
    imem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEMORY_SIZE(MEMORY_SIZE)
    ) dut (
        .instr_addr(instr_addr),
        .instr(instr)
    );

    // Test procedure
    initial begin
        $display("Starting Instruction Memory Testbench");
        $display("-------------------------------------");

        // Initial address
        instr_addr = 32'h0000_0000;
        #10;
        $display("ADDR = 0x%08h -> INSTR = 0x%08h", instr_addr, instr);

        // Next instruction (word aligned)
        instr_addr = 32'h0000_0004;
        #10;
        $display("ADDR = 0x%08h -> INSTR = 0x%08h", instr_addr, instr);

        // Another instruction
        instr_addr = 32'h0000_0008;
        #10;
        $display("ADDR = 0x%08h -> INSTR = 0x%08h", instr_addr, instr);

        // Random address
        instr_addr = 32'h0000_0020; // mem[8]
        #10;
        $display("ADDR = 0x%08h -> INSTR = 0x%08h", instr_addr, instr);

        // Out-of-range check (logical, not fatal)
        instr_addr = 32'h0000_FFFC;
        #10;
        $display("ADDR = 0x%08h -> INSTR = 0x%08h", instr_addr, instr);

        $display("-------------------------------------");
        $display("Testbench finished");
        $finish;
    end

endmodule