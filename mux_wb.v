`timescale 1ns/1ps 

module mux_wb(alu_result, mem_data, w_sel, out);
input  [15:0] alu_result; // from ALU
input  [15:0] mem_data;   // from Data Memory
input         w_sel;      // 0 = ALU path, 1 = Memory path
output [15:0] out;
assign out = w_sel ? mem_data : alu_result;
endmodule
