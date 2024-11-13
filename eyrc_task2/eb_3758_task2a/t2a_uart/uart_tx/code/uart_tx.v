// // EcoMender Bot : Task 2A - UART Transmitter
// /*
// Instructions
// -------------------
// Students are not allowed to make any changes in the Module declaration.

// This file is used to generate UART Tx data packet to transmit the messages based on the input data.

// Recommended Quartus Version : 20.1
// The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

// Warning: The error due to compatibility will not be entertained.
// -------------------
// */

// /*
// Module UART Transmitter

// Input:  clk_3125 - 3125 KHz clock
//         parity_type - even(0)/odd(1) parity type
//         tx_start - signal to start the communication.
//         data    - 8-bit data line to transmit

// Output: tx      - UART Transmission Line
//         tx_done - message transmitted flag
// */
module uart_tx(
    input clk_3125,
    input parity_type, tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

// Initial values for tx and tx_done
initial begin
    tx = 1;
    tx_done = 0;
end

// Add your code here...


reg [3:0] state = 0;
reg [3:0] counter = 0;
reg parity_counter = 0;
reg check;

parameter ST_IDLE = 3'b000, 
          ST_START = 3'b001, 
          ST_DATA = 3'b010, 
          ST_PARITY = 3'b011, 
          ST_STOP = 3'b100;
			
reg [2:0] bit_index =3'b111 ;
			 

always @(posedge clk_3125) begin
	counter = counter +1;
	if (tx_start )begin 
	state=ST_START;
	counter =14;
	end
	
    // Counter for timing control (hold each bit for 16 cycles)
   if (counter==14) begin   
        // State machine
        case (state)
            ST_IDLE: begin
                tx = 1;  // Idle state keeps tx high
                tx_done = 0;
					 check=0;
            end

            ST_START: begin
                tx = 0;  // Start bit
                state = ST_DATA;
					 parity_counter = 0;
                bit_index = 7;  // Reset bit index for data transmission
            end

            ST_DATA: begin
                tx = data[bit_index];  // Transmit data bits
                if (data[bit_index])
                    parity_counter = parity_counter + 1;  // Count 1s for parity

                if ((bit_index) > 3'b000)
                    bit_index = bit_index-1;
                else
                    state = ST_PARITY;  // Move to parity bit after 8 data bits
            end

            ST_PARITY: begin
                // Calculate parity based on parity_type (even/odd)
                if (parity_type) 
                    tx = ~parity_counter;  // Odd parity
                else
                    tx = parity_counter;  // Even parity
                state = ST_STOP;  // After parity, move to stop bit
            end

            ST_STOP: begin
                tx = 1;  // Stop bit is always high
                state = ST_IDLE;
				    check=1;	 // Return to idle state after stop bit
                
            end
        endcase

		 if (state==ST_IDLE && check==1) tx_done=1;
		 else tx_done=0;
		 counter =0;
    end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
