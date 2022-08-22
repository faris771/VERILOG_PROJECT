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


// module TST_IV_BIT_ADDER; // CHECK FOR BETTER DELAY 

//     reg cin;
//     reg [3:0] a,b;
//     wire [3:0] sum;
//     wire cout;

//     IV_BIT_ADDER DUMMY(.sum(sum), .cout(cout), .a(a), .b(b), .cin(cin));
  
//   	initial begin 
//       $dumpfile("dump.vcd");
//       $dumpvars(1);
      
      
//     end

//     initial begin
        
//         $display("4 BIT ADDER TST BENCHMARK2");

//         a = 4'b0000;
//         b = 4'b0000;
//         cin = 1'b0;

//         #70 a = 4'b1111; 
//         #70 b = 4'b1001;
//         #70 cin = 1'b1;

//     end
//     always #69 $display("Time %0d input = %b %b %b SUM= %b CARRY = %b\n",$time,a,b,cin,sum,cout); // 1 sec diff between  changing of Ta and Tb and Tcin and printing the value
//     always #300 $finish;



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

// module TST_SYSTEM;
    
//     reg cin;
//     reg [3:0] a,b;
//     reg [1:0] s;
//     wire [3:0] d;
//     wire cout;

//     SYSTEM DUMMY(.d(d), .cout(cout), .a(a), .b(b), .s(s), .cin(cin));


//     initial begin
//         // mux = 20 ns , 4bit adder : 45 =  65 + 5 for safety

//         $display("SYSTEM TST BENCHMARK");
//         {s,cin} = 3'b000;
//         a = 4'b0000;
//         b = 4'b1111;
//         $display("a : %b | b : %b ",a,b);
//         repeat(8) begin
            
//             #70 {s,cin} = {s,cin} +  3'b001;


//         end
        

//     end
//     always #69 $display("Time %0d select = %b%b OUT= %b CARRY = %b\n",$time,s,cin,d,cout); // 1 sec diff between  changing of Ta and Tb and Tcin and printing the value   
//     always #565 $finish; // 70 * 8 + 5 for safety




// endmodule


// ===================== Carry look ahead adder ============================

module CLA_ADDER(S , Cout , A , B , Cin); // SOURCE : https://www.geeksforgeeks.org/carry-look-ahead-adder/

    input [3:0]A;
    input [3:0]B; 
    input Cin;
    
    output Cout; 
    output[3:0]S; // sum
    
    wire [3:1]C;// C[i + 1 ]  = G[i]  + P[i]& c[i] ,  c[0] = cin

    wire [0:3]P; // Pi = Ai xor Bi
    wire [0:3]G; // Gi  = Ai and Bi 

    ///  Gi 
    and #7 g0(G[0] , A[0] , B[0]);
    and #7 g1(G[1] , A[1] , B[1]);
    and #7 g2(G[2] , A[2] , B[2]);
    and #7 g3(G[3] , A[3] , B[3]);
    
    ///  Pi
    xor #11 p0(P[0] , A[0] , B[0]);
    xor #11 p1(P[1] , A[1] , B[1]);
    xor #11 p2(P[2] , A[2] , B[2]);
    xor #11 p3(P[3] , A[3] , B[3]);
    
    ///  C1
    wire tmp1;
    and #7 c11(tmp1 , P[0] , Cin); 
    or  #7 c12(C[1] , G[0] , tmp1); // C[1] = G[0] + P[0]& cin
    
    ///  C2
    wire tmp2; // tmp2 = P[1]& cin
    wire tmp3;// tmp3 = P[1]& cin & G[1]
    and #7 c21(tmp2 , P[1] , G[0]);
    and #7 c22(tmp3 , P[1] , P[0] , Cin);
    or  #7 c23(C[2] , tmp2 , tmp3 , G[1]);
    
    ///  C3
    wire tmp4; // tmp4 = P[2]& G[1]
    wire tmp5;// tmp5 = P[2]& P[1] & G[0]
    wire tmp6; // tmp6 = P[2]& P[1] & P[0] & cin

    and #7  c31(tmp4 , P[2] , G[1]);
    and #7  c32(tmp5 , P[2] , P[1] , G[0]);
    and #7  c33(tmp6 , P[2] , P[1] , P[0] , Cin);
    or  #7  c34(C[3] , tmp4 , tmp5 , tmp6 , G[2]);
    
    ///  Cout (C4) 
    wire tmp7;
    wire tmp8;
    wire tmp9;
    wire tmp10;

    and #7  c41(tmp7 , P[3] , G[2]);
    and #7  c42(tmp8 , P[3] , P[2] , G[1]);
    and #7  c43(tmp9 , P[3] , P[2] , P[1] , G[0]);
    and #7  c44(tmp10 , P[3] , P[2] , P[1] , P[0] , Cin);
    or  #7  c45(Cout , tmp7 , tmp8 , tmp9 , tmp10 , G[3]);
    
    ///  Sums // SUM = Pi XOR Ci

    xor #11 s0(S[0] , P[0] , Cin);
    xor #11 s1(S[1] , P[1] , C[1]);
    xor #11 s2(S[2] , P[2] , C[2]);
    xor #11 s3(S[3] , P[3] , C[3]);
    
endmodule 

// module TST_CLA; // SEEMS like 45 ns is the suitable delay
// reg [3:0]A;
//     reg [3:0]B; 
//     reg Cin;
    
//     wire Cout; 
//     wire [3:0]S; // sum
    
//     CLA_ADDER DUMMY(.S(S), .Cout(Cout), .A(A), .B(B), .Cin(Cin));

