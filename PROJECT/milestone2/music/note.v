module note(CLOCK_50, SW, KEY, GPIO_0)
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
	output [35:0] GPIO_0;
	
	noteGenerator(CLOCK_50, SW[9], KEY[0], SW[3:0], GPIO_0[0]); 

endmodule

// ------------------NOTE GENERATOR------------------------------

module noteGenerator(clk, enable, resetn, note, sound);
	input clk, enable, resetn;
	input [3:0] note;
	output sound;
	
	wire [15:0] frequency;
	noteLUT nl(note, frequency);
	
	soundGenerator sg(clk, resetn, enable, frequency, sound);
endmodule

module soundGenerator(clk, resetn, enable, freq, sound);
	input clk, resetn, enable;
	input [15:0] freq;
	output reg sound;
	
	reg [15:0] count;
    
    always @(posedge clk)
		begin
		if (!resetn)
    		count <= 16'd0;
    	else if (enable)
			begin	
			if(count == 16'd0)
				count <= freq;
			else
				count <= count - 1'b1;
			end
		end
	 
    always @(posedge clk) 
		begin
		if (!resetn)
			sound <= 1'b0;
		else if (enable)
			begin
			if(count == 16'd0)
				sound <= ~sound;
			end
		end
endmodule

module noteLUT(note, frequency);
    input [3:0] note;
    output reg [15:0] frequency;
    
    always @(*)
        case(note)
//         0: frequency = 16'd47710 - 1'b1; // C4
//  	    1: frequency = 16'd42517 - 1'b1; // D4
//  	    2: frequency = 16'd35817 - 1'b1; // F4
//  	    3: frequency = 16'd31888 - 1'b1; // G4
//  	    4: frequency = 16'd28409 - 1'b1; // A4
//  	    5: frequency = 16'd23901 - 1'b1; // C5
//  	    6: frequency = 16'd21295 - 1'b1; // D5
//         7: frequency = 16'd17908 - 1'b1; // F5
//         8: frequency = 16'd15944 - 1'b1; // G5
//  	    9: frequency = 16'd14205 - 1'b1; // A5
		0: frequency = 16'd3 - 1'b1; // C4
 	    1: frequency = 16'd4 - 1'b1; // D4
 	    2: frequency = 16'd5 - 1'b1; // F4
 	    3: frequency = 16'd6 - 1'b1; // G4
 	    4: frequency = 16'd7 - 1'b1; // A4
 	    5: frequency = 16'd8 - 1'b1; // C5
 	    6: frequency = 16'd9 - 1'b1; // D5
        7: frequency = 16'd10 - 1'b1; // F5
	    8: frequency = 16'd11 - 1'b1; // G5
 	    9: frequency = 16'd12 - 1'b1; // A5
 	    default: frequency = 16'd0;
        endcase
endmodule
// ---------------------------------------------------------