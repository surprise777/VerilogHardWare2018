module piano(CLOCK_50, KEY, key_address, start_time, duration, HEX0, HEX1, HEX5, HEX3, LEDR, HEX4, HEX2);
	
	input CLOCK_50;
	input [3:0] KEY;
	
	output reg [1:0] key_address;
	output reg [12:0] start_time; //unit: 0.01s, max:163.84s
	output reg [12:0] duration; // unit:0.01s, max: 2.56s
	
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
			end
		else
			begin
				if (count001 == 19'd0) //0.01s passed
					begin
						count001 <= 19'd499999;
						system_time <= system_time + 13'd1;
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
	
	hex_display(duration[3:0], HEX0);
	hex_display(duration[7:4], HEX1);
	hex_display(system_time[7:4], HEX5); //MAKE IT CHANGE SLOWER
	hex_display({2'd0, key_address}, HEX3);
	
	assign LEDR = 10'd0;
	assign HEX4 = 7'b1111111;
	assign HEX2 = 7'b1111111;
   //========================================================

endmodule



module hex_display(SW, HEX);
         input [3:0] SW;
		   output [6:0] HEX;
	   
	      hex_0 m1(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[0])
						 );
		
						  			 
	   	hex_1 m2(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[1])
						 );
			
			
			hex_2 m3(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[2])
						 );
			
			
			hex_3 m4(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[3])
						 );
			
			
			hex_4 m5(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[4])
						 );
						 
						 
			hex_5 m6(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[5])
						 );
						 
						 
			hex_6 m7(
		             .d(SW[0]),
						 .c(SW[1]),
						 .b(SW[2]),
						 .a(SW[3]),
						 .m(HEX[6])
						 );
						 

endmodule




module hex_0(a,b,c,d,m);
       input a;
		 input b;
		 input c;
		 input d;
		 output m;
		 assign m = ~((b & c) | (~b & ~d) | (~a & c & d) | (~a & b & d) | (a & ~c & ~d) | (a & ~b & ~c));
endmodule



module hex_1(a,b,c,d,m);
       input a;
       input b;
       input c;
       input d;
       output m; 
       assign m = ~((~a & ~b) | (~b & ~d) | (a & ~c & d) | (~a & ~c & ~d) | (~a & c & d));
endmodule
		 
		 
module hex_2(a,b,c,d,m);
       input a;
		 input b;
		 input c;
		 input d;
		 output m;
		 assign m = ~((~a & ~c) | (a & ~b) | (~a & b) | (~c & d) | (~a & c & d));
endmodule 



module hex_3(a,b,c,d,m);
       input a;
		 input b;
		 input c;
		 input d;
		 output m;
		 assign m = ~((a & ~c) | (b & ~c & d) | (~a & c & ~d) | (a & ~b & d) | (~a & ~b & ~d) | (b & c & ~d) | (~b & c & d));
endmodule 



module hex_4(a,b,c,d,m);
       input a;
		 input b;
		 input c;
		 input d;
		 output m;
		 assign m = ~((~b & ~d) | (a & b) | (c & ~d) | (a & c & d));
endmodule 




module hex_5(a,b,c,d,m);
       input a;
		 input b;
		 input c;
		 input d;
		 output m;
		 assign m = ~((~c & ~d) | (a & c) | (a & ~b) | (~a & b & ~c) | (b & c & ~d));
endmodule 




module hex_6(a,b,c,d,m);
       input a;
		 input b;
		 input c;
		 input d;
		 output m;
		 assign m = ~((a & d) | (c & ~d) | (a & ~b) | (~a & b & ~c) | (~a & ~b & c));
endmodule 



