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
endmodule