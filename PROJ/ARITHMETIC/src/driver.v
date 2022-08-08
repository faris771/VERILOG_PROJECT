/*
*   AUTHOR : FARIS ABUFARHA 
    ID : 1200546
    SECTION : 2
*
*
*/



/*

    Gate
Delay


Inverter        
3 ns


NOR
5 ns


AND
7 ns


OR
7 ns


XNOR
9 ns


XOR
11 ns



*/


module MUX4X1(f,s, b);

    input  [0:3] b;
    input [1: 0] s;
    output  f;



    wire [0:3] w;
    wire ns1,ns0; // not s1, not s0

    not #3ns (ns1, s[1]);
    not #3ns (ns0, s[0]);

    and #7ns AND0(w[0] , b[0], ns1 ,ns0), AND1(w[1] , b[1], s[0] ,ns1), AND2(w[2] , b[2], s[1] ,ns0), AND3(w[3] , b[3],s[1], s[0]); 
    
    or #7ns out (f, w[0], w[1], w[2], w[3]);





endmodule	 




module TSTMUX4;

    reg [0:3] b;
    reg [1: 0] s;
    wire f;
    MUX4X1 tst (.b(b), .s(s), .f(f)) ; // order doesn't matter
    

    initial begin
 
         s = 2'b00 ;b = 4'b0101;
        #10 s = 2'b01 ;b = 4'b0101;
        #10 s = 2'b10 ;b = 4'b0101;
        #10 s = 2'b11 ;b = 4'b0101;
        
        $finish();





    end



endmodule

