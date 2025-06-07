module Program_Counter (
    input clk,
    input reset,
    /*input interrupt,
    input rti, //return from intr
    input [7:0] int_addr, //from interr controller */
    output reg [7:0] pc_out
);
    reg [7:0] return_address; //holds pc during interrupt

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_out <= 8'd0;
       // return_address <= 8'd0; // Initialize return_address
    end 
	/* else if (interrupt) begin
        return_address <= pc_out; // Save current PC
        pc_out <= int_addr;       // Jump to handler
    end else if (rti) begin
        pc_out <= return_address; // Restore PC
    end */ 
	else begin
        pc_out <= pc_out + 1;
    end
end
endmodule