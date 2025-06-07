module Instruction_Decoder (
    input [7:0] instruction,
    output reg [3:0] alu_control_out, // To drive ALUControl
    output reg [1:0] rs1_addr,        // Address for RegFile ReadPort1 (ALU A input)
    output reg [1:0] rs2_addr,        // Address for RegFile ReadPort2 (ALU B input)
    output reg [1:0] rd_addr,         // Address for RegFile WritePort
    output reg RegWrite
);

always @(*) begin
    // instruction[7:4] = ALU_Op_Select (directly maps to ALUControl)
    // instruction[3:2] = Rd
    // instruction[1:0] = Rs1

    alu_control_out = instruction[7:4];
    rd_addr         = instruction[3:2];
    rs1_addr        = instruction[1:0];

    // For ALU operand B (Rs2), we use the current value of the destination register (Rd)
    rs2_addr        = instruction[3:2]; // Rs2 address is the same as Rd address

    // Determine if it's a NOP (all zeros) or an actual operation
    if (instruction == 8'h00) begin
        RegWrite  = 1'b0; // Don't write for NOP
        // For NOP, ALU can do anything, let's make it ADD to be safe, result isn't written.
        alu_control_out = 4'b0000;
    end else begin
        RegWrite  = 1'b1; // Enable write for all other defined ALU ops
    end
end
endmodule 
/*

module Instruction_Decoder(
    input [15:0] instruction,      // 16-bit input instruction
    output reg [3:0] opcode,       // 4-bit opcode
    output reg [3:0] ALUControl,   // ALU operation select
    output reg [2:0] rs,           // Source register 1
    output reg [2:0] rt,           // Source register 2
    output reg [2:0] rd,           // Destination register
    output reg [7:0] immediate     // 8-bit immediate value
);

always @(*) begin
    opcode = instruction[15:12];         // Top 4 bits: opcode
    ALUControl = instruction[11:8];      // Next 4 bits: ALU control (specific operation)
    rs = instruction[7:5];               // Next 3 bits: source register 1
    rt = instruction[4:2];               // Next 3 bits: source register 2
    rd = instruction[2:0];               // Last 3 bits: destination register (reused bits)
    immediate = instruction[7:0];        // Lower 8 bits as immediate (used in immediate-based instructions)
end

endmodule
*/