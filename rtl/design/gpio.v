module gpio_controller #(
    parameter BASE_ADDR = 32'h10000000
)(
    input  wire        clk,
    input  wire        resetn,

    // CPU interface
    input  wire        mem_valid,
    input  wire [31:0] mem_addr,
    input  wire [31:0] mem_wdata,
    input  wire [3:0]  mem_wstrb,
    output reg  [31:0] mem_rdata,
    output reg         mem_ready,

    // GPIO
    output reg  [7:0]  gpio_out,
    input  wire [7:0]  gpio_in
);

    // Internal registers
    reg [15:0] gpio_dir;
    reg [15:0] gpio_out_r;

    // Main logic
    always @(posedge clk) begin
        if (!resetn) begin
            gpio_dir   <= 16'h00FF;
            gpio_out_r <= 16'h0000;
            mem_ready  <= 1'b0;
            mem_rdata  <= 32'b0;
        end else begin
            mem_ready <= 1'b0;

            if (mem_valid) begin

                // =========================
                // DIR REGISTER
                // =========================
                if (mem_addr == BASE_ADDR) begin
                    mem_ready <= 1;

                    if (|mem_wstrb)
                        gpio_dir <= mem_wdata[15:0];
                    else
                        mem_rdata <= {16'b0, gpio_dir};
                end

                // =========================
                // OUTPUT REGISTER
                // =========================
                else if (mem_addr == BASE_ADDR + 4) begin
                    mem_ready <= 1;

                    if (|mem_wstrb)
                        gpio_out_r <= mem_wdata[15:0];
                    else
                        mem_rdata <= {16'b0, gpio_out_r};
                end

                // =========================
                // INPUT REGISTER
                // =========================
                else if (mem_addr == BASE_ADDR + 8) begin
                    mem_ready <= 1;
                    mem_rdata <= {16'b0, gpio_in};
                end
            end
        end
    end

    // Output logic
    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            gpio_out[i] = gpio_dir[i] ? gpio_out_r[i] : 1'b0;
        end
    end

endmodule