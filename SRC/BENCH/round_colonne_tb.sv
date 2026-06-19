`timescale 1ns / 1ps

module round_colonne_tb();

logic [31:0] mat_entree_s [0:15];
logic [31:0] mat_sortie_s [0:15];


round_colonne DUT (
        .mat_i(mat_entree_s),
        .mat_o(mat_sortie_s)
);

    
initial begin
        mat_entree_s[0]  = 32'h61707865;
        mat_entree_s[1]  = 32'h3320646e;
        mat_entree_s[2]  = 32'h79622d32;
        mat_entree_s[3]  = 32'h6b206574;
        mat_entree_s[4]  = 32'he921c73a;
        mat_entree_s[5]  = 32'h76a2b5ea;
        mat_entree_s[6]  = 32'h322fdc9a;
        mat_entree_s[7]  = 32'h27a09386;
        mat_entree_s[8]  = 32'hd52a3eec;
        mat_entree_s[9]  = 32'hd3a53fef;
        mat_entree_s[10] = 32'h860e69ae;
        mat_entree_s[11] = 32'h4e7ced7e;
        mat_entree_s[12] = 32'h00000001;
        mat_entree_s[13] = 32'h06e46ce3;
        mat_entree_s[14] = 32'hcaccf259;
        mat_entree_s[15] = 32'hd4ac91b9;

        #10;

        $display("RESULTATS");
        for (int i = 0; i < 16; i++) begin
            $display("mat_sortie[%0d] = %h", i, mat_sortie_s[i]);
        end
        
        #10;
        $finish;
end

endmodule : round_colonne_tb
