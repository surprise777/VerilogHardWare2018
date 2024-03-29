module music(clock, KEY, speaker);
		input clock;
		input [3:0] KEY;
		output reg speaker;
		
		//reg enable;
				
		reg [15:0] frequency;
		reg [15:0] clkdivider;
 		reg [15:0] counter;
		
		reg ld_do, ld_re, ld_mi;
		
		always@(posedge clock) begin
		
			if (~KEY[2]) begin
			   if (!ld_do) begin //the moment when player begin to press do
					frequency <= 16'd523; 
					clkdivider <= 16'd23900;
					counter <= clkdivider;
					speaker <= 0;
					ld_do <= 1; end
				else begin //when player is pressing do
					if(counter==16'b0) begin
						counter <= clkdivider-1;
						speaker <= ~speaker; end
					else counter <= counter-1;
				end
			end
			
			else if(~KEY[1]) begin
				if (!ld_re) begin
					frequency = 16'd587; 
					clkdivider= 16'd21295;
					counter <= clkdivider;
					speaker <= 0;
					ld_re <= 1; end
				else begin
					if(counter==16'b0) begin
						counter <= clkdivider-1;
						speaker <= ~speaker; end
					else counter <= counter-1;
				end
			end
				
			else if(~KEY[0]) begin
				if (!ld_mi) begin
					frequency = 16'd659; 
					clkdivider= 16'd18968;
					counter <= clkdivider;
					speaker <= 0;
				   ld_mi <= 1; end
				else begin
					if(counter==16'b0) begin
						counter <= clkdivider-1;
						speaker <= ~speaker; end
					else counter <= counter-1;
				end
			end
			
			else begin
				frequency = 16'd0; 
				clkdivider = 16'd0;
				counter <= clkdivider;
				speaker <= 0;
				ld_do <= 0;
				ld_re <= 0;
				ld_mi <= 0;
				end
		end
		
		
//		always@(posedge clock)
//			case (note_address)
//				2'b01: begin frequency = 16'd523; 
//								 clkdivider= 16'd23900;end
//				2'b10: begin frequency = 16'd587; 
//								 clkdivider= 16'd21295;end
//				2'b11: begin frequency = 16'd659; 
//								 clkdivider= 16'd18968;end
//				default: begin frequency = 16'd0; clkdivider = 16'd0; end
//			endcase
//			
			

endmodule
		

