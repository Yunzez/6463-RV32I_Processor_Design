`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2022 07:07:57 PM
// Design Name: 
// Module Name: Mux
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


module Mux(
    input UpperInput,
    input LowerInput,
    input ControlSingal,
    output wire selectedVal
    );
    
    if(ControlSingal == 1) assign selectedVal = UpperInput;
    else assign selectedVal = LowerInput;
    
    
    
endmodule
