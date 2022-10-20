`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoder_3_8;
  logic enable;
  logic [2:0] in;

  wire [7:0] out;

  decoder_3_to_8 UUT(enable, in, out);

  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("decoders.fst");
    $dumpvars(0, UUT);
    enable = 1;
    $display("ena | in  | out");
    for (int i = 0; i < 8; i = i + 1) begin
      in = i[2:0];
      #1 $display(" %1b  | %3b | %8b", enable, in, out);
    end

    enable = 0;
    $display("ena | in  | out");
    for (int i = 0; i < 8; i = i + 1) begin
      in = i[2:0];
      #1 $display(" %1b  | %3b | %8b", enable, in, out);
    end
        
    $finish;      
	end

endmodule
