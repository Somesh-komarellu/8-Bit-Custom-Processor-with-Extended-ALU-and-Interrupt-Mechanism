# 8-Bit-Custom-Processor-with-Extended-ALU-and-Interrupt-Mechanism
Designed, implemented, and verified a custom 8-bit microprocessor core using Verilog HDL, from architectural specification through system-level simulation in QuestaSim.
Developed a modular datapath including a Program Counter, Instruction Memory, Register File, Instruction Decoder, and a versatile 8-bit Arithmetic Logic Unit (ALU).
Engineered an extended ALU capable of performing standard arithmetic (ADD, SUB) and logical (AND, OR, XOR, NOT) operations, complemented by custom functions such as SQUARE, MODULO, PARITY, and bitwise SHIFTS.
Defined and implemented a custom 8-bit Instruction Set Architecture (ISA) to efficiently encode operations and operand addressing for the designed ALU and register file.
Integrated a foundational single-level interrupt mechanism, enabling the processor to vector to an Interrupt Service Routine (ISR) upon an external request and return via an RTI instruction.
Conducted rigorous functional verification using a comprehensive Verilog testbench, targeted test programs, and detailed waveform analysis in QuestaSim, successfully validating all implemented features.
Systematically debugged and resolved design challenges, including initial state propagation issues ('X'-states) and ensuring correct ALU computational logic through iterative testing and clean compilation practices.
