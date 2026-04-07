`timescale 1ns/1ps
module tb_top;
reg clk, rst;
integer cycle_count;
initial clk = 0;
always #5 clk = ~clk;
initial begin
rst = 1;
cycle_count = 0;
#15 rst = 0;
#1000 $finish;
end
always @(posedge clk) begin
if(rst)
cycle_count <= 0;
else
cycle_count <= cycle_count + 1;
end
initial begin

wait(uut.cu_inst.state == 3'd6);
#1;
$display("  Total Clock Cycles = %0d", cycle_count);
$display("  Total Time         = %0d ns", cycle_count * 10);
$display("      REGISTER FILE FINAL VALUES:");
$display("  R0 = %0d", uut.rf_inst.registers[0]);
$display("  R1 = %0d", uut.rf_inst.registers[1]);
$display("  R2 = %0d", uut.rf_inst.registers[2]);
$display("  R3 = %0d", uut.rf_inst.registers[3]);
$display("  R4 = %0d", uut.rf_inst.registers[4]);
$display("  R5 = %0d", uut.rf_inst.registers[5]);
$display("  DATA MEMORY:");
$display("  mem[10] = %0d", uut.dm_inst.mem[10]);
$display("  mem[11] = %0d", uut.dm_inst.mem[11]);
$display("  mem[20] = %0d", uut.dm_inst.mem[20]);
$display("  mem[21] = %0d", uut.dm_inst.mem[21]);
end
initial begin
$monitor("T=%0t | CYC=%0d | ST=%0d | IR=%h | R1=%0d | R2=%0d | R3=%0d | R4=%0d | R5=%0d | g=%b e=%b l=%b",
$time,
cycle_count,
uut.cu_inst.state,
uut.ir_inst.instr_out,
uut.rf_inst.registers[1],
uut.rf_inst.registers[2],
uut.rf_inst.registers[3],
uut.rf_inst.registers[4],
uut.rf_inst.registers[5],
uut.g, uut.e, uut.l);
end
top uut(.clk(clk), .rst(rst));

endmodule 
