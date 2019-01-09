
module datapath_write(
    input clk,
    input resetn,
    
    input do, re, mi, plot,
  
    output [7:0] data_x,
    output [6:0] data_y,
    output [2:0] data_c,
    );
    
    reg [7:0] x;
    reg [6:0] y;
    reg [2:0] c;
    reg ld_do;
	reg ld_re;
	reg ld_mi;
	reg p;
    

    
    always @ (posedge clk) begin
        if (!resetn) begin
            	x <= 8'd52; 
           		y <= 7'd90;
           		c <= 3'd0;
           	    ld_do <= 0;
				ld_re <= 0;
				ld_mi <= 0;
				p<=0;
        end
        else if (plot == 1)begin
            if (do == 0 && ld_do == 0)
					begin
					    x <= 8'd52;
						y <= 7'd90;
						c <= 3'b100;
                        ld_do <= 1;
                        p<=1;
					end
			if (re == 0 && ld_re == 0)
					begin
						x <= 8'd76;
						y <= 7'd90;
						c <= 3'b100;
						ld_re <= 1;
						p<=1;
					end
				if (mi == 0 && ld_mi == 0)
					begin
						x <= 8'd100;
						y <= 7'd90;
						c <= 3'b100;
						ld_mi <= 1;
						p<=1;
					end
				if (do == 1 && ld_do == 1)
					begin
						 x <= 8'd52;
						y <= 7'd90;
						c <= 3'd0;
						ld_do <=0;
					end
			   if (re == 1 && ld_re == 1)
				   begin
					   x <= 8'd76;
						y <= 7'd90;
						c <= 3'd0;
						ld_mi <= 0;
				   end
			   if (mi == 1 && ld_mi == 1)
				   begin
					  x <= 8'd100;
						y <= 7'd90;
						ld_mi<=0;
				   end
    
        end
    end
    
    
    
    reg [5:0] count;
    	
	always @(posedge clk) begin
		if (resetn==0 | p == 0)
			count <= 6'b000000;
		else 
			if (count == 6'b111111) begin
					count <= 6'b000000;
					//p <= 0;
					end
			else
					count <= count + 1'b1;
					//p <=p;
	end


	assign data_x = x + count[2:0];
	assign data_y = y + count[5:3];
	assign data_c = c;

 
    
endmodule


