module tb_processor;

    reg clk;
    reg reset;
    reg tb_RegWrite_stim;
    reg [1:0] tb_WriteReg_stim;
    reg [7:0] tb_WriteData_stim;

    wire [7:0] pc_out_obs;
    wire [7:0] instruction_obs;
    wire [7:0] ALUResult_obs;

    Top_Level_Processor uut (
        .clk(clk),
        .reset(reset),
        .tb_RegWrite(tb_RegWrite_stim),
        .tb_WriteReg(tb_WriteReg_stim),
        .tb_WriteData(tb_WriteData_stim),
        .pc_out(pc_out_obs),
        .instruction(instruction_obs),
        .ALUResult_out(ALUResult_obs)
    );

    always #5 clk = ~clk; // Clock period 10 time units

    initial begin
        $display("[%0t] Testbench: Starting simulation.", $time);
        clk = 0;
        reset = 1;
        tb_RegWrite_stim = 0;
        tb_WriteReg_stim = 2'b00;
        tb_WriteData_stim = 8'h00;
        $display("[%0t] Testbench: Reset asserted.", $time);

        #10;
        reset = 0;
        $display("[%0t] Testbench: Reset de-asserted.", $time);
        #5;

        $display("[%0t] Testbench: Initializing R0 with 6.", $time);
        tb_RegWrite_stim = 1'b1;
        tb_WriteReg_stim = 2'd0;
        tb_WriteData_stim = 8'd6;
        #10; // Hold for one clock cycle (clk period is 10)

        $display("[%0t] Testbench: Initializing R1 with 2.", $time);
        tb_WriteReg_stim = 2'd1;
        tb_WriteData_stim = 8'd2;
        #10; // Hold for one clock cycle

        $display("[%0t] Testbench: Disabling direct TB writes.", $time);
        tb_RegWrite_stim = 1'b0;
        #5;

        $display("[%0t] Testbench: Running for 200ns.", $time);
        #250;
        $display("[%0t] Testbench: Simulation duration complete. Stopping.", $time);
        $stop;
    end
endmodule