module display_calculator(
		input wren,
		input clock,
		input clock002,
		input [1:0] key_address,
		output [359:0] data
		);
		
		reg top_do;
		reg top_re;
		reg top_mi;
		reg down;
		
		always @(posedge clock) begin
			if (wren)
				data <= 360'b0;
			if (!wren) begin
			   down <= 1;
				if (key_address == 2'b00) begin
					top_do <= 0;
					top_re <= 0;
					top_mi <= 0;
				end
				else if (key_address == 2'b01)
					top_do <= 1;
				else if (key_address == 2'b10)
					top_re <= 1;
				else if (key_address == 2'b11)
					top_mi <= 1;
			end
		end
	
	   //Display changes every .02 s; 
		//It takes 120 * 0.02 = 2.4 S for a strip to be dropped down
	   always @(posedge clock002) begin
		   if (top_do && down)
				data <= {data[358:240],1'b0,data[238:120],1'b0,data[118:1],1'b1};
			else if (top_re && down)
				data <= {data[358:240],1'b0,data[238:120],1'b1,data[118:1],1'b0};
			else if 	(top_mi && down)
				data <= {data[358:240],1'b1,data[238:120],1'b0,data[118:1],1'b0};
			else if (down)
			   data <= {data[358:240],1'b0,data[238:120],1'b0,data[118:1],1'b0};
		end

endmodule

				
module displayer(
		input wren,
		input clock,
		input key_address,
		input [359:0] data,
		output reg [2:0] colour,
		output reg [7:0] x,
		output reg [6:0] y
		);
		
		reg [10:0] count_do;
		reg [10:0] count_re;
		reg [10:0] count_mi;
		
		always @(posedge clock) begin
			if (wren) begin
				count_do <= 11'd0;
				count_re <= 11'd0;
				count_mi <= 11'd0;
				end
			else if (!wren) begin
			   if (count_do != 11'd1199)
					x <= 8'd50
					
					
			
			
			end
				
				
				
				
				
				
endmodule 
