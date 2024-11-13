// EcoMender Bot : Task 2A - UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Baudrate: 230400 

Input:  clk_3125 - 3125 KHz clock
        rx      - UART Receiver

Output: rx_msg - received input message of 8-bit width
        rx_parity - received parity bit
        rx_complete - successful uart packet processed signal
*/

// module declaration
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

initial begin
    rx_msg = 0;
	  rx_parity = 0;
    rx_complete = 0;
end

// Add your code here....

parameter ST_IDLE = 3'b000, 
          ST_START = 3'b001, 
          ST_DATA = 3'b010, 
          ST_PARITY = 3'b011, 
          ST_STOP = 3'b100;
			 
reg [3:0] counter=0;
reg [3:0] state=ST_IDLE;
reg [7:0] data;
reg parity_counter;
reg [2:0]bit_index;
reg check=0;
reg parity;
			 
always @(posedge clk_3125) begin
	counter=counter+1'b1;
	rx_complete<=0;
	
	if (counter==13) begin
	
		case(state)
			ST_START:begin
							state<=ST_DATA;
							parity_counter<=0;
							bit_index<=7;
							data<=0;
						end
			ST_DATA:begin
							data[bit_index]<=rx;
							if (bit_index>0) bit_index<=bit_index-1'b1;
							else state <= ST_PARITY;
							if (rx) begin
							parity_counter <= parity_counter + 1'b1;
							end
					  end
			ST_PARITY:begin
							parity=rx;
							state<=ST_STOP;
							if (parity_counter != parity) data <= 8'h3F;
						 end
			ST_STOP: begin
							state <= ST_IDLE;
							check<=1;
						end
			ST_IDLE: begin
							rx_complete<=0;
							check<=0;
						end
		
		endcase
	
	end
	
//	if (counter==13 && state==ST_IDLE && check==1) rx_msg=data;
	if (state == ST_IDLE && rx==0) begin
		state <= ST_START;
//		counter=13;
	 end
	
	
	if (counter==14) begin
		 counter =0;
//		 if (state==ST_IDLE && check==1) begin
//			 rx_complete=1;
//			 rx_msg=data;
//			 rx_parity = parity;
//			 check=0;
//		 end
//		 else rx_complete=0;
//		 counter =0;
    end
	if (state==ST_IDLE && check==1 && counter==1) begin
			 rx_complete<=1;
			 rx_msg=data;
			 rx_parity = parity;
			 check<=0;
		 end
		 else rx_complete<=0;
	 

end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////


endmodule

