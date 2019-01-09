module piano(

      //INPUT
		CLOCK_50,
		CLOCK_25,
		SW, 
		KEY, 
		//OUTPUT @ Board
		HEX0, 
		HEX1, 
		HEX2, 
		HEX3, 
		HEX4, 
		HEX5,
		//Make sound
		speaker,
      // The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						   //	VGA Blue[9:0]
		);

		input CLOCK_50, CLOCK_25;
		input [0:0] SW;
		input [3:0] KEY;
		assign clock = CLOCK_50;
		assign resetn = KEY[3];
		assign do = KEY[2];
		assign re = KEY[1];
		assign mi = KEY[0];
		
		//==============Used to Play and Replay=============
		
		output [6:0] HEX0;
		output [6:0] HEX1;
		output [6:0] HEX2;
		output [6:0] HEX3;
		output [6:0] HEX4;
		output [6:0] HEX5;
		output speaker;
	
	
	
	   //=======Do not change the following outputs=======
		
		output			VGA_CLK;   				//	VGA Clock
		output			VGA_HS;					//	VGA H_SYNC
		output			VGA_VS;					//	VGA V_SYNC
		output			VGA_BLANK_N;			//	VGA BLANK
		output			VGA_SYNC_N;				//	VGA SYNC
		output	[9:0]	VGA_R;   				//	VGA Red[9:0]
		output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
		output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
		
		
		//====================WIRES========================
		wire [12:0] counter;
		wire [12:0] system_time;
		wire [12:0] duration;
		wire [12:0] start_time;
		wire [1:0] key_address;
		wire [27:0] song;
		wire ld_do;
		wire ld_re;
		wire ld_mi;
		wire writeEn;
		wire x;
		wire y;
		wire [2:0] colour;
		wire [359:0] data;
		wire clock002;
		
		// Create an Instance of a VGA controller - there can be only one!
		// Define the number of colours as well as the initial background
		// image file (.MIF) for the controller.
//		vga_adapter VGA(
//				.resetn(resetn),
//				.clock(CLOCK_50),
//				.colour(colour),
//				.x(x),
//				.y(y),
//				.plot(writeEn),
//				/* Signals for the DAC to drive the monitor. */
//				.VGA_R(VGA_R),
//				.VGA_G(VGA_G),
//				.VGA_B(VGA_B),
//				.VGA_HS(VGA_HS),
//				.VGA_VS(VGA_VS),
//				.VGA_BLANK(VGA_BLANK_N),
//				.VGA_SYNC(VGA_SYNC_N),
//				.VGA_CLK(VGA_CLK)
//				);
//		defparam VGA.RESOLUTION = "160x120";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
//		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
		
		//Behaviour Register
		ram8192x28 r0(
				.address(counter[12:0]),  //address is system_time
				.clock(clock),
				.wren(~SW[0]), // SW[0]=0: WRITE;   SW[0]=1: READ
				.data({key_address[1:0], start_time[12:0], duration[12:0]}),
				.q(song[27:0])
				);
		
		
