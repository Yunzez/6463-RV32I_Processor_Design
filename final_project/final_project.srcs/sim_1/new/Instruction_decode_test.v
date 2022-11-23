`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2022 07:51:05 PM
// Design Name: 
// Module Name: Instruction_decode_test
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


module Instruction_decode_test(

    );
    // test file 
    reg clk_t;
    reg  [31:0]instr_in_t;
    wire [4:0]rd_addr_t;
    wire [4:0]rs1_addr_t;
    wire [4:0]rs2_addr_t;
    wire [6:0]opcode_t;
    wire [2:0]funct_t;
    wire [31:0] imm_ext_t;

    // load 
    reg [31:0]instr_in_load;
    reg [4:0]rd_addr_load;
    reg [4:0]rs1_addr_load;
    reg [4:0]rs2_addr_load;
    reg [6:0]opcode_load;
    reg [2:0]funct_load;
    reg [31:0] imm_ext_load;

    integer testPassNum = 0;
    integer testFailNum = 0;

    localparam period = 10; 

    integer file_pointer; // file pointer

    Instruction_decode dut(
       .clk(clk_t),      
       .instr_in(instr_in_t), 
       .rd_addr(rd_addr_t),  
       .rs1_addr(rs1_addr_t),
       .rs2_addr(rs2_addr_t),
       .opcode(opcode_t),
       .funct(funct_t),  
       .imm_ext(imm_ext_t)
    );
    
    initial begin
        $display("testing Instruction decode");
        
        file_pointer = $fopen("control_unit_testfile.csv", "r");
        if(file_pointer == 0 ) begin 
            $display("cannot open testfile");
            $stop;
        end 
        $display("load test file successfully");
        
        #period;
        while(!$feof(file_pointer)) begin
            $display("testing one line");
            #10;
            clk_t = 0;
            //instruction   opcode  rd  rs1  rs2  funct3   
            $fscanf(file_pointer, "%100b,%b,%b,%b,%b,%b", instr_in_load, opcode_load, rd_addr_load, rs1_addr_load, rs2_addr_load, funct_load);
            instr_in_t = instr_in_load;
            $display("instruction value: %32b", instr_in_load);
            #10;
            clk_t = 1;
            
             if(
                opcode_load != opcode_t ||
                rd_addr_load != rd_addr_t || 
                rs1_addr_load != rs1_addr_t || 
                rs2_addr_load!= rs2_addr_t ||
                funct_load!= funct_t 
             ) begin
             
              $display("Test Failed!, test value =   ");
                $display(instr_in_load," ", opcode_load," ", rd_addr_load," ", rs1_addr_load," ", rs2_addr_load," ", funct_load);
                $display("actual value:");
                $display(instr_in_t," ", opcode_t," ", rd_addr_t," ", rs1_addr_t," ", rs2_addr_t," ", funct_t);
                testFailNum = testFailNum + 1;

                $stop;
             end
             
             else begin 
                $display("pass");
                testPassNum = testPassNum + 1;
             end 
             
             if(testFailNum == 0) $display("Yay, All tests passed,     passed:", testPassNum, "     failed:",testFailNum);
             $fclose(file_pointer);
        end
        
    end 

endmodule
