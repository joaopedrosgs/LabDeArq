`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Source: https://www.element14.com/community/thread/23394/l/draw-vga-color-bars-with-fpga-in-verilog
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga640x480(
  input wire dclk,      //pixel clock: 25MHz
  input wire clr,      //asynchronous reset
  input wire [63:0] vdata,   //video data from memory 
  output wire hsync,    //horizontal sync out
  output wire vsync,    //vertical sync out
  output reg [3:0] red,  //red vga output
  output reg [3:0] green, //green vga output
  output reg [3:0] blue  //blue vga output
  );

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 525; // vertical lines per frame

parameter hfp = 16;   // beginning of horizontal front porch
parameter hpulse = 96;   // hsync pulse length
parameter hbp = 48;   // end of horizontal back porch

parameter vfp = 10;   // beginning of vertical front porch
parameter vpulse = 2;   // vsync pulse length
parameter vbp = 33;     // end of vertical back porch

parameter hchar = 8;
parameter vchar = 8;
parameter paddingtop = 208+vbp:
parameter paddingleft = 288+hbp;

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

reg [2:0] charh;
reg [2:0] charv;

wire pixel;


// Downsampling to 20x20 pixels per bit 

//upsampling to 64x64
assign pixel = vdata[((hc-paddingleft)/8) + ((vc-paddingtop/8)*8)];

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc > hpixels-hbp-hpulse && hc < hpixels-hbp) ? 0 : 1;
assign vsync = (vc > vlines-vbp-vpulse && vc < vlines-vbp) ? 0 : 1;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
  // reset condition
  if (clr == 1)
  begin
    hc <= 0;
    vc <= 0;
  end
  else
  begin
    // keep counting until the end of the line
    if (hc < 800 - 1)
      hc <= hc + 1;
    else
    // When we hit the end of the line, reset the horizontal
    // counter and increment the vertical counter.
    // If vertical counter is at the end of the frame, then
    // reset that one too.
    begin
      hc <= 0;
      if (vc < 525 - 1)
        vc <= vc + 1;
      else
        vc <= 0;
    end
    
  end
end

// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
  // os 64 pixels centrais da tela
  if (vc > paddingtop && vc < paddingtop + 64)
  begin

    if (hc > paddingleft  && hc < paddingtop-64 )
    begin
      red = {4{pixel}};
      green = {4{pixel}};
      blue = ~{4{pixel}};    
    end
      // we're outside active horizontal range so display black
    else
    begin
      red = 0;
      green = 0;
      blue = 0;
    end
  end
  // we're outside active vertical range so display black
  else
  begin
    red = 0;
    green = 0;
    blue = 0;
  end
end

endmodule