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




*/


module MUX4X1(f,s, b);

    // TIME NEEDED 3 + 7 +7 >= 17 
    input  [0:3] b;
    input [1: 0] s;
    output  f;



    wire [0:3] w;
    wire ns1,ns0; // not s1, not s0

    not #3 (ns1, s[1]);
    not #3 (ns0, s[0]);

    and #7 (w[0] , b[0], ns1 ,ns0) , (w[1] , b[1], s[0] ,ns1), (w[2] , b[2], s[1] ,ns0), (w[3] , b[3],s[1], s[0]); 

    or #7  (f, w[0], w[1], w[2], w[3]);



endmodule

// module TSTMUX4;

//     reg [0:3] b;
//     reg [1: 0] s;
//     wire f;
//     MUX4X1 DUMMY(.b(b), .s(s), .f(f)) ;

//     initial begin
 
//         {s,b} = 6'b000000;
        
//         $monitor("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
        
//         repeat(127) begin
            
//             #20 {s,b} = {s,b} + 6'b000001;

 
        
//         end



//     end



// endmodule


// module TSTMUX4;

//     reg [0:3] b;
//     reg [1: 0] s;
//     wire f;
//     MUX4X1 tst (.b(b), .s(s), .f(f)) ; // order doesn't matter
    

//     initial begin
        
        // $monitor("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);

//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
 
//         #20 s = 2'b00 ;b = 4'b0101;
//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
//         #20 s = 2'b01 ;b = 4'b0101;

//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
//         #20 s = 2'b10 ;b = 4'b0101;
//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);


//         #20 s = 2'b11 ;b = 4'b0101;
//         $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);


//         $finish();





//     end



// endmodule


//===================== FULL ADDER ============================
module FULLADDER(sum, cout , a, b, cin);
    
    input a, b, cin;
    output sum, cout;

    wire z1,z2,z3;

    xor #11 (sum,a,b,cin);

    and #7 (z1, a, b);
    and #7 (z2, a, cin);
    and #7 (z3, b, cin);

    or #7 (cout, z1,z2,z3);
    


endmodule



module FA_TEST;

    reg Tcin,Ta,Tb;
    wire Tsum,Tcout;

    FULLADDER DUMMY(.sum(Tsum), .cout(Tcout), .a(Ta), .b(Tb), .cin(Tcin));

    initial  begin
        $display("FULL ADDER TST BENCHMARK");
        // total time must be > 22 ns
        {Tcin,Ta,Tb} = 3'b000;


        repeat(7) begin
            #26 {Tcin,Ta,Tb} = {Tcin,Ta,Tb} +  3'b001;
        end  
          
        
    end
    always #25 $display("Time %0d input = %b %b %b SUM= %b CARRY = %b\n",$time,Ta,Tb,Tcin,Tsum,Tcout); // 1 sec diff between  changing of Ta and Tb and Tcin and printing the value 
    always #500 $finish;




endmodule


//===================== 4 bit  ADDER ============================

module IV_BIT_ADDER(sum,cout,a,b,cin);

    input cin;
    input [3:0] a,b;
    output [3:0] sum;
    output cout;
    wire [2:0] w;

    FULLADDER FA1(.sum(sum[0]), .cout(w[0]), .a(a[0]), .b(b[0]), .cin(cin));
    FULLADDER FA2(.sum(sum[1]), .cout(w[1]), .a(a[1]), .b(b[1]), .cin(w[0]));
    FULLADDER FA3(.sum(sum[2]), .cout(w[2]), .a(a[2]), .b(b[2]), .cin(w[1]));
    FULLADDER FA4(.sum(sum[3]), .cout(cout), .a(a[3]), .b(b[3]), .cin(w[2]));
    

endmodule


// module TST_IV_BIT_ADDER;

//     reg cin;
//     reg [3:0] a,b;
//     wire [3:0] sum;
//     wire cout;

//     IV_BIT_ADDER DUMMY(.sum(sum), .cout(cout), .a(a), .b(b), .cin(cin));

//     initial begin
        
//         $display("4 BIT ADDER TST BENCHMARK2");

//         a = 4'b0000;
//         b = 4'b0000;
//         cin = 1'b0;
//         $monitor("Time %0d | input = %d %d %d SUM= %d CARRY = %d\n",$time,a,b,cin,sum,cout);

//         #40 a = 15;
//         #40 a = 3;
//         #40 b = 3;
//         #40 cin = 1;



//     end
   



// endmodule

//===================== SYSTEM============================

module SYSTEM(d,cout,a,b,s,cin);
    input cin;
    input [3:0] a,b;
    input [1:0] s;
    output [3:0] d;
    output cout;
    // wire [2:0] c;
    wire [3:0] y;
    
    // logic [3:0] tmpB0,tmpB1,tmpB2,tmpB3;
    // tmpB0 = `{[0],~b[0],0,1}
    // tmpB1 =`{[1],~b[1],0,1}
    // tmpB2 =`{[2],~b[2],0,1}
    // tmpB3 =`{[3],~b[3],0,1}


    MUX4X1 mux0(.b({b[0],~b[0],1'b0,1'b1}), .s(s), .f(y[0]));    
    MUX4X1 mux1(.b({b[1],~b[1],1'b0,1'b1}), .s(s), .f(y[1]));    
    MUX4X1 mux2(.b({b[2],~b[2],1'b0,1'b1}), .s(s), .f(y[2]));    
    MUX4X1 mux3(.b({b[3],~b[3],1'b0,1'b1}), .s(s), .f(y[3]));    
    
    IV_BIT_ADDER ADDER4(.sum(d), .cout(cout), .a(a), .b(y), .cin(cin));


endmodule

