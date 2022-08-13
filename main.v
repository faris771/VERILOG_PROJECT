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
//     MUX4X1 tst (.b(b), .s(s), .f(f)) ; // order doesn't matter
    

//     initial begin

//         $display(" MUX TEST BENCH");

//         // $monitor("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f);
//         {s} = 2'b00;
//         b = 4'b1010;

//         repeat(4) begin

//             #21 {s} = {s} + 2'b01; // 1 ns diff between each iteration priting the value  

//         end
      

//     end

//     always #20 $display("Time %0d select= %b input = %b OUT= %b\n",$time,s,b,f); // 20 > 17(mux toal delation )
//     always #85 $finish; // 4 cases each case 20 ns  = 80 ns, 85 ns > 80 ns




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



// module FA_TEST;

//     reg Tcin,Ta,Tb;
//     wire Tsum,Tcout;

//     FULLADDER DUMMY(.sum(Tsum), .cout(Tcout), .a(Ta), .b(Tb), .cin(Tcin));

//     initial  begin
//         $display("FULL ADDER TST BENCHMARK");
        // total time must be > 25 ns
//         {Tcin,Ta,Tb} = 3'b000;


//         repeat(7) begin
//             #26 {Tcin,Ta,Tb} = {Tcin,Ta,Tb} +  3'b001;
//         end  
          
        
//     end
//     always #25 $display("Time %0d input = %b %b %b SUM= %b CARRY = %b\n",$time,Ta,Tb,Tcin,Tsum,Tcout); // 1 sec diff between  changing of Ta and Tb and Tcin and printing the value 
//     always #500 $finish;




// endmodule


//===================== 4 bit  ADDER ============================

module IV_BIT_ADDER(sum,cout,a,b,cin);

    input cin;
    input [3:0] a,b;
    output [3:0] sum;
    output cout;
    wire [2:0] w;

    FULLADDER FA0(.sum(sum[0]), .cout(w[0]), .a(a[0]), .b(b[0]), .cin(cin));
    FULLADDER FA1(.sum(sum[1]), .cout(w[1]), .a(a[1]), .b(b[1]), .cin(w[0]));
    FULLADDER FA2(.sum(sum[2]), .cout(w[2]), .a(a[2]), .b(b[2]), .cin(w[1]));
    FULLADDER FA3(.sum(sum[3]), .cout(cout), .a(a[3]), .b(b[3]), .cin(w[2]));
    

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

//         #45 a = 4'b1111; // why 45 ? because  full adder needs 25 ns and each full adder needs carry which needs 14ns  = 44ns 1ns (but it'd concurrent so 14 + 25 ==44 + 1 for safety )        #45 a = 4'b1011;
//         #45 b = 4'b1001;
//         #45 cin = 1'b1;

//     end
//     always #44 $display("Time %0d input = %b %b %b SUM= %b CARRY = %b\n",$time,a,b,cin,sum,cout); // 1 sec diff between  changing of Ta and Tb and Tcin and printing the value
//     always #185 $finish;



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
    

    MUX4X1 mux0(.b({b[0],~b[0],1'b0,1'b1}), .s(s), .f(y[0]));    
    MUX4X1 mux1(.b({b[1],~b[1],1'b0,1'b1}), .s(s), .f(y[1]));    
    MUX4X1 mux2(.b({b[2],~b[2],1'b0,1'b1}), .s(s), .f(y[2]));    
    MUX4X1 mux3(.b({b[3],~b[3],1'b0,1'b1}), .s(s), .f(y[3]));    
    
    IV_BIT_ADDER ADDER4(.sum(d), .cout(cout), .a(a), .b(y), .cin(cin));


endmodule

module TST_SYSTEM;
    
    reg cin;
    reg [3:0] a,b;
    reg [1:0] s;
    wire [3:0] d;
    wire cout;

    SYSTEM DUMMY(.d(d), .cout(cout), .a(a), .b(b), .s(s), .cin(cin));


    initial begin
        // mux = 20 ns , 4bit adder : 45 =  65 + 5 for safety

        $display("SYSTEM TST BENCHMARK");
        {s,cin} = 3'b000;
        a = 4'b0000;
        b = 4'b1111;
        $display("a : %b | b : %b ",a,b);
        repeat(8) begin
            
            #70 {s,cin} = {s,cin} +  3'b001;


        end
        

    end
    always #69 $display("Time %0d select = %b%b OUT= %b CARRY = %b\n",$time,s,cin,d,cout); // 1 sec diff between  changing of Ta and Tb and Tcin and printing the value   
    always #565 $finish; // 70 * 8 + 5 for safety




endmodule