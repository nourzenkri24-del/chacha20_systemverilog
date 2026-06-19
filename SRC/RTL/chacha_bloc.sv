`timescale 1ns / 1ps
module chacha_bloc (
	input logic [31:0] mat_init_i [0:15],
	input logic init_i,
	input logic clk_i,
	input logic enable_i,
	input logic rst_i,
	
	output logic [31:0] mat_o [0:15]
	
);

logic [31:0] mat_rc_s [0:15];
logic [31:0] mat_rd_s [0:15];
logic [31:0] mat_rg_s [0:15];
logic [31:0] mat_mult_s [0:15];

genvar i;
generate
	for (i = 0; i < 16; i = i+1) begin
	    assign mat_o[i] = mat_mult_s[i] + mat_init_i[i];
	end
endgenerate

mult mux(
	.mat_init_i(mat_init_i),
	.mat_data_i(mat_mult_s),
	.select_i(init_i),
	.mat_o(mat_rc_s)
);

round_colonne rc(
	.mat_i(mat_rc_s),
	.mat_o(mat_rd_s)
);

round_diagonale rd(
	.mat_i(mat_rd_s),
	.mat_o(mat_rg_s)
);

registre rg(
	.data_i(mat_rg_s),
	.enable_i(enable_i),
	.clock_i(clk_i),
	.reset_i(rst_i),
	.q_o(mat_mult_s)
);

endmodule: chacha_bloc
