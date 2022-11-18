`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/28 17:34:48
// Design Name: 
// Module Name: testup
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
//the copilot was not used.

module alu_test();
    
    
    
    
    
    reg [3:0] alu_ctrl;
    reg [31:0] operand1;
    reg [31:0] operand2;
    wire [31:0] alu_out;
    reg [3:0] file_arg1;
    reg [31:0] file_arg2;
    reg [31:0] file_arg3;
    reg [31:0] file_arg4;
    
    integer fp;
    ALU dut(
    
    .alu_ctrl(alu_ctrl),
    .operand1(operand1),
    .operand2(operand2),
    .alu_out(alu_out)
    );
    initial begin
        fp = $fopen("alu_tb.csv", "r");
        if(fp == 0) begin 
            $display("Failed to open target file.");
            $stop;
        end
        
        
        while( !$feof(fp)) begin 
            #2;
            
            $fscanf(fp, "%b%b%b%b %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b\n", file_arg1, file_arg2, file_arg3, file_arg4);
            
            alu_ctrl = file_arg1;
            operand1 = file_arg2;
            operand2 = file_arg3;
            
            
            #1;
            $display(file_arg4);
            $display(alu_out);
            

            if(alu_out != file_arg4) begin
                $display("test failed");
                $fclose(fp);
                $stop;
            end
        end
        $display("Test finished successfully");
        $fclose(fp);
    end


endmodule
