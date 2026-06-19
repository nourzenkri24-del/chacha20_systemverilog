`timescale 1ns/1ps

module xor_cipher (
    input  logic         clk_i,
    input  logic         resetb_i,
    input  logic         cipher_valid_i,
    input  logic [1:0]   count_i,
    input  logic [127:0] data_i,
    input  logic [31:0]  keystream_i [0:15],
    output logic [127:0] cipher_o
);

logic [127:0] keystream_128_s;

always_comb begin
    case (count_i)
        2'd0 : keystream_128_s = {keystream_i[3],  keystream_i[2],  keystream_i[1],  keystream_i[0]};
        2'd1 : keystream_128_s = {keystream_i[7],  keystream_i[6],  keystream_i[5],  keystream_i[4]};
        2'd2 : keystream_128_s = {keystream_i[11], keystream_i[10], keystream_i[9],  keystream_i[8]};
        default : keystream_128_s = 128'd0;
    endcase
end

// registre (mémoire)
always_ff @(posedge clk_i or negedge resetb_i) begin
    if (!resetb_i)
        cipher_o <= 128'd0;
    else if (cipher_valid_i)
        cipher_o <= data_i ^ keystream_128_s;
end

endmodule
