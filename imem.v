module imem#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEMORY_SIZE = 4096
)(
    input  wire [ADDR_WIDTH-1:0] instr_addr,
    output wire [DATA_WIDTH-1:0] instr
);

    reg [DATA_WIDTH-1:0] mem[0:MEMORY_SIZE-1];

    initial begin 
        $readmemh("instruction.hex", mem);

        // ---- DEBUG PRINTS ----
        $display("IMEM[0] = %h", mem[0]);
        $display("IMEM[1] = %h", mem[1]);
        $display("IMEM[2] = %h", mem[2]);
        $display("IMEM[3] = %h", mem[3]);
        $display("IMEM[4] = %h", mem[4]);
    end

    assign instr = mem[instr_addr[ADDR_WIDTH-1:2]];

endmodule