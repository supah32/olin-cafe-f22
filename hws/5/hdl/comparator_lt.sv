module comparator_lt(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

// Using only *structural* combinational logic, make a module that computes if a is less than b!
// Note: this assumes that the two inputs are signed: aka should be interpreted as two's complement.

// Copy any other modules you use into the HDL folder and update the Makefile accordingly.
adder_n #(.N(N)) subtractor(
  .a(a),
  .b(~b),
  .c_in(1),
  .sum(),
  .c_out()
);

endmodule


