`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 01:14:08 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    clk,
    rst,
    en,
    readS1,
    readS2,
    readRd,
    data_in,
    rs1,
    rs2
    );
    
input clk;
input rst;
input en;
input wire [4:0] readS1;
input wire [4:0] readS2;
input wire [4:0] readRd;
input wire [31:0] data_in;
output reg [31:0] rs1;
output reg [31:0] rs2;

reg [31:0] rf [1:31];

// = {32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0,32'b0, 32'b0, 32'b0, 32'b0};
initial begin
rf[0] <= 32'b0;
      rf[1] <= 32'b0;
      rf[2] <= 32'b0;
      rf[3] <= 32'b0;
      rf[4] <= 32'b0;
      rf[5] <= 32'b0;
      rf[6] <= 32'b0;
      rf[7] <= 32'b0;
      rf[8] <= 32'b0;
      rf[9] <= 32'b0;
      rf[10] <= 32'b0;
      rf[11] <= 32'b0;
      rf[12] <= 32'b0;
      rf[13] <= 32'b0;
      rf[14] <= 32'b0;
      rf[15] <= 32'b0;
      rf[16] <= 32'b0;
      rf[17] <= 32'b0;
      rf[18] <= 32'b0;
      rf[19] <= 32'b0;
      rf[20] <= 32'b0;
      rf[21] <= 32'b0;
      rf[22] <= 32'b0;
      rf[23] <= 32'b0;
      rf[24] <= 32'b0;
       rf[25]<= 32'b0;
       rf[26] <= 32'b0;
       rf[27] <= 32'b0;
       rf[28] <= 32'b0;
       rf[29] <= 32'b0;
       rf[30] <= 32'b0;
       rf[31] <= 32'b0;
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        
        rf[0] <= 32'b0;
      rf[1] <= 32'b0;
      rf[2] <= 32'b0;
      rf[3] <= 32'b0;
      rf[4] <= 32'b0;
      rf[5] <= 32'b0;
      rf[6] <= 32'b0;
      rf[7] <= 32'b0;
      rf[8] <= 32'b0;
      rf[9] <= 32'b0;
      rf[10] <= 32'b0;
      rf[11] <= 32'b0;
      rf[12] <= 32'b0;
      rf[13] <= 32'b0;
      rf[14] <= 32'b0;
      rf[15] <= 32'b0;
      rf[16] <= 32'b0;
      rf[17] <= 32'b0;
      rf[18] <= 32'b0;
      rf[19] <= 32'b0;
      rf[20] <= 32'b0;
      rf[21] <= 32'b0;
      rf[22] <= 32'b0;
      rf[23] <= 32'b0;
      rf[24] <= 32'b0;
       rf[25]<= 32'b0;
       rf[26] <= 32'b0;
       rf[27] <= 32'b0;
       rf[28] <= 32'b0;
       rf[29] <= 32'b0;
       rf[30] <= 32'b0;
       rf[31] <= 32'b0;
        
        
        
        rs1 <= 32'b0;
        rs2 <= 32'b0;
    end
    else if (en) begin
        rf[readRd] <= data_in;
        rf[0] <= 32'b0;
    end
    else begin
        rs1 <= rf[readS1];
        rs2 <= rf[readS2];
    end
end   
    
        
    
    
endmodule
