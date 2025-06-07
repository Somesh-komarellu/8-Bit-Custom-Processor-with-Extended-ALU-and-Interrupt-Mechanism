module Reg_File(
    input clk,
    input reset,
    input RegWrite, // This is the effective RegWrite signal for the RF module
    input [1:0] ReadReg1, ReadReg2, WriteReg, // WriteReg is the destination index
    input [7:0] WriteData,               // 8-bit width for data
    output reg [7:0] ReadData1, ReadData2 // 8-bit width for data
);

// Register storage: 32 registers, though only 4 are addressable with [1:0] selectors
reg [7:0] registers [0:31];
integer i;

// Removed the separate 'initial' block for register initialization.
// All initialization is handled by the reset condition in the clocked process.

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize all registers to 0 first
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 8'b0;
        end
        // Then, set specific initial values as required by the design
        // (e.g., if stack pointer or specific registers need non-zero reset values)
        // For this design, the testbench initializes R0 and R1, and reset can set others if needed.
        // Let's ensure R0,R1,R2 are 0 after reset, TB will then set them.
        // The TB sets R0=5, R1=3.
        // The original reset set R1=5, R2=3. To avoid confusion, let reset make them 0.
        // Testbench initializations will take effect after reset.
        registers[1] <= 8'd0; // Example: R1 is 0 after reset
        registers[2] <= 8'd0; // Example: R2 is 0 after reset
    end else if (RegWrite) begin // Only write if RegWrite input to this module is asserted
        if (WriteReg < 4) begin // Safety check: only write to implemented part of RF if needed
                                 // Though [1:0] WriteReg naturally limits this.
            registers[WriteReg] <= WriteData;
        end
    end
end

// Combinational Read Ports
always @(*) begin
    if (ReadReg1 < 4 && ReadReg2 < 4) begin // Basic bounds check
        ReadData1 = registers[ReadReg1];
        ReadData2 = registers[ReadReg2];
    end else begin // Should not happen with [1:0] inputs, but defensive
        ReadData1 = 8'hXX;
        ReadData2 = 8'hXX;
    end
end

endmodule

/*
module Reg_file (
    input clk,
    input rst,
    input regWrite,                // Write enable
    input [2:0] readReg1,          // Read register 1 address
    input [2:0] readReg2,          // Read register 2 address
    input [2:0] writeReg,          // Write register address
    input [7:0] writeData,         // Data to be written
    output reg [7:0] readData1,    // Data read from register 1
    output reg [7:0] readData2     // Data read from register 2
);

reg [7:0] registers [7:0];         // 8 registers, each 8 bits wide

// Reset or Write logic
integer i;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] <= 8'b0;
        end
    end else if (regWrite) begin
        registers[writeReg] <= writeData;
    end
end

// Combinational read logic
always @(*) begin
    readData1 = registers[readReg1];
    readData2 = registers[readReg2];
end

endmodule
*/