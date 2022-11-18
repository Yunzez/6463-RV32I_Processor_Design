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

module alu_control_test();
    
    
    
    
    
    
    reg clk;
    reg rst;
    reg funct7;
    
    reg [1:0] ALUop;
    reg [2:0] funct3;
    wire [3:0] alu_ctrl;
    
    reg  file_arg1, file_arg2, file_arg3;
    reg [1:0] file_arg4;
    reg [2:0] file_arg5;
    
    
    integer fp;
    ALU_Control dut(
    .clk(clk),
    .rst(rst),
    .funct7(funct7),
    .ALUop(ALUop),
    .funct3(funct3),
    .alu_ctrl(alu_ctrl)
    
    );
    initial begin
        fp = $fopen("alu_ctrl_tb.csv", "r");
        if(fp == 0) begin 
            $display("Failed to open target file.");
            $stop;
        end
        
        
        while( !$feof(fp)) begin 
            #1;
            
            clk = 0;
            $fscanf(fp, "%b %b %b%b %b%b%b %b%b%b%b\n", file_arg1, file_arg2, file_arg3, file_arg4, file_arg5);
            
            
            rst = file_arg1;
            funct7 = file_arg2;
            ALUop = file_arg3;
            funct3 = file_arg4;
            
            
            
            #1;
            clk = 1;
            $display(file_arg5);
            $display(alu_ctrl);
            

            if(alu_ctrl != file_arg5) begin
                $display("test failed");
                $fclose(fp);
                $stop;
            end
        end
        $display("Test finished successfully");
        $fclose(fp);
    end


endmodule
