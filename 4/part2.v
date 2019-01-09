module part2(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
     input [9:0] SW;
	 input KEY;	 
	 output [7:0] LEDR;
	 output [6:0] HEX0;
	 output [6:0] HEX1;
	 output [6:0] HEX2;
	 output [6:0] HEX3;
	 output [6:0] HEX4;
	 output [6:0] HEX5;
	 wire [3:0] A;
	 wire [3:0] B;
	 wire reset_n;
	 wire alu_func;
	 wire [4:0] case00;
	 wire [7:0] case0;
	 wire [4:0] case01;
	 wire [7:0] case1;
	 wire [4:0] case02;
	 wire [7:0] case2;
	 wire [3:0] AXB;
	 wire [3:0] AORB;
	 wire [7:0] AB;
	 wire AB1;
	 wire [7:0] case3;
	 wire [7:0] case4;
	 wire [7:0] case5;
	 wire [7:0] case6;
	 wire [7:0] A_mult_B;
	 wire [7:0] case7;
	 wire [7:0] caseDefault;
	 reg [7:0] Out;
	 
	 assign A = SW[3:0];
	 //assign alu_func = SW[7:5];
	 assign reset_n = SW[9];

	 reg [7:0] C;
	 always @(posedge KEY)
	 begin
	     if (reset_n == 1'b0)
		  
		      C <= 8'b00000000;
				
		  else
		  
		      C <= Out;
	 end
	 
	 assign B = C[3:0];
	 
    adder d0(
        .a(A),
        .c(4'b0001),
		  .b(case00)
        );  
	 assign case0 = {3'b000, case00};
	 
	 adder d1(
        .a(A),
        .c(B),
		  .b(case01)
        );
	 assign case1 = {3'b000, case01};
	 
	 assign case02 = A + B;
	 assign case2 = {3'b000, case02};
	 
	 assign AB = {A, B};
	 assign AXB = A^B;
	 assign AORB = A|B;
	 assign case3 = {AORB, AXB};
	 
	 assign AB1 = | AB;
	 assign case4 = {7'b0000000, AB1};
	 
	 assign case5 = B << A;
	
	 assign case6 = B >> A;
	 
	 assign A_mult_B = A * B;
	 
	 assign case7 = {4'b0000, A_mult_B};

	 //assign caseDefault = 8'b00000000;
	 

	 
	 //assign case
	 
	 //reg [7:0] Out;
	 
	 always @(*)
	 begin
	     case (SW [7:5])
		      3'b000: Out = case0;
				3'b001: Out = case1;
				3'b010: Out = case2;
				3'b011: Out = case3;
				3'b100: Out = case4;
				3'b101: Out = case5;
				3'b110: Out = case6;
				3'b111: Out = case7;
				//default: Out = caseDefault;
		  endcase
	 end
	 
	 assign LEDR[7:0] = Out[7:0];
	 
	 HEXER H0(
        .SSW(A),
        .HEX(HEX0[6:0])
        );
		  
    offhex H1(
        .HEX(HEX1[6:0])
        );
		  
    offhex H2(
        .HEX(HEX2[6:0])
        );
		  
    offhex H3(
        .HEX(HEX3[6:0])
        );
		  
	 HEXER H4(
        .SSW(Out[3:0]),
        .HEX(HEX4[6:0])
        );
		  
	 HEXER H5(
        .SSW(Out[7:4]),
        .HEX(HEX5[6:0])
        );
	 
endmodule 
	 
	 
module adder(a, c, b);
    input [3:0] a;
	 input [3:0] c;
	 output [4:0] b;
	 wire c1;
	 wire c2;
	 wire c3;
	 
	 fulladder f0(
        .A(a[0]),
        .B(c[0]),
		  .cin(1'b0),
		  .S(b[0]),
		  .cout(c1)
        );
		  
	 fulladder f1(
        .A(a[1]),
        .B(c[1]),
		  .cin(c1),
		  .S(b[1]),
		  .cout(c2)
        );
		  
	 fulladder f2(
        .A(a[2]),
        .B(c[2]),
		  .cin(c2),
		  .S(b[2]),
		  .cout(c3)
        );
		  
	 fulladder f3(
        .A(a[3]),
        .B(c[3]),
		  .cin(c3),
		  .S(b[3]),
		  .cout(b[4])
        );
		  
endmodule
	 
module fulladder(A, B, cin, S, cout);
    input A;
    input B;
    input cin;
    output S;
	 output cout;
  
    assign cout = A & B | B & cin | A & cin;
	 assign S = (A ^ B) ^ cin;

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

module offhex(HEX);
    output [6:0] HEX;
	 
	 assign HEX[0] = 1;
	 assign HEX[1] = 1;
	 assign HEX[2] = 1;
	 assign HEX[3] = 1;
	 assign HEX[4] = 1;
	 assign HEX[5] = 1;
	 assign HEX[6] = 1;
	 
endmodule
