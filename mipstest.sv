`timescale 1ns / 1ps
//------------------------------------------------
// mipstest.sv
// David_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Testbench for MIPS processor
//------------------------------------------------

module testbench();

  logic        clk, resetn;

  // instantiate device to be tested
  topmulti dut(.CLOCK_50(clk), .reset(resetn));
  
  // initialize test
  initial
    begin
      resetn <= 1; # 22; resetn <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

endmodule



