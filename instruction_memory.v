`timescale 1ns/1ps
module instruction_memory(address, instr);
input  [8:0]  address;
output [15:0] instr;
reg [15:0] mem [0:511]; // 512 locations, 16-bit each
integer i;
initial begin
for(i = 0; i < 512; i = i + 1)
mem[i] = 16'h0000;
mem[0] = 16'h620A;  // LOAD R1, mem[10]
mem[1] = 16'h640B;  // LOAD R2, mem[11]
mem[2] = 16'h1650;  // ADD  R3, R1, R2
mem[3] = 16'h3850;  // MUL  R4, R1, R2  ← changed
mem[4] = 16'h7815;  // STORE R4, mem[21] ← changed
mem[5] = 16'hF000;  // HALT             =
end
assign instr = mem[address];
endmodule
