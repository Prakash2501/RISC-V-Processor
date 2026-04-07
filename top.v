`timescale 1ns/1ps  
module top(clk,rst,sw,display_box,seg0,seg1,halt_led);

input clk, rst;
input  [2:0] sw;

output halt_led;
output [7:0] display_box;
output [6:0] seg0, seg1;

// ===================== WIRES =====================
wire [8:0]  pc_address;
wire [15:0] instr;
wire [15:0] ins_out;

wire [3:0]  opcode;
wire [2:0]  rd, rs1, rs2;
wire [8:0]  mem_address;

wire [15:0] rs1_data, rs2_data, rd_data;
wire [15:0] alu_result;
wire g,e,l;

wire [15:0] read_data;
wire [15:0] write_data;

// Control signals
wire ld_ir, pc_write;
wire reg_write, mem_read, mem_write;
wire w_sel;
wire [3:0] alu_op;
wire [2:0] state;

assign halt_led = (state == 3'd6);

// ===================== CLOCK DIVIDER =====================
reg [26:0] div;

always @(posedge clk or posedge rst) begin
    if(rst)
        div <= 0;
    else
        div <= div + 1;
end

// VERY SLOW CPU CLOCK (visible execution)
wire slow_clk = div[26];

// ===================== CPU BLOCKS =====================
pc pc_inst(
    .clk(slow_clk), .rst(rst),
    .pc_write(pc_write),
    .address(pc_address)
);

instruction_memory im_inst(
    .address(pc_address),
    .instr(instr)
);

ir ir_inst(
    .clk(slow_clk), .rst(rst),
    .ld_ir(ld_ir),
    .instr_in(instr),
    .instr_out(ins_out)   // ✅ CORRECT
);

instruction_decoder id_inst(
    .instruction(ins_out),
    .opcode(opcode),
    .rd(rd), .rs1(rs1), .rs2(rs2),
    .mem_address(mem_address)
);

register_file rf_inst(
    .clk(slow_clk), .rst(rst),
    .rs1(rs1), .rs2(rs2), .rd(rd),
    .reg_write(reg_write),
    .write_data(write_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .rd_data(rd_data)
);

alu alu_inst(
    .alu_op(alu_op),
    .a(rs1_data), .b(rs2_data),
    .result(alu_result),
    .g(g), .e(e), .l(l)
);

data_memory dm_inst(
    .clk(slow_clk), .rst(rst),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .address(mem_address),
    .write_data(rd_data),   // your design style (OK)
    .read_data(read_data)
);

mux_wb wb_inst(
    .alu_result(alu_result),
    .mem_data(read_data),
    .w_sel(w_sel),
    .out(write_data)
);

control_unit cu_inst(
    .clk(slow_clk), .rst(rst),
    .opcode(opcode),
    .ld_ir(ld_ir),
    .pc_write(pc_write),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .w_sel(w_sel),
    .alu_op(alu_op),
    .state_out(state)
);

// ===================== SWITCH SYNC =====================
reg [2:0] sw_reg;

always @(posedge clk) begin
    sw_reg <= sw;
end

// ===================== REGISTER READ =====================
wire [15:0] reg_value;
assign reg_value = rf_inst.registers[sw_reg];

// ===================== CLOCK DOMAIN SYNC =====================
// Detect rising edge of slow_clk inside fast clk domain
reg slow_clk_d;

always @(posedge clk) begin
    slow_clk_d <= slow_clk;
end

wire slow_clk_posedge = slow_clk & ~slow_clk_d;

// ===================== DISPLAY LATCH =====================
reg [15:0] instr_disp;
reg [15:0] reg_value_disp;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        instr_disp      <= 16'h0000;
        reg_value_disp  <= 16'h0000;
    end
    else if(slow_clk_posedge) begin
        instr_disp      <= ins_out;
        reg_value_disp  <= reg_value;
    end
end

// ===================== DISPLAY =====================
seven_segment_display ssd(
    .clk(clk),  // FAST clock for multiplexing
    .rst(rst),
    .instruction(instr_disp),     // ✅ stable
    .reg_value(reg_value_disp),   // ✅ stable
    .display_box(display_box),
    .seg0(seg0),
    .seg1(seg1)
);

endmodule