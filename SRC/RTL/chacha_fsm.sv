`timescale 1ns/1ps

module chacha_fsm (
	input  logic clock_i,    
	input  logic resetb_i,
	input  logic start_i,
	input  logic data_valid_i,
	input  logic [4:0] counter_i, 

    	output logic end_o, //une sortie de chachatop (mis a 1 quand keystream prêt
    	output logic cipher_valid_o, //une sortie de chachatop (mis a 1 dans CIPHER)
    	output logic init_counter_o, //initalise le compteur externe
    	output logic active_counter_o, //controle l'incrémentation du compteur externe
    	output logic init_block_o, //initialise le bloc chacha round
    	output logic enable_reg_o //active la mémorisation du registre      
);

typedef enum logic [2:0] { 
        IDLE = 3'b000,
        INIT = 3'b001,
        ROUND = 3'b010,
        KEYSTREAM = 3'b011,
        WAIT = 3'b100,
        CIPHER = 3'b101,
        MEM = 3'b110,
        DONE = 3'b111
} state_t;

state_t current_state_s, next_state_s;

// Registre d'état
always_ff @(posedge clock_i or negedge resetb_i) begin
	if (!resetb_i)
	    current_state_s <= IDLE;
	else
	    current_state_s <= next_state_s;
end

// Logique de transition
always_comb begin
        next_state_s = current_state_s;
        
        case (current_state_s)
            
            IDLE : 
            if (start_i) next_state_s = INIT;
            
            INIT: 
            next_state_s = ROUND;
            
            ROUND: 
            if (counter_i == 5'd8) next_state_s = KEYSTREAM;
            else next_state_s = ROUND;
            
            KEYSTREAM:                                 
            next_state_s = WAIT;
            
            WAIT:
            if (data_valid_i) next_state_s = CIPHER;
            
            CIPHER: 
            next_state_s = MEM;
            
            MEM :
    	    if (counter_i == 5'd3) next_state_s = DONE;
    	    else if (!data_valid_i) next_state_s = WAIT;
            
            DONE :
            if (!start_i) next_state_s = IDLE;
            
        endcase
end

    // Logique de sortie (Moore)
    always_comb begin
        // Valeurs par défaut
        end_o            = 1'b0;
        cipher_valid_o   = 1'b0;
        init_counter_o   = 1'b0;
        init_block_o     = 1'b0;
        active_counter_o = 1'b0;
        enable_reg_o     = 1'b0;

        case (current_state_s)
            IDLE : begin
            end
            INIT : begin
                init_counter_o   = 1'b1;  // reset compteur
                init_block_o     = 1'b1;
                enable_reg_o     = 1'b1;  // charge la valeur initiale dans le registre
            end
            ROUND : begin
                active_counter_o = 1'b1;  // incrémente le compteur
                enable_reg_o     = 1'b1;  // mémorise après chaque ronde
            end
            KEYSTREAM : begin
                end_o            = 1'b1;
                init_counter_o   = 1'b1;
            end
            WAIT : begin
            	cipher_valid_o   = 1'b0;
            end
            CIPHER : begin
                cipher_valid_o   = 1'b1;
                active_counter_o = 1'b1;
            end
            MEM : begin
            end
            
            DONE : begin
            end
        endcase
    end

endmodule
