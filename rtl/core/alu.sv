module alu (
  input  logic [31:0] a, b,
  input  logic [2:0] op,
  output logic [31:0] y
);
always_comb begin
  case (op)
    3'd0: y = a + b;
    3'd1: y = a - b;
    3'd2: y = a & b;
    3'd3: y = a | b;
    3'd4: y = a ^ b;
    default: y = 32'd0;
  endcase
end
endmodule