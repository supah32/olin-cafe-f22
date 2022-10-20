`timescale 1ns/1ps
`default_nettype none

// You may find it useful to have a way to build an n-bit adder, 
// or you can manually create them. 

// This module shows how to use a generate statement to connect
// n 1-bit adders with carries to make a ripple carry adder.
module adder_n(a, b, c_in, sum, c_out);

parameter N = 2;

input  wire [N-1:0] a, b;
input wire c_in;
output logic [N-1:0] sum;
output wire c_out;

wire [N:0] carries;
assign carries[0] = c_in;
assign c_out = carries[N];
generate
  genvar i;
  for(i = 0; i < N; i++) begin : ripple_carry
    adder_1 ADDER (
      .in0(a[i]),
      .in1(b[i]),
      .c_in(carries[i]),
      .sum(sum[i]),
      .c_out(carries[i+1])
    );
  end
endgenerate

endmodule
// to instantiate
// adder_n #(.N(32)) adder_32bit_a ( port list );
