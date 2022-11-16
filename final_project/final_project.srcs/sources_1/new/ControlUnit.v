`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 01:14:08 AM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input clk, rst, en,
    input [6:0]opcode,
    input [2:0]funct3,
    
    output  reg             Branch,
    output  reg             MemRead,
    output  reg             MemtoReg,
    output  reg     [3:0]   MemWrite,
    output  reg             ALUSrc,
    output  reg     [1:0]   ALUOptions,
    output  reg             RegWrite
    );
    
    reg [2:0]curr_state;
    reg [2:0]next_state;
    
    parameter INITALIZE  = 3'b000;
    parameter INSRUCTIONLOAD    = 3'b001;
    parameter EXECUTION    = 3'b010;
    parameter STOREMEMORY    = 3'b011;
    parameter HALT   = 3'b100;
   
      reg             Branch_temp;
      reg             MemRead_temp;
      reg             MemtoReg_temp;
      reg     [3:0]   MemWrite_temp;
      reg             ALUSrc_temp;
      reg     [1:0]   ALUOptions_temp;  
      reg             RegWrite_temp;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state   <= IF;
        else
            state   <= next_state;
    end
    
    // cases we have for op module 
    // 0110111 // R-type
    // 0010111 //Auipc//
    // 1101111 //Jal
    // 1100111 //Jalr
    // 1100011 //Branch
    // 0000011 //Load
    // 0100011 //Store
    // 0010011 I_TYPE
    // 0110011 //Lui
    
    always @(*) begin
     case(state)
        INITALIZE: begin
                Branch_tmp      = 1'b0;
                ALUSrc_temp       = 1'b0;
                MemRead_tmp     = 1'b0;
                MemWrite_tmp    = 4'b0000;
                ALUOptions_temp   = 2'b00;
                MemtoReg_temp    = 1'b0;       
                RegWrite_tmp    = 1'b0;
        end
        
        INSRUCTIONLOAD: begin 
            case(opcode)
                7'b0110111: begin //LUI
    //            Loads the immediate value into the upper
    //            20 bits of the target register rd and sets
    //            the lower bits to 0
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
    
                end
                
                7'b0010111: begin // AUIPC
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b1101111: begin // JAL
//                Jump to PC=PC+(sign-extended
//                immediate value) and store the current PC
                    Branch_tmp      = 1'b1;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b1100111: begin //JALR
//                Jump to PC=rs1 register value
//                +(sign-extended immediate value) and
//                store the current PC address+4 in register
//                rd
                    Branch_tmp      = 1'b1;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b1100011: begin //BEQ...
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b0000011: begin //LB
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end 
                
                7'b0100011: begin // SB
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b0010011: begin //ADDI 
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b0110011: begin //ADD
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b0001111: begin //FENCE 
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b1110011: begin //ECALL
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
           endcase
        end
    endcase
   end
            
    
endmodule
