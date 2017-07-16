//------------------------------------------------
// mipsmem.sv
// Sarah_Harris@hmc.edu 27 May 2007
// Update to SystemVerilog 17 Nov 2010 DMH
// External unified memory used by MIPS multicycle
// processor.
//------------------------------------------------

module charmem(input  logic        clk,
           input  logic [5:0] caractere, 
           output logic [63:0] bitmap);

  logic  [63:0] RAM[39:0];



  // initialize memory with instructions
  initial
    begin
      $readmemh("charmem.dat",RAM);  // "memfile.dat" contains your instructions in hex
                                     // you must create this file
    end

  assign bitmap = RAM[caractere];
endmodule
