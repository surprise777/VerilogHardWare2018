module hexDisplay(SW, HEX0);
	input [3:0] SW;
	output [6:0] HEX0;
	   
	hex0 h0(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[0])
		);
		
	hex1 h1(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[1])
		);

	hex2 h2(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[2])
		);

	hex3 h3(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[3])
		);

	hex4 h4(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[4])
		);

	hex5 h5(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[5])
		);

	hex6 h6(
		.d(SW[0]),
		.c(SW[1]),
		.b(SW[2]),
		.a(SW[3]),
		.m(HEX0[6])
		);
						  			 
	   
endmodule




module hex0(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~a & ~b & ~c & d | ~a & b & ~c & ~d | a & b & ~c & d | a & ~b & c & d;
endmodule



module hex1(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~a & b & ~c & d | b & c & ~d | a & c & d | a & b & ~d;
endmodule
		 
		 
module hex2(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~a & ~b & c & ~d | a & b & ~d | a & b & c;
endmodule 



module hex3(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~b & ~c & d | ~a & b & ~c & ~d | b & c & d | a & ~b & c & ~d;
endmodule


module hex4(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~a & d | ~a & b & ~c | ~b & ~c & d ;
endmodule 




module hex5(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~a & ~b & d | ~a & ~b & c | ~a & c & d | a & b & ~c & d;
endmodule 




module hex6(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	assign m = ~a & ~b & ~c | ~a & b & c & d | a & b & ~c & ~d;
endmodule 