//		ram8192x360 r1(
//				.address(counter[12:0]),
//				.clock(clock),
//				.data(data[359:0]),
//				.wren(~SW[0]),
//				.q(screen[359:0]) //[359:240]-MI [239:120]-RE [119:0]-DO
//				);
//				
		display_calculator d1(
				.wren(~SW[0]),
				.clock(clock),
				.clock002(clock002),
				.key_address(song[27:26]),
				.data(data[359:0])
		      );
				
		displayer(
				.wren(~SW[0]),
				.clock(clock),
				.clock002(clock002),
				.key_address(song[27:26]),
				.data(data[359:0]),
				.colour(colour),
				.x(x),
				.y(y),
				.p(p)
				);
		
		time_counter c0(
				.clock(clock),
				.resetn(resetn),
				//output
				.system_time(system_time),
				.counter(counter),
				.clock002(clock002)
				);
				
		recorder rec0(
				.clock(clock),
				.resetn(resetn),
				.KEY(KEY[2:0]),
				.system_time(system_time),
				//output
				.key_address(key_address),
				.ld_do(ld_do),
				.ld_re(ld_re),
				.ld_mi(ld_mi),
				.start_time(start_time),
				.duration(duration)
				);
				
				
		music m0(
				.clock(CLOCK_25), 
				.KEY(KEY[3:0]), 
				.speaker(speaker)
				);
				
		
		piano_keyboard p0(
				.clock(clock),						//	On Board 50 MHz
				.resetn(resetn),
				.writeEn(~SW[0]),
				.do(do),
				.re(re),
				.mi(mi),
				.ld_do(ld_do),
				.ld_re(ld_re),
				.ld_mi(ld_mi),
				// The ports below are for the VGA output.  Do not change.
				.VGA_CLK(VGA_CLK),   						//	VGA Clock
				.VGA_HS(VGA_HS),							//	VGA H_SYNC
				.VGA_VS(VGA_VS),							//	VGA V_SYNC
				.VGA_BLANK_N(VGA_BLANK_N),						//	VGA BLANK
				.VGA_SYNC_N(VGA_SYNC_N),						//	VGA SYNC
				.VGA_R(VGA_R),   						//	VGA Red[9:0]
				.VGA_G(VGA_G),	 						//	VGA Green[9:0]
				.VGA_B(VGA_B)   						//	VGA Blue[9:0]
				);
				
	   //==================This part is a play and replay===================				
		hex_display h0(song[3:0], HEX0);
		hex_display h1(song[7:4], HEX1);
		hex_display h2(song[16:13], HEX2);
		hex_display h3(song[20:17], HEX3);
		hex_display h4(system_time[7:4], HEX4); //MAKE IT CHANGE SLOWER
		hex_display h5({2'd0, song[27:26]}, HEX5);
					
endmodule


module time_counter(
		clock,
		resetn,
		system_time,
		counter,
		clock002
		);
		
		input clock;
		input resetn;
		
		output reg [12:0] system_time;
		output reg [12:0] counter;
		output reg clock002;
		reg [18:0] count001;
		
		//Change of system_time
		always @(posedge clock, negedge resetn)
		begin
			if (resetn == 0)
				begin
					//Set system_time to zero. system_time has max 2^14-1=16383*0.01s=163.84s~3min
					system_time <= 13'd0; 
					//Set countdown to 499999. If it decrease by 1 at every positive edge, 
					//after 500,000/50,000,000 = 0.01s, it becomes 0.
					count001 <= 19'd499999;
					counter <= 13'd0;
					clock002 <= 0;
				end
			else
				begin
					if (count001 == 19'd0) //0.01s passed
						begin
							count001 <= 19'd499999;
							system_time <= system_time + 13'd1;
							counter <= counter + 13'd1;
							clock002 <= ~clock002;
						end
					else
						count001 <= count001 - 19'd1;
				end
		end

endmodule




module recorder(
	  	clock,
		resetn,
		KEY,
		system_time,
		key_address,
		ld_do,
		ld_re,
		ld_mi,
		start_time,
		duration,
		);
		
		input clock;
		input resetn;
		input [2:0] KEY;
		input [12:0]system_time;
		
		output reg [1:0] key_address;
		output reg ld_do;
		output reg ld_re;
		output reg ld_mi;
		output reg [12:0] start_time;
		output reg [12:0] duration;
		
		assign do = KEY[2];
		assign re = KEY[1];
		assign mi = KEY[0];
	
		//Set key_address, start_time
		always @(posedge clock)
		begin
			if (resetn == 0)
				begin
					start_time <= 13'd0;
					duration <= 13'd0;
					key_address <= 2'b00; //Set key address 2'b00 to be NO KEY
					ld_do <= 0;
					ld_re <= 0;
					ld_mi <= 0;
				end
			else
				begin
				   //Press key
					if (do == 0 && ld_do == 0)
						begin
							key_address <= 2'b01;
							start_time <= system_time;
							ld_do <= 1;
						end
					if (re == 0 && ld_re == 0)
						begin
							key_address <= 2'b10;
							start_time <= system_time;
							ld_re <= 1;
						end
					if (mi == 0 && ld_mi == 0)
						begin
							key_address <= 2'b11;
							start_time <= system_time;
							ld_mi <= 1;
						end
					//Release Key	
					if (do == 1 && ld_do == 1)
						begin
							key_address <= 2'b00;
							duration <= system_time - start_time;
							ld_do <= 0;
						end
					if (re == 1 && ld_re == 1)
						begin
							key_address <= 2'b00;
							duration <= system_time - start_time;
							ld_re <= 0;
						end
					if (mi == 1 && ld_mi == 1)
						begin
							key_address <= 2'b00;
							duration <= system_time - start_time;
							ld_mi <= 0;
						end
				end
		end
		
endmodule

				

module hex_display(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
