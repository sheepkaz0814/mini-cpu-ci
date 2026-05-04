module inst_mem (
  input  logic [31:0] addr,
  output logic [31:0] inst
);

  logic [31:0] mem [0:15];

  initial begin
    // プログラム書く（後でテスト）
    mem[0] = 32'b000000000101_00000_000_00001_0010011; // ADDI r1, r0, 5
    mem[1] = 32'b000000000010_00001_000_00010_0010011; // ADDI r2, r1, 2
  end

  assign inst = mem[addr[5:2]]; // wordアドレス

endmodule