`timescale 1ns/1ps
module decoder_2_to_4(ena, in, out);

input wire ena;
input wire [1:0] in;
output logic [3:0] out;

wire ena0, ena1;
// wire [1:0] decoder_enables;

decoder_1_to_2 DEC0(
  .enable(ena0),
  .a(in[0]),
  .c_0(out[1]),
  .c_1(out[0])
);

decoder_1_to_2 DEC1(
  .enable(ena1),
  .a(in[0]),
  .c_0(out[3]),
  .c_1(out[2])
);

decoder_1_to_2 DEC_ENA(
  .enable(ena),
  .a(in[1]),
  .c_0(ena1),
  .c_1(ena0)
);

endmodule