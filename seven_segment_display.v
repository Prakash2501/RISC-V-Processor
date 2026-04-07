`timescale 1ns / 1ps

module seven_segment_display(
    input clk, rst,
    input [15:0] instruction,
    input [15:0] reg_value,
    output reg [7:0] display_box,
    output [6:0] seg0, seg1
);

// ── Clock divider (~1ms refresh) ───────────────────────────
reg [16:0] counter = 0;

always @(posedge clk) begin
    if(rst)
        counter <= 0;
    else if(counter == 17'd99999)
        counter <= 0;
    else
        counter <= counter + 1;
end

wire slow_clk = (counter == 17'd99999);

// ── Digit selector (0-3) ───────────────────────────────────
reg [1:0] digit = 0;

always @(posedge clk) begin
    if(rst)
        digit <= 0;
    else if(slow_clk)
        digit <= digit + 1;
end

// ── LEFT DISPLAY (reg_value) - FIXED ORDER ─────────────────
reg [3:0] nibble_left;

always @(*) begin
    case(digit)
        2'd0: nibble_left = reg_value[3:0];      // RIGHTMOST
        2'd1: nibble_left = reg_value[7:4];
        2'd2: nibble_left = reg_value[11:8];
        2'd3: nibble_left = reg_value[15:12];    // LEFTMOST
    endcase
end

// ── RIGHT DISPLAY (instruction) - FIXED ORDER ──────────────
reg [3:0] nibble_right;

always @(*) begin
    case(digit)
        2'd0: nibble_right = instruction[3:0];
        2'd1: nibble_right = instruction[7:4];
        2'd2: nibble_right = instruction[11:8];
        2'd3: nibble_right = instruction[15:12];
    endcase
end

// ── Anode control (active LOW) ─────────────────────────────
always @(*) begin
    display_box = 8'b11111111;

    case(digit)
        2'd0: display_box = 8'b11101110;
        2'd1: display_box = 8'b11011101;
        2'd2: display_box = 8'b10111011;
        2'd3: display_box = 8'b01110111;
    endcase
end

// ── Segment decoder (hex) ──────────────────────────────────
function [6:0] hex_to_7seg;
    input [3:0] val;
    begin
        case(val)
            4'h0: hex_to_7seg = 7'b1000000;
            4'h1: hex_to_7seg = 7'b1111001;
            4'h2: hex_to_7seg = 7'b0100100;
            4'h3: hex_to_7seg = 7'b0110000;
            4'h4: hex_to_7seg = 7'b0011001;
            4'h5: hex_to_7seg = 7'b0010010;
            4'h6: hex_to_7seg = 7'b0000010;
            4'h7: hex_to_7seg = 7'b1111000;
            4'h8: hex_to_7seg = 7'b0000000;
            4'h9: hex_to_7seg = 7'b0010000;
            4'hA: hex_to_7seg = 7'b0001000;
            4'hB: hex_to_7seg = 7'b0000011;
            4'hC: hex_to_7seg = 7'b1000110;
            4'hD: hex_to_7seg = 7'b0100001;
            4'hE: hex_to_7seg = 7'b0000110;
            4'hF: hex_to_7seg = 7'b0001110;
        endcase
    end
endfunction

reg [6:0] seg0_r, seg1_r;

always @(*) begin
    seg0_r = hex_to_7seg(nibble_left);
    seg1_r = hex_to_7seg(nibble_right);
end

// ── FIX: Bit order correction (VERY IMPORTANT) ─────────────
assign seg0 = {seg0_r[0], seg0_r[1], seg0_r[2], seg0_r[3], seg0_r[4], seg0_r[5], seg0_r[6]};
assign seg1 = {seg1_r[0], seg1_r[1], seg1_r[2], seg1_r[3], seg1_r[4], seg1_r[5], seg1_r[6]};

endmodule