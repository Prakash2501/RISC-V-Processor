module ir(clk, rst, ld_ir, instr_in, instr_out);
input clk, rst, ld_ir;
input  [15:0] instr_in;
output reg [15:0] instr_out;
always @(posedge clk or posedge rst) begin
if(rst)
instr_out <= 16'h0000;  // reset → NOP
else if(ld_ir)
instr_out <= instr_in;  // latch only when FSM says so
end
endmodule 
