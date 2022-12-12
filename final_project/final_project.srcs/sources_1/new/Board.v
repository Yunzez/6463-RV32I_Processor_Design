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
    output wire[15:0] LED
    );
    reg unsigned [23:0] inter_clock;
    wire slowclock;
    always @(posedge CLK100MHZ) begin 
        inter_clock <= inter_clock + 1;
    end
    assign slowclock  = inter_clock[23];
    Head Head(
        .rst_n(sw[0]),
        .clk(slowclock),
        .lightLED_clock(LED[0]),
        .lightLED_read(LED[1]),
        .lightLED_write(LED[2]),
        .lightLED_opcode(LED[15:8]),
        .lightLED_func3(LED[6:4])
    );

endmodule
