`timescale 1ns/1ps

module compteur (
    input  logic clock_i,
    input  logic resetb_i,
    input  logic init_i,      
    input  logic active_i,    
    output logic [4:0] count_o
);

always_ff @(posedge clock_i or negedge resetb_i) begin : counter_seq
    if (!resetb_i) begin
        count_o <= 5'd0;
    end
    else begin
        if (init_i == 1'b1)
            count_o <= 5'd0;
        else if (active_i == 1'b1)
            count_o <= count_o + 1'b1;
    end
end : counter_seq

endmodule : compteur
