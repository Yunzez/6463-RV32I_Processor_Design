`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 01:14:08 AM
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input reg clk, 
    input reg rst, 
    input reg en, 
    input reg[31:0] newAddress,
    output wire [31:0] nextAddress
    );
    
    always @(posedge clk or negedge rst) begin
        if(rst == 0) nextAddress = 32'h01000000; //  Upon reset this should equal the start address of instruction memory (0x01000000)
        
        else if (en == 1) nextAddress = newAddress;
        // add 4: 
        // RISC-V deals with everything in byte addresses (from page 19 of the ISA manual: "RV32I provides a 32-bit user address space that is byte-addressed and little-endian").
        // src: https://stackoverflow.com/questions/63904609/why-program-counter-in-risc-v-should-be-added-by-4-instead-of-adding-0-or-2
    end
endmodule
