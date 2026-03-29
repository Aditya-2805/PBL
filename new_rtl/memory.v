/* Single memory block — holds ROM (program) and RAM (data/stack)
   Word-addressed, 4 bytes per entry
   Total: 128KB (ROM 0x0000_0000..0x0000_FFFF + RAM 0x0001_0000..0x0001_FFFF) */

module memory #(
    parameter HEX_FILE = "sw/hello.hex"
)(
    input         clk,
    input  [31:0] addr,
    input  [31:0] wdata,
    input  [ 3:0] wstrb,   /* byte write enables */
    input         valid,
    output reg [31:0] rdata,
    output reg        ready
);
    reg [31:0] mem [0:32767];  /* 32K words = 128KB */

    initial begin
        $readmemh(HEX_FILE, mem);
    end

    wire [14:0] word_addr = addr[16:2];  /* drop byte bits, drop bit 17+ */

    always @(posedge clk) begin
        ready <= 0;
        if (valid) begin
            if (wstrb == 0) begin
                /* Read */
                rdata <= mem[word_addr];
            end else begin
                /* Write — byte enables */
                if (wstrb[0]) mem[word_addr][ 7: 0] <= wdata[ 7: 0];
                if (wstrb[1]) mem[word_addr][15: 8] <= wdata[15: 8];
                if (wstrb[2]) mem[word_addr][23:16] <= wdata[23:16];
                if (wstrb[3]) mem[word_addr][31:24] <= wdata[31:24];
                rdata <= 32'hx;
            end
            ready <= 1;
        end
    end
endmodule