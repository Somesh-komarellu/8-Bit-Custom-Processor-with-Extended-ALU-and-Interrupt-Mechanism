module ALU(
    input [7:0] A,          // 8 bits
    input [7:0] B,          // 8 bits
    input [3:0] ALUControl,
    output reg [7:0] ALUResult  // 8 bits
);

always @(*) begin
    ALUResult = 8'hXX; 

    case (ALUControl)
        4'b0000: ALUResult = A + B;            // ADD
        4'b0001: ALUResult = A - B;            // SUB
        4'b0010: ALUResult = A & B;            // AND
        4'b0011: ALUResult = A | B;            // OR
        4'b0100: ALUResult = A ^ B;            // XOR
        4'b0101: ALUResult = A << 1;           // Shift Left A (Logical)
        4'b0110: ALUResult = A >> 1;           // Shift Right A (Logical)
        4'b0111: ALUResult = (B != 0) ? (A % B) : 8'hFF; // Modulus (return FF if B is 0)
        4'b1000: ALUResult = A * A;            // Square A (result is 8-bit, potential overflow)
        4'b1001: ALUResult = {7'b0, ^(A)};     // Parity A (1 if odd parity, 0 if even), result in LSB
        4'b1010: ALUResult = ~A;               // NOT A (Bitwise NOT)
        // Intentional default case to catch any unexpected ALUControl values
        default: ALUResult = 8'hXX;            // Undefined ALUControl results in X
    endcase
end
endmodule