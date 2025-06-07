module Instruction_Memory (
    input [7:0] address,     // PC Address input
    output reg [7:0] instruction // Instruction output
);

    reg [7:0] memory [0:255]; // 256 x 8-bit Memory locations
    integer i; // For initialization loop

    // In Instruction_Memory.v initial block
// Format: [ALU_Op(4) Rd(2) Rs1(2)] --- Rs2 for ALU_B is implicitly Rd

initial begin
    // Initialize all memory to NOP (00)
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] = 8'h00;
    end

    // Test Program:
    // R0 initially 5 (from TB)
    // R1 initially 3 (from TB)
    // R2, R3 initially 0 (from RegFile reset)

    // 1. ADD R0, R1  (R0 = R1 + R0_old ; R0 = 3 + 5 = 8)
    memory[0] = {4'b0000, 2'b00, 2'b01}; // ALU_Op=ADD, Rd=R0, Rs1=R1. ALU_B uses R0_old.

    // 2. SUB R1, R0  (R1 = R0 - R1_old ; R1 = 8 - 3 = 5)
    memory[1] = {4'b0001, 2'b01, 2'b00}; // ALU_Op=SUB, Rd=R1, Rs1=R0. ALU_B uses R1_old.

    // 3. SQUARE R2, R0 (R2 = R0*R0 ; R2 = 8*8 = 64 = 0x40)
    memory[2] = {4'b1000, 2'b10, 2'b00}; // ALU_Op=SQUARE, Rd=R2, Rs1=R0. ALU_B ignored.

    // 4. AND R3, R0, R1 (R3 = R0 & R3_old ; R3 = 0x40 & 0 (R3_old) = 0).  Wait, R0 is 8 (0x08), R1 is 5.
    //    AND R3, R0 (R3 = R0 & R3_old ; R3 = 8 & 0 = 0)
    memory[3] = {4'b0010, 2'b11, 2'b00}; // ALU_Op=AND, Rd=R3, Rs1=R0. ALU_B uses R3_old.

    // 5. OR R0, R1 (R0 = R1 | R0_old ; R0 = 5 | 8 = 0xD)
    memory[4] = {4'b0011, 2'b00, 2'b01}; // ALU_Op=OR, Rd=R0, Rs1=R1. ALU_B uses R0_old.

    // 6. XOR R1, R0 (R1 = R0 ^ R1_old ; R1 = 0xD ^ 5 = 0x08)
    memory[5] = {4'b0100, 2'b01, 2'b00}; // ALU_Op=XOR, Rd=R1, Rs1=R0. ALU_B uses R1_old.

    // 7. SLL R2, R0 (R2 = R0 << 1 ; R2 = 0xD << 1 = 0x1A)
    memory[6] = {4'b0101, 2'b10, 2'b00}; // ALU_Op=SLL, Rd=R2, Rs1=R0. ALU_B ignored.

    // 8. SRL R3, R2 (R3 = R2 >> 1 ; R3 = 0x1A >> 1 = 0x0D)
    memory[7] = {4'b0110, 2'b11, 2'b10}; // ALU_Op=SRL, Rd=R3, Rs1=R2. ALU_B ignored.

    // 9. MOD R0, R1 (R0 = R1 % R0_old ; R0 = R1(0x08) % R0(0x1A_old?) - depends on prev state of R0 before this instruction)
    //    Let's set up R0=17 (0x11), R1=5 (0x05 from earlier). R0 = R1 % R0_old -> R0 = 5 % 17 = 5.
    //    To make it simple: MOD R0, R2. R2 is 0x1A, R0 is 0xD from instr 4. R0 = R2 % R0_old -> R0 = 0x1A % 0xD = 0x1A % 13 = 26 % 13 = 0.
    memory[8] = {4'b0111, 2'b00, 2'b10}; // MOD R0, R2. Rd=R0, Rs1=R2. ALU_B uses R0_old.

    // 10. PARITY R1, R2 (R1 = parity(R2) ; R2=0x1A (00011010) -> 3 ones -> odd parity -> 1)
    memory[9] = {4'b1001, 2'b01, 2'b10}; // PARITY R1, R2. Rd=R1, Rs1=R2. ALU_B ignored.

    // 11. NOT R0, R0 (R0 = ~R0_old)
    //     If R0 was 0 from MOD op: R0 = ~0 = 0xFF
    memory[10] = {4'b1010, 2'b00, 2'b00}; // NOT R0, R0. Rd=R0, Rs1=R0. ALU_B ignored.

    // 12. NOP
    memory[11] = 8'h00;
end

    always @(*) begin
        instruction = memory[address];
    end

endmodule