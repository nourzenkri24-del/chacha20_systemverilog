`timescale 1ns / 1ps

module round_diagonale_tb();

logic [31:0] mat_entree_s [0:15];
logic [31:0] mat_sortie_s [0:15];


round_diagonale DUT (
        .mat_i(mat_entree_s),
        .mat_o(mat_sortie_s)
);

    
initial begin
        mat_entree_s[0]  = 32'hdf768f7d;
        mat_entree_s[1]  = 32'hcf72de24;
        mat_entree_s[2]  = 32'h6d0b7504;
        mat_entree_s[3]  = 32'h9cc7c200;
        mat_entree_s[4]  = 32'hb51b4034;
        mat_entree_s[5]  = 32'h3f18819b;
        mat_entree_s[6]  = 32'h60a74d6f;
        mat_entree_s[7]  = 32'h2134ec9b;
        mat_entree_s[8]  = 32'hfd8e795e;
        mat_entree_s[9]  = 32'h13d1f2cf;
        mat_entree_s[10] = 32'h1fb825a2;
        mat_entree_s[11] = 32'h3c44a0df;
        mat_entree_s[12] = 32'he8c5efe0;
        mat_entree_s[13] = 32'hc97103b9;
        mat_entree_s[14] = 32'h9e145a96;
        mat_entree_s[15] = 32'h84846cf5;

        #10;

        $display("RESULTATS");
        for (int i = 0; i < 16; i++) begin
            $display("mat_sortie[%0d] = %h", i, mat_sortie_s[i]);
        end
        
        #10;
        $finish;
end

endmodule : round_diagonale_tb
