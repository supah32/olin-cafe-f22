`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
    input wire clk;
    input wire rst;
    input wire ena;

    input wire state_0;
    output logic state_d; // NOTE - this is only an output of the module for debugging purposes. 
    output logic state_q;

    input wire [7:0] neighbors;

    logic [1:0] sum0, sum1, sum2, sum3;
    logic [2:0] sum4, sum5;
    logic [3:0] sum6;

    // 8 bit adder
    adder_1 adder_1_0(.in0(neighbors[0]), .in1(neighbors[1]), .c_in(1'b0),.sum(sum0[0]), .c_out(sum0[1]));
    adder_1 adder_1_1(.in0(neighbors[3]), .in1(neighbors[2]), .c_in(1'b0),.sum(sum1[0]), .c_out(sum1[1]));
    adder_1 adder_1_2(.in0(neighbors[5]), .in1(neighbors[4]), .c_in(1'b0),.sum(sum2[0]), .c_out(sum2[1]));
    adder_1 adder_1_3(.in0(neighbors[7]), .in1(neighbors[6]), .c_in(1'b0),.sum(sum3[0]), .c_out(sum3[1]));

    adder_n #(.N(2)) adder_2_0(.a(sum0), .b(sum1), .c_in(1'b0), .sum(sum4[1:0]), .c_out(sum4[2]));
    adder_n #(.N(2)) adder_2_1(.a(sum2), .b(sum3), .c_in(1'b0), .sum(sum5[1:0]), .c_out(sum5[2]));

    adder_n #(.N(3)) adder_4(.a(sum4), .b(sum5), .c_in(1'b0), .sum(sum6[2:0]), .c_out(sum6[3]));

    // Determine next state
    always_comb state_d = (&(~sum6[3] & ~sum6[2] & sum6[1] & ~sum6[0])&state_q) + &(~sum6[3] & ~sum6[2] & sum6[1] & sum6[0]);

    always_ff @(posedge clk) begin
        state_q = rst ? state_0: (ena ? state_d: state_q);
    end


endmodule