//     initial begin
//         $display("CLA TST BENCHMARK");
// 		A = 4'b0000;
//       	B = 4'b0000;
//       	Cin = 1'b0;
      
      
//       // #34 A = 4'b0001;
//         #45 B = 4'b0001;
//         // #34 A = 4'b0010;
//         #45 B = 4'b1000;
//         #45 A = 4'b1110;
//         #45 B = 4'b0010;
//         #45 Cin = 1'b1;
//         #45 B = 4'b1111;
//         #45 A = 4'b1000;
//     end
    
//     always #44 $display("Time %0d A = %b B = %b Cin = %b Cout = %b S = %b\n",$time,A,B,Cin,Cout,S); // 1 sec diff between  changing  and printing the value


//     always #500 $finish;

// endmodule



// module Test; // abu sh
// 	reg [3:0] A, B;
// 	reg CIN;
// 	wire [4:0] S;
// 	integer counter = 0, counter2 = 1, maxtime = 0;
// 	integer ctime;
// 	CLA_ADDER CLA(.S(S[3:0]), .Cout(S[4]), .A(A), .B(B), .Cin(Cin));

//     initial begin
// 		{A, B, CIN} = counter;
// 		counter = counter + 1;
// 		ctime = $time;
// 		repeat(2**9 - 1)begin
// 			#70
// 			{A, B, CIN} = 11'bx;
// 			#70
// 			{A, B, CIN} = counter;
// 			counter = counter + 1;
// 			ctime = $time;
// 		end
// 		#100 $display("MAX TIME = %0d", maxtime);
	
//     end
	

//     always @ (S)
        
//         if (S == A + B + CIN && S != 0) begin
			
//             $display("Time %0d | A = %b | B = %b | CIN = %b | S = %b | %0d", ($time - ctime)/1000, A, B, CIN, S,counter2);
// 			counter2 = counter2 + 1;
// 			maxtime = ($time - ctime > maxtime)? $time-ctime : maxtime;
		
//         end
    
// endmodule
// full test bench with generator and analyzer


module TEST_GENERATOR (d,cout,a,b,s,cin,clk);

    output reg cin;
    output reg [3:0] a,b;
    output reg [1:0] s;

    input clk; // HERE ?? 
    integer counter;
    output reg [3:0] d; // extra bit for carry 
    output reg cout;
    


    initial begin
        counter = 0;

    end

    always @(posedge clk) begin
        
        if( counter == 2049) // 2048 +  1 extra bit for last case 
            $finish;
        {cin, a, b,s} = counter;
        counter = counter + 1;

        // if ({s,cin} == 3'b000 ) begin
        // end

        case({s,cin})

            4'b0000 : begin d = a + b; cout = d[4];end 
            4'b0001 : begin d = a + b + 1;cout = d[4];end
            4'b0010 : begin d = a + ~b; cout = d[4];end
            4'b0011 : begin d = a + ~b + 1 ;cout = d[4];end
            4'b0100 : begin d = a;cout = d[4];end
            4'b0101 : begin d = a +1;cout = d[4];end
            4'b0110 : begin d = a - 1 ;cout = d[4];end
            4'b0111 : begin d = a;cout = d[4];end
            
        endcase

    end

endmodule


module ANALYZER(exact_sum, prob_sum, clk  );

    input clk;
    input [4:0] exact_sum;
    input [4:0] prob_sum; // extra bit for carry

    always @( negedge clk) begin // generator is on positive edge, analyzer must be on negative edge

        if( exact_sum != prob_sum ) begin
            // $display("\033[1m"); bold
            $display("ERROR");
            // $display("\033[0m");
        end
        else begin
            $display("OK");
        end


    end







endmodule

module FULL_TEST_R;


    wire cin;
    wire [3:0] a,b;
    wire [1:0] s;
    
    reg clk;


    initial begin
       clk = 1; 
    end

    // ==================  =================

    wire [3:0] d; // prob sum
    wire cout1;

    wire [3:0] exact_sum;   //  
    wire cout2;

    TEST_GENERATOR TG(.cin(cin), .a(a), .b(b), .s(s), .d(exact_sum), .cout(cout2),.clk(clk));

    SYSTEM DUMMY(.d(d), .cout(cout1), .a(a), .b(b), .s(s), .cin(cin));
    ANALYZER ANLZ(.exact_sum({cout2,exact_sum}),.prob_sum({cout1,d}) ,.clk(clk));

    always #70 clk = ~clk; // By trial : 70 ns is a suitable latency for the system to finish correctly



endmodule



module SYSTEM_CLA(d,cout,a,b,s,cin);

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
    
    CLA_ADDER ADDER4(.S(d), .Cout(cout), .A(a), .B(y), .Cin(cin));


endmodule


// module FULL_TEST_CLA;


//     wire cin;
//     wire [3:0] a,b;
//     wire [1:0] s;
    
//     reg clk;


//     initial begin
//        clk = 1; 
//     end

//     // ==================  =================

//     wire [3:0] d; // prob sum
//     wire cout1;

//     wire [3:0] exact_sum;   //  
//     wire cout2;

//     TEST_GENERATOR TG(.cin(cin), .a(a), .b(b), .s(s), .d(exact_sum), .cout(cout2),.clk(clk));

//     SYSTEM_CLA DUMMY(.d(d), .cout(cout1), .a(a), .b(b), .s(s), .cin(cin));
//     ANALYZER ANLZ(.exact_sum({cout2,exact_sum}),.prob_sum({cout1,d}) ,.clk(clk));

//     always #55 clk = ~clk; //55 GOOD



// endmodule

