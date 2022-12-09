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
    opcode,
    funct3,
    // output
    alu_ctrl
    );

input clk;
input rst;
input wire [6:0] opcode;
input wire [2:0] funct3;
input wire [6:0] funct7;
output reg [3:0] alu_ctrl;

wire hasFunc7;
reg [3:0] alu_op_tmp;

always @(posedge clk or negedge rst) begin
    if (!rst)
        alu_ctrl <= 4'b0;
    else 
        alu_ctrl <= alu_op_tmp;
    end

assign hasFunc7 = funct7[5];
always @(*) begin
    case(opcode)
        7'b0110011:                                         //Rtype
            alu_op_tmp = {hasFunc7,funct3};
        7'b0010011:
            alu_op_tmp = {{1'b0},funct3};                  //Itype
        7'b0110111:                                         //LUI
            alu_op_tmp = 4'b0000;
        7'b0010111:                                         //AUIPC
            alu_op_tmp = 4'b0000;
        7'b0110111:                                         //JAL
            alu_op_tmp = 4'b0000;
        7'b1100111:                                         //JALR
            alu_op_tmp = 4'b0000;
        7'b1100011:                                         //Branch
            if(funct3 == 3'b000 | funct3 == 3'b001)         //BEQ,BNE
                alu_op_tmp = 4'b1000;
            else if(funct3 == 3'b100 | funct3 == 3'b101)    //BLT,BGE
                alu_op_tmp = 4'b0010;
            else if(funct3 == 3'b110 | funct3 == 3'b111)    //BLTU,BGEU
                alu_op_tmp = 4'b0011;
            else
                alu_op_tmp = 4'b0000;
        7'b0000011:                                         //LOAD
            alu_op_tmp = 4'b0000;
        7'b0100011:                                         //SAVE
            alu_op_tmp = 4'b0000;
        7'b0001111:                                         //FENCE
            alu_op_tmp = 4'b0000;
        7'b1110011:                                         //EBREAK,ECALL
            alu_op_tmp = 4'b0000;
        default:
            alu_op_tmp = 4'b0000;
    endcase
end
            
endmodule
