`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 01:14:08 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    alu_ctrl,
    operand1,
    operand2,
    alu_out
    );
input wire [3:0] alu_ctrl;
input wire [31:0] operand1;
input wire [31:0] operand2;
output reg [31:0] alu_out;

wire [31:0] addc;
wire [31:0] subc;
wire [31:0] andc;
wire [31:0] orc;

assign addc = operand1 + operand2;
assign subc = operand1 - operand2;
assign andc = operand1 & operand2;
assign orc = operand1 | operand2;

always @(*) begin
    case(alu_ctrl)
        4'b0010: alu_out = addc;
        4'b0110: alu_out = subc;
        4'b0000: alu_out = andc;
        4'b0001: alu_out = orc;
        default: alu_out = 0;
     endcase
        
end
  
    
    
    
endmodule
