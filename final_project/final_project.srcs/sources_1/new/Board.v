`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2022 12:45:03 AM
// Design Name: 
// Module Name: Board
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


module Board(
    input wire CLK100MHZ,
    input wire[15:0] sw,
    input wire btnU, 
    output wire [15:0] LED
    );
    reg unsigned [15:0] inter_clock;
    wire slowclock;
    always @(posedge CLK100MHZ) begin 
        inter_clock <= inter_clock + 1;
    end
    assign slowclock  = inter_clock[15];

    Head Head(
        .rst_n(btnU),
        .clk(slowclock), 
        .boardLEDs(LED),
        .boardSwitches(sw)
    );

endmodule
