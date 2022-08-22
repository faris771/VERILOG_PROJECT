
module TST_CLA; // SEEMS like 36 ns the delay

    reg [3:0]A;
    reg [3:0]B; 
    reg Cin;
    
    wire Cout; 
    wire [3:0]S; // sum
    
    CLA_ADDER DUMMY(.S(S), .Cout(Cout), .A(A), .B(B), .Cin(Cin));

    initial begin
        $display("CLA TST BENCHMARK");

      // #34 A = 4'b0001;
        #40 B = 4'b0001;
        // #34 A = 4'b0010;
        #40 B = 4'b1000;
        #40 A = 4'b1110;
        #40 B = 4'b0010;
        #40 Cin = 1'b1;
        #40 B = 4'b1111;
        #40 A = 4'b1000;
    end
    
    always #39 $display("Time %0d A = %b B = %b Cin = %b Cout = %b S = %b\n",$time,A,B,Cin,Cout,S); // 1 sec diff between  changing  and printing the value


    always #500 $finish;

endmodule

module CLA_ADDER(S , Cout , A , B , Cin); // SOURCE : https://www.geeksforgeeks.org/carry-look-ahead-adder/

    input [3:0]A;
    input [3:0]B; 
    input Cin;
    
    output Cout; 
    output[3:0]S; // sum
    
    wire [3:1]C;// C[i + 1 ]  = G[i]  + P[i]& c[i] ,  c[0] = cin

    wire [0:3]P; // Pi = Ai xor Bi
    wire [0:3]G; // Gi  = Ai and Bi 
    
    /// Making Pi
    xor #11 p0(P[0] , A[0] , B[0]);
    xor #11 p1(P[1] , A[1] , B[1]);
    xor #11 p2(P[2] , A[2] , B[2]);
    xor #11 p3(P[3] , A[3] , B[3]);
    
    /// Making Gi 
    and #7 g0(G[0] , A[0] , B[0]);
    and #7 g1(G[1] , A[1] , B[1]);
    and #7 g2(G[2] , A[2] , B[2]);
    and #7 g3(G[3] , A[3] , B[3]);
    
    /// Making C1
    wire tmp1;
    and #7 c11(tmp1 , P[0] , Cin); 
    or  #7 c12(C[1] , G[0] , tmp1); // C[1] = G[0] + P[0]& cin
    
    /// Making C2
    wire tmp2; // tmp2 = P[1]& cin
    wire tmp3;// tmp3 = P[1]& cin & G[1]
    and #7 c21(tmp2 , P[1] , G[0]);
    and #7 c22(tmp3 , P[1] , P[0] , Cin);
    or  #7 c23(C[2] , tmp2 , tmp3 , G[1]);
    
    /// Making C3
    wire tmp4; // tmp4 = P[2]& G[1]
    wire tmp5;// tmp5 = P[2]& P[1] & G[0]
    wire tmp6; // tmp6 = P[2]& P[1] & P[0] & cin

    and #7  c31(tmp4 , P[2] , G[1]);
    and #7  c32(tmp5 , P[2] , P[1] , G[0]);
    and #7  c33(tmp6 , P[2] , P[1] , P[0] , Cin);
    or  #7  c34(C[3] , tmp4 , tmp5 , tmp6 , G[2]);
    
    /// Making Cout (C4) 
    wire tmp7;
    wire tmp8;
    wire tmp9;
    wire tmp10;

    and #7  c41(tmp7 , P[3] , G[2]);
    and #7  c42(tmp8 , P[3] , P[2] , G[1]);
    and #7  c43(tmp9 , P[3] , P[2] , P[1] , G[0]);
    and #7  c44(tmp10 , P[3] , P[2] , P[1] , P[0] , Cin);
    or  #7  c45(Cout , tmp7 , tmp8 , tmp9 , tmp10 , G[3]);
    
    /// Making Sums // SUM = Pi XOR Ci

    xor #11 s0(S[0] , P[0] , Cin);
    xor #11 s1(S[1] , P[1] , C[1]);
    xor #11 s2(S[2] , P[2] , C[2]);
    xor #11 s3(S[3] , P[3] , C[3]);
    
endmodule