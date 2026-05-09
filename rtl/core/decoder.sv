module decoder (
  input  logic [31:0] inst,
  input  logic        mem_to_reg, // Load Memory Data to Register File
  // レジスタ
  output logic [4:0] rs1, rs2, rd,
  // 即値
  output logic [31:0] imm,
  // 制御信号
  output logic [2:0] alu_op,
  output logic       reg_we,
  output logic       mem_we,
  output logic       mem_re,
  output logic       use_imm
);
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

assign opcode = inst[6:0];
assign rd     = inst[11:7];
assign funct3 = inst[14:12];
assign rs1    = inst[19:15];
assign rs2    = inst[24:20];
assign funct7 = inst[31:25];

assign imm = {{20{inst[31]}}, inst[31:20]}; // 符号拡張 I-typeの即値

always_comb begin
  // デフォルト（重要）
  alu_op  = 3'd0;
  reg_we  = 0;
  mem_we  = 0;
  mem_re  = 0;
  use_imm = 0;

  case (opcode)

    // -----------------
    // R-type
    // -----------------
    7'b0110011: begin
      reg_we = 1;
      use_imm = 0;

      case ({funct7, funct3})
        {7'b0000000, 3'b000}: alu_op = 3'd0; // ADD
        {7'b0100000, 3'b000}: alu_op = 3'd1; // SUB
        {7'b0000000, 3'b111}: alu_op = 3'd2; // AND
        {7'b0000000, 3'b110}: alu_op = 3'd3; // OR
        default : alu_op = 3'd4;
      endcase
    end

    // -----------------
    // I-type (ADDI)
    // -----------------
    7'b0010011: begin
      reg_we  = 1;
      use_imm = 1;
      alu_op  = (funct3 == 3'b000) ? 3'd0 : 3'd4; // ADDI or default
//      case (funct3)
//        3'b000: alu_op = 3'd0; // ADDI
//      endcase
    end

    // -----------------
    // LOAD
    // -----------------
    7'b0000011: begin
      reg_we  = 1;
      mem_re  = 1;
      use_imm = 1;
      alu_op  = 3'd0; // address calc
    end

    // -----------------
    // STORE
    // -----------------
    7'b0100011: begin
      mem_we  = 1;
      use_imm = 1;
      alu_op  = 3'd0;
    end

    default : begin
      // 何もしない
    end
  endcase
end
endmodule
