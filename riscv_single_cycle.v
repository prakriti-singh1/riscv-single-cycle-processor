module riscv_single_cycle(
    input clk,
    input reset,
    output reg [31:0] pc,
    output [31:0] instr
);

    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;

    wire [31:0] reg_data1, reg_data2;
    wire [31:0] imm_out;
    wire [31:0] alu_input2;
    wire [31:0] alu_result;
    wire zero;

    wire [31:0] read_data;
    wire [31:0] write_back_data;

    wire reg_write, mem_read, mem_write, alu_src, mem_to_reg, branch;
    wire [1:0] alu_op;
    wire [3:0] alu_ctrl;

    // Instruction Fetch
    instr_mem imem (
        .addr(pc),
        .instr(instr)
    );

    // Instruction Decode
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    register_file rf (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    imm_gen immgen (
        .instr(instr),
        .imm_out(imm_out)
    );

    control_unit ctrl (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_op(alu_op)
    );

    alu_control_unit alu_ctrl_unit (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    assign alu_input2 = alu_src ? imm_out : reg_data2;

    alu alu_unit (
        .a(reg_data1),
        .b(alu_input2),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    data_mem dmem (
        .clk(clk),
        .addr(alu_result),
        .write_data(reg_data2),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    assign write_back_data = mem_to_reg ? read_data : alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (branch && zero)
            pc <= pc + imm_out;
        else
            pc <= pc + 4;
    end

endmodule
