`timescale 1ns/1ps

module chacha_top (
    input  logic         clock_i,
    input  logic         resetb_i,
    input  logic         start_i,
    input  logic         data_valid_i,

    input  logic [127:0] data_i,
    input  logic [255:0] key_i,
    input  logic [95:0]  nonce_i,

    output logic         end_o,
    output logic         cipher_valid_o,
    output logic [127:0] cipher_o
);

// Signaux internes
logic [31:0] state_init_s [0:15];
logic [31:0] keystream_s [0:15];

logic [4:0]  counter_s;

logic end_s;
logic init_counter_s;
logic active_counter_s;
logic init_block_s;
logic enable_reg_s;

// État initial ChaCha
assign state_init_s[0]  = 32'h61707865;
assign state_init_s[1]  = 32'h3320646e;
assign state_init_s[2]  = 32'h79622d32;
assign state_init_s[3]  = 32'h6b206574;

assign state_init_s[4]  = key_i[31:0];
assign state_init_s[5]  = key_i[63:32];
assign state_init_s[6]  = key_i[95:64];
assign state_init_s[7]  = key_i[127:96];
assign state_init_s[8]  = key_i[159:128];
assign state_init_s[9]  = key_i[191:160];
assign state_init_s[10] = key_i[223:192];
assign state_init_s[11] = key_i[255:224];

assign state_init_s[12] = 32'h00000001;

assign state_init_s[13] = nonce_i[31:0];
assign state_init_s[14] = nonce_i[63:32];
assign state_init_s[15] = nonce_i[95:64];

// Compteur rounds
compteur cpt (
    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .init_i(init_counter_s),
    .active_i(active_counter_s),
    .count_o(counter_s)
);

// FSM
chacha_fsm fsm (
    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .start_i(start_i),
    .data_valid_i(data_valid_i),
    .counter_i(counter_s),

    .end_o(end_s),
    .cipher_valid_o(cipher_valid_o),
    .init_counter_o(init_counter_s),
    .active_counter_o(active_counter_s),
    .init_block_o(init_block_s),
    .enable_reg_o(enable_reg_s)
);

// Bloc ChaCha (génération keystream)
chacha_bloc bloc (
    .mat_init_i(state_init_s),
    .init_i(init_block_s),
    .clk_i(clock_i),
    .enable_i(enable_reg_s),
    .rst_i(resetb_i),
    .mat_o(keystream_s)
);

// XOR + sélection + sortie
xor_cipher cipher_u (
    .clk_i          (clock_i),
    .resetb_i       (resetb_i),
    .cipher_valid_i (cipher_valid_o),
    .count_i        (counter_s),
    .data_i         (data_i),
    .keystream_i    (keystream_s),
    .cipher_o       (cipher_o)
);

assign end_o = end_s;

endmodule
