# RISC-V-Processor
This project implements a custom RISC-style processor on FPGA, inspired by classroom-level instruction sets and basic RISC-V principles.

The design includes:

Custom instruction format (R-type & M-type)
Basic ALU operations
Register file
Memory interface
Assembly program execution

The project demonstrates how a simple processor executes instructions like:
LOAD R1, 10
LOAD R2, 11
ADD  R3, R1, R2
MUL  R4, R1, R2
STORE R4, 21
HALT

R-Type Format
[15:12] Opcode | [11:9] rd | [8:6] rs1 | [5:3] rs2 | [2:0] unused
✅ M-Type Format
[15:12] Opcode | [11:9] reg | [8:0] memory address

🔢 Opcode Table
| Instruction | Binary | Hex |
| ----------- | ------ | --- |
| NOP         | 0000   | 0   |
| ADD         | 0001   | 1   |
| SUB         | 0010   | 2   |
| MUL         | 0011   | 3   |
| CMP         | 0100   | 4   |
| MOV         | 0101   | 5   |
| LOAD        | 0110   | 6   |
| STORE       | 0111   | 7   |
| HALT        | 1111   | F   |
