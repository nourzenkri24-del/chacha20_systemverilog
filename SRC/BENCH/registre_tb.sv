`timescale 1ns / 1ps

module registre_tb ();

bit clock_s, reset_s, enable_s;
logic [31:0] data_s [0:15];
logic [31:0] q_s [0:15];

// DUT
registre DUT (
  .data_i(data_s),
  .reset_i(reset_s),
  .clock_i(clock_s),
  .enable_i(enable_s),
  .q_o(q_s)
);

// Clock
initial begin
  clock_s = 0;
  forever #5 clock_s = ~clock_s;
end

// Stimuli
initial begin
  // Reset propre
  reset_s = 0;
  enable_s = 0;
  data_s = '{default: 32'b0};

  #12;
  reset_s = 1;

  // Test write
  @(posedge clock_s);
  enable_s = 1;
  data_s = '{default: 32'hAAAA_AAAA};

  @(posedge clock_s);

  // Test hold
  enable_s = 0;
  data_s = '{default: 32'hFFFF_FFFF};

  @(posedge clock_s);

  // Vérif : doit rester AAAA
  if (q_s !== '{default: 32'hAAAA_AAAA})
    $error("Erreur: registre n'a pas conservé la valeur");

  // Test update
  enable_s = 1;
  @(posedge clock_s);
  data_s = '{default: 32'h5555_5555};

  @(posedge clock_s);

  $finish;
end

endmodule
