module pc (
  input  logic clk,
  input  logic rst,
  input  logic [2:0]  branch_op,
  input  logic        zero,
  input  logic        lt,
  input  logic        ltu,
  input  logic [31:0] branch_offset,
  output logic [31:0] pc
);

localparam BR_NONE = 3'd0;
localparam BR_BEQ  = 3'd1;
localparam BR_BNE  = 3'd2;
localparam BR_BLT  = 3'd3;
localparam BR_BGE  = 3'd4;
localparam BR_BLTU = 3'd5;
localparam BR_BGEU = 3'd6;

logic [31:0] pc_next;

always_comb begin
  pc_next = pc + 32'd4;

  unique case (branch_op)
    BR_BEQ:  if (zero)  pc_next = pc + branch_offset;
    BR_BNE:  if (!zero) pc_next = pc + branch_offset;
    BR_BLT:  if (lt)    pc_next = pc + branch_offset;
    BR_BGE:  if (!lt)   pc_next = pc + branch_offset;
    BR_BLTU: if (ltu)   pc_next = pc + branch_offset;
    BR_BGEU: if (!ltu)  pc_next = pc + branch_offset;
    default: begin
      // Sequential execution
    end
  endcase
end

always_ff @(posedge clk) begin
  if (rst)
    pc <= 0;
  else
    pc <= pc_next;
end

endmodule