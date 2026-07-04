module pc (
  input  logic clk,
  input  logic rst,
  input  logic [2:0]  branch_op,
  input  logic        zero,
  input  logic [31:0] branch_offset,
  output logic [31:0] pc
);

localparam BR_NONE = 3'd0;
localparam BR_BEQ  = 3'd1;

logic [31:0] pc_next;

always_comb begin
  pc_next = pc + 32'd4;

  unique case (branch_op)
    BR_BEQ: begin
      if (zero)
        pc_next = pc + branch_offset;
    end

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