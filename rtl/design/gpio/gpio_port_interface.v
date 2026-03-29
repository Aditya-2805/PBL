module gpio_port_interface( 
    input wire PCLK,
    input wire PRESETn,

    input wire [31:0] gpio_dir,
    input wire [31:0] gpio_dataout,

    inout  [31:0] xpins,
    output reg [31:0] gpio_datain
);

genvar i;

generate 
for(i = 0; i<32; i=i+1)
begin 
    assign xpins[i] = gpio_dir[i] ? gpio_dataout[i] : 1'bz; // If direction is output, drive the pin; else high impedance
end 
endgenerate

always @(posedge PCLK)
begin 
    gpio_data <= xpins; // Sample the input pins on the rising edge of the clock
end


endmodule