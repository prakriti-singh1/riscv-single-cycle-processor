module register_file (
    input clk,
    input reg_write,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] reg_file [0:31];

    // Initialize all registers to 0 at the start of simulation
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            reg_file[i] = 0;
    end

    // Read operations
    assign read_data1 = reg_file[rs1];
    assign read_data2 = reg_file[rs2];

    // Write operation
    always @(posedge clk) begin
        if (reg_write && rd != 0)
            reg_file[rd] <= write_data;
    end

endmodule
