`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 09:53:01
// Design Name: 
// Module Name: ALU_Control
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


module ALU_Control(
    clk,
    rst,
    funct7,
    ALUop,
    funct3,
    
    
    alu_ctrl

    );

input clk;
input rst;
input wire [1:0] ALUop;
input wire [2:0] funct3;
input wire funct7;
output reg [3:0] alu_ctrl;

reg [3:0] temp;

always @(posedge clk or negedge rst) begin
    if (!rst)
        alu_ctrl <= 4'b0;
    else 
        alu_ctrl <= temp;
    end
    
always @(*) begin
    case(ALUop)
        2'b00:
            temp = 4'b0010;
        2'b01:
            temp = 4'b0110;
        2'b10:
            if (funct3 == 3'b000) begin
                if (!funct7)
                    temp = 4'b0010;
                else if (funct7)
                    temp = 4'b0110;
            end
            else if (funct3 == 3'b111) begin
                temp = 4'b0000;
            end
            else
                temp = 4'b0001;
                
            
        default: 
            temp = 4'b0000;
    endcase
end
            
    
endmodule
