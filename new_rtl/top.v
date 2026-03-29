/* Minimum SoC:
     PicoRV32 core
   + Memory (ROM + RAM in one block)
   + UART (fake — writes go to $write in simulation)

   Memory map:
     0x0000_0000 - 0x0000_FFFF  ROM  (program)
     0x0001_0000 - 0x0001_FFFF  RAM  (stack, data)
     0x1000_0000                UART TX (write byte = print char)
*/

module top (
    input clk,
    input resetn   /* active-low reset */
);
    /* PicoRV32 memory interface signals */
    wire        mem_valid;
    wire        mem_instr;
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [ 3:0] mem_wstrb;
    wire [31:0] mem_rdata;

    /* ------- PicoRV32 core ------- */
  picorv32 #(
    .STACKADDR(32'h0001_FFFC),
    .PROGADDR_RESET(32'h0),
    .ENABLE_MUL(0),
    .ENABLE_DIV(0),
    .COMPRESSED_ISA(1)
) cpu (
    .clk       (clk),
    .resetn    (resetn),
    .mem_valid (mem_valid),
    .mem_instr (mem_instr),
    .mem_ready (mem_ready),
    .mem_addr  (mem_addr),
    .mem_wdata (mem_wdata),
    .mem_wstrb (mem_wstrb),
    .mem_rdata (mem_rdata),

    // these were missing — tie them off
    .trap         (),          // output, don't care
    .mem_la_read  (),          // output, don't care
    .mem_la_write (),
    .mem_la_addr  (),
    .mem_la_wdata (),
    .mem_la_wstrb (),
    .pcpi_valid   (),          // coprocessor — not using
    .pcpi_insn    (),
    .pcpi_rs1     (),
    .pcpi_rs2     (),
    .pcpi_wr      (1'b0),      // inputs must be driven
    .pcpi_rd      (32'h0),
    .pcpi_wait    (1'b0),
    .pcpi_ready   (1'b0),
    .irq          (32'h0),     // no interrupts
    .eoi          (),
    .trace_valid  (),
    .trace_data   ()
);
    /* ------- Address decode ------- */
    wire sel_mem  = (mem_addr[31:17] == 0);          /* 0x0000_0000 - 0x0001_FFFF */
    wire sel_uart = (mem_addr == 32'h1000_0000);

    /* ------- Memory ------- */
    wire [31:0] mem_rdata_mem;
    wire        mem_ready_mem;

    memory #(.HEX_FILE("sw/hello.hex")) ram (
        .clk   (clk),
        .addr  (mem_addr),
        .wdata (mem_wdata),
        .wstrb (sel_mem ? mem_wstrb : 4'b0),
        .valid (mem_valid && sel_mem),
        .rdata (mem_rdata_mem),
        .ready (mem_ready_mem)
    );

    /* ------- UART (simulation only) ------- */
    reg uart_ready;
    always @(posedge clk) begin
        uart_ready <= 0;
        if (mem_valid && sel_uart && mem_wstrb != 0) begin
            $write("%c", mem_wdata[7:0]);  /* print character immediately */
            uart_ready <= 1;
        end
    end

    /* ------- Mux read data and ready back to CPU ------- */
    assign mem_rdata = sel_mem  ? mem_rdata_mem : 32'h0;
    assign mem_ready = sel_mem  ? mem_ready_mem :
                       sel_uart ? uart_ready    : 0;

endmodule