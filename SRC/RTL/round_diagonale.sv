`timescale 1ns / 1ps

module round_diagonale(
	input logic [31:0] mat_i [0:15],
	output logic [31:0] mat_o [0:15]
);

quarterround QR1(
	.a_i(mat_i[0]),
	.b_i(mat_i[5]),
	.c_i(mat_i[10]),
	.d_i(mat_i[15]),
	
	.a_o(mat_o[0]),
	.b_o(mat_o[5]),
	.c_o(mat_o[10]),
	.d_o(mat_o[15])
);

quarterround QR2(
	.a_i(mat_i[1]),
	.b_i(mat_i[6]),
	.c_i(mat_i[11]),
	.d_i(mat_i[12]),
	
	.a_o(mat_o[1]),
	.b_o(mat_o[6]),
	.c_o(mat_o[11]),
	.d_o(mat_o[12])
);

quarterround QR3(
	.a_i(mat_i[2]),
	.b_i(mat_i[7]),
	.c_i(mat_i[8]),
	.d_i(mat_i[13]),
	
	.a_o(mat_o[2]),
	.b_o(mat_o[7]),
	.c_o(mat_o[8]),
	.d_o(mat_o[13])
);

quarterround QR4(
	.a_i(mat_i[3]),
	.b_i(mat_i[4]),
	.c_i(mat_i[9]),
	.d_i(mat_i[14]),
	
	.a_o(mat_o[3]),
	.b_o(mat_o[4]),
	.c_o(mat_o[9]),
	.d_o(mat_o[14])
);

endmodule : round_diagonale
