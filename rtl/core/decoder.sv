module decoder (
  // decoder for RISC-V instructions
  input  logic [31:0] inst,
//  input  logic        mem_to_reg, // Load Memory Data to Register File
  // レジスタ
  output logic [4:0] rs1, rs2, rd,
  // 即値
  output logic [31:0] imm,
  // 制御信号
  output logic [2:0] alu_op,
  output logic       reg_we,
  output logic       mem_we,
  output logic       mem_re,
  output logic       use_imm,
  output logic       mem_to_reg,
  output logic [2:0] branch_op
);
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

// Opcode definitions
localparam OPC_RTYPE = 7'b0110011;
localparam OPC_ITYPE = 7'b0010011;
localparam OPC_LOAD  = 7'b0000011;
localparam OPC_STORE = 7'b0100011;
localparam OPC_BRANCH = 7'b1100011;

// ALU operations
localparam ALU_ADD = 3'd0;
localparam ALU_SUB = 3'd1;
localparam ALU_AND = 3'd2;
localparam ALU_OR  = 3'd3;
localparam ALU_INV = 3'd7;

// Branch operations
localparam BR_NONE = 3'd0;
localparam BR_BEQ  = 3'd1;
localparam BR_BNE  = 3'd2;
localparam BR_BLT  = 3'd3;
localparam BR_BGE  = 3'd4;
localparam BR_BLTU = 3'd5;
localparam BR_BGEU = 3'd6;

assign opcode = inst[6:0];
assign rd     = inst[11:7];
assign funct3 = inst[14:12];
assign rs1    = inst[19:15];
assign rs2    = inst[24:20];

assign funct7 = inst[31:25];

always_comb begin
  imm = 32'd0;

  unique case (opcode)
    // I-type (ADDI/LW)
    OPC_ITYPE, OPC_LOAD:
      imm = {{20{inst[31]}}, inst[31:20]};
    // S-type (SW)
    OPC_STORE:
      imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    // B-type (BEQ)
    OPC_BRANCH:
      imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    default:
      imm = 32'd0;
  endcase
end

always_comb begin
  // デフォルト（重要）
  alu_op  = ALU_ADD;
  reg_we  = 0;
  mem_we  = 0;
  mem_re  = 0;
  use_imm = 0;
  mem_to_reg = 0;
  branch_op = BR_NONE;

  unique case (opcode)

    // -----------------
    // R-type
    // -----------------
    OPC_RTYPE: begin
      reg_we = 1;
      use_imm = 0;

      case ({funct7, funct3})
        {7'b0000000, 3'b000}: alu_op = ALU_ADD; // ADD
        {7'b0100000, 3'b000}: alu_op = ALU_SUB; // SUB
        {7'b0000000, 3'b111}: alu_op = ALU_AND; // AND
        {7'b0000000, 3'b110}: alu_op = ALU_OR; // OR
        default : alu_op = ALU_INV; // invalid
      endcase
    end

    // -----------------
    // I-type (ADDI)
    // -----------------
    OPC_ITYPE: begin
      if (funct3 == 3'b000) begin
        reg_we  = 1;
        use_imm = 1;
        alu_op  = ALU_ADD;
      end
      else begin
        alu_op = ALU_INV;
      end
    end

    // -----------------
    // LOAD
    // -----------------
    OPC_LOAD: begin
      if (funct3 == 3'b010) begin // LW
        reg_we     = 1;
        mem_re     = 1;
        use_imm    = 1;
        alu_op     = ALU_ADD; // address calc
        mem_to_reg = 1;
      end
    end

    // -----------------
    // STORE
    // -----------------
    OPC_STORE: begin
      if (funct3 == 3'b010) begin // SW
        mem_we  = 1;
        use_imm = 1;
        alu_op  = ALU_ADD;
      end
    end

    // -----------------
    // BRANCH
    // -----------------
    OPC_BRANCH: begin
      unique case (funct3)
        3'b000: branch_op = BR_BEQ;   // BEQ
        3'b001: branch_op = BR_BNE;   // BNE
        3'b100: branch_op = BR_BLT;   // BLT
        3'b101: branch_op = BR_BGE;   // BGE
        3'b110: branch_op = BR_BLTU;  // BLTU
        3'b111: branch_op = BR_BGEU;  // BGEU
        default: branch_op = BR_NONE;
      endcase
    end

    default : begin
      // 何もしない
    end
  endcase
end
endmodule
