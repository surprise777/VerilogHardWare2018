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
		input do,
		input re,
		input mi,
		input [359:0] data,
		output [2:0] colour,
		output [7:0] x,
		output [6:0] y,
		output reg [23:0] score,
		output reg p
		);
		
		reg [1:0] area;
		
		reg [7:0] x_;
		reg [6:0] y_;
		reg [2:0] c_;
		
		reg [9:0] count_do;
		reg [9:0] count_re;
		reg [9:0] count_mi;
		
		reg [119:0] row_do;
		reg [119:0] row_re;
		reg [119:0] row_mi;
		
		reg match_perfect_do, match_perfect_re, match_perfect_mi;
		reg match_good_do, match_good_re, match_good_mi;
		reg ld_do;
	    reg ld_re;
	    reg ld_mi;
		
		
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
					if (row_do[count_do[9:3]] == 1)
					 begin
					   if(match_perfect_do ==1)
					      c_<= 3'b101;
					   else if (match_good_do == 1)
					      c <= 3'b101;
					   else
					      c_ <= 3'b100;
					  end
					else c_ <= 3'b000;
				end
				
				if (area == 2'b01) begin
					x_ <= 8'd76 + {5'b0, count_re[2:0]}; //COLUMN 76-83
					y_ <= count_re[9:3]; //ROW 0-119
					if (row_re[count_re[9:3]] == 1) begin
					   if(match_perfect_re==1)
					      c_<= 3'b101;
					   else if (match_good_re == 1)
					      c <= 3'b101;
					   else
					      c_ <= 3'b010;
					  end
					else c_ <= 3'b000;
				end
				
				if (area == 2'b10) begin
					x_ <= 8'd102 + {5'b0, count_mi[2:0]}; //COLUMN 102-109
					y_ <= count_mi[9:3]; //ROW 0-119
					if (row_mi[count_mi[9:3]] == 1)  begin
					   if(match_perfect_mi==1)
					      c_<= 3'b101;
					   else if (match_good_mi == 1)
					      c <= 3'b101;
					   else
					      c_ <= 3'b001;
					  end
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
	
	always @ (posedge clock) begin
        if (wren) begin
            	match_perfect_do <= 0;
            	match_perfect_re <= 0;
            	match_perfect_mi <= 0;
		        match_good_do <= 0;
		        match_good_re <= 0;
		        match_good_mi <= 0;
		        ld_do <= 0;
				ld_re <= 0;
				ld_mi <= 0;
				score <= 23'b0;
		
        end
        else begin
            if (do == 0 && ld_do == 0)
					begin
					    if (row_do[90:89] == 2'b01 | row_do[89:88] == 2'b01 |row_do[88:87] == 2'b01|row_do[87:86] == 2'b01|row_do[86:85] == 2'b01)
					      begin
					      match_perfect_do <=1;
					      score[23:0] <= score[23:0] + 8'b0010;
					      end
					    else if (row_do[85:84] == 2'b01 | row_do[84:83] == 2'b01 |row_do[83:82] == 2'b01|row_do[82:81] == 2'b01|row_do[81:80] == 2'b01)
					      begin
					      match_good_do <= 1;
					      score[23:0] <= score[23:0] + 8'b0001;
					      end
					    else
					      begin
					       match_perfect_do <=0;
					       match_good_do <= 0;
					       score[23:0] <= score[23:0];
					      end     
					    ld_do<=1;
					end
			if (re == 0 && ld_re == 0)
					begin
						 if (row_re[90:89] == 2'b01 | row_re[89:88] == 2'b01 |row_re[88:87] == 2'b01|row_re[87:86] == 2'b01|row_re[86:85] == 2'b01)
					      begin
					      match_perfect_re <=1;
					      score[23:0] <= score[23:0] + 8'b0010;
					      end
					    else if (row_re[85:84] == 2'b01 | row_re[84:83] == 2'b01 |row_re[83:82] == 2'b01|row_re[82:81] == 2'b01|row_re[81:80] == 2'b01)
					      begin
					      match_good_re <= 1;
					      score[23:8] <= score[23:0] + 8'b0001;
					      end
					    else
					      begin
					       match_perfect_re <=0;
					       match_good_re <= 0;
					       score[23:0] <= score[23:0];
					      end     
						ld_re <= 1;
					end
				if (mi == 0 && ld_mi == 0)
					begin
						 if (row_mi[90:89] == 2'b01 | row_mi[89:88] == 2'b01 |row_mi[88:87] == 2'b01|row_mi[87:86] == 2'b01|row_mi[86:85] == 2'b01)
					      begin
					      match_perfect_mi <=1;
					      score[23:0] <= score[23:0] + 8'b0010;
					      end
					    else if (row_mi[85:84] == 2'b01 | row_mi[84:83] == 2'b01 |row_mi[83:82] == 2'b01|row_mi[82:81] == 2'b01|row_do[81:80] == 2'b01)
					      begin
					      match_good_mi <=1;
					      score[23:0] <= score[23:0] + 8'b0001;
					      end
					    else
					      begin
					       match_perfect_mi <=0;
					       match_good_mi <= 0;
					       score[23:0] <= score[23:0];
					      end     
						ld_mi <= 1;
					end
				if (do == 1 && ld_do == 1)
					begin
						 match_perfect_do <=0;
					       match_good_do <= 0;
					       score[23:0] <= score[23:0];
						ld_do <=0;
					end
			   if (re == 1 && ld_re == 1)
				   begin
					   match_perfect_re <=0;
					       match_good_re <= 0;
					       score[23:0] <= score[23:0];
						ld_mi <= 0;
				   end
			   if (mi == 1 && ld_mi == 1)
				   begin
					  match_perfect_mi <=0;
					       match_good_mi <= 0;
					       score[23:0] <= score[23:0];
						ld_mi<=0;
				   end
    
        end
    end


endmodule











