`timescale 1ns/1ps
module control_unit(clk, rst, opcode,
ld_ir, pc_write,
reg_write, mem_read, mem_write,
w_sel, alu_op, state_out);
input        clk, rst;
input  [3:0] opcode;
output reg   ld_ir, pc_write;
output reg   reg_write, mem_read, mem_write;
output reg   w_sel;
output reg [3:0] alu_op;
output [2:0] state_out;

// State encoding
parameter IDLE   = 3'd0;
parameter FETCH  = 3'd1;
parameter DECODE = 3'd2;
parameter EXE    = 3'd3;
parameter MEM    = 3'd4;
parameter WB     = 3'd5;
parameter HALT   = 3'd6;
reg [2:0] state, next_state;
assign state_out = state;
always @(posedge clk or posedge rst) begin
if(rst)
state <= IDLE;       // reset → go to IDLE
else
state <= next_state; 
end
always @(*) begin

if(state == IDLE)
next_state = FETCH;
else if(state == FETCH)
next_state = DECODE;
else if(state == DECODE) begin
if(opcode == 4'hF)
next_state = HALT;       // HALT instruction
else if(opcode == 4'h0)
next_state = FETCH;      // NOP → skip
else
next_state = EXE;        // all others → execute
end
else if(state == EXE) begin
if(opcode == 4'h6 || opcode == 4'h7)
next_state = MEM;        // LOAD/STORE → memory
else
next_state = WB;         // arithmetic → writeback
end
else if(state == MEM) begin
if(opcode == 4'h7)
next_state = FETCH;      // STORE → no writeback!
else
next_state = WB;         // LOAD → needs writeback
end
else if(state == WB)
next_state = FETCH;          // always go fetch next
else if(state == HALT)
next_state = HALT;           // stay here forever
else
next_state = IDLE;           // safety default
end
always @(*) begin
ld_ir     = 0;
pc_write  = 0;
reg_write = 0;
mem_read  = 0;
mem_write = 0;
w_sel     = 0;
alu_op    = 4'b0000;

if(state == IDLE) begin
// nothing - just waiting
end

else if(state == FETCH) begin
ld_ir    = 1;  // new instruction into IR
pc_write = 1;  //pc=pc+1
end

else if(state == DECODE) begin
end

else if(state == EXE) begin
if(opcode == 4'h1)      alu_op = 4'b0001; // ADD
else if(opcode == 4'h2) alu_op = 4'b0010; // SUB
else if(opcode == 4'h3) alu_op = 4'b0011; // MUL
else if(opcode == 4'h4) alu_op = 4'b0100; // CMP
else if(opcode == 4'h5) alu_op = 4'b0101; // MOV
else                    alu_op = 4'b0000;
end

else if(state == MEM) begin
if(opcode == 4'h6) mem_read  = 1; // LOAD  → read memory
if(opcode == 4'h7) mem_write = 1; // STORE → write memory
end
else if(state == WB) begin
reg_write = 1; // write result to register file
if(opcode == 4'h6)
w_sel = 1; // LOAD  → take memory data path
else
w_sel = 0; // arith → take ALU result path
if(opcode == 4'h1)      
alu_op = 4'b0001;
else if(opcode == 4'h2) 
alu_op = 4'b0010;
else if(opcode == 4'h3) 
alu_op = 4'b0011;
else if(opcode == 4'h4) 
alu_op = 4'b0100;
else if(opcode == 4'h5) 
alu_op = 4'b0101;
end
else if(state == HALT) begin
end
end
endmodule 
