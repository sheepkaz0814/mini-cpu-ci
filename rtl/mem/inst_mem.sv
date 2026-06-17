module inst_mem (
  input  logic [31:0] addr,
  output logic [31:0] inst
);

  logic [31:0] mem [0:15];
/*
  initial begin
    // ADDI x1, x0, 5
    mem[0] = 32'b000000000101_00000_000_00001_0010011;
    // ADDI x2, x0, 3
    mem[1] = 32'b000000000011_00000_000_00010_0010011;
    // ADD x3, x1, x2
    mem[2] = 32'b0000000_00010_00001_000_00011_0110011;
    // SUB x4, x1, x2
    mem[3] = 32'b0100000_00010_00001_000_00100_0110011;
    // AND x5, x1, x2
    mem[4] = 32'b0000000_00010_00001_111_00101_0110011;
    // OR x6, x1, x2
    mem[5] = 32'b0000000_00010_00001_110_00110_0110011;
end 
*/
//  assign inst = mem[addr[5:2]]; // wordアドレス

always_comb begin
    case (addr)

      32'd0 : inst = 32'h01000093; // addi x1,x0,16
      32'd4 : inst = 32'h07B00113; // addi x2,x0,123
      32'd8 : inst = 32'h0020A023; // sw x2,0(x1)
      32'd12: inst = 32'h0000A183; // lw x3,0(x1)

      default: inst = 32'h00000013; // nop(addi x0,x0,0)

    endcase
end
endmodule