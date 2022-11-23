`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2022 07:51:05 PM
// Design Name: 
// Module Name: Instruction_decode_test
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


module Instruction_decode_test(

    );
    // test file 
    reg clk_t;
    reg [31:0]instr_in_t;
    wire rd_addr_t;
    wire rs1_addr_t;
    wire rs2_addr_t;
    wire opcode_t;
    wire funct_t;
    wire [31:0] imm_ext_t;

    // load 
    reg rd_addr_load;
    reg rs1_addr_load;
    reg rs2_addr_load;
    reg opcode_load;
    reg funct_load;
    reg [31:0] imm_ext_load;

    integer testPassNum = 0;
    integer testFailNum = 0;

    localparam period = 10; 

    integer file_pointer; // file pointer

    Instruction_decode dut(
       .clk(clk_t),      
       .instr_in(instr_in_t), 
       .rd_addr(rd_addr_t),  
       .rs1_addr(rs1_addr_t),
       .rs2_addr(rs2_addr_t) ,
       .opcode(opcode_t)   ,
       .funct(funct_t) ,  
       .imm_ext(imm_ext_t) ,
    );

endmodule
