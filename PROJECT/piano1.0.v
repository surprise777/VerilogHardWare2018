module piano(CLOCK_50, SW, KEY, key_address, start_time, duration, HEX0, HEX1, HEX5, HEX3, LEDR, HEX4, HEX2);
	
	input CLOCK_50;
	input [3:0] KEY;
	input [0:0] SW;
	
	output reg [1:0] key_address;
	output reg [12:0] start_time; //unit: 0.01s, max:163.84s
	output reg [12:0] duration; // unit:0.01s, max: 2.56s
	wire [27:0] song; // song[27:26] show key_address, song[25:13] show start_time, song[12:0] show duration
	reg [6:0] counter;
	//================test test===============
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX5;
	output [6:0] HEX3;
	
	output [9:0] LEDR;
	output [6:0] HEX4;
	output [6:0] HEX2;
	//========================================
	
	reg [12:0] system_time;
	reg [18:0] count001;
	
	reg ld_do;
	reg ld_re;
	reg ld_mi;
	
	assign do = KEY[2];
	assign re = KEY[1];
	assign mi = KEY[0];
	assign reset_n = KEY[3];
	assign clock = CLOCK_50;
	
	ram128x28 r0(
				.address(counter[6:0]),
				.clock(clock),
				.wren(~SW[0]),
				.data({key_address[1:0], start_time[12:0], duration[12:0]}),
				.q(song[27:0])
	);
	
	//Change of system_time
	always @(posedge clock, negedge reset_n)
	begin
		if (reset_n == 0)
			begin
				//Set system_time to zero. system_time has max 2^14-1=16383*0.01s=163.84s~3min
				system_time <= 13'd0; 
				//Set countdown to 499999. If it decrease by 1 at every positive edge, 
				//after 500,000/50,000,000 = 0.01s, it becomes 0.
				count001 <= 19'd499999;
				counter <= 7'd0;
			end
		else
			begin
				if (count001 == 19'd0) //0.01s passed
					begin
						count001 <= 19'd499999;
						system_time <= system_time + 13'd1;
						counter <= counter + 7'd1;
					end
				else
					count001 <= count001 - 19'd1;
			end
	end
	
	//Set key_address, start_time
	always @(posedge clock)
	begin
		if (reset_n == 0)
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
				if (do == 1 && ld_do == 1)
					begin
						duration <= system_time - start_time;
						ld_do <= 0;
					end
			   if (re == 1 && ld_re == 1)
				   begin
					   duration <= system_time - start_time;
					   ld_re <= 0;
				   end
			   if (mi == 1 && ld_mi == 1)
				   begin
					   duration <= system_time - start_time;
					   ld_mi <= 0;
				   end
			end
	end
	
	//==================This part is a test===================
	
	hex_display h0(song[3:0], HEX0);
	hex_display h1(song[7:4], HEX1);
	hex_display h2(song[16:13], HEX2);
	hex_display h3(song[20:17], HEX3);
	hex_display h4(system_time[7:4], HEX4); //MAKE IT CHANGE SLOWER
	hex_display h5({2'd0, song[27:26]}, HEX5);
	
	//assign LEDR = 10'd0;
	//assign HEX4 = 7'b1111111;
	//assign HEX2 = 7'b1111111;
   //========================================================

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
