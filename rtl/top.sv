/*
module top;
  logic clk = 0;
  always #5 clk = ~clk;

  logic [31:0] a=5, b=10, y;
  logic [2:0] op = 0; // ADD

  alu u_alu(.a(a), .b(b), .op(op), .y(y));

  initial begin
    #20;
    if (y != 15) begin
      $display("FAIL");
      $finish(1);
    end
    $display("PASS");
    $finish(0);
  end
*/

`timescale 1ps/1ps

module cpu_top;

  // -----------------
  // クロック
  // -----------------
  logic clk = 0;
  //always #5 clk = ~clk;

  // -----------------
  // 命令（固定：ADDI r1, r0, 5）
  // -----------------
  logic [31:0] instr;

  initial begin
    // opcode=0010011, funct3=000, rs1=0, rd=1, imm=5
    instr = 32'b000000000101_00000_000_00001_0010011;
  end

  // -----------------
  // decoder出力
  // -----------------
  logic [4:0] rs1, rs2, rd;
  logic [31:0] imm;
  logic [2:0] alu_op;
  logic reg_we, mem_we, mem_re, use_imm;
  logic [31:0] pc;
  logic [31:0] inst;
  logic rst;

  decoder u_decoder (
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .imm(imm),
    .alu_op(alu_op),
    .reg_we(reg_we),
    .mem_we(mem_we),
    .mem_re(mem_re),
    .use_imm(use_imm)
  );

  // -----------------
  // regfile
  // -----------------
  logic [31:0] rs1_data, rs2_data;
  logic [31:0] wb_data;

  regfile u_regfile (
    .clk(clk),
    .we(reg_we),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wd(wb_data),
    .rd1(rs1_data),
    .rd2(rs2_data)
  );

  // -----------------
  // ALU入力選択
  // -----------------
  logic [31:0] alu_b;

  assign alu_b = (use_imm) ? imm : rs2_data;

  // -----------------
  // ALU
  // -----------------
  logic [31:0] alu_y;

  alu u_alu (
    .a(rs1_data),
    .b(alu_b),
    .op(alu_op),
    .y(alu_y)
  );

  // -----------------
  // write back
  // -----------------
  assign wb_data = alu_y;

pc u_pc (
  .clk(clk),
  .rst(rst),
  .pc(pc)
);

inst_mem u_imem (
  .addr(pc),
  .inst(inst)
);
  // -----------------
  // テスト
  // -----------------
 /*
  initial begin
    #20;

    @(posedge clk);
    #1; // クロックエッジから少し遅らせる 
    if (u_regfile.regs[1] != 5) begin
      $display("FAIL: r1 = %0d", u_regfile.regs[1]);
      $finish(1);
    end
    else begin
      $display("PASS: r1 = %0d", u_regfile.regs[1]);
      $finish(0);
    end
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, top);
  end
  */
endmodule