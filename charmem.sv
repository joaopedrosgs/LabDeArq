//------------------------------------------------
// charmem.sv
// Memoria externa para os caracteres.
//------------------------------------------------

module charmem( input  logic        clk,
                input logic charprint,
                input  logic [5:0] caractere, 
                output logic [63:0] bitmap);

  logic  [63:0] CRAM[39:0];



  // inicializando a memoria com os bitmaps 
  initial
    begin
      $readmemh("charmem.dat",CRAM);  
    end

  always @(posedge clk) begin
    if (charprint) begin
      bitmap = CRAM[caractere];
    end
  end

endmodule
