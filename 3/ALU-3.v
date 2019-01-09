//SW[7:0] data inputs
//KEY[2:0] function inputs
//HEX0[6:0] output hexer decoder display
//HEX1[6:0] output hexer decoder display
//HEX2[6:0] output hexer decoder display
//HEX3[6:0] output hexer decoder display
//HEX4[6:0] output hexer decoder display
//HEX5[6:0] output hexer decoder display
//LEDR[7:0] output display

module part3(LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 , KEY);
    input [7:0] SW;
    output [7:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    input [2:0] KEY;
    wire [3:0] cin1;
    wire [3:0] cin0;
    wire [7:0] cout;
    wire [2:0] fin;
    
   multin i1(
        .a(SW[3]),
        .b(SW[2]),
        .c(SW[1]),
        .d(SW[0]),
        .A(cin1)
   );
   
   multin i0(
        .a(SW[7]),
        .b(SW[6]),
        .c(SW[5]),
        .d(SW[4]),
        .A(cin0)
   );
   
   funcIn f0(
        .a(KEY[2]),
        .b(KEY[1]),
        .c(KEY[0]),
        .d(fin)

   );
   
   
   multiOut o0(
        .o(cout),
        .a(LEDR[7]),
        .b(LEDR[6]),
        .c(LEDR[5]),
        .d(LEDR[4]),
        .e(LEDR[3]),        
        .f(LEDR[2]),
        .g(LEDR[1]),
        .h(LEDR[0])
   );
   
 
   hexDisplay d0(
        .A(cin1), 
        .M(HEX0[6:0])
        );

 hexDisplay d1(
        .A(4'b0000), 
        .M(HEX1[6:0])
        );


 hexDisplay d2(
        .A(cin0), 
        .M(HEX2[6:0])
        );

 hexDisplay d3(
        .A(4'b0000), 
        .M(HEX3[6:0])
        );



 hexDisplay d4(
        .A(cout[3:0]), 
        .M(HEX4[6:0])
        );

 hexDisplay d5(
        .A(cout[7:4]), 
        .M(HEX5[6:0])
        );


   ALU a0(
       .A(cin1),
       .B(cin0),
       .k(fin),
       .C(cout)
   
   );

        
endmodule

module multin(a, b, c, d, A);

input a, b, c, d;
output [3:0] A;

assign A[3] = a;
assign A[2] = b;
assign A[1] = c;
assign A[0] = d;

endmodule

module funcIn(a, b, c, d);

input a, b, c;
output [2:0] d;

assign d[2] = a;
assign d[1] = b;
assign d[0] = c;

endmodule

module multiOut(o, a, b, c, d, e, f, g, h);

input[7:0] o;
output a,b, c, d, e, f, g, h;

assign a = o[7];
assign b = o[6];
assign c = o[5];
assign d = o[4];
assign e = o[3];
assign f = o[2];
assign g = o[1];
assign h = o[0];

endmodule



module ALU(A, B, k, C);
  
input [3:0] A, B;
input [2:0] k;
output[7:0] C;
wire[7:0] cs0, cs1, cs2, cs3, cs4, cs5;
wire[3:0] uno;

assign uno = 4'b0001;



case1 cse0 (A, uno, cs0);
case1 cse1 (A, B, cs1);
case2 cse2 (A, B, cs2);
case3 cse3 (A, B, cs3);
case4 cse4 (A, B, cs4);
assign cs5[7:4] = B[3:0];
assign cs5[3:0] = A[3:0];


reg [7:0] Out;

always @(*)
begin
    case(k)
    3'b111: Out = cs0;
    3'b110: Out = cs1;
    3'b101: Out = cs2;
    3'b100: Out = cs3;
    3'b011: Out = cs4;
    3'b010: Out = cs5;
    default: Out = 8'b00000000;
    endcase
end

assign C[7:0] = Out[7:0];
endmodule



module case1(A, B, C);

input[3:0] A, B;
output[7:0] C;

wire fco2;
wire fco1;
wire fco0;

assign C[5] = 0;
assign C[6] = 0;
assign C[7] = 0;

   fullAdder u0(A[0],B[0],1'b0,C[0],fco0);
    
    fullAdder u1(A[1],B[1],fco0,C[1],fco1);
        
    fullAdder u2(A[2],B[2],fco1,C[2],fco2);
        
    fullAdder u3(A[3],B[3],fco2,C[3],C[4]);


endmodule

module case2(A, B, C);

input[3:0] A, B;
output[7:0] C;

assign C[4:0] = A + B;
assign C[5] = 1'b0;
assign C[6] = 1'b0;
assign C[7] = 1'b0;

endmodule

module case3(A, B, C);

input[3:0] A, B;
output[7:0] C;
wire[3:0] c1;
wire[3:0] c2;

assign c1 = A ^ B;
assign c2 = A | B; 

assign C[3:0] = c1[3:0];
assign C[7:4] = c2[3:0];

endmodule

module case4(A, B, C);

input[3:0] A, B;
output[7:0] C;
wire[7:0] connect;

assign connect[7:4] = A[3:0];
assign connect[3:0] = B[3:0];

reg[7:0] Out;

always @(*)
begin
    case(connect)
        8'b00000000: Out = 8'b00000000;
        default: Out = 8'b00000001;
    endcase
end

assign C[7:0] = Out[7:0];

endmodule


module fullAdder(a, b, cin, s, c);
    input a, b, cin; 
    output s, c; 
  
    assign c = a & cin | b & cin | a & b;
    assign s = b & ~a & ~cin | ~b & ~a & cin | b & a & cin | ~b & a & ~cin; 

endmodule
    
module hexDisplay(A, M);
	input [3:0] A;
	output [6:0] M;
	   
	hex0 h0(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[0])
		);
		
	hex1 h1(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[1])
		);

	hex2 h2(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[2])
		);

	hex3 h3(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[3])
		);

	hex4 h4(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[4])
		);

	hex5 h5(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[5])
		);

	hex6 h6(
		.d(A[0]),
		.c(A[1]),
		.b(A[2]),
		.a(A[3]),
		.m(M[6])
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
