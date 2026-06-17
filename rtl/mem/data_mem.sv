module data_mem (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    // 256 words = 1KB
    logic [31:0] mem [0:255];

    // Write
    always_ff @(posedge clk) begin
        if (we)
            mem[addr[9:2]] <= wdata;
    end

    // Read
    assign rdata = mem[addr[9:2]];

endmodule