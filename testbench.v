`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instr;

    riscv_single_cycle uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Time=%0t | PC=%h | Instr=%h", $time, pc, instr);

        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        // Run for 1000ns
        #1000;
        $finish;
    end

    always @(posedge clk) begin
        $display("Time=%0t | PC=%h | Instr=%h", $time, pc, instr);
    end

endmodule
