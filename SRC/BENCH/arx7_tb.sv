`timescale 1ns / 1ps

module arx7_tb();

logic [31:0] augend_s;
logic [31:0] addend_s;
logic [31:0] xor_s;
logic [31:0] sum_s;
logic [31:0] shift_s;

arx7 DUT (
	.augend_i(augend_s),
	.addend_i(addend_s),
	.xor_i(xor_s),
	.sum_o(sum_s),
	.shift_o(shift_s)
);

initial begin
	augend_s = 32'h01234567;
	addend_s = 32'h77777777;
	xor_s = 32'h01020304;
	#10
	//augend_s = 32'hF2E1A126;
	//addend_s = 32'h2B3E4456;
	//xor_s = 32'h12B7F568;
	//#10
	$display("sum: %X , shift: %X", sum_s, shift_s);
	$stop;
end
endmodule : arx7_tb
