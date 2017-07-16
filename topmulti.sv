`timescale 1ns / 1ps
//------------------------------------------------
// topmulti.sv
// David_Harris@hmc.edu 9 November 2005
// Update to SystemVerilog 17 Nov 2010 DMH
// Top level system including multicycle MIPS 
// and unified memory
//------------------------------------------------

module topmulti (
  input wire reset, 
	input wire CLOCK_50,	//board clock: 50MHz
	output wire VGA_HS,		//horizontal sync out
	output wire VGA_VS,		//vertical sync out
	output reg [3:0] VGA_R,	//red vga output
	output reg [3:0] VGA_G, //green vga output
	output reg [3:0] VGA_B	//blue vga output
	);

	logic CLOCK_25;
  
  logic [31:0] writedata, adr, readdata, vadr;
	logic [63:0] vdata;
  logic        memwrite;
  
	clockdiv cd(
	.clr(reset),
	.clk(CLOCK_50),
	.dclk(CLOCK_25)
	);
	
	vga640x480 vd(
	.clr(reset),
	.dclk(CLOCK_25),
  .vdata(vdata),
	.hsync(VGA_HS),
	.vsync(VGA_VS),
	.red(VGA_R),
	.green(VGA_G),
	.blue(VGA_B)
	);  
  
  // microprocessor (control & datapath)
  mips mips(CLOCK_25, reset, adr, writedata, memwrite, readdata, charprint);

  // memory 
  mem mem(CLOCK_25, memwrite, adr, writedata, readdata);
	
	// video memory
	charmem charmem(clock_25,charprint, readdata[25:20], vdata )

endmodule
