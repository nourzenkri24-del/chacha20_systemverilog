`timescale 1ns/1ps

module chacha_bloc_tb();

    logic clk;
    logic rst;
    logic enable;
    logic init;

    logic [31:0] mat_init_i [0:15];
    logic [31:0] mat_o   [0:15];

chacha_bloc DUT (
        .mat_init_i(mat_init_i),
        .init_i(init),
        .clk_i(clk),
        .enable_i(enable),
        .rst_i(rst),
        .mat_o(mat_o)
);

    // CLOCK
    initial begin
         clk = 1'b0;
         forever #5 clk = ~clk;
    end

    initial begin
        rst = 0;
        enable = 0;
        init = 0;

        mat_init_i[0]  = 32'h61707865;
        mat_init_i[1]  = 32'h3320646e;
        mat_init_i[2]  = 32'h79622d32;
        mat_init_i[3]  = 32'h6b206574;

        mat_init_i[4]  = 32'he921c73a;
        mat_init_i[5]  = 32'h76a2b5ea;
        mat_init_i[6]  = 32'h322fdc9a;
        mat_init_i[7]  = 32'h27a09386;

        mat_init_i[8]  = 32'hd52a3eec;
        mat_init_i[9]  = 32'hd3a53fef;
        mat_init_i[10] = 32'h860e69ae;
        mat_init_i[11] = 32'h4e7ced7e;

        mat_init_i[12] = 32'h00000001;
        mat_init_i[13] = 32'h06e46ce3;
        mat_init_i[14] = 32'hcaccf259;
        mat_init_i[15] = 32'hd4ac91b9;

        #10
        rst = 1;
        @(posedge clk);
        init = 0;
        enable = 0;
        
        @(posedge clk);
        
        init = 1;
        enable = 1;    
       
        @(posedge clk);
        init = 0;
        
        repeat(9) @(posedge clk);
      
        enable = 0;
        
        @(posedge clk);
        
        $display("RESULTAT");
        for (int i = 0; i < 16; i++) begin
            $display("mat_o[%0d] = %h", i, mat_o[i]);
        end

        #10;
        $stop;
    end

endmodule
