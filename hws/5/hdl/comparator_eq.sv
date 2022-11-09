module comparator_eq_1(a, b, eq);
input wire a, b, prev;
output logic eq;

// Using only *structural* combinational logic, make a module that computes if a == b. 

// Copy any other modules you use into the HDL folder and update the Makefile accordingly.
always_comb begin
  // behavioural: high level
  out = (a == b);

  
end

endmodule


