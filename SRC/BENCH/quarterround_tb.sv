`timescale 1ns / 1ps

module quarterround_tb();

logic [31:0] entree1_s;
logic [31:0] entree2_s;
logic [31:0] entree3_s;
logic [31:0] entree4_s;

logic [31:0] sortie1_s;
logic [31:0] sortie2_s;
logic [31:0] sortie3_s;
logic [31:0] sortie4_s;

quarterround DUT (
	.a_i(entree1_s),
	.b_i(entree2_s),
	.c_i(entree3_s),
	.d_i(entree4_s),
	
	.a_o(sortie1_s),
	.b_o(sortie2_s),
	.c_o(sortie3_s),
	.d_o(sortie4_s)
);

initial begin
	entree1_s = 32'h11111111;
	entree2_s = 32'h01020304;
	entree3_s = 32'h9b8d6f43;
	entree4_s = 32'h01234567;
	#10
	
	$display("a: %X , b: %X, c: %X, d: %X", sortie1_s, sortie2_s, sortie3_s, sortie4_s);
	$stop;
end
endmodule : quarterround_tb
