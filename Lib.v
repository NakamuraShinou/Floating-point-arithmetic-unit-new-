////// Adder library /////////
module HalfAdder(s, cout, x, cin);
	output s, cout;
	input x, cin;
	
	xor(s, x, cin);
	and(cout, x, cin);
endmodule 

module FullAdder(s, cout, x, y, cin);
	output s, cout;
	input x, y, cin;
	
	xor(s, x, y, cin);
	and(w1, x, y);
	and(w2, x, cin);
	and(w3, y, cin);
	or(cout, w1, w2, w3);
endmodule

module HA_dec(s, cout, x, cin);
	output s, cout;
	input x, cin;
	
	assign cout = ~x && cin;
	assign s = x ^ cin;
endmodule 

module Fast_Adder8(S, cout, X, Y, cin);
	output [7:0] S;
	output cout;
	input [7:0] X, Y;
	input cin;
	wire [7:0] G, P;
	wire [7:1] C;
	
	assign G[0] = X[0] && Y[0];
	assign G[1] = X[1] && Y[1];
	assign G[2] = X[2] && Y[2];
	assign G[3] = X[3] && Y[3];
	assign G[4] = X[4] && Y[4];
	assign G[5] = X[5] && Y[5];
	assign G[6] = X[6] && Y[6];
	assign G[7] = X[7] && Y[7];
	
	assign P[0] = X[0] || Y[0];
	assign P[1] = X[1] || Y[1];
	assign P[2] = X[2] || Y[2];
	assign P[3] = X[3] || Y[3];
	assign P[4] = X[4] || Y[4];
	assign P[5] = X[5] || Y[5];
	assign P[6] = X[6] || Y[6];
	assign P[7] = X[7] || Y[7];
	
	assign C[1] = G[0]||(P[0]&&cin);
	assign C[2] = G[1]||(P[1]&&G[0])||(P[1]&&P[0]&&cin);
	assign C[3] = G[2]||(P[2]&&G[1])||(P[2]&&P[1]&&G[0])||(P[2]&&P[1]&&P[0]&&cin);
	assign C[4] = G[3]||(P[3]&&G[2])||(P[3]&&P[2]&&G[1])||(P[3]&&P[2]&&P[1]&&G[0])||(P[3]&&P[2]&&P[1]&&P[0]&&cin);
	assign C[5] = G[4]||(P[4]&&G[3])||(P[4]&&P[3]&&G[2])||(P[4]&&P[3]&&P[2]&&G[1])||(P[4]&&P[3]&&P[2]&&P[1]&&G[0])||(P[4]&&P[3]&&P[2]&&P[1]&&P[0]&&cin);
	assign C[6] = G[5]||(P[5]&&G[4])||(P[5]&&P[4]&&G[3])||(P[5]&&P[4]&&P[3]&&G[2])||(P[5]&&P[4]&&P[3]&&P[2]&&G[1])||(P[5]&&P[4]&&P[3]&&P[2]&&P[1]&&G[0])||(P[5]&&P[4]&&P[3]&&P[2]&&P[1]&&P[0]&&cin);
	assign C[7] = G[6]||(P[6]&&G[5])||(P[6]&&P[5]&&G[4])||(P[6]&&P[5]&&P[4]&&G[3])||(P[6]&&P[5]&&P[4]&&P[3]&&G[2])||(P[6]&&P[5]&&P[4]&&P[3]&&P[2]&&G[1])||(P[6]&&P[5]&&P[4]&&P[3]&&P[2]&&P[1]&&G[0])||(P[6]&&P[5]&&P[4]&&P[3]&&P[2]&&P[1]&&P[0]&&cin);
	assign cout = G[7]||(P[7]&&G[6])||(P[7]&&P[6]&&G[5])||(P[7]&&P[6]&&P[5]&&G[4])||(P[7]&&P[6]&&P[5]&&P[4]&&G[3])||(P[7]&&P[6]&&P[5]&&P[4]&&P[3]&&G[2])||(P[7]&&P[6]&&P[5]&&P[4]&&P[3]&&P[2]&&G[1])||(P[7]&&P[6]&&P[5]&&P[4]&&P[3]&&P[2]&&P[1]&&G[0])||(P[7]&&P[6]&&P[5]&&P[4]&&P[3]&&P[2]&&P[1]&&P[0]&&cin);
	
	assign S[0] = X[0] ^ Y[0] ^ cin;
	assign S[1] = X[1] ^ Y[1] ^ C[1];
	assign S[2] = X[2] ^ Y[2] ^ C[2];
	assign S[3] = X[3] ^ Y[3] ^ C[3];
	assign S[4] = X[4] ^ Y[4] ^ C[4];
	assign S[5] = X[5] ^ Y[5] ^ C[5];
	assign S[6] = X[6] ^ Y[6] ^ C[6];
	assign S[7] = X[7] ^ Y[7] ^ C[7];
endmodule 

module Fast_Adder24(S, cout, X, Y, cin);
	output [23:0] S;
	output cout;
	input [23:0] X, Y;
	input cin;
	wire [2:1] C;
	
	Fast_Adder8 F0(S[7:0], C[1], X[7:0], Y[7:0], cin);
	Fast_Adder8 F1(S[15:8], C[2], X[15:8], Y[15:8], C[1]);
	Fast_Adder8 F2(S[23:16], cout, X[23:16], Y[23:16], C[2]);
endmodule 

module Adder9(S, cout, X, Y, cin);
	output [8:0] S;
	output cout;
	input [8:0] X, Y;
	input cin;
	
	Fast_Adder8 stage0(S[7:0], c1, X[7:0], Y[7:0], cin);
	FullAdder stage1(S[8], cout, X[8], Y[8], c1);
endmodule 

module Adder25(S, cout, X, Y, cin);
	output [24:0] S;
	output cout;
	input [24:0] X, Y;
	input cin;
	
	Fast_Adder24 F3(S[23:0], c, X[23:0], Y[23:0], cin);
	FullAdder F4(S[24], cout, X[24], Y[24], c);
endmodule

module Adder26(S, cout, X, Y, cin);
	output [25:0] S;
	output cout;
	input [25:0] X, Y;
	input cin;
	
	Adder25 F5(S[24:0], c, X[24:0], Y[24:0], cin);
	FullAdder F6(S[25], cout, X[25], Y[25], c);
