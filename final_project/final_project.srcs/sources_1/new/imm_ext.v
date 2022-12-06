`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2022 12:36:33 AM
// Design Name: 
// Module Name: imm_ext
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


module imm_ext(
    input clk,
    input [6:0]opcode,
    input  [31:0]instr_in,
    output [31:0] imm_ext
    );
    
    reg [31:0]imm_temp;
    localparam [6:0]R_TYPE  = 7'b0110011, // op: 000
                I_TYPE  = 7'b0010011, // op: 001
                S_TYPE   = 7'b0100011, // op: 010
                L_TYPE    = 7'b0000011, // op: 011
                B_TYPE  = 7'b1100011,   // op: 100
                JALR    = 7'b1100111,   // op: 101
                JAL     = 7'b1101111,   // op  101
                AUIPC   = 7'b0010111,   // op: 110
                LUI     = 7'b0110111;   // op: 110
                
                
      always @(posedge clk) begin
        case(opcode) 
        LUI:
            imm_temp = {instr_in[31:12], 12'b0};
        AUIPC:
            imm_temp = {instr_in[31:12], 12'b0};
        JAL:
            imm_temp = {{12{instr_in[31]}}, instr_in[19:12], instr_in[20], instr_in[30:21], 1'b0}; // 12{{instr_in[31]}} extend the first bit of instruction 12 times; if 0, 12 * 0 are put in front
        I_TYPE:
            imm_temp = {{21{instr_in[31]}}, instr_in[30:20]};
        L_TYPE:
            imm_temp = {{21{instr_in[31]}}, instr_in[30:20]};
        JALR:
            imm_temp = {{21{instr_in[31]}}, instr_in[30:20]};
        B_TYPE:
            imm_temp = {{20{instr_in[31]}}, instr_in[7], instr_in[30:25], instr_in[11:8], 1'b0};
        S_TYPE:
            imm_temp = {{21{instr_in[31]}}, instr_in[30:25], instr_in[11:7]};
        default:
            imm_temp = {{21{instr_in[31]}}, instr_in[30:20]}; //ITYPE ALU 
            
    endcase
   end
   
   assign imm_ext = imm_temp;
endmodule
