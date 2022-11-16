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
   
      reg             Branch;
      reg             MemRead;
      reg             MemtoReg;
      reg     [3:0]   MemWrite;
      reg             ALUSrc;
      reg     [1:0]   ALUOptions;
      reg             RegWrite;
    
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
        case(opcode)
            7'b0110111: begin 
            
            end
            
            7'b0010111: begin
            
            end
            
            7'b1101111: begin 
            
            end
            7'b1100111: begin 
            
            end
            
            7'b1100011: begin 
            end
            7'b0000011: begin 
            end 
            
            7'b0100011: begin
             end
            
            7'b0010011: begin 
             end
            
            7'b0110011: begin
             end
            
            7'b0001111: begin 
             end
            
            7'b1110011: begin
             end
            

            
            
    
endmodule
