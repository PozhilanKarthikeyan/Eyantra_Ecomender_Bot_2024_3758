// EcoMender Bot : Task 1B : Color Detection using State Machines
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will detect colors red, green, and blue using state machine and frequency detection.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Color Detection
//Inputs : clk_1MHz, cs_out
//Output : filter, color

// Module Declaration
module t1b_cd_fd (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [8:0] counter;
reg count;

parameter RED = 2'b00, BLUE = 2'b01, GREEN = 2'b11, CLEAR = 2'b10;

reg [1:0] state; 


reg [15:0] freq_red, freq_blue, freq_green;

initial begin
    filter = 3;
    color = 0;
	 count=0;
    state = 3;
    counter = 0;
    freq_red = 0; freq_blue = 0; freq_green = 0;
end

always @(posedge clk_1MHz) begin
    if (filter == 2) begin
        filter = filter + 1'b1;  
        state = filter;  
    end else begin
        if (counter == 500) begin
            filter = filter + 1'b1;  
            state = filter;
            counter = 1;  
        end else begin
            counter = counter + 1'b1;  
        end
    end
end

always @(posedge cs_out,posedge clk_1MHz ) begin
    case (state)
        RED: begin
            freq_red <= freq_red + 1'b1;
				count=0;
        end
        BLUE: begin
            freq_blue <= freq_blue + 1'b1;
        end
        GREEN: begin
            freq_green <= freq_green + 1'b1;

        end
        CLEAR: begin
				if (count==0)begin
					if (freq_red > freq_blue && freq_red > freq_green)
						 color <= 2'b01;  
					else if (freq_green > freq_blue)
						 color <= 2'b10;  
					else
						 color <= 2'b11; 

					freq_red = 0;
					freq_green = 0;
					freq_blue = 0;
					count=count+1;
				end
        end
    endcase
end



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
