module music(CLOCK_25, KEY, speaker);
		input CLOCK_25;
		input [3:0] KEY;
		output speaker;
		
		assign enable = ~KEY[2] | ~KEY[1] | ~KEY[0];
		
		
		wire speaker;
	   wire enable;
		reg [1:0] note_address;	
		
		always@(*) begin
			if (~KEY[2])
				note_address <= 2'b01;
			else if(~KEY[1])
				note_address <= 2'b10;
			else if(~KEY[0])
				note_address <= 2'b11;
			else
				note_address <= 2'b00;
		end
		
		play_note play(.clk(CLOCK_25), 
							.enable(enable), 
							.note_address(note_address), 
							.speaker(speaker));
		
		
//		play_do do(.clk(CLOCK_25),
//					  .enable_do(enable_do),
//					  .speaker(speaker));
//		
//		play_re re(.clk(CLOCK_25),
//					  .enable_re(enable_re),
//					  .speaker(speaker));
//		
//		play_mi mi(.clk(CLOCK_25),
//					  .enable_mi(enable_mi),
//					  .speaker(speaker));
endmodule
		

		
module play_note(clk, enable, note_address, speaker);
		input clk;
		input enable;
		input [1:0] note_address;
		output speaker;
		
		reg [15:0] frequency;
		reg [15:0] clkdivider;
 		
		always@(*)
			case (note_address)
				2'b01: begin frequency = 16'd523; 
								 clkdivider= 16'd23900;end
				2'b10: begin frequency = 16'd587; 
								 clkdivider= 16'd21295;end
				2'b11: begin frequency = 16'd659; 
								 clkdivider= 16'd18968;end
				default: begin frequency = 16'd0; clkdivider = 16'd0; end
			endcase
		
		
		reg [14:0] counter;
		
		always @(posedge clk) begin
			if (enable) begin
				if(counter==0) 
					counter <= clkdivider-1; 
				else counter <= counter-1;
			end
		end
		
		reg speaker;
		
		always @(posedge clk) 
			if(counter==0) 
				speaker <= ~speaker;				

endmodule 
//
//
//
//module play_do(clk, enable_do, speaker);
//		input clk;
//		input enable_do;
//		output speaker;
//		parameter clkdivider = 25000000/523/2;
//
//		reg [14:0] counter;
//		always @(posedge clk) begin
//			if (enable_do) begin
//				if(counter==0) 
//					counter <= clkdivider-1; 
//				else counter <= counter-1;
//			end
//		end
//		
//		reg speaker;
//		
//		always @(posedge clk) 
//			if(counter==0) 
//				speaker <= ~speaker;				
//
//endmodule 
//
//
//
//module play_re(clk, enable_re, speaker);
//		input clk;
//		input enable_re;
//		output speaker;
//		parameter clkdivider = 25000000/587/2;
//		
//		reg [14:0] counter;
//		always @(posedge clk) begin
//			if (enable_re) begin
//				if(counter==0) 
//					counter <= clkdivider-1; 
//				else counter <= counter-1;
//			end
//		end
//		
//		reg speaker;
//		
//		always @(posedge clk) 
//			if(counter==0) 
//				speaker <= ~speaker;
//endmodule 
//
//
//
//module play_mi(clk, enable_mi, speaker);
//		input clk;
//		input enable_mi;
//		output speaker;
//		parameter clkdivider = 25000000/659/2;
//
//		reg [14:0] counter;
//		always @(posedge clk) begin
//			if (enable_mi) begin
//				if(counter==0)
//					counter <= clkdivider-1; 
//				else counter <= counter-1;
//			end
//		end
//		
//		reg speaker;
//		
//		always @(posedge clk) 
//			if(counter==0) 
//				speaker <= ~speaker;
//				
//endmodule 


