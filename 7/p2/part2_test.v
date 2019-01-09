// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY[3:0],
        SW[9:0],
		
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	
	wire ld_y, ld_x, ld_c;
	// Do not change the following outputs
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);
	
	datapath d0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .data_in(SW[6:0]),
        .colour(SW[9:7]),

        .ld_x(ld_x),
        .ld_y(ld_y),
        .ld_c(ld_c),
        .plot(writeEn),

        
        .data_x(x),
        .data_y(y),
        .data_c(colour)
        
    );

    // Instansiate FSM control
    // control c0(...);
    control c0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .write(~KEY[1]),
        
        .go(~KEY[3]),
        
        .ld_x(ld_x),
        .ld_y(ld_y),
        .ld_c(ld_c),
        .plot(writeEn)      
    );

    
endmodule


module control(
    input clk,
    input resetn,
    input go,
    input write,

    output reg ld_x, ld_y, ld_c, plot
    );

    reg [2:0] current_state, next_state; 
    
    localparam  S_LOAD_X        = 3'd0,
                S_LOAD_X_WAIT   = 3'd1,
                S_LOAD_Y        = 3'd2,
                S_LOAD_Y_WAIT   = 3'd3,
                S_CYCLE_0       = 3'd4;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X; // Loop in current state until value is input
                S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_Y; // Loop in current state until go signal goes low
                S_LOAD_Y: next_state = write ? S_LOAD_Y_WAIT : S_LOAD_Y; // Loop in current state until value is input
                S_LOAD_Y_WAIT: next_state = write ? S_LOAD_Y_WAIT : S_CYCLE_0; // Loop in current state until value is input
                S_CYCLE_0: next_state = go? S_LOAD_X: S_CYCLE_0;// we will be done our operations, start over after
            default:     next_state = S_LOAD_X;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin
        ld_x = 1'b0;
        ld_y = 1'b0;
        ld_c = 1'b0;
        plot = 1'b0;

        case (current_state)
            S_LOAD_X: begin
                ld_x = 1'b1;
                end
            S_LOAD_Y: begin
                ld_y = 1'b1;
                ld_c = 1'b1;
                end
          
            S_CYCLE_0: begin 
                plot = 1'b1;
            	end
           
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [6:0] data_in,
    input [2:0] colour,
    input ld_x, ld_y, ld_c, plot,
  
    output [7:0] data_x,
    output [6:0] data_y,
    output [2:0] data_c
    );
    
    reg [7:0] x;
    reg [6:0] y;
    reg [2:0] c;

    
    always @ (posedge clk) begin
        if (!resetn) begin
            	x <= 8'd0; 
           		y <= 7'd0;
           		c <= 3'd0;
        end
        else begin
            if (ld_x)
                x <= {1'b0, data_in}; 
            if (ld_y)
                y <= data_in; 
            if (ld_c)
                c <= colour;
            
    
        end
    end
    
    
    
    reg [3:0] count;
    	
	always @(posedge clk) begin
		if (resetn==0 | plot == 0)
			count <= 4'b0000;
		else 
			if (count == 4'b1111)
					count <= 4'b0000;
			else
					count <= count + 1'b1;
	end


	assign data_x = x + count[1:0];
	assign data_y = y + count[3:2];
	assign data_c = c;

 
    
endmodule


