`timescale 1ns / 1ps

module registre (
    input  logic [31:0] data_i [0:15],
    input  logic enable_i, clock_i, reset_i,
    output logic [31:0] q_o [0:15]
);
    always_ff @(posedge clock_i, negedge reset_i) begin
        if (reset_i ==  1'b0) begin
            q_o <= '{default: 32'h0};
	end
        else begin
	    if (enable_i == 1'b1) begin
                q_o <= data_i;
	    end
	end
    end
endmodule : registre
