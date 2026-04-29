module regfile (
  input  logic clk,
  input  logic we,
  input  logic [4:0] rs1, rs2, rd,
  input  logic [31:0] wd,
  output logic [31:0] rd1, rd2
);
logic [31:0] regs [31:0];
assign rd1 = regs[rs1];
assign rd2 = regs[rs2];
always_ff @(posedge clk) begin
  if (we && rd != 0) regs[rd] <= wd;
end
endmodule