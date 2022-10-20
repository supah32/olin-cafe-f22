`timescale 1ns/1ps
`default_nettype none

module decoder_1_to_2(enable, a, c_0, c_1);

input wire enable;
input wire a;
output logic c_0, c_1;

always_comb begin
  c_0 = a & enable;
  c_1 = ~a & enable;
end

endmodule