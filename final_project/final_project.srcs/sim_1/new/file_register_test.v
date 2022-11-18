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
    reg clk_t;
    reg rst_t;
    reg en_t;
    
    reg [4:0] readS1_t;
    reg [4:0] readS2_t;
    reg [4:0] readRd_t;
    reg [31:0] data_in_t;
    wire [31:0] rs1_t;
    wire [31:0] rs2_t;
    
    reg  rst_load, en_load;
    reg [4:0] readS1_load;
    reg [4:0] readS2_load;
    reg [4:0] readRd_load;
    reg [31:0] data_in_load;
    reg [31:0] rs1_load;
    reg [31:0] rs2_load;
    
    
    integer fp;

    RegisterFile dut(
    .clk(clk_t),
    .rst(rst_t),
    .en(en_t),
    .readS1(readS1_t),
    .readS2(readS2_t),
    .readRd(readRd_t),
    .data_in(data_in_t),
    .rs1(rs1_t),
    .rs2(rs2_t)
    
    );
    initial begin
        fp = $fopen("rf_tb.csv", "r");
        if(fp == 0) begin 
            $display("Failed to open target file.");
            $stop;
        end
        
        
        while( !$feof(fp)) begin 
            #1;
            
            clk_t = 0;
            $fscanf(fp, "%b %b %b %b %b %b %b %b", rst_load, en_load, readS1_load, readS2_load, readRd_load, data_in_load, rs1_load, rs2_load);
            
            
            rst_t = rst_load;
            en_t = en_load;
            readS1_t = readS1_load;
            readS2_t = readS2_load;
            readRd_t = readRd_load;
            data_in_t = data_in_load;
            
            
            
            
            #1;
            clk_t = 1;
            $display("----------------------");
            $display("expected output-------");
            $display(readS1_load, readS2_load);
           $display("actual output-----");
            $display(readS1_t, readS2_t);
            
            

            if(readS1_t != readS1_load ||  readS2_t != readS2_load) begin
                $display("test failed");
                $fclose(fp);
                $stop;
            end
        end
        $display("Test finished successfully");
        $fclose(fp);
    end


endmodule
