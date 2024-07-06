`include "i2c_write.v"

module I2C_Controller(
	input CLK, 
	input START_SIG, 
	input RESET, 
	input WRITE, 
	input [23:0] DATA,
	output I2C_SCL,
	output STOP_SIG, 
	output ACK,
	inout I2C_SDA
);

wire SDA;
assign I2C_SDA= SDA? 1'bz: 1'b0;

i2c_write first(
	.reset_n  ( RESET),
	.clock    ( CLK),
	.start      ( START_SIG  ),
	.stop_ok   ( STOP_SIG),
	.ack_ok   ( ACK  ),
	.byte_num ( 2    ),  //2byte	
	.sda_in     ( I2C_SDA),//IN
	.sda_out    ( SDA    ),//OUT
	.scl_out    ( I2C_SCL ),	
	.slave_addr ( DATA[23:16] ),
	.data     ( DATA[15:0]  )	
);

endmodule




