`timescale 1ns / 1ps

module chacha_top_prof_tb();

    // Testbench signals
    logic clock_tb;
    logic resetb_tb;
    logic start_tb;
    logic [127:0] data_tb;
    logic data_valid_tb;
    logic [255:0] key_tb;
    logic [95:0] nonce_tb;
    logic [127:0] cipher_tb;
    logic cipher_valid_tb;
    logic end_tb;

    logic [367:0] full_cipher_tb; // To store the full 46 bytes of cipher output

    // Instantiate the DUT
    chacha_top dut (
        .clock_i(clock_tb),
        .resetb_i(resetb_tb),
        .start_i(start_tb),
        .data_i(data_tb),
        .data_valid_i(data_valid_tb),
        .key_i(key_tb),
        .nonce_i(nonce_tb),
        .cipher_o(cipher_tb),
        .cipher_valid_o(cipher_valid_tb),
        .end_o(end_tb)
    );

    // Clock generation
    initial begin
        clock_tb = 0;
        forever #5 clock_tb = ~clock_tb; // 100 MHz clock
    end

    // Test sequence
    initial begin

        // Format time displays
        $timeformat(-9, 3, " ns", 7);

        // Initialize signals
        resetb_tb = 0;
        start_tb = 0;
        key_tb = 256'h4e7ced7e860e69aed3a53fefd52a3eec27a09386322fdc9a76a2b5eae921c73a;
        nonce_tb = 96'hd4ac91b9caccf25906e46ce3;
        data_tb = 128'h0;
        data_valid_tb = 0;

        repeat (20) @(negedge clock_tb); // Wait for a few clock cycles
        resetb_tb = 1; // Release reset
        @(negedge clock_tb);

        start_tb = 1; // Start the encryption process
        @(negedge clock_tb);
        start_tb = 0; // Deassert start after one clock cycle

        wait (end_tb == 1); // Wait for the end signal from the DUT

        @(negedge clock_tb);

        // Send first plaintext word
        data_tb = 128'h65704f20656966696e67697320657551;
        @(negedge clock_tb);
        data_valid_tb = 1; // Indicate that data is valid

        @(negedge clock_tb);

        // Wait for cipher output to be valid
        wait (cipher_valid_tb == 1);
        @(negedge clock_tb);   
        @(negedge clock_tb);   
        $display("Ciphertext word #1 @%t: %h", $time, cipher_tb); // Display the cipher output for the first word
        full_cipher_tb[127:0] = cipher_tb; // Store the first 128 bits of cipher output
       
        data_valid_tb = 0; // Deassert data valid after one clock cycle
        @(negedge clock_tb);

        // Send second plaintext word
        data_tb = 128'h65766e49206561727574614e20617472;
        @(negedge clock_tb);
        data_valid_tb = 1; // Indicate that data is valid

        // Wait for cipher output to be valid
        wait (cipher_valid_tb == 1);
        @(negedge clock_tb);
        @(negedge clock_tb);
        $display("Ciphertext word #2 @%t: %h", $time, cipher_tb); // Display the cipher output for the second word
        full_cipher_tb[255:128] = cipher_tb; // Store the second 128 bits of cipher output
       
        data_valid_tb = 0; // Deassert data valid after one clock cycle
         @(negedge clock_tb);
        
        // Last plaintext word with 2 bytes of padding
        data_tb = 128'h00003f206172656e754d20746e75696e;
        @(negedge clock_tb);
        data_valid_tb = 1; // Indicate that data is valid

        // Wait for cipher output to be valid
        wait (cipher_valid_tb == 1);
        @(negedge clock_tb);
        @(negedge clock_tb);
        $display("Ciphertext word #3 @%t: %h", $time, cipher_tb); // Display the cipher output for the third word
        full_cipher_tb[367:256] = cipher_tb[111:0]; // Store the last 112 bits of cipher output

        data_valid_tb = 0; // Deassert data valid after one clock cycle

        #10;

        $display("Computed Ciphertext: %h", full_cipher_tb); // Display the full 46 bytes of cipher output
        $display("Expected Ciphertext: fab0b90f73406abbf0408580ba3ee46c5ee17a42f515954acdecd4eeef62322523b73ceabe5e8e05fc68143022e0");
        $display("Computed ^ Expected: %h", full_cipher_tb ^ 368'hfab0b90f73406abbf0408580ba3ee46c5ee17a42f515954acdecd4eeef62322523b73ceabe5e8e05fc68143022e0);

        if (|(full_cipher_tb ^ 368'hfab0b90f73406abbf0408580ba3ee46c5ee17a42f515954acdecd4eeef62322523b73ceabe5e8e05fc68143022e0) == 0) begin
            $display("Test PASSED: Computed ciphertext matches expected value.");
        end else begin
            $display("Test FAILED: Computed ciphertext does NOT match expected value.");
        end

        $finish; // End the simulation

    end
endmodule : chacha_top_prof_tb
