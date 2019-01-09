module display_calculator(
		input wren,
		input clock,
		input clock002,
		input [1:0] key_address,
		output reg [359:0] data
		);
		
		reg top_do;
		reg top_re;
		reg top_mi;
		reg down;
		
		always @(posedge clock) begin
			if (wren)
				down <= 1'b0;
			if (!wren) begin
			   down <= 1'b1;
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
				data <= {data[358:240],1'b0,data[238:120],1'b0,data[118:0],1'b1};
			else if (top_re && down)
				data <= {data[358:240],1'b0,data[238:120],1'b1,data[118:0],1'b0};
			else if 	(top_mi && down)
				data <= {data[358:240],1'b1,data[238:120],1'b0,data[118:0],1'b0};
			else if (down)
			   data <= {data[358:240],1'b0,data[238:120],1'b0,data[118:0],1'b0};
			else
				data <= 360'b0;
		end

endmodule

				
module displayer(
		input wren,
		input clock,
		input clock002,
		input key_address,
		input [359:0] data,
		output [2:0] colour,
		output [7:0] x,
		output [6:0] y,
		output reg p
		);
		
		reg [1:0] area;
		
		reg [7:0] x_;
		reg [6:0] y_;
		reg [2:0] c_;
		
		reg [9:0] count_do;
		reg [9:0] count_re;
		reg [9:0] count_mi;
		
		reg [6:0] row_do;
		reg [6:0] row_re;
		reg [6:0] row_mi;
		
		
		// Renew values every 0.02s
		always @(posedge clock002) begin
				row_do <= data[119:0];
				row_re <= data[239:120];
				row_mi <= data[359:240];
		end
		
		
		always @(posedge clock) begin
		
			if (!wren) begin
				p <= 1;
		      if (area == 2'b00) begin
					x_ <= 8'd50 + {5'b0, count_do[2:0]}; //COLUMN 50-57
					y_ <= count_do[9:3]; //ROW 0-119
					if (row_do[count_do] == 1) c_ <= 3'b100;
					else c_ <= 3'b000;
				end
				
				if (area == 2'b01) begin
					x_ <= 8'd76 + {5'b0, count_re[2:0]}; //COLUMN 76-83
					y_ <= count_re[9:3]; //ROW 0-119
					if (row_re[count_re] == 1) c_ <= 3'b100;
					else c_ <= 3'b000;
				end
				
				if (area == 2'b10) begin
					x_ <= 8'd102 + {5'b0, count_mi[2:0]}; //COLUMN 102-109
					y_ <= count_mi[9:3]; //ROW 0-119
					if (row_mi[count_mi] == 1) c_ <= 3'b100;
					else c_ <= 3'b000;
				end
				
			end	
			else p <= 0;
		end
				
				
		always @(posedge clock) begin
			if (wren) begin
				count_do <= 10'd0;
				count_re <= 10'd0;
				count_mi <= 10'd0;
				area <= 2'b00;	end
			else begin
				if (area == 2'b00) begin
					if (count_do == 10'd959) begin
						count_do <= 10'd0;
						area <= 2'b01; end
				   else count_do <= count_do + 10'd1;
				end
				else if (area == 2'b01) begin
					if (count_re == 10'd959) begin
						count_re <= 10'd0;
						area <= 2'b01; end
				   else count_re <= count_re + 10'd1;
				end
				else if (area == 2'b10) begin
					if (count_mi == 10'd959) begin
						count_mi <= 10'd0;
						area <= 2'b00; end
				   else count_mi <= count_mi + 10'd1;
				end
				else begin //DEFAULT
					count_do <= 10'd0;
					count_re <= 10'd0;
					count_mi <= 10'd0;
					area <= 2'b00;	end
			end
		end


	assign x = x_;
	assign y = y_;
	assign colour = c_;


endmodule











