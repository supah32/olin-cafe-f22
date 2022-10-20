`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module adder_1(in0, in1, c_in, sum, c_out);

input wire c_in;

input wire in0, in1;

output logic sum, c_out;

logic XOR_0_out, XNOR_0_out, AND_0_out, AND_1_out;

always_comb XOR_0_out = in0 ^ in1;
always_comb XNOR_0_out = ~(in0 ^ in1);

always_comb AND_0_out = XOR_0_out & ~c_in;
always_comb AND_1_out = XNOR_0_out & c_in;

always_comb sum = AND_0_out + AND_1_out;

logic XOR_1_out, AND_2_out, AND_3_out;

always_comb XOR_1_out = in0 ^ in1; // same as XOR_0_out

always_comb AND_2_out = in0 & in1;
always_comb AND_3_out = XOR_1_out & c_in; // same as AND_1_out
always_comb c_out = AND_2_out + AND_3_out;

endmodule

// module adder_2(in0, in1, in2, in3, c_in0, c_in1, sum, c_out);

// parameter N = 32;

// input wire [N-1 : 0] in0, in1, in2, in3, c_in0, c_in1;

// wire [N - 1 : 0] sum_0, sum_1, c_out_inter_0, c_out_inter_1;

// output logic [N-1 :0] sum, c_out;

// adder_1 #(.N(N)) adder_1(
//   .in0(in0), .in1(in1), .c_in(c_in0), .sum(sum_0), .c_out(c_out_inter)

// );
// endmodule