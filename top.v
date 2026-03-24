module top (
    input  wire clk,
    input  wire resetn
);

    // -----------------------------
    // PicoRV32 memory interface
    // -----------------------------
    wire        mem_valid;
    wire        mem_instr;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;
    wire        mem_ready;

    // -----------------------------
    // Memory read data wires
    // -----------------------------
    wire [31:0] imem_rdata;
    wire [31:0] dmem_rdata;
    wire        dmem_ready;

    // -----------------------------
    // PicoRV32 Core
    // -----------------------------
    picorv32 cpu (
        .clk        (clk),
        .resetn     (resetn),

        .mem_valid  (mem_valid),
        .mem_instr  (mem_instr),
        .mem_addr   (mem_addr),
        .mem_wdata  (mem_wdata),
        .mem_wstrb  (mem_wstrb),
        .mem_rdata  (mem_rdata),
        .mem_ready  (mem_ready)
    );

    // -----------------------------
    // Instruction Memory
    // -----------------------------
    imem imem_inst (
        .instr_addr (mem_addr),
        .instr      (imem_rdata)
    );

    // -----------------------------
    // Data Memory
    // -----------------------------
    data_mem dmem_inst (
        .clk        (clk),
        .mem_valid  (mem_valid & ~mem_instr),
        .mem_wstrb  (|mem_wstrb),
        .mem_addr   (mem_addr),
        .mem_wdata  (mem_wdata),
        .mem_rdata  (dmem_rdata),
        .mem_ready  (dmem_ready)
    );

    // -----------------------------
    // Read data mux
    // -----------------------------
    assign mem_rdata = mem_instr ? imem_rdata : dmem_rdata;

    // -----------------------------
    // Ready logic
    // -----------------------------
    assign mem_ready = mem_instr ? 1'b1 : dmem_ready;

endmodule
