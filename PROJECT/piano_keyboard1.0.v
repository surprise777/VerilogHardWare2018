

module piano_keyboard
	(
		clock,						//	On Board 50 MHz
		resetn,
		writeEn,
        do,
        re,
        mi,
        ld_do,
        ld_re,
        ld_mi,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input clock, do, re, mi, ld_do, ld_re, ld_mi, resetn, writeEn;

	
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	
	// Create the colour, x, y wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire en;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(clock),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(en),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	
    
    // Instansiate datapath
	// datapath d0(...);
	
	datapath d0(
        .clk(CLOCK_50),
        .resetn(resetn),

        .ld_do(ld_do),
        .ld_re(ld_re),
        .ld_mi(ld_mi),
        .do(do),
        .re(re),
        .mi(mi),
        .plot(writeEn),

        
        .data_x(x),
        .data_y(y),
        .data_c(colour),
		  .p(en)
        
    );

    
endmodule



module datapath(
    input clk,
    input resetn,
    
    input ld_do, ld_re, ld_mi, do, re, mi, plot,
  
    output [7:0] data_x,
    output [6:0] data_y,
    output [2:0] data_c,
	 output reg p
    );
    
    reg [7:0] x;
    reg [6:0] y;
    reg [2:0] c;
    

    
    always @ (posedge clk) begin
        if (!resetn) begin
            	x <= 8'd0; 
           		y <= 7'd87;
           		c <= 3'd0;
           	    p <= 1'd0;
        end
        else if (plot == 1)begin
            if (do == 0 && ld_do == 0)
					begin
					    x <= 8'd0;
						y <= 7'd87;
						c <= 3'b100;
						p <= 1'd1;
					end
				if (re == 0 && ld_re == 0)
					begin
						x <= 8'd64;
						y <= 7'd87;
						c <= 3'b010;
						p <= 1'd1;
					end
				if (mi == 0 && ld_mi == 0)
					begin
						x <= 8'd128;
						y <= 7'd87;
						c <= 3'b001;
						p <= 1'd1;
					end
				if (do == 1 && ld_do == 1)
					begin
						 x <= 8'd0;
						y <= 7'd87;
						c <= 3'd0;
						p <= 1'd1;
					end
			   if (re == 1 && ld_re == 1)
				   begin
					   x <= 8'd64;
						y <= 7'd87;
						c <= 3'd0;
						p <= 1'd1;
				   end
			   if (mi == 1 && ld_mi == 1)
				   begin
					  x <= 8'd128;
						y <= 7'd87;
						p <= 1'd1;
						c <= 3'd0;
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
					p <= 0;
					end
			else
					count <= count + 1'b1;
					p <=p;
	end


	assign data_x = x + count[2:0];
	assign data_y = y + count[5:3];
	assign data_c = c;

 
    
endmodule


