/**
Descripcion,
Testbench simple para vgaHdmi,
sirve para verificar que las senales de hsync y vsync se envíen correctamente.

-----------------------------------------------------------------------------
Author : Nicolas Hasbun, nhasbun@gmail.com
File   : vgaHdmi_TB.v
Create : 2017-06-15 15:44:30
Editor : sublime text3, tab size (2)
-----------------------------------------------------------------------------
*/

`timescale 1ns / 1ps
module hdmi_tb;

//Internal signals declarations:
reg clock_25, clock_50;
reg reset;
reg switch_red, switch_green, switch_blue;
wire h_sync;
wire v_sync;
wire data_enable;
wire vga_clk;
wire [23:0] rgb_channel;

// Unit Under Test port map
HDMI_main UUT (
  // input
  .clock_25  (clock_25),
  .clock_50(clock_50),
	.reset  (reset),
	.h_sync  (h_sync),
	.v_sync  (v_sync),

  // output
  .switch_red   (switch_red),
  .switch_green   (switch_green),
  .switch_blue   (switch_blue),
	.data_enable(data_enable),
  .vga_clk  (vga_clk),
  .rgb_channel(rgb_channel)
  );

initial begin
  clock_25   = 0;
  reset   = 1;
  switch_red = 0;
  switch_green = 0;
  switch_blue = 0;
  #10;
  reset = 0;
  #4000
  
  switch_red = 0;
  switch_green = 0;
  switch_blue = 0;
  #4000000
  switch_red = 1;
  switch_green = 0;
  switch_blue = 0;
  #1000
  switch_red = 1;
  switch_green = 0;
  switch_blue = 0;
  #1000;
  switch_red = 0;
  switch_green = 1;
  switch_blue = 0;
  #1000
  
  switch_red = 0;
  switch_green = 0;
  switch_blue = 1;
  #1000
  forever begin
    clock_25 = ~clock_25;
    #10;
  end
end

initial begin
  clock_50 = 0;
  #10;
  forever begin
    clock_50 = ~clock_50;
    #5;
  end
end

endmodule

