`timescale 1ns/1ps  
module instruction_decoder(instruction, opcode, rd, rs1, rs2,mem_address);
input  [15:0] instruction;
output [3:0]  opcode;
output [2:0]  rd, rs1, rs2;
output [8:0]  mem_address;
assign opcode = instruction[15:12]; // top 4 bits = operation
assign rd = instruction[11:9];  // dest register
assign rs1 = instruction[8:6];   // source register 1
assign rs2= instruction[5:3];   // source register 2
assign mem_address = instruction[8:0];   // for LOAD/STORE address
endmodule 
