module memory #(
    parameter HEX_FILE = "sw/hello.hex"
)(
    input         clk,
    input  [31:0] addr,
    input  [31:0] wdata,
    input  [ 3:0] wstrb,
    input         valid,
    output reg [31:0] rdata,
    output reg        ready
);
    reg [31:0] mem [0:32767];

    initial begin
        $readmemh(HEX_FILE, mem);
        $display("[mem] first word = %08x", mem[0]);
    end

    wire [14:0] word_addr = addr[16:2];

    always @(posedge clk) begin
        ready <= 0;
        if (valid && !ready) begin       // ← key: only respond once
            if (wstrb == 0) begin
                rdata <= mem[word_addr];
            end else begin
                if (wstrb[0]) mem[word_addr][ 7: 0] <= wdata[ 7: 0];
                if (wstrb[1]) mem[word_addr][15: 8] <= wdata[15: 8];
                if (wstrb[2]) mem[word_addr][23:16] <= wdata[23:16];
                if (wstrb[3]) mem[word_addr][31:24] <= wdata[31:24];
            end
            ready <= 1;
        end
    end
endmodule
// ```

// The key change is `if (valid && !ready)` — this prevents the memory from re-triggering on the cycle where ready is still high. The handshake becomes:
// ```
// cycle N:   valid=1, ready=0  → memory sees request, registers rdata, sets ready=1
// cycle N+1: valid=1, ready=1  → CPU sees ready, samples rdata, deasserts valid
// cycle N+2: valid=0, ready=0  → idle