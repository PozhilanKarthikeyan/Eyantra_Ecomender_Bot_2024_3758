// EcoMender Bot : Task 1A : PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 1MHz Clock Frequency to 500Hz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : clk_1MHz, pulse_width
//Output : clk_500Hz, pwm_signal

module pwm_generator(
    input clk_1MHz,
    input [3:0] pulse_width,
    output reg clk_500Hz, pwm_signal
);

initial begin
    clk_500Hz = 0; pwm_signal = 1;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
reg [6:0] clk_counter = -1;
reg clk_10KHz = 1 ;
reg [4:0]pwm_counter=-1;

always @(posedge clk_1MHz) begin
        clk_counter = clk_counter + 1'b1;

        if (clk_counter == 50) begin
            clk_10KHz = ~clk_10KHz;  
            clk_counter = 0;         
        end
    end
always @(posedge clk_10KHz) begin
        pwm_counter = pwm_counter + 1'b1;

        if (pwm_counter < pulse_width)
            pwm_signal = 1;
        else
            pwm_signal = 0;

        if (pwm_counter == 20)begin
            pwm_counter = 0;
				pwm_signal = 1;
				end
			if (pwm_counter ==10 || pwm_counter == 0) begin
				clk_500Hz = ~clk_500Hz;
		   end
				
    end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
