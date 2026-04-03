`timescale 1ns/1ps

module top (
    input clk,
    input resetn
);

    wire        mem_valid;
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;
    wire        mem_instr;
    wire        trap;

    // 🔥 ENABLE COMPRESSED ISA HERE
    picorv32 #(
        .COMPRESSED_ISA(1)
    ) cpu (
        .clk         (clk),
        .resetn      (resetn),

        .trap        (trap),

        .mem_valid   (mem_valid),
        .mem_instr   (mem_instr),
        .mem_ready   (mem_ready),
        .mem_addr    (mem_addr),
        .mem_wdata   (mem_wdata),
        .mem_wstrb   (mem_wstrb),
        .mem_rdata   (mem_rdata),

        .irq         (32'b0),
        .eoi         ()
    );

    dmem memory (
        .clk(clk),
        .mem_valid(mem_valid),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready)
    );

endmodule