module arx16 (
	input logic [31:0] augend_i,
	input logic [31:0] addend_i,
	input logic [31:0] xor_i,
	output logic [31:0] sum_o,
	output logic [31:0] shift_o
);
logic [31:0] sum_s; 
logic [31:0] shift_s;

//Addition
assign sum_s = augend_i + addend_i;
//Xor
assign shift_s = sum_s ^ xor_i;
//Rotation7
assign shift_o = {shift_s[15:0] , shift_s[31:16]};
//sum
assign sum_o = sum_s;

endmodule : arx16
