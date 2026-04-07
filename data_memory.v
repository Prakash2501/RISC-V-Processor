`timescale 1ns/1ps  
module data_memory(clk, rst,
mem_read, mem_write,
address, write_data,
read_data);
input        clk, rst, mem_read, mem_write;
input  [8:0]  address;
input  [15:0] write_data;
output [15:0] read_data;
reg [15:0] mem     [0:511]; // data memory
reg [15:0] data_reg;        // MDR: holds read value stable
integer i;
initial begin
for(i = 0; i < 512; i = i + 1)
mem[i] = 16'h0000;

mem[10] = 16'd10;  // value for R1
mem[11] = 16'd11;  // value for R2
end

always @(posedge clk) begin
if(rst)
data_reg<=16'h0000;
else begin
if(mem_write)
mem[address] <= write_data;  // STORE: write to memory
if(mem_read)
data_reg <= mem[address];    // LOAD: latch into MDR
end
end

// MDR holds read value stable across state changes
assign read_data = data_reg;

endmodule 
