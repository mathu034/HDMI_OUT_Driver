module hdmi_display(
	input CLOCK_50,
	input RESET_N, 
	input SWITCH_RED,
	input SWITCH_GREEN, 
	input SWITCH_BLUE,
	
	output [23:0] HDMI_TX_DATA,
	output HDMI_TX_VSYNC, 
	output HDMI_TX_HSYNC, 
	output HDMI_TX_DE, 
	output HDMI_TX_CLK,
	
	input  HDMI_TX_INT,
	inout  HDMI_I2C_SDA, 
	output HDMI_I2C_SCL, 
	output START,
	
	output HDMI_I2S0,  // dont care
	output HDMI_MCLK,  // dont care
	output HDMI_LRCLK, // dont care
	output HDMI_SCLK   // dont care
);
	
wire CLOCK_25, LOCK;
wire RESET;

assign RESET=~RESET_N;

assign HDMI_I2S0  = 1'b z;
assign HDMI_MCLK  = 1'b z;
assign HDMI_LRCLK = 1'b z;
assign HDMI_SCLK  = 1'b z;
	
pll_25 pll_25(
.refclk(CLOCK_50),
.rst(RESET),
.outclk_0(CLOCK_25),
.locked(LOCK)
);

HDMI_main hdmi_main (
  // input
  .clock_25     (CLOCK_25),
  .clock_50    	(CLOCK_50),
  .reset       	(~LOCK),
  .h_sync       (HDMI_TX_HSYNC),
  .v_sync       (HDMI_TX_VSYNC),
  .switch_red   (SWITCH_RED),
  .switch_green (SWITCH_GREEN),
  .switch_blue	(SWITCH_BLUE),

  // output
  .data_enable (HDMI_TX_DE),
  .vga_clk     (HDMI_TX_CLK),
  .rgb_channel (HDMI_TX_DATA)
);

// **I2C Interface for ADV7513 initial config**
i2c_hdmi #(
  .clk_freq (50000000), // 50MHz
  .i2c_freq (20000)    // 20kHz for i2c clock
  )

 i2c_hdmi (
  .clock (CLOCK_50),
  .reset_n  (RESET_N),
  .i2c_scl  (HDMI_I2C_SCL),
  .i2c_sda  (HDMI_I2C_SDA),
  .hdmi_tx	(HDMI_TX_INT),
  .start    (START)
);

endmodule