endmodule 

module Adder53(S, cout, X, Y, cin);
	output [52:0] S;
	output cout;
	input [52:0] X, Y;
	input cin;

	Adder26 stage0(S[25:0], c0, X[25:0], Y[25:0], cin);
	Adder26 stage1(S[51:26], c1, X[51:26], Y[51:26], c0);
	FullAdder stage2(S[52], cout, X[52], Y[52], c1);
endmodule

module Adder55(S, cout, X, Y, cin);
	output [54:0] S;
	output cout;
	input [54:0] X, Y;
	input cin;
	
	Adder53 add53(S[52:0], c1, X[52:0], Y[52:0], cin);
	FullAdder fulladder0(S[53], c2, X[53], Y[53], c1);
	FullAdder fulladder1(S[54], cout, X[54], Y[54], c2);
endmodule
///////////////////////////////

////// Inc & Dec library //////
module Increase8(F, cout, X, cin);
	output [7:0] F;
	output cout;
	input [7:0] X;
	input cin;
	wire C[7:1];
	
	HalfAdder stage0(F[0], C[1], X[0], cin);
	HalfAdder stage1(F[1], C[2], X[1], C[1]);
	HalfAdder stage2(F[2], C[3], X[2], C[2]);
	HalfAdder stage3(F[3], C[4], X[3], C[3]);
	HalfAdder stage4(F[4], C[5], X[4], C[4]);
	HalfAdder stage5(F[5], C[6], X[5], C[5]);
	HalfAdder stage6(F[6], C[7], X[6], C[6]);
	HalfAdder stage7(F[7], cout, X[7], C[7]);
endmodule 

module Increase24(F, cout, X, cin);
	output [23:0] F;
	output cout;
	input [23:0] X;
	input cin;
	wire [2:1] C;
	
	Increase8 F7(F[7:0], C[1], X[7:0], cin);
	Increase8 F8(F[15:8], C[2], X[15:8], C[1]);
	Increase8 F9(F[23:16], cout, X[23:16], C[2]);
endmodule

module Increase26(F, cout, X, cin);
	output [25:0] F;
	output cout;
	input [25:0] X;
	input cin;
	
	Increase24 inc24(F[23:0], c1, X[23:0], cin);
	HalfAdder stage0(F[24], c2, X[24], c1);
	HalfAdder stage1(F[25], cout, X[25], c2);
endmodule 

module Increase27(F, cout, X, cin);
	output [26:0] F;
	output cout;
	input [26:0] X;
	input cin;
	
	Increase26 inc(F[25:0], c, X[25:0], cin);
	HalfAdder half_adder(F[26], cout, X[26], c);
endmodule

module Increase28(F, cout, X, cin);
	output [27:0] F;
	output cout;
	input [27:0] X;
	input cin;
	
	Increase27 inc0(F[26:0], c, X[26:0], cin);
	HalfAdder halfadder(F[27], cout, X[27], c);
endmodule

module Decrease8(S, cout, X, cin);
	output [7:0] S;
	output cout;
	input [7:0] X;
	input cin;
	wire [7:1] C;

	HA_dec F10(S[0], C[1], X[0], cin);
	HA_dec F11(S[1], C[2], X[1], C[1]);
	HA_dec F12(S[2], C[3], X[2], C[2]);
	HA_dec F13(S[3], C[4], X[3], C[3]);
	HA_dec F14(S[4], C[5], X[4], C[4]);
	HA_dec F15(S[5], C[6], X[5], C[5]);
	HA_dec F16(S[6], C[7], X[6], C[6]);
	HA_dec F17(S[7], cout, X[7], C[7]);
endmodule

module Decrease23(S, cout, X, cin);
	output [22:0] S;
	output cout;
	input [22:0] X;
	input cin;
	wire C[22:1];
	
	HA_dec F18(S[0], C[1], X[0], cin);
	HA_dec F19(S[1], C[2], X[1], C[1]);
	HA_dec F20(S[2], C[3], X[2], C[2]);
	HA_dec F21(S[3], C[4], X[3], C[3]);
	HA_dec F22(S[4], C[5], X[4], C[4]);
	HA_dec F23(S[5], C[6], X[5], C[5]);
	HA_dec F24(S[6], C[7], X[6], C[6]);
	HA_dec F25(S[7], C[8], X[7], C[7]);
	HA_dec F26(S[8], C[9], X[8], C[8]);
	HA_dec F27(S[9], C[10], X[9], C[9]);
	HA_dec F28(S[10], C[11], X[10], C[10]);
	HA_dec F29(S[11], C[12], X[11], C[11]);
	HA_dec F30(S[12], C[13], X[12], C[12]);
	HA_dec F31(S[13], C[14], X[13], C[13]);
	HA_dec F32(S[14], C[15], X[14], C[14]);
	HA_dec F33(S[15], C[16], X[15], C[15]);
	HA_dec F34(S[16], C[17], X[16], C[16]);
	HA_dec F35(S[17], C[18], X[17], C[17]);
	HA_dec F36(S[18], C[19], X[18], C[18]);
	HA_dec F37(S[19], C[20], X[19], C[19]);
	HA_dec F38(S[20], C[21], X[20], C[20]);
	HA_dec F39(S[21], C[22], X[21], C[21]);
	HA_dec F40(S[22], cout, X[22], C[22]);
endmodule
///////////////////////////////

////// mux library ///////////
module mux2to1(out, s, in0, in1);
	output out;
	input s, in0, in1;
	
	not(not_s, s);
	and(w1, not_s, in0);
	and(w2, s, in1);
	or(out, w1, w2);
endmodule 

module mux4to1(out, S, in0, in1, in2, in3);
	output out;
	input in0, in1, in2, in3;
	input [1:0] S;
	
	assign out = ((~S[1])&&(~S[0])&&in0) || ((~S[1])&&S[0]&&in1) || (S[1]&&(~S[0])&&in2) || (S[1]&&S[0]&&in3);
endmodule

