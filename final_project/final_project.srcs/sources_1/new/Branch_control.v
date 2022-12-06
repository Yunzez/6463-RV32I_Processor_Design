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


module BC(
    funct3
    operand1,
    operand2,
    bc_enable,
    opcode,
    bc_out
    );
input bc_enable;
input wire [2:0] opcode;
input wire [31:0] operand1;
input wire [31:0] operand2;
output reg bc_out;




always @(*) begin
    if (bc_enable) begin
        if (opcode == 3b'000) begin
            if (operand1 - operand2 == 0)
                bc_out <= 1;
            else
                bc_out <= 0; 
        end
        else if (opcode == 3b'001) begin
            if (operand1 - operand2 != 0)
                bc_out <= 1;
            else
                bc_out <= 0; 
        end

        else if (opcode == 3b'100) begin
            if (operand1[31] == 0 && operand2[31] == 1)
                bc_out <= 0;
            else if (operand1[31] == 1 && operand2[31] == 0)
                bc_out <= 1;
            else begin
                if (operand1 - operand2 < 0)
                    bc_out <= 1;
                else 
                    bc_out <= 0;
            end
            
        end

        else if (opcode == 3b'101) begin
            if (operand1[31] == 0 && operand2[31] == 1)
                bc_out <= 1;
            else if (operand1[31] == 1 && operand2[31] == 0)
                bc_out <= 0;
            else begin
                if (operand1 - operand2 >= 0)
                    bc_out <= 1;
                else 
                    bc_out <= 0;
            end
        end
        else if (opcode == 3b'110) begin
            if (operand1 - operand2 >= 0)
                bc_out <= 1;
            else
                bc_out <= 0; 
        end
        else if (opcode == 3b'111) begin
            if (operand1 - operand2 >= 0)
                bc_out <= 1;
            else
                bc_out <= 0; 
        end
        
        else 
            bc_out <= 0;
    end
        
end
  
    
    
    
endmodule