`timescale 1ns/1ps
module mult (
    input  logic [31:0] mat_init_i [0:15],  // état initial S_init
    input  logic [31:0] mat_data_i [0:15],  // état du registre
    input  logic        select_i,            // depuis init_block_o de la FSM
    output logic [31:0] mat_o     [0:15]
);

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin
        assign mat_o[i] = (select_i) ? mat_init_i[i] : mat_data_i[i];
    end
endgenerate

endmodule : mult
