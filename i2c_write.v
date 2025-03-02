module i2c_write(
	input reset_n,
	input clock,
	input start,
	input [15:0] data,
	input [7:0] slave_addr,
	input sda_in,
	output reg sda_out,
	output reg scl_out,
	output reg stop_ok,
	
	// for test 
	output reg [4:0] state,
	output reg [7:0] CNT,
	output reg [7:0] BYTE,
	output reg ack_ok,
	input [7:0] byte_num
	
);

reg [8:0] addr;


always@ (negedge reset_n or posedge clock) begin
	if(!reset_n) state <=0;
	else begin	
		case (state)
		0:	begin
				sda_out <= 1;
				scl_out <= 1;
				ack_ok	<= 0;
				CNT 	<= 0;
				stop_ok 	<= 1;
				BYTE 	<= 0;
				if (start) state <=11;
			end
			
		1:	begin	
				state	<=2;
				{ sda_out,  scl_out } <= 2'b01; 
				addr	<={slave_addr, 1'b1}; // Write
			end
		
		2: begin
				state	<=3;
				{ sda_out,  scl_out } <= 2'b00;
			end
		
		3: begin
				state	<=4;
				{sda_out, addr} <= {addr, 1'b0};
			end
		
		4:	begin
				state	<=5;
				scl_out <=1'b1;
				CNT 	<=CNT+1'b1;
			end
		
		5: begin 
				scl_out	<=1'b0;
				if(CNT==9) begin	
					if(BYTE==byte_num) state<=6;
				else begin	
					CNT<=0;
					state<=2;
					if(BYTE==0) begin BYTE<=1; addr<= {data[15:8], 1'b1}; end
					else if(BYTE ==1) begin BYTE<=2; addr<={data[7:0], 1'b1}; end
				end
				if(sda_in) ack_ok<=1;
				end
			else state <=2;
			end
		
		6:	begin 
				state<= 7;
				{ sda_out,  scl_out } <= 2'b00;
			end
		
		7: 	begin 
				state<=8;
				{ sda_out,  scl_out } <= 2'b01;
			end
		
		8:	begin
				state<=9;
				{ sda_out,  scl_out } <= 2'b11;
			end
		
		9:	begin	
				state<=10;
				sda_out<=1;
				scl_out<=1;
				CNT<=0;
				stop_ok<=1;
				BYTE<=0;
			end
		
		10:	begin	
				if(!start) state<=11;
			end
			
		11: begin
				stop_ok <=0;
				ack_ok <=0;
				state<=1;
			end
		endcase
		
	end
end
endmodule
			
				
	