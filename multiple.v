module number_detect(zero, inf, NaN, normal, E, F);
	output zero, inf, NaN, normal;
	input [7:0] E;
	input [22:0] F;
	wire E_zero, E_max, F_zero, F_nonzero;
	
	nor(E_zero, E[7], E[6], E[5], E[4], E[3], E[2], E[1], E[0]);
	and(E_max, E[7], E[6], E[5], E[4], E[3], E[2], E[1], E[0]);
	nor(F_zero, F[0], F[1], F[2], F[3], F[4], F[5], F[6], F[7], F[8], F[9], F[10], F[11], F[12], F[13], F[14], F[15], F[16], F[17], F[18], F[19], F[20], F[21], F[22]);
	or(F_nonzero, F[0], F[1], F[2], F[3], F[4], F[5], F[6], F[7], F[8], F[9], F[10], F[11], F[12], F[13], F[14], F[15], F[16], F[17], F[18], F[19], F[20], F[21], F[22]);
	and(zero, E_zero, F_zero);
	and(inf, E_max, F_zero);
	and(NaN, E_max, F_nonzero);
	nor(normal, zero, inf, NaN);
endmodule

module and_1bit_vs_25bit(OUT, num25, flag);
	output [24:0] OUT;
	input [24:0] num25;
	input flag;
	
	and(OUT[0], num25[0], flag);
	and(OUT[1], num25[1], flag);
	and(OUT[2], num25[2], flag);
	and(OUT[3], num25[3], flag);
	and(OUT[4], num25[4], flag);
	and(OUT[5], num25[5], flag);
	and(OUT[6], num25[6], flag);
	and(OUT[7], num25[7], flag);
	and(OUT[8], num25[8], flag);
	and(OUT[9], num25[9], flag);
	and(OUT[10], num25[10], flag);
	and(OUT[11], num25[11], flag);
	and(OUT[12], num25[12], flag);
	and(OUT[13], num25[13], flag);
	and(OUT[14], num25[14], flag);
	and(OUT[15], num25[15], flag);
	and(OUT[16], num25[16], flag);
	and(OUT[17], num25[17], flag);
	and(OUT[18], num25[18], flag);
	and(OUT[19], num25[19], flag);
	and(OUT[20], num25[20], flag);
	and(OUT[21], num25[21], flag);
	and(OUT[22], num25[22], flag);
	and(OUT[23], num25[23], flag);
	and(OUT[24], num25[24], flag);
endmodule

module Exponent_compute(E, E1, E2);
	output [7:0] E;
	input [7:0] E1, E2;
	wire [8:0] temp;
	wire [7:0] w_E;

	Fast_Adder8 e1puse2(temp[7:0], temp[8], E1, E2, 1'b0);
	Adder9 e1e2diff127_1({sw1, w_E}, cout, temp, 9'b110000000, 1'b1);
	HalfAdder e1e2diff127_2(sw2, c, 1'b1, cout);
	mux4to1_8bit select(E, {sw2, sw1}, w_E, 8'b11111111, 8'b0, 8'b0);
endmodule 

module Fraction_component(F1_nplus1, F1_n, F2, index_out, index_in);
	output [52:0] F1_nplus1;
	output [2:0] index_out;
	input [52:0] F1_n;
	input [26:0] F2;
	input [2:0] index_in;
	wire [52:0] shiftright_value1, shiftright_value2;
	wire [26:0] wire_mc, not_F2, not_2F2, neg_F2, neg_2F2;
	
	assign not_F2 = ~F2;
	assign not_2F2 = ~({F2[25:0], 1'b0});
	Increase27 inc0(neg_F2, c0, not_F2, 1'b1);
	Increase27 inc1(neg_2F2, c1, not_2F2, 1'b1);
	
	assign shiftright_value1 = {F1_n[52], F1_n[52:1]};
	Adder53 add(shiftright_value2, cout, shiftright_value1, {wire_mc, 26'b0}, 1'b0);
	
	mux8to1_26bit chooseValue(wire_mc[25:0], index_in, 26'b0, F2[25:0], F2[25:0], {F2[24:0], 1'b0}, neg_2F2[25:0], neg_F2[25:0], neg_F2[25:0], 26'b0);
	mux8to1 choosebit0(wire_mc[26], index_in, {1'b0, neg_F2[26], neg_F2[26], neg_2F2[26], F2[25], F2[26], F2[26], 1'b0});
	
	assign index_out = F1_nplus1[2:0];
	assign F1_nplus1 = {shiftright_value2[52], shiftright_value2[52:1]};
endmodule

module Fraction_compute(F, cout, F1, F2);
	output [22:0] F;
	output cout;
	input [22:0] F1, F2;
	wire [52:0] cycle1, cycle2, cycle3, cycle4, cycle5, cycle6, cycle7, cycle8, cycle9, cycle10, cycle11, cycle12, cycle13, cycle14;
	wire [26:0] mc;
	wire [23:0] temp;
	wire [2:0] index1, index2, index3, index4, index5, index6, index7, index8, index9, index10, index11, index12, index13;
	
	assign cycle1 = {29'b1, F1, 1'b0};
	assign mc = {4'b1, F2};
	
	Fraction_component phase1(cycle2, cycle1, mc, index1,cycle1[2:0]);
	Fraction_component phase2(cycle3, cycle2, mc, index2, index1);
	Fraction_component phase3(cycle4, cycle3, mc, index3, index2);
	Fraction_component phase4(cycle5, cycle4, mc, index4, index3);
	Fraction_component phase5(cycle6, cycle5, mc, index5, index4);
	Fraction_component phase6(cycle7, cycle6, mc, index6, index5);
	Fraction_component phase7(cycle8, cycle7, mc, index7, index6);
	Fraction_component phase8(cycle9, cycle8, mc, index8, index7);
	Fraction_component phase9(cycle10, cycle9, mc, index9, index8);
	Fraction_component phase10(cycle11, cycle10, mc, index10, index9);
	Fraction_component phase11(cycle12, cycle11, mc, index11, index10);
	Fraction_component phase12(cycle13, cycle12, mc, index12, index11);
	Fraction_component phase13(cycle14, cycle13, mc, index13, index12);
	mux2to1_24bit mx24(temp, cycle14[48], cycle14[47:24], cycle14[48:25]);
	assign F = temp[22:0];
	assign cout = cycle14[48];
endmodule 