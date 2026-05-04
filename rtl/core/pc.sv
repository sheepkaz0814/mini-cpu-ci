module pc (
  input  logic clk,
  input  logic rst,
  output logic [31:0] pc
);

always_ff @(posedge clk) begin
  if (rst)
    pc <= 0;
  else
    pc <= pc + 4;
end

endmodule