`timescale 1ns/1ps
module pc(clk, rst, pc_write, address);
input  clk, rst, pc_write;
output reg [8:0] address;
always @(posedge clk or posedge rst) begin
if(rst)
address <= 0;           
else if(pc_write)
address <= address + 1; 
end
endmodule
