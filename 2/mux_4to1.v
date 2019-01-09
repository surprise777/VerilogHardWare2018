//SW[3:0] data inputs
//SW[9:8] select signals

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;
    wire c1;
    wire c0;

    mux2to1 u0(
        .x(SW[3]),
        .w(SW[1]),
        .s(SW[9]),
        .m(c1)
        );
    
    mux2to1 u1(
        .x(SW[2]),
        .w(SW[0]),
        .s(SW[9]),
        .m(c0)
        );
    
    mux2to1 u2(
        .x(c1),
        .w(c0),
        .s(SW[8]),
        .m(LEDR[0])
        );
        
endmodule

module mux2to1(x, w, s, m);
    input x; //selected when s1 is 0
    input w; //selected when s1 is 1
    input s; //select signal 1
    output m; //output1 connection
  
    assign m = s & w | ~s & x;

endmodule
    
