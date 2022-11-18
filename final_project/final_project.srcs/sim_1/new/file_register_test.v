`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 20:19:30
// Design Name: 
// Module Name: file_register_test
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


module file_register_test(

    );
    reg clk;
    reg rst;
    reg en;
    
    reg [4:0] readS1;
    reg [4:0] readS2;
    reg [4:0] readRd;
    reg [31:0] data_in;
    wire [31:0] rs1;
    wire [31:0] rs2;
    
    reg  file_arg1, file_arg2;
    reg [4:0] file_arg3;
    reg [4:0] file_arg4;
    reg [4:0] file_arg5;
    reg [31:0] file_arg6;
    reg [31:0] file_arg7;
    reg [31:0] file_arg8;
    
    
    integer fp;
    RegisterFile dut(
    .clk(clk),
    .rst(rst),
    .en(en),
    .readS1(readS1),
    .readS2(readS2),
    .readRd(readRd),
    .data_in(data_in),
    .rs1(rs1),
    .rs2(rs2)
    
    );
    initial begin
        fp = $fopen("rf_tb.csv", "r");
        if(fp == 0) begin 
            $display("Failed to open target file.");
            $stop;
        end
        
        
        while( !$feof(fp)) begin 
            #1;
            
            clk = 0;
            $fscanf(fp, "%b %b %b%b%b%b%b %b%b%b%b%b %b%b%b%b%b %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b\n", file_arg1, file_arg2, file_arg3, file_arg4, file_arg5, file_arg6, file_arg7, file_arg8);
            
            
            rst = file_arg1;
            en = file_arg2;
            readS1 = file_arg3;
            readS2 = file_arg4;
            readRd = file_arg5;
            data_in = file_arg6;
            
            
            
            
            #1;
            clk = 1;
            $display(file_arg7);
            $display(file_arg8);
            $display(rs1);
            $display(rs2);
            

            if(rs1 != file_arg7 && rs2 != file_arg8) begin
                $display("test failed");
                $fclose(fp);
                $stop;
            end
        end
        $display("Test finished successfully");
        $fclose(fp);
    end


endmodule
