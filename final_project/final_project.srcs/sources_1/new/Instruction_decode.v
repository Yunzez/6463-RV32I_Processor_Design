`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2022 02:04:45 AM
// Design Name: 
// Module Name: Instruction_decode
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


module Instruction_decode(
    input reg clk, 
    input instr_in,
    output rd_addr,
    output rs1_addr,
    output rs2_addr,
    output opcode,
    output funct,
    output [2:0]imm_op
    );
    localparam [6:0]R_TYPE  = 7'b0110011, // op: 000
                I_TYPE  = 7'b0010011, // op: 001
                S_TYPE   = 7'b0100011, // op: 010
                L_TYPE    = 7'b0000011, // op: 011
                B_TYPE  = 7'b1100011,   // op: 100
                JALR    = 7'b1100111,   // op: 101
                JAL     = 7'b1101111,   // op  101
                AUIPC   = 7'b0010111,   // op: 110
                LUI     = 7'b0110111;   // op: 110
    
  
   reg opcode_temp = instr_in[6:0];
   reg funct_temp = instr_in[14:12];
   reg rd_addr_temp = instr_in[11:7];
   reg rs1_addr_temp = instr_in[19:15];
   reg rs2_addr_temp = instr_in[24:20];

   assign opcode   = opcode_temp ;
   assign funct    = funct_temp  ;
   assign rd_addr  = rd_addr_temp ;
   assign rs1_addr = rs1_addr_temp;
   assign rs2_addr = rs2_addr_temp;
   
   case(instr_in[6:0]) 
        R_TYPE: begin
            assign imm_op = 3'b000;
        end
         I_TYPE: begin
            assign imm_op = 3'b001;
        end 
          S_TYPE: begin
            assign imm_op = 3'b010;
        end 
          L_TYPE: begin
            assign imm_op = 3'b011;
        end 
         B_TYPE: begin
            assign imm_op = 3'b100;
        end 
         JALR || JALR: begin
            assign imm_op = 3'b101;
        end 
         AUIPC || LUI: begin
            assign imm_op = 3'b110;
        end
        
    endcase
endmodule
