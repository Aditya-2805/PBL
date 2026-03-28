module data_mem #(
    parameter MEM_DEPTH = 1024
)(
    input  wire        clk,
    input  wire        mem_valid,
    input  wire        mem_wstrb,
    input  wire [31:0] mem_addr,
    input  wire [31:0] mem_wdata,
    output reg  [31:0] mem_rdata,
    output reg         mem_ready
);

    reg [31:0] mem [0:MEM_DEPTH-1];
    wire [31:0] word_addr;

    assign word_addr = mem_addr >> 2;

    // FULL initialization to avoid X
    integer i;
    initial begin
        mem_ready = 1'b0;
        mem_rdata = 32'b0;
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            mem[i] = 32'b0;
    end

    always @(posedge clk) begin
        mem_ready <= 1'b0;

        if (mem_valid) begin
            if (mem_wstrb) begin
                mem[word_addr] <= mem_wdata;   // WRITE
                mem_rdata <= mem_wdata;        // WRITE-THROUGH
            end else begin
                mem_rdata <= mem[word_addr];   // READ
            end
            mem_ready <= 1'b1;
        end
    end

endmodule