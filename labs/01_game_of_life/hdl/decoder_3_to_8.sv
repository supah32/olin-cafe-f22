`timescale 1ns/1ps
`default_nettype none

module decoder_3_to_8(enable, in, out);

  input wire enable;
  input wire [2:0] in;
  logic decoder_0_c0, decoder_0_c1, decoder_1_c0, decoder_1_c1, 
  decoder_2_c0, decoder_2_c1;

  output logic [7:0] out;

  decoder_1_to_2 decoder_0(
    .enable(enable), .a(in[2]), .c_0(decoder_0_c0), .c_1(decoder_0_c1)
  );

  decoder_1_to_2 decoder_1(
    .enable(enable), .a(in[1]), .c_0(decoder_1_c0), .c_1(decoder_1_c1)
  );

  decoder_1_to_2 decoder_2(
    .enable(enable), .a(in[0]), .c_0(decoder_2_c0), .c_1(decoder_2_c1)
  );

  always_comb begin
    out[0] = decoder_0_c1 & decoder_1_c1 & decoder_2_c1;
    out[1] = decoder_0_c1 & decoder_1_c1 & decoder_2_c0;
    out[2] = decoder_0_c1 & decoder_1_c0 & decoder_2_c1;
    out[3] = decoder_0_c1 & decoder_1_c0 & decoder_2_c0;
    out[4] = decoder_0_c0 & decoder_1_c1 & decoder_2_c1;
    out[5] = decoder_0_c0 & decoder_1_c1 & decoder_2_c0;
    out[6] = decoder_0_c0 & decoder_1_c0 & decoder_2_c1;
    out[7] = decoder_0_c0 & decoder_1_c0 & decoder_2_c0;
  end

endmodule