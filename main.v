/*
*   AUTHOR : FARIS ABUFARHA 
    ID : 1200546
    SECTION : 2
*
*
*/

`timescale 1ns/1ns // to make ns is the default time unit



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




// */


// module MUX4X1(f,s, b);

//     input  [0:3] b;
//     input [1: 0] s;
//     output  f;



//     wire [0:3] w;
//     wire ns1,ns0; // not s1, not s0

//     not #3ns (ns1, s[1]);
//     not #3ns (ns0, s[0]);

//     and #7ns (w[0] , b[0], ns1 ,ns0) , (w[1] , b[1], s[0] ,ns1), (w[2] , b[2], s[1] ,ns0), (w[3] , b[3],s[1], s[0]); 

//     or #7ns  (f, w[0], w[1], w[2], w[3]);



// endmodule

// // module TSTMUX4;

// //     reg [0:3] b;
// //     reg [1: 0] s;
// //     wire f;
// //     MUX4X1 DUMMY(.b(b), .s(s), .f(f)) ;

// //     initial begin
 
// //         {s,b} = 6'b000000;
        
// //         $monitor("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
        
// //         repeat(127) begin
            
// //             #20ns {s,b} = {s,b} + 6'b000001;

 
        
// //         end



// //     end



// // endmodule


// module TSTMUX4;

//     reg [0:3] b;
//     reg [1: 0] s;
//     wire f;
//     MUX4X1 tst (.b(b), .s(s), .f(f)) ; // order doesn't matter
    

//     initial begin
        
//         // $monitor("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);

//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
 
//         #20 s = 2'b00 ;b = 4'b0101;
//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
//         #20ns s = 2'b01 ;b = 4'b0101;

//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
//         #20ns s = 2'b10 ;b = 4'b0101;
//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);


//         #20ns s = 2'b11 ;b = 4'b0101;
//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);


//         $finish();





//     end



// endmodule


//===================== FULL ADDER ============================
module FULLADDER(sum, cout , a, b, cin);
    
    input a, b, cin;
    output sum, cout;

    wire z1,z2,z3;

    xor #11ns (sum,a,b,cin);

    and #7ns (z1, a, b);
    and #7ns (z2, a, cin);
    and #7ns (z3, b, cin);

    or #7ns (cout, z1,z2,z3);
    


endmodule



module FA_TEST;

    reg Tcin,Ta,Tb;
    wire Tsum,Tcout;

    FULLADDER DUMMY(.sum(Tsum), .cout(Tcout), .a(Ta), .b(Tb), .cin(Tcin));

    initial begin
        
        $display("FULL ADDER TST BENCHMARK");
        // total time must be > 22 ns
        {Tcin,Ta,Tb} = 3'b000;

        $monitor("Time %0d input = %b %b %b SUM= %b CARRY = %b\n",$time,Ta,Tb,Tcin,Tsum,Tcout);

        repeat(7) begin
            {Tcin,Ta,Tb} = {Tcin,Ta,Tb} +  3'b001;


        end    





    end













endmodule