module mux8to1(out, S, IN);
	output out;
	input [2:0] S;
	input [7:0] IN;
	
	assign out = (IN[0]&&(~S[2])&&(~S[1])&&(~S[0]))||(IN[1]&&(~S[2])&&(~S[1])&&S[0])||(IN[2]&&(~S[2])&&S[1]&&(~S[0]))||(IN[3]&&(~S[2])&&S[1]&&S[0])||(IN[4]&&S[2]&&(~S[1])&&(~S[0]))||(IN[5]&&S[2]&&(~S[1])&&S[0])||(IN[6]&&S[2]&&S[1]&&(~S[0]))||(IN[7]&&S[2]&&S[1]&&S[0]);
endmodule

module mux16to1(out,S,IN);
	input[15:0] IN;
	input[3:0] S;
	output out;
	wire temp1,temp2;
	
	mux8to1 mux81_1(temp1, S[2:0], IN[7:0]);
	mux8to1 mux81_2(temp2, S[2:0], IN[15:8]);
	mux2to1 mux21_3(out, S[3], temp1, temp2);
endmodule 

module mux24to1(out, S, IN);
	output out;
	input [4:0] S;
	input [23:0] IN;
	
	mux32to1 chooseChanel(out, S, {8'b0, IN});
endmodule

module mux24to1_re(out, S, IN);
	output out;
	input [4:0] S;
	input [23:0] IN;
	wire [23:0] S_reverse; // S = 0 -> S_reverse = 23, ... => S_reverse = 23 - S
	
	Fast_Adder8 sub(S_reverse, cout, 8'b00010111, ~S, 1'b1);
	mux24to1 mx(out, S_reverse, IN);
endmodule

/*
module mux24to1(out, S, IN);
	output reg out;
	input [4:0] S;
	input [23:0] IN;
	
	always @(S, IN)
	case (S)
		5'b00000: out = IN[0];
		5'b00001: out = IN[1];
		5'b00010: out = IN[2];
		5'b00011: out = IN[3];
		5'b00100: out = IN[4];
		5'b00101: out = IN[5];
		5'b00110: out = IN[6];
		5'b00111: out = IN[7];
		5'b01000: out = IN[8];
		5'b01001: out = IN[9];
		5'b01010: out = IN[10];
		5'b01011: out = IN[11];
		5'b01100: out = IN[12];
		5'b01101: out = IN[13];
		5'b01110: out = IN[14];
		5'b01111: out = IN[15];
		5'b10000: out = IN[16];
		5'b10001: out = IN[17];
		5'b10010: out = IN[18];
		5'b10011: out = IN[19];
		5'b10100: out = IN[20];
		5'b10101: out = IN[21];
		5'b10110: out = IN[22];
		5'b10111: out = IN[23];
	endcase
endmodule
*/

module mux32to1(out,S,IN);
	input[31:0] IN;
	input[4:0] S;
	output out;
	wire temp1, temp2;
	wire[1:0] temp3;
	
	mux16to1 mux161_1(temp1, S[3:0], IN[15:0]);
	mux16to1 mux161_2(temp2, S[3:0], IN[31:16]);
	mux2to1 mux21_3(out, S[4], temp1, temp2);
endmodule 

/*
module mux24to1_re(out, S, IN);
	output reg out;
	input [4:0] S;
	input [23:0] IN;
	
	always @(S, IN)
	case (S)
		5'b00000: out = IN[23];
		5'b00001: out = IN[22];
		5'b00010: out = IN[21];
		5'b00011: out = IN[20];
		5'b00100: out = IN[19];
		5'b00101: out = IN[18];
		5'b00110: out = IN[17];
		5'b00111: out = IN[16];
		5'b01000: out = IN[15];
		5'b01001: out = IN[14];
		5'b01010: out = IN[13];
		5'b01011: out = IN[12];
		5'b01100: out = IN[11];
		5'b01101: out = IN[10];
		5'b01110: out = IN[9];
		5'b01111: out = IN[8];
		5'b10000: out = IN[7];
		5'b10001: out = IN[6];
		5'b10010: out = IN[5];
		5'b10011: out = IN[4];
		5'b10100: out = IN[3];
		5'b10101: out = IN[2];
		5'b10110: out = IN[1];
		5'b10111: out = IN[0];
	endcase
endmodule
*/

module mux2to1_2bit(OUT, s, IN0, IN1);
	output [1:0] OUT;
	input s;
	input [1:0] IN0, IN1;
	
	mux2to1 stage0(OUT[0], s, IN0[0], IN1[0]);
	mux2to1 stage1(OUT[1], s, IN0[1], IN1[1]);
endmodule

module mux2to1_8bit(OUT, s, IN0, IN1);
	output [7:0] OUT;
	input s;
	input [7:0] IN0, IN1;
	
	mux2to1 stage0(OUT[0], s, IN0[0], IN1[0]);
	mux2to1 stage1(OUT[1], s, IN0[1], IN1[1]);
	mux2to1 stage2(OUT[2], s, IN0[2], IN1[2]);
	mux2to1 stage3(OUT[3], s, IN0[3], IN1[3]);
	mux2to1 stage4(OUT[4], s, IN0[4], IN1[4]);
	mux2to1 stage5(OUT[5], s, IN0[5], IN1[5]);
	mux2to1 stage6(OUT[6], s, IN0[6], IN1[6]);
	mux2to1 stage7(OUT[7], s, IN0[7], IN1[7]);
endmodule 

module mux2to1_24bit(OUT, s, IN0, IN1);
	output [23:0] OUT;
	input s;
	input [23:0] IN0, IN1;
	
	mux2to1_8bit stage0(OUT[7:0], s, IN0[7:0], IN1[7:0]);
	mux2to1_8bit stage1(OUT[15:8], s, IN0[15:8], IN1[15:8]);
	mux2to1_8bit stage2(OUT[23:16], s, IN0[23:16], IN1[23:16]);
endmodule 

module mux4to1_8bit(OUT, S, IN0, IN1, IN2, IN3);
	output [7:0] OUT;
	input [7:0] IN0, IN1, IN2, IN3;
	input [1:0] S;
	
	mux4to1 F41(OUT[0], S, IN0[0], IN1[0], IN2[0], IN3[0]);
	mux4to1 F42(OUT[1], S, IN0[1], IN1[1], IN2[1], IN3[1]);
	mux4to1 F43(OUT[2], S, IN0[2], IN1[2], IN2[2], IN3[2]);
	mux4to1 F44(OUT[3], S, IN0[3], IN1[3], IN2[3], IN3[3]);
	mux4to1 F45(OUT[4], S, IN0[4], IN1[4], IN2[4], IN3[4]);
	mux4to1 F46(OUT[5], S, IN0[5], IN1[5], IN2[5], IN3[5]);
	mux4to1 F47(OUT[6], S, IN0[6], IN1[6], IN2[6], IN3[6]);
	mux4to1 F48(OUT[7], S, IN0[7], IN1[7], IN2[7], IN3[7]);
endmodule

module mux4to1_23bit(OUT, S, IN0, IN1, IN2, IN3);
	output [22:0] OUT;
	input [1:0] S;
	input [22:0] IN0, IN1, IN2, IN3;
	
	mux4to1 F49(OUT[0], S, IN0[0], IN1[0], IN2[0], IN3[0]);
	mux4to1 F50(OUT[1], S, IN0[1], IN1[1], IN2[1], IN3[1]);
	mux4to1 F51(OUT[2], S, IN0[2], IN1[2], IN2[2], IN3[2]);
	mux4to1 F52(OUT[3], S, IN0[3], IN1[3], IN2[3], IN3[3]);
	mux4to1 F53(OUT[4], S, IN0[4], IN1[4], IN2[4], IN3[4]);
	mux4to1 F54(OUT[5], S, IN0[5], IN1[5], IN2[5], IN3[5]);
	mux4to1 F55(OUT[6], S, IN0[6], IN1[6], IN2[6], IN3[6]);
	mux4to1 F56(OUT[7], S, IN0[7], IN1[7], IN2[7], IN3[7]);
	mux4to1 F57(OUT[8], S, IN0[8], IN1[8], IN2[8], IN3[8]);
	mux4to1 F58(OUT[9], S, IN0[9], IN1[9], IN2[9], IN3[9]);
	mux4to1 F59(OUT[10], S, IN0[10], IN1[10], IN2[10], IN3[10]);
	mux4to1 F60(OUT[11], S, IN0[11], IN1[11], IN2[11], IN3[11]);
	mux4to1 F61(OUT[12], S, IN0[12], IN1[12], IN2[12], IN3[12]);
	mux4to1 F62(OUT[13], S, IN0[13], IN1[13], IN2[13], IN3[13]);
	mux4to1 F63(OUT[14], S, IN0[14], IN1[14], IN2[14], IN3[14]);
	mux4to1 F64(OUT[15], S, IN0[15], IN1[15], IN2[15], IN3[15]);
	mux4to1 F65(OUT[16], S, IN0[16], IN1[16], IN2[16], IN3[16]);
	mux4to1 F66(OUT[17], S, IN0[17], IN1[17], IN2[17], IN3[17]);
	mux4to1 F67(OUT[18], S, IN0[18], IN1[18], IN2[18], IN3[18]);
	mux4to1 F68(OUT[19], S, IN0[19], IN1[19], IN2[19], IN3[19]);
	mux4to1 F69(OUT[20], S, IN0[20], IN1[20], IN2[20], IN3[20]);
	mux4to1 F70(OUT[21], S, IN0[21], IN1[21], IN2[21], IN3[21]);
	mux4to1 F71(OUT[22], S, IN0[22], IN1[22], IN2[22], IN3[22]);
endmodule

module mux4to1_32bit(OUT, S, IN0, IN1, IN2, IN3);
	output [31:0] OUT;
	input [1:0] S;
	input [31:0] IN0, IN1, IN2, IN3;
	
	mux4to1 m0(OUT[0], S, IN0[0], IN1[0], IN2[0], IN3[0]);
	mux4to1 m1(OUT[1], S, IN0[1], IN1[1], IN2[1], IN3[1]);
	mux4to1 m2(OUT[2], S, IN0[2], IN1[2], IN2[2], IN3[2]);
	mux4to1 m3(OUT[3], S, IN0[3], IN1[3], IN2[3], IN3[3]);
	mux4to1 m4(OUT[4], S, IN0[4], IN1[4], IN2[4], IN3[4]);
	mux4to1 m5(OUT[5], S, IN0[5], IN1[5], IN2[5], IN3[5]);
	mux4to1 m6(OUT[6], S, IN0[6], IN1[6], IN2[6], IN3[6]);
	mux4to1 m7(OUT[7], S, IN0[7], IN1[7], IN2[7], IN3[7]);
	mux4to1 m8(OUT[8], S, IN0[8], IN1[8], IN2[8], IN3[8]);
	mux4to1 m9(OUT[9], S, IN0[9], IN1[9], IN2[9], IN3[9]);
	mux4to1 m10(OUT[10], S, IN0[10], IN1[10], IN2[10], IN3[10]);
	mux4to1 m11(OUT[11], S, IN0[11], IN1[11], IN2[11], IN3[11]);
	mux4to1 m12(OUT[12], S, IN0[12], IN1[12], IN2[12], IN3[12]);
	mux4to1 m13(OUT[13], S, IN0[13], IN1[13], IN2[13], IN3[13]);
	mux4to1 m14(OUT[14], S, IN0[14], IN1[14], IN2[14], IN3[14]);
	mux4to1 m15(OUT[15], S, IN0[15], IN1[15], IN2[15], IN3[15]);
	mux4to1 m16(OUT[16], S, IN0[16], IN1[16], IN2[16], IN3[16]);
	mux4to1 m17(OUT[17], S, IN0[17], IN1[17], IN2[17], IN3[17]);
	mux4to1 m18(OUT[18], S, IN0[18], IN1[18], IN2[18], IN3[18]);
	mux4to1 m19(OUT[19], S, IN0[19], IN1[19], IN2[19], IN3[19]);
	mux4to1 m20(OUT[20], S, IN0[20], IN1[20], IN2[20], IN3[20]);
	mux4to1 m21(OUT[21], S, IN0[21], IN1[21], IN2[21], IN3[21]);
	mux4to1 m22(OUT[22], S, IN0[22], IN1[22], IN2[22], IN3[22]);
	mux4to1 m23(OUT[23], S, IN0[23], IN1[23], IN2[23], IN3[23]);
	mux4to1 m24(OUT[24], S, IN0[24], IN1[24], IN2[24], IN3[24]);
	mux4to1 m25(OUT[25], S, IN0[25], IN1[25], IN2[25], IN3[25]);
	mux4to1 m26(OUT[26], S, IN0[26], IN1[26], IN2[26], IN3[26]);
	mux4to1 m27(OUT[27], S, IN0[27], IN1[27], IN2[27], IN3[27]);
	mux4to1 m28(OUT[28], S, IN0[28], IN1[28], IN2[28], IN3[28]);
	mux4to1 m29(OUT[29], S, IN0[29], IN1[29], IN2[29], IN3[29]);
	mux4to1 m30(OUT[30], S, IN0[30], IN1[30], IN2[30], IN3[30]);
	mux4to1 m31(OUT[31], S, IN0[31], IN1[31], IN2[31], IN3[31]);
endmodule

module mux8to1_2bit(OUT, S, IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7);
	output [1:0] OUT;
	input [2:0] S;
	input [1:0] IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7;
	
	mux8to1 mx0(OUT[0], S, {IN7[0], IN6[0], IN5[0], IN4[0], IN3[0], IN2[0], IN1[0], IN0[0]});
	mux8to1 mx1(OUT[1], S, {IN7[1], IN6[1], IN5[1], IN4[1], IN3[1], IN2[1], IN1[1], IN0[1]});
endmodule

module mux8to1_26bit(OUT, S, IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7);
	output [25:0] OUT;
	input [2:0] S;
	input [25:0] IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7;
	
	mux8to1 bit0(OUT[0], S, {IN7[0], IN6[0], IN5[0], IN4[0], IN3[0], IN2[0], IN1[0], IN0[0]});
	mux8to1 bit1(OUT[1], S, {IN7[1], IN6[1], IN5[1], IN4[1], IN3[1], IN2[1], IN1[1], IN0[1]});
	mux8to1 bit2(OUT[2], S, {IN7[2], IN6[2], IN5[2], IN4[2], IN3[2], IN2[2], IN1[2], IN0[2]});
	mux8to1 bit3(OUT[3], S, {IN7[3], IN6[3], IN5[3], IN4[3], IN3[3], IN2[3], IN1[3], IN0[3]});
	mux8to1 bit4(OUT[4], S, {IN7[4], IN6[4], IN5[4], IN4[4], IN3[4], IN2[4], IN1[4], IN0[4]});
	mux8to1 bit5(OUT[5], S, {IN7[5], IN6[5], IN5[5], IN4[5], IN3[5], IN2[5], IN1[5], IN0[5]});
	mux8to1 bit6(OUT[6], S, {IN7[6], IN6[6], IN5[6], IN4[6], IN3[6], IN2[6], IN1[6], IN0[6]});
	mux8to1 bit7(OUT[7], S, {IN7[7], IN6[7], IN5[7], IN4[7], IN3[7], IN2[7], IN1[7], IN0[7]});
	mux8to1 bit8(OUT[8], S, {IN7[8], IN6[8], IN5[8], IN4[8], IN3[8], IN2[8], IN1[8], IN0[8]});
	mux8to1 bit9(OUT[9], S, {IN7[9], IN6[9], IN5[9], IN4[9], IN3[9], IN2[9], IN1[9], IN0[9]});
	mux8to1 bit10(OUT[10], S, {IN7[10], IN6[10], IN5[10], IN4[10], IN3[10], IN2[10], IN1[10], IN0[10]});
	mux8to1 bit11(OUT[11], S, {IN7[11], IN6[11], IN5[11], IN4[11], IN3[11], IN2[11], IN1[11], IN0[11]});
	mux8to1 bit12(OUT[12], S, {IN7[12], IN6[12], IN5[12], IN4[12], IN3[12], IN2[12], IN1[12], IN0[12]});
	mux8to1 bit13(OUT[13], S, {IN7[13], IN6[13], IN5[13], IN4[13], IN3[13], IN2[13], IN1[13], IN0[13]});
	mux8to1 bit14(OUT[14], S, {IN7[14], IN6[14], IN5[14], IN4[14], IN3[14], IN2[14], IN1[14], IN0[14]});
	mux8to1 bit15(OUT[15], S, {IN7[15], IN6[15], IN5[15], IN4[15], IN3[15], IN2[15], IN1[15], IN0[15]});
	mux8to1 bit16(OUT[16], S, {IN7[16], IN6[16], IN5[16], IN4[16], IN3[16], IN2[16], IN1[16], IN0[16]});
	mux8to1 bit17(OUT[17], S, {IN7[17], IN6[17], IN5[17], IN4[17], IN3[17], IN2[17], IN1[17], IN0[17]});
	mux8to1 bit18(OUT[18], S, {IN7[18], IN6[18], IN5[18], IN4[18], IN3[18], IN2[18], IN1[18], IN0[18]});
	mux8to1 bit19(OUT[19], S, {IN7[19], IN6[19], IN5[19], IN4[19], IN3[19], IN2[19], IN1[19], IN0[19]});
	mux8to1 bit20(OUT[20], S, {IN7[20], IN6[20], IN5[20], IN4[20], IN3[20], IN2[20], IN1[20], IN0[20]});
	mux8to1 bit21(OUT[21], S, {IN7[21], IN6[21], IN5[21], IN4[21], IN3[21], IN2[21], IN1[21], IN0[21]});
	mux8to1 bit22(OUT[22], S, {IN7[22], IN6[22], IN5[22], IN4[22], IN3[22], IN2[22], IN1[22], IN0[22]});
	mux8to1 bit23(OUT[23], S, {IN7[23], IN6[23], IN5[23], IN4[23], IN3[23], IN2[23], IN1[23], IN0[23]});
	mux8to1 bit24(OUT[24], S, {IN7[24], IN6[24], IN5[24], IN4[24], IN3[24], IN2[24], IN1[24], IN0[24]});
	mux8to1 bit25(OUT[25], S, {IN7[25], IN6[25], IN5[25], IN4[25], IN3[25], IN2[25], IN1[25], IN0[25]});
endmodule
////////////////////////////////

////// comparator library //////
module comparator8(XgtY, X, Y);
// XgtY == 1: X > Y, 8bit
	output XgtY;
	input [7:0] X, Y;
	wire [7:0] I, not_Y;
	
	not(not_Y[0], Y[0]);
	not(not_Y[1], Y[1]);
	not(not_Y[2], Y[2]);
	not(not_Y[3], Y[3]);
	not(not_Y[4], Y[4]);
	not(not_Y[5], Y[5]);
	not(not_Y[6], Y[6]);
	not(not_Y[7], Y[7]);
	
	xnor(I[0], X[0], Y[0]);
	xnor(I[1], X[1], Y[1]);
	xnor(I[2], X[2], Y[2]);
	xnor(I[3], X[3], Y[3]);
	xnor(I[4], X[4], Y[4]);
	xnor(I[5], X[5], Y[5]);
	xnor(I[6], X[6], Y[6]);
	xnor(I[7], X[7], Y[7]);
	
	assign XgtY = (X[7]&&not_Y[7]) || (I[7]&&X[6]&&not_Y[6]) || (I[7]&&I[6]&&X[5]&&not_Y[5]) || (I[7]&&I[6]&&I[5]&&X[4]&&not_Y[4]) || (I[7]&&I[6]&&I[5]&&I[4]&&X[3]&&not_Y[3]) || (I[7]&&I[6]&&I[5]&&I[4]&&I[3]&&X[2]&&not_Y[2]) || (I[7]&&I[6]&&I[5]&&I[4]&&I[3]&&I[2]&&X[1]&&not_Y[1]) || (I[7]&&I[6]&&I[5]&&I[4]&&I[3]&&I[2]&&I[1]&&X[0]&&not_Y[0]);
endmodule

module comparator24(XgtY, X, Y);
// XgtY == 1: X >= Y
	output XgtY;
	input [23:0] X, Y;
	wire XgtY0, XgtY1, XgtY2;
	wire i0 = (X[23]~^Y[23])&&(X[22]~^Y[22])&&(X[21]~^Y[21])&&(X[20]~^Y[20])&&(X[19]~^Y[19])&&(X[18]~^Y[18])&&(X[17]~^Y[17])&&(X[16]~^Y[16]),
		 i1 = (X[15]~^Y[15])&&(X[14]~^Y[14])&&(X[13]~^Y[13])&&(X[12]~^Y[12])&&(X[11]~^Y[11])&&(X[10]~^Y[10])&&(X[9]~^Y[9])&&(X[8]~^Y[8]),
		 i2 = (X[7]~^Y[7])&&(X[6]~^Y[6])&&(X[5]~^Y[5])&&(X[4]~^Y[4])&&(X[3]~^Y[3])&&(X[2]~^Y[2])&&(X[1]~^Y[1])&&(X[0]~^Y[0]);
	
	comparator8 chunk0(XgtY0, X[23:16], Y[23:16]);
	comparator8 chunk1(XgtY1, X[15:8], Y[15:8]);
	comparator8 chunk2(XgtY2, X[7:0], Y[7:0]);
	assign XgtY = XgtY0 || (i0 && XgtY1) || (i0 && i1 && XgtY2) || (i0 && i1 && i2);
endmodule

module comparator25(XgtY, X, Y);
// XgtY == 1: X >= Y
	output XgtY;
	input [24:0] X, Y;
	wire xgty, XgtY0, XgtY1, XgtY2;
	wire i0 = X[24]~^Y[24],
		 i1 = (X[23]~^Y[23])&&(X[22]~^Y[22])&&(X[21]~^Y[21])&&(X[20]~^Y[20])&&(X[19]~^Y[19])&&(X[18]~^Y[18])&&(X[17]~^Y[17])&&(X[16]~^Y[16]),
		 i2 = (X[15]~^Y[15])&&(X[14]~^Y[14])&&(X[13]~^Y[13])&&(X[12]~^Y[12])&&(X[11]~^Y[11])&&(X[10]~^Y[10])&&(X[9]~^Y[9])&&(X[8]~^Y[8]),
		 i3 = (X[7]~^Y[7])&&(X[6]~^Y[6])&&(X[5]~^Y[5])&&(X[4]~^Y[4])&&(X[3]~^Y[3])&&(X[2]~^Y[2])&&(X[1]~^Y[1])&&(X[0]~^Y[0]);
	
	assign xgty = X[24] && (~Y[24]);
	comparator8 chunk0(XgtY0, X[23:16], Y[23:16]);
	comparator8 chunk1(XgtY1, X[15:8], Y[15:8]);
	comparator8 chunk2(XgtY2, X[7:0], Y[7:0]);
	assign XgtY = xgty||(i0&&XgtY0)||(i0&&i1&&XgtY1)||(i0&&i1&&i2&&XgtY2)||(i0&&i1&&i2&&i3);
endmodule
////////////////////////////////

////// shift library ///////////
module shift_left24(sh_value, X, numbit_toshift);
// shift left 24bit
	output [23:0] sh_value;
	input [23:0] X;
	input [7:0] numbit_toshift;
	wire [23:0] w_sh_value;
	
	mux24to1_re shl0(w_sh_value[23], numbit_toshift[4:0], X[23:0]);
	mux24to1_re shl1(w_sh_value[22], numbit_toshift[4:0], {X[22:0], 1'b0});
	mux24to1_re shl2(w_sh_value[21], numbit_toshift[4:0], {X[21:0], 2'b0});
	mux24to1_re shl3(w_sh_value[20], numbit_toshift[4:0], {X[20:0], 3'b0});
	mux24to1_re shl4(w_sh_value[19], numbit_toshift[4:0], {X[19:0], 4'b0});
	mux24to1_re shl5(w_sh_value[18], numbit_toshift[4:0], {X[18:0], 5'b0});
	mux24to1_re shl6(w_sh_value[17], numbit_toshift[4:0], {X[17:0], 6'b0});
	mux24to1_re shl7(w_sh_value[16], numbit_toshift[4:0], {X[16:0], 7'b0});
	mux24to1_re shl8(w_sh_value[15], numbit_toshift[4:0], {X[15:0], 8'b0});
	mux24to1_re shl9(w_sh_value[14], numbit_toshift[4:0], {X[14:0], 9'b0});
	mux24to1_re shl10(w_sh_value[13], numbit_toshift[4:0], {X[13:0], 10'b0});
	mux24to1_re shl11(w_sh_value[12], numbit_toshift[4:0], {X[12:0], 11'b0});
	mux24to1_re shl12(w_sh_value[11], numbit_toshift[4:0], {X[11:0], 12'b0});
	mux24to1_re shl13(w_sh_value[10], numbit_toshift[4:0], {X[10:0], 13'b0});
	mux24to1_re shl14(w_sh_value[9], numbit_toshift[4:0], {X[9:0], 14'b0});
	mux24to1_re shl15(w_sh_value[8], numbit_toshift[4:0], {X[8:0], 15'b0});
	mux24to1_re shl16(w_sh_value[7], numbit_toshift[4:0], {X[7:0], 16'b0});
	mux24to1_re shl17(w_sh_value[6], numbit_toshift[4:0], {X[6:0], 17'b0});
	mux24to1_re shl18(w_sh_value[5], numbit_toshift[4:0], {X[5:0], 18'b0});
	mux24to1_re shl19(w_sh_value[4], numbit_toshift[4:0], {X[4:0], 19'b0});
	mux24to1_re shl20(w_sh_value[3], numbit_toshift[4:0], {X[3:0], 20'b0});
	mux24to1_re shl21(w_sh_value[2], numbit_toshift[4:0], {X[2:0], 21'b0});
	mux24to1_re shl22(w_sh_value[1], numbit_toshift[4:0], {X[1:0], 22'b0});
	mux24to1_re shl23(w_sh_value[0], numbit_toshift[4:0], {X[0], 23'b0});
	comparator8 shl24(switch, numbit_toshift, 8'b10111);
	mux2to1_24bit choose_Value(sh_value, switch, w_sh_value, 24'b0);
endmodule

module shift_right24(sh_value, X, numbit_toshift);
// shift right 24bit
	output [23:0] sh_value;
	input [23:0] X;
	input [7:0] numbit_toshift;
	wire [23:0] w_sh_value;
	
	mux24to1 sh0(w_sh_value[0], numbit_toshift[4:0], X);
	mux24to1 sh1(w_sh_value[1], numbit_toshift[4:0], {1'b0, X[23:1]});
	mux24to1 sh2(w_sh_value[2], numbit_toshift[4:0], {2'b0, X[23:2]});
	mux24to1 sh3(w_sh_value[3], numbit_toshift[4:0], {3'b0, X[23:3]});
	mux24to1 sh4(w_sh_value[4], numbit_toshift[4:0], {4'b0, X[23:4]});
	mux24to1 sh5(w_sh_value[5], numbit_toshift[4:0], {5'b0, X[23:5]});
	mux24to1 sh6(w_sh_value[6], numbit_toshift[4:0], {6'b0, X[23:6]});
	mux24to1 sh7(w_sh_value[7], numbit_toshift[4:0], {7'b0, X[23:7]});
	mux24to1 sh8(w_sh_value[8], numbit_toshift[4:0], {8'b0, X[23:8]});
	mux24to1 sh9(w_sh_value[9], numbit_toshift[4:0], {9'b0, X[23:9]});
	mux24to1 sh10(w_sh_value[10], numbit_toshift[4:0], {10'b0, X[23:10]});
	mux24to1 sh11(w_sh_value[11], numbit_toshift[4:0], {11'b0, X[23:11]});
	mux24to1 sh12(w_sh_value[12], numbit_toshift[4:0], {12'b0, X[23:12]});
	mux24to1 sh13(w_sh_value[13], numbit_toshift[4:0], {13'b0, X[23:13]});
	mux24to1 sh14(w_sh_value[14], numbit_toshift[4:0], {14'b0, X[23:14]});
	mux24to1 sh15(w_sh_value[15], numbit_toshift[4:0], {15'b0, X[23:15]});
	mux24to1 sh16(w_sh_value[16], numbit_toshift[4:0], {16'b0, X[23:16]});
	mux24to1 sh17(w_sh_value[17], numbit_toshift[4:0], {17'b0, X[23:17]});
	mux24to1 sh18(w_sh_value[18], numbit_toshift[4:0], {18'b0, X[23:18]});
	mux24to1 sh19(w_sh_value[19], numbit_toshift[4:0], {19'b0, X[23:19]});
	mux24to1 sh20(w_sh_value[20], numbit_toshift[4:0], {20'b0, X[23:20]});
	mux24to1 sh21(w_sh_value[21], numbit_toshift[4:0], {21'b0, X[23:21]});
	mux24to1 sh22(w_sh_value[22], numbit_toshift[4:0], {22'b0, X[23:22]});
	mux24to1 sh23(w_sh_value[23], numbit_toshift[4:0], {23'b0, X[23]});
	comparator8 compare(switch, numbit_toshift, 8'b10111);
	mux2to1_24bit choose_Value(sh_value, switch, w_sh_value, 24'b0);
endmodule
////////////////////////////////

////// encoder library /////////
module encoder4to2(OUT, IN);
	output [1:0] OUT;
	input [3:0] IN;
	
	xor(OUT[1], IN[3], IN[2]);
	assign OUT[0] = IN[3] || ((~IN[3])&&(~IN[2])&&IN[1]);
endmodule

module encoder4to2_priority(OUT, v, IN);
	// IN[3] IN[2] IN[1] IN[0]  OUT[1]  OUT[0]  v
	//   0     0     0     0      x        x    0
	//   1     x     x     x      0        0    1
	//   0     1     x     x      0        1    1
	//   0     0     1     x      1        0    1
	//   0     0     0     1      1        1    1
	output [1:0] OUT;
	output v;
	input [3:0] IN;
	
	assign OUT[1] = (IN[1] || IN[0]) && (~IN[2]) && (~IN[3]);
	assign OUT[0] = (IN[2] && (~IN[3])) || (IN[0] && (~IN[1]) && (~IN[3]));
	assign v = IN[3] || IN[2] || IN[1] || IN[0];
endmodule 

module encoder2to1_priority(OUT, IN);
	// IN[1]  IN[0]   OUT
	//   0      0      x
	//   1      x      0
	//   0      1      1
	output OUT;
	input [1:0] IN;

	assign OUT = (~IN[1]) && IN[0];
endmodule 

module encoder32to5_priority(OUT, IN);
	output [4:0] OUT;
	input [31:0] IN;
	wire [3:0] v1, v0;
	wire [1:0] out1, out0, out1_1, out1_0, out0_7, out0_6, out0_5, out0_4, out0_3, out0_2, out0_1, out0_0;
	wire MSB, temp1, temp0;
	
	encoder4to2_priority e0(out0_7, v1[3], IN[31:28]);
	encoder4to2_priority e1(out0_6, v1[2], IN[27:24]);
	encoder4to2_priority e2(out0_5, v1[1], IN[23:20]);
	encoder4to2_priority e3(out0_4, v1[0], IN[19:16]);
	encoder4to2_priority e4(out0_3, v0[3], IN[15:12]);
	encoder4to2_priority e5(out0_2, v0[2], IN[11:8]);
	encoder4to2_priority e6(out0_1, v0[1], IN[7:4]);
	encoder4to2_priority e7(out0_0, v0[0], IN[3:0]);
	
	encoder4to2_priority o1(out1_1, temp1, v1);
	encoder4to2_priority o0(out1_0, temp0, v0);
	
	encoder2to1_priority msb(MSB, {temp1, temp0});
	
	mux2to1_2bit mx1(out1, MSB, out1_1, out1_0);
	mux8to1_2bit mx0(out0, {MSB, out1}, out0_7, out0_6, out0_5, out0_4, out0_3, out0_2, out0_1, out0_0);
	
	assign OUT = {MSB, out1, out0};
endmodule


module encoder_numbit_toshift(numbit_toshift, X);
	output [4:0] numbit_toshift;
	input [23:0] X;
	wire switch;
	
	nor(switch0, X[23], X[22], X[21], X[20], X[19], X[18], X[17], X[16]);
	nor(switch1, X[15], X[14], X[13], X[12], X[11], X[10], X[9], X[8]);
	nor(switch2, X[7], X[6], X[5], X[4], X[3], X[2], X[1], X[0]);
	and(switch, switch0, switch1, switch2);
	encoder32to5_priority encode(numbit_toshift, {X, switch, 7'b0});
endmodule


/*
module encoder_numbit_toshift(numbit_toshift, X);
	output reg [4:0] numbit_toshift;
	input [23:0] X;
	
	always @(X)
	if (X[23] == 1'b1) numbit_toshift = 5'b00000;
	else if (X[23:22] == 2'b1) numbit_toshift = 5'b00001;
	else if (X[23:21] == 3'b1) numbit_toshift = 5'b00010;
	else if (X[23:20] == 4'b1) numbit_toshift = 5'b00011;
	else if (X[23:19] == 5'b1) numbit_toshift = 5'b00100;
	else if (X[23:18] == 6'b1) numbit_toshift = 5'b00101;
	else if (X[23:17] == 7'b1) numbit_toshift = 5'b00110;
	else if (X[23:16] == 8'b1) numbit_toshift = 5'b00111;
	else if (X[23:15] == 9'b1) numbit_toshift = 5'b01000;
	else if (X[23:14] == 10'b1) numbit_toshift = 5'b01001;
	else if (X[23:13] == 11'b1) numbit_toshift = 5'b01010;
	else if (X[23:12] == 12'b1) numbit_toshift = 5'b01011;
	else if (X[23:11] == 13'b1) numbit_toshift = 5'b01100;
	else if (X[23:10] == 14'b1) numbit_toshift = 5'b01101;
	else if (X[23:9] == 15'b1) numbit_toshift = 5'b01110;
	else if (X[23:8] == 16'b1) numbit_toshift = 5'b01111;
	else if (X[23:7] == 17'b1) numbit_toshift = 5'b10000;
	else if (X[23:6] == 18'b1) numbit_toshift = 5'b10001;
	else if (X[23:5] == 19'b1) numbit_toshift = 5'b10010;
	else if (X[23:4] == 20'b1) numbit_toshift = 5'b10011;
	else if (X[23:3] == 21'b1) numbit_toshift = 5'b10100;
	else if (X[23:2] == 22'b1) numbit_toshift = 5'b10101;
	else if (X[23:1] == 23'b1) numbit_toshift = 5'b10110;
	else if (X == 24'b1) numbit_toshift = 5'b10111;
	else if (X == 24'b0) numbit_toshift = 5'b11000;
	
	always @(X)
	case (X)
		24'b1xxxxxxxxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00000;
		24'b01xxxxxxxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00001;
		24'b001xxxxxxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00010;
		24'b0001xxxxxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00011;
		24'b00001xxxxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00100;
		24'b000001xxxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00101;
		24'b0000001xxxxxxxxxxxxxxxxx: numbit_toshift = 5'b00110;
		24'b00000001xxxxxxxxxxxxxxxx: numbit_toshift = 5'b00111;
		24'b000000001xxxxxxxxxxxxxxx: numbit_toshift = 5'b01000;
		24'b0000000001xxxxxxxxxxxxxx: numbit_toshift = 5'b01001;
		24'b00000000001xxxxxxxxxxxxx: numbit_toshift = 5'b01010;
		24'b000000000001xxxxxxxxxxxx: numbit_toshift = 5'b01011;
		24'b0000000000001xxxxxxxxxxx: numbit_toshift = 5'b01100;
		24'b00000000000001xxxxxxxxxx: numbit_toshift = 5'b01101;
		24'b000000000000001xxxxxxxxx: numbit_toshift = 5'b01110;
		24'b0000000000000001xxxxxxxx: numbit_toshift = 5'b01111;
		24'b00000000000000001xxxxxxx: numbit_toshift = 5'b10000;
		24'b000000000000000001xxxxxx: numbit_toshift = 5'b10001;
		24'b0000000000000000001xxxxx: numbit_toshift = 5'b10010;
		24'b00000000000000000001xxxx: numbit_toshift = 5'b10011;
		24'b000000000000000000001xxx: numbit_toshift = 5'b10100;
		24'b0000000000000000000001xx: numbit_toshift = 5'b10101;
		24'b00000000000000000000001x: numbit_toshift = 5'b10110;
		24'b000000000000000000000001: numbit_toshift = 5'b10111;
		24'b000000000000000000000000: numbit_toshift = 5'b11000;
	endcase
endmodule
*/
////////////////////////////////