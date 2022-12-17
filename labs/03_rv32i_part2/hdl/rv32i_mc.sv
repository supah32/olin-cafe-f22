`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "rv32i_defines.sv"

module rv32i_multicycle_core(
  clk, rst, ena,
  mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
  PC, instructions_completed
);

parameter PC_START_ADDRESS=0;

// Standard control signals.
input  wire clk, rst, ena; // <- worry about implementing the ena signal last.

// Memory interface.
output logic [31:0] mem_addr, mem_wr_data;
input   wire [31:0] mem_rd_data;
output logic mem_wr_ena;
output logic instructions_completed;

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic PC_ena;
logic [31:0] PC_next;

// Instruction Register
logic [31:0] IR; // instruction
logic IR_write; // IR's only control signal

// Decoded Instruction
logic [6:0] op;
logic [4:0] rd, rs1, rs2;
logic [2:0] funct3;
logic [6:0] funct7;
logic [11:0] imm12;
logic [19:0] imm20;

// Decode "logic"
always_comb begin: DECODER
  op = IR[6:0];
  rd = IR[11:7];
  rs1 = IR[19:15];
  rs2 = IR[24:20];
  funct3 = IR[14:12];
  funct7 = IR[31:25];
  imm12 = IR[31:20];
  // TODO: Undo these comments
  // case(op)
  //   OP_ITYPE : imm12 = IR[31:20];
  //   OP_STYPE : imm12 = {IR[31:25],IR[11:7]};
  //   // OP_BTYPE : imm12 = {IR[31], IR[7], IR[30:25], IR[11:8]}
  //   default : imm12 = 0;
  // endcase
end

// Sign extension CL
logic [31:0] sign_extended_immediate;
always_comb begin: SIGN_EXTENDER
  // for i-types
  sign_extended_immediate = { {20{imm12[11]}} , imm12 };
  // TODO: Undo these comments
  // case(state)

  // S_EXEC_I: begin
  //   sign_extended_immediate = { {20{imm12[11]}} , imm12 };
  // end

  // default: begin
  //   sign_extended_immediate = 0;
  // end
  // endcase
end

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC), .q(PC_old)
);


register #(.N(32)) INSTRUCTION_REGISTER(
  .clk(clk), .rst(rst), .ena(IR_write), .d(mem_rd_data), .q(IR)
);

//  an example of how to make named inputs for a mux:
/*
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    always_comb begin : memory_read_address_mux
      case(mem_src)
        MEM_SRC_RESULT : mem_rd_addr = alu_result;
        MEM_SRC_PC : mem_rd_addr = PC;
        default: mem_rd_addr = 0;
    end
*/

// Register file
logic reg_write;
// logic [4:0] rd, rs1, rs2;
logic [31:0] rfile_wr_data;
wire [31:0] reg_data1, reg_data2;
logic [31:0] regA, regB; // Readings from rs1 and rs2.
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(reg_data1), .rd_data1(reg_data2)
);


// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] src_a, src_b;
alu_control_t alu_control;
wire [31:0] alu_result;
logic [31:0] last_result; // ALUOut in the textbook.
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(src_a), .b(src_b), .result(alu_result),
  .control(alu_control),
  .overflow(overflow), .zero(zero), .equal(equal)
);

// Implement your multicycle rv32i CPU here!

enum logic [3:0] {
  S_FETCH = 0, S_DECODE = 1, S_EXEC_I = 2, S_WRITEBACK = 3, S_ERROR = 4'd15
} state;

// sequential logic
always_ff @( posedge clk ) begin : main_fsm
  if(rst) begin
    state <= S_FETCH;
    regA <= 0;
    regB <= 0;
    last_result <= 0;
    instructions_completed <= 0;
  end else begin
    case(state)
      S_FETCH: state <= S_DECODE;
      S_DECODE: begin
        // Find out the next state based on the 6 op bits.
        case(op)
          OP_ITYPE : state <= S_EXEC_I;
          default : state <= S_ERROR;
        endcase

        // Read from the reg file.
        regA <= reg_data1;
        regB <= reg_data2;
      end
      S_EXEC_I: begin
        state <= S_WRITEBACK;
        last_result <= alu_result;
      end
      S_WRITEBACK: begin
        state <= S_FETCH;
        instructions_completed <= instructions_completed + 1; // TODO JUST FOR DEBUG

      end
      default: state <= S_ERROR; // to catch unimplemented behavious
    endcase
  end
end

always_comb begin : control_unit_cl
  case(state) // create a mux for each control signal.
    S_FETCH: begin
      // only the CL for S_FETCH goes here.
      // Program Counter Control
      PC_next = alu_result;
      PC_ena = 1'b1;
      // ALU Control
      src_a = PC;
      src_b = 32'd4;
      alu_control = ALU_ADD;
      // IR Control
      IR_write = 1'b1;
      // Memory Control
      mem_addr = PC;
      mem_wr_ena = 1'b0;
      // Register File Control
      reg_write = 1'b0;
    end
    S_DECODE: begin
      // Program Counter Control
      PC_next = alu_result;
      PC_ena = 1'b0;
      // ALU Control
      src_a = 0;
      src_b = 0;
      alu_control = ALU_ADD;
      // IR Control
      IR_write = 1'b0;
      // Memory Control
      mem_addr = 0;
      mem_wr_ena = 1'b0;
      // Register File Control
      reg_write = 1'b0;
    end

    S_EXEC_I: begin
      // Program Counter Control
      PC_next = alu_result;
      PC_ena = 1'b0;
      // ALU Control
      src_a = regA;
      src_b = sign_extended_immediate;
      alu_control = ALU_ADD; // TODO: do different things based on funct3.
      // IR Control
      IR_write = 1'b0;
      // Memory Control
      mem_addr = 0;
      mem_wr_ena = 1'b0;
      // Register File Control
      reg_write = 1'b0;
    end
    S_WRITEBACK: begin
      // Program Counter Control
      PC_next = alu_result;
      PC_ena = 1'b0;
      // ALU Control
      src_a = regA;
      src_b = sign_extended_immediate;
      alu_control = ALU_ADD;
      // IR Control
      IR_write = 1'b0;
      // Memory Control
      mem_addr = 0;
      mem_wr_ena = 1'b0;
      // Register File Control
      reg_write = 1'b1;
      rfile_wr_data = last_result;
    end
    default: begin
      // set all control signals to have minimum impact
      PC_next = 0;
      PC_ena = 1'b0;
      src_a = 0;
      src_b = 0;
      alu_control = ALU_ADD;
      IR_write = 1'b0;
    end
  endcase
end

endmodule
