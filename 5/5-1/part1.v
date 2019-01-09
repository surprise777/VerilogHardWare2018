module part1(SW, KEY, HEX0, HEX1);
    input [1:0] SW;
	 input [0:0] KEY;	 
	 output [6:0] HEX0;
	 output [6:0] HEX1;
	 wire enable;
	 wire clear_b;
	 wire clock;
	 wire [7:0] t_t;
	 wire [3:0] h1;
	 wire [3:0] h2;
	 assign clock = KEY[0];
	 assign enable = SW[1];
	 assign clear_b = SW[0];
	 
	 mytflipflop t0(
	       .t(enable),
			 .q(t_t[7]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
			 
	 mytflipflop t1(
	       .t(enable & t_t[7]),
			 .q(t_t[6]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
	 
	 mytflipflop t2(
	       .t(enable & t_t[7] & t_t[6]),
			 .q(t_t[5]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );

	 mytflipflop t3(
	       .t(enable & t_t[7] & t_t[6] & t_t[5]),
			 .q(t_t[4]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
		
	 mytflipflop t4(
	       .t(enable & t_t[7] & t_t[6] & t_t[5] & t_t[4]),
			 .q(t_t[3]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
		
	 mytflipflop t5(
	       .t(enable & t_t[7] & t_t[6] & t_t[5] & t_t[4]& t_t[3]),
			 .q(t_t[2]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
			 
	 mytflipflop t6(
	       .t(enable & t_t[7] & t_t[6] & t_t[5] & t_t[4]& t_t[3] & t_t[2]),
			 .q(t_t[1]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
			 
	 mytflipflop t7(
	       .t(enable & t_t[7] & t_t[6] & t_t[5] & t_t[4]& t_t[3] & t_t[2] & t_t[1]),
			 .q(t_t[0]),
			 .clock(clock),
			 .clear_b(clear_b)
			 );
			 
	 assign h1 = {t_t[4], t_t[5], t_t[6], t_t[7]};
	 assign h2 = {t_t[0], t_t[1], t_t[2], t_t[3]};
			 
	 HEXER H0(
        .SSW(h1),
        .HEX(HEX0[6:0])
        );
		  
    HEXER H1(
	     .SSW(h2),
        .HEX(HEX1[6:0])
        );
	 
endmodule


module HEXER(HEX, SSW);
    input [3:0] SSW;
    output [6:0] HEX;
	 
	 assign HEX[0] = (~SSW[3] & ~SSW[2] & ~SSW[1] & SSW[0]) | (~SSW[3] & SSW[2] & ~SSW[1] & ~SSW[0]) | (SSW[3] & ~SSW[2] & SSW[1] & SSW[0]) | (SSW[3] & SSW[2] & ~SSW[1] & SSW[0]);
	 assign HEX[1] = (SSW[3] & SSW[2] & ~SSW[0]) | (SSW[3] & SSW[1] & SSW[0]) | (SSW[2] & SSW[1] & ~SSW[0]) | (~SSW[3] & SSW[2] & ~SSW[1] & SSW[0]);
	 assign HEX[2] = (SSW[3] & SSW[2] & ~SSW[0]) | (SSW[3] & SSW[2] & SSW[1]) | (~SSW[3] & ~SSW[2] & SSW[1] & ~SSW[0]);
	 assign HEX[3] = (~SSW[3] & SSW[2] & ~SSW[1] & ~SSW[0]) | (~SSW[3] & ~SSW[2] & ~SSW[1] & SSW[0]) | (SSW[2] & SSW[1] & SSW[0]) | (SSW[3] & ~SSW[2] & SSW[1] & ~SSW[0]);
	 assign HEX[4] = (~SSW[3] & SSW[0]) | (~SSW[3] & SSW[2] & ~SSW[1]) | (~SSW[2] & ~SSW[1] & SSW[0]);
	 assign HEX[5] = (SSW[3] & SSW[2] & ~SSW[1] & SSW[0]) | (~SSW[3] & ~SSW[2] & SSW[0]) | (~SSW[3] & ~SSW[2] & SSW[1]) | (~SSW[3] & SSW[1] & SSW[0]);
	 assign HEX[6] = (~SSW[3] & ~SSW[2] & ~SSW[1]) | (~SSW[3] & SSW[2] & SSW[1] & SSW[0]) | (SSW[3] & SSW[2] & ~SSW[1] & ~SSW[0]);
	 
endmodule


module mytflipflop(t, q, clock, clear_b);
    input t;
	 input clock;
	 input clear_b;
	 output reg q;
	 wire d;
	 assign d = (~ t & q) | (~ q & t);
	 
	 always @(posedge clock, negedge clear_b)
	 begin
	     if (clear_b == 1'b0)
		  
		      q <= 1'b0;		
		  
		  else
		  
		      q <= d;
	 end
endmodule
