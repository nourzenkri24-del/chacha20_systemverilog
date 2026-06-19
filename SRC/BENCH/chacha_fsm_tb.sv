`timescale 1ns/1ps

module chacha_fsm_tb();

logic        clock_s;
logic        resetb_s;
logic        start_s;
logic        data_valid_s;
logic [4:0]  counter_s;

logic        end_s;
logic        cipher_valid_s;
logic        init_counter_s;
logic        active_counter_s;
logic        init_block_s;
logic        enable_reg_s;

chacha_fsm dut (
    .clock_i         (clock_s),
    .resetb_i        (resetb_s),
    .start_i         (start_s),
    .data_valid_i    (data_valid_s),
    .counter_i       (counter_s),
    .end_o           (end_s),
    .cipher_valid_o  (cipher_valid_s),
    .init_counter_o  (init_counter_s),
    .active_counter_o(active_counter_s),
    .init_block_o    (init_block_s),
    .enable_reg_o    (enable_reg_s)
);

always #5 clock_s = ~clock_s;

// Simulation du compteur externe
always_ff @(posedge clock_s or negedge resetb_s) begin
    if (!resetb_s)
        counter_s <= 5'd0;
    else if (init_counter_s)
        counter_s <= 5'd0;
    else if (active_counter_s)
        counter_s <= counter_s + 1'b1;
end

// Tâche envoi d'un bloc
task automatic send_block;
    input logic wait_before;
    begin
        if (wait_before) begin
            data_valid_s = 0;
            repeat(2) @(posedge clock_s); #1;
        end
        data_valid_s = 1;
        @(posedge clock_s); #1;  // CIPHER
        @(posedge clock_s); #1;  // MEM
    end
endtask

// Simuli
initial begin

    clock_s      = 0;
    resetb_s     = 0;
    start_s      = 0;
    data_valid_s = 0;

    repeat(2) @(posedge clock_s); #1;
    resetb_s = 1;
    repeat(2) @(posedge clock_s); #1;
    
    // Test 1 : 
    $display("Test 1");

    start_s = 1;
    @(posedge clock_s); #1;
    start_s = 0;

    @(posedge end_s);
    $display("t=%0t : keystream pret, counter=%0d", $time, counter_s);

    send_block(1);
    $display("t=%0t : P1 chiffre, counter=%0d", $time, counter_s);
    send_block(1);
    $display("t=%0t : P2 chiffre, counter=%0d", $time, counter_s);
    send_block(1);
    $display("t=%0t : P3 chiffre, counter=%0d", $time, counter_s);

    data_valid_s = 0;
    repeat(3) @(posedge clock_s); #1;

    // Test 2 : data_valid immédiat
    $display("Test 2 : data_valid immediat");

    start_s = 1;
    @(posedge clock_s); #1;
    start_s = 0;

    @(posedge end_s);
    $display("t=%0t : keystream pret, counter=%0d", $time, counter_s);

    send_block(0);
    $display("t=%0t : P1 chiffre, counter=%0d", $time, counter_s);
    send_block(0);
    $display("t=%0t : P2 chiffre, counter=%0d", $time, counter_s);
    send_block(0);
    $display("t=%0t : P3 chiffre, counter=%0d", $time, counter_s);

    data_valid_s = 0;
    repeat(3) @(posedge clock_s); #1;

    // Test 3 : reset en cours de rondes
    $display("Test 3 : reset en cours");

    start_s = 1;
    @(posedge clock_s); #1;
    start_s = 0;

    repeat(3) @(posedge clock_s); #1;
    resetb_s = 0;
    @(posedge clock_s); #1;
    resetb_s = 1;
    $display("t=%0t : reset -> retour IDLE, counter=%0d", $time, counter_s);

    repeat(3) @(posedge clock_s); #1;

    $display("Fin des tests");
    $finish;
end

// Affichage terminal
initial begin
    $monitor("t=%0t | state=%s | counter=%0d | end=%b | cipher_valid=%b | init=%b | active=%b | enable=%b | init_block=%b",
        $time,
        dut.current_state_s.name(),
        counter_s,
        end_s,
        cipher_valid_s,
        init_counter_s,
        active_counter_s,
        enable_reg_s,
        init_block_s
    );
end

endmodule
