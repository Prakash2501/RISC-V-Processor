`timescale 1ns/1ps  
module alu(alu_op, a, b, result, g, e, l);
input  [3:0]  alu_op;
input  [15:0] a, b;
output reg [15:0] result;
output g, e, l; 
always @(*) begin
case(alu_op)
4'b0001: result = a + b;  // ADD
4'b0010: result = a - b;  // SUB
4'b0011: result = a * b;  // MUL
4'b0100: result = a - b;  // CMP 
4'b0101: result = a;      // MOV
default: result = 16'h0000;
endcase
end
assign e = (a == b);        // equal
assign l = (a <  b);        // less than
assign g = (a >  b);        // greater than

endmodule 
