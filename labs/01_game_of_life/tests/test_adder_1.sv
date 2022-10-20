`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_1;

  logic c_in;
  logic [1 : 0] in;
  wire sum, c_out;

  adder_1 UUT(in, c_in, sum, c_out);

  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("decoders.fst");
    $dumpvars(0, UUT);
    c_in = 0;
    $display("c_in | in | sum | c_out");
    for (int i = 0; i < 4; i = i + 1) begin
      in = i[1:0];
      #1 $display(" %1b | %2b | %1b | %1b", c_in, in, sum, c_out);
    end

    c_in = 1;
    $display("c_in | in | sum | c_out");
    for (int i = 0; i < 4; i = i + 1) begin
      in = i[1:0];
      #1 $display(" %1b | %2b | %1b | %1b", c_in, in, sum, c_out);
    end
        
    $finish;      
	end

endmodule
