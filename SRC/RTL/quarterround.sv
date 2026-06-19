`timescale 1ns / 1ps

module quarterround(
	input logic [31:0] a_i,
	input logic [31:0] b_i,
	input logic [31:0] c_i,
	input logic [31:0] d_i,
	
	output logic [31:0] a_o,
	output logic [31:0] b_o,
	output logic [31:0] c_o,
	output logic [31:0] d_o
);

logic [31:0] sumarx7_s;
logic [31:0] shiftarx7_s;

logic [31:0] sumarx8_s;
logic [31:0] shiftarx8_s;

logic [31:0] sumarx12_s;
logic [31:0] shiftarx12_s;

logic [31:0] sumarx16_s;
logic [31:0] shiftarx16_s;

arx7 a7(
	.augend_i(shiftarx8_s),
	.addend_i(sumarx12_s),
	.xor_i(shiftarx12_s),
	.sum_o(sumarx7_s),
	.shift_o(shiftarx7_s)
);

arx8 a8(
	.augend_i(sumarx16_s),
	.addend_i(shiftarx12_s),
	.xor_i(shiftarx16_s),
	.sum_o(sumarx8_s),
	.shift_o(shiftarx8_s)
);

arx12 a12(
	.augend_i(shiftarx16_s),
	.addend_i(c_i),
	.xor_i(b_i),
	.sum_o(sumarx12_s),
	.shift_o(shiftarx12_s)
);

arx16 a16(
	.augend_i(a_i),
	.addend_i(b_i),
	.xor_i(d_i),
	.sum_o(sumarx16_s),
	.shift_o(shiftarx16_s)
);

assign a_o = sumarx8_s;
assign b_o = shiftarx7_s;
assign c_o = sumarx7_s;
assign d_o = shiftarx8_s;

endmodule : quarterround
