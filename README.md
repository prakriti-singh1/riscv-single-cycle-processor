#  32-bit RISC-V Single-Cycle Processor (Verilog)

A modular, single-cycle 32-bit RISC-V processor built using Verilog. Designed for educational and core electronics resume projects. Simulates RV32I subset instructions using Vivado 2025.1.

---

##  Features

- Implements basic RV32I instructions: `ADD`, `SUB`, `ADDI`, `LW`, `SW`, `BEQ`
- Modular design:
  - `ALU`
  - `Register File`
  - `Control Unit`
  - `Instruction & Data Memory`
  - `Immediate Generator`
- Instruction Fetch, Decode, Execute, Memory, Writeback handled in one cycle
- Branching using zero flag and PC-relative updates
- Word-aligned memory accesses

---

##  File Structure

| File | Description |
|------|-------------|
| `riscv_single_cycle.v` | Top-level processor |
| `alu.v` | Arithmetic Logic Unit |
| `control_unit.v` | Main control logic based on opcode |
| `alu_control_unit.v` | Generates ALU control signals from funct bits |
| `register_file.v` | Register read/write logic |
| `imm_gen.v` | Immediate value generator for I, S, B-types |
| `instr_mem.v` | Instruction memory (preloaded from file) |
| `data_mem.v` | Data memory for LW/SW |
| `testbench.v` | Simulation environment |
| `instructions.mem` | Program in hexadecimal machine code |

---

##  Sample Program (`instructions.mem`)
```assembly
addi x1, x0, 5      # x1 = 5
addi x2, x0, 10     # x2 = 10
add  x3, x1, x2     # x3 = 15
sw   x3, 0(x0)      # store to mem[0]
lw   x5, 0(x0)      # load from mem[0] to x5
