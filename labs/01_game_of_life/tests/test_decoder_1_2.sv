`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  // logic ena;
  // logic [2:0] in;
  // wire [7:0] out;

  parameter N = 32;

  input wire [N-1 : 0] enable;
  input wire [N-1:0] in0, in1, in2;
  logic [N-1:0] decoder_0_c0, decoder_0_c1, decoder_1_c0, decoder_1_c1, 
  decoder_2_c0, decoder_2_c1;
  output logic [N - 1: 0] out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7;

  decoder_3_to_8 #(.N(N)) UUT(
    .enable(enable), .in0(in0), .in1(in1), .in2(in2), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3), .out_4(out_4), .out_5(out_5), .out_6(out_6), .out_7(out_7)
    );

  initial begin
    // Collect waveforms
    $dumpfile("decoders.fst");
    $dumpvars(0, UUT);
    
    ena = 1;
    $display("ena in | out");
    for (int i = 0; i < 8; i = i + 1) begin
      in = i[2:0];
      #1 $display("%1b %2b | %4b", ena, in, out);
    end

    ena = 0;
    for (int i = 0; i < 8; i = i + 1) begin
      in = i[2:0];
      #1 $display("%1b %2b | %4b", ena, in, out);
    end
        
    $finish;      
	end

endmodule
