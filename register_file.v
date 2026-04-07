`timescale 1ns/1ps
module register_file(clk, rst,rs1, rs2, rd,reg_write, write_data,rs1_data, rs2_data, rd_data);
input clk, rst, reg_write;
input  [2:0] rs1, rs2, rd;
input  [15:0] write_data;
output [15:0] rs1_data, rs2_data, rd_data;
reg [15:0] registers [0:7]; // 8 registers, R0 to R7
integer i;
always @(posedge clk or posedge rst) begin
if(rst) begin
for(i = 0; i < 8; i = i + 1)
registers[i] <= 16'h0000;
end
else if(reg_write && rd != 0)
registers[rd] <= write_data; // write to destination register
end 
assign rs1_data = registers[rs1];
assign rs2_data = registers[rs2];
assign rd_data  = registers[rd];
endmodule 
