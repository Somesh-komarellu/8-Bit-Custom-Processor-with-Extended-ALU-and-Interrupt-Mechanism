module Top_Level_Processor(
    input clk,
    input reset,
    input tb_RegWrite,      // This is tb_RegWrite_stim from testbench
    input [1:0] tb_WriteReg,
    input [7:0] tb_WriteData,
    output [7:0] pc_out,
    output [7:0] instruction,
    output [7:0] ALUResult_out
);

    // Internal wires
    wire [3:0] alu_control_signal_from_decoder;
    wire [1:0] dec_rs1_addr, dec_rs2_addr, dec_rd_addr; // From Decoder
    wire [7:0] regData1, regData2;
    wire [7:0] alu_internal_result;
    wire id_RegWrite; // Output from decoder, but we will override its effect on RF_inst

    wire [7:0] pc_current;
    wire [7:0] instruction_fetched;

    // Interrupt signals (currently inactive as PC module is simplified)
    // wire interrupt_signal = 1'b0;
    // wire rti_signal = 1'b0;
    // wire [7:0] interrupt_vector_addr = 8'd0;

    // Using the simplified Program_Counter (interrupt/RTI ports commented out internally)
    Program_Counter PC_inst (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_current)
    );

    Instruction_Memory IM_inst (
        .address(pc_current),
        .instruction(instruction_fetched)
    );

    Instruction_Decoder ID_inst (
        .instruction(instruction_fetched),
        .alu_control_out(alu_control_signal_from_decoder),
        .rs1_addr(dec_rs1_addr),
        .rs2_addr(dec_rs2_addr),
        .rd_addr(dec_rd_addr),
        .RegWrite(id_RegWrite) // Decoder still generates this signal
    );

    Reg_File RF_inst (
        .clk(clk),
        .reset(reset),
        // MODIFIED LINE:
        // Only allow the testbench to enable writes to the Register File.
        // Once tb_RegWrite (from tb_RegWrite_stim) goes low, no further writes will occur
        // from processor instructions, keeping register values fixed.
        .RegWrite(tb_RegWrite),

        .ReadReg1(dec_rs1_addr),
        .ReadReg2(dec_rs2_addr),

        // WriteReg and WriteData selection logic remains the same.
        // These are only effective if RF_inst.RegWrite (now tb_RegWrite) is high.
        .WriteReg(tb_RegWrite ? tb_WriteReg : dec_rd_addr),
        .WriteData(tb_RegWrite ? tb_WriteData : alu_internal_result),

        .ReadData1(regData1),
        .ReadData2(regData2)
    );

    ALU ALU_inst (
        .A(regData1),
        .B(regData2),
        .ALUControl(alu_control_signal_from_decoder),
        .ALUResult(alu_internal_result)
    );

    assign pc_out = pc_current;
    assign instruction = instruction_fetched;
    assign ALUResult_out = alu_internal_result;

endmodule