`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2022 01:25:19 PM
// Design Name: 
// Module Name: leftRotateVerilogTest
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
module ContolUnit_test();
    // original 
    reg clk_t;
    reg rst_t;
    reg [6:0]opcode_t;
    reg bc_t;

    wire PC_s_t;
    wire PC_we_t;
    wire Instr_rd_t;
    wire RegFile_s_t; 
    wire RegFile_we_t; 
    wire Imm_op_t; 
    wire ALU_s1_t; 
    wire ALU_s2_t; 
    wire DataMem_rd_t; 
    wire Data_op_t; 
    wire Data_s_t; 
    wire Bc_Op_t; 
    wire Data_we_t;
    
     wire [1:0] ALU_op_t;

    // loader form test file
    reg PC_s_load;
    reg PC_we_load;
    reg Instr_rd_load; 
    reg RegFile_s_load; 
    reg RegFile_we_load; 
    reg Imm_op_load; 
    reg ALU_s1_load; 
    reg ALU_s2_load; 
    reg DataMem_rd_load;
    reg  Data_op_load; 
    reg Data_s_load; 
    reg Bc_Op_load; 
    reg Data_we_load;

    reg [1:0]ALU_op_load;

    reg [6:0]opcode_load;
    reg bc_load;
    
     integer testPassNum = 0;
    integer testFailNum = 0;

    localparam period = 10; 

    integer file_pointer; // file pointer
    
    ControlUnit dut (
        // self assigned input
        .clk(clk_t),
        .rst(rst_t),

        // test assigned input
        .bc(bc_t),
        .opcode(opcode_t),

        // output 
        .PC_s(PC_s_t), 
        .PC_we(PC_we_t), 
        .Instr_rd(Instr_rd_t), 
        .RegFile_s(RegFile_s_t), 
        .RegFile_we(RegFile_we_t), 
        .Imm_op(Imm_op_t),
        .ALU_s1(ALU_s1_t), 
        .ALU_s2(ALU_s2_t), 
        .ALU_op(ALU_op_t), 
        .DataMem_rd(DataMem_rd_t), 
        .Data_op(Data_op_t), 
        .Data_s(Data_s_t), 
        .Bc_Op(Bc_Op_t), 
        .Data_we(Data_we_t)
    );

    initial begin
    $display("testing control unit");
        file_pointer = $fopen("instruction_decode_test_file.txt", "r");
        if(file_pointer == 0 ) begin 
            $display("cannot open testfile");
            $stop;
        end 
        $display("load test file successfully");
        
         //
        rst_t = 0;
        #period;
        while(!$feof(file_pointer)) begin
            $display("testing one line");
            #10;
             $fscanf(file_pointer, "%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b", opcode_load, bc_load, PC_s_load, PC_we_load, Instr_rd_load, RegFile_s_load, RegFile_we_load, Imm_op_load, ALU_s1_load, ALU_s2_load, ALU_op_load, DataMem_rd_load, Data_op_load, Data_s_load,  Bc_Op_load, Data_we_load );

            opcode_t =opcode_load;
            $display("opcode_load, bc_load, PC_s_load, PC_we_load, Instr_rd_load, RegFile_s_load, RegFile_we_load, Imm_op_load, ALU_s1_load, ALU_s2_load, ALU_op_load, DataMem_rd_load, Data_op_load, Data_s_load, Bc_Op_load, Data_we_load");

                #period;
                clk_t = 1;
                bc_t = bc_load;
                opcode_t = opcode_load;
                rst_t = 1; 

                #period;
                clk_t = 0;
                
                if(
                PC_s_load != PC_s_t ||
                PC_we_load != PC_we_t || 
                Instr_rd_load != Instr_rd_t || 
                RegFile_s_load!= RegFile_s_t ||
                RegFile_we_load!= RegFile_we_t ||
                Imm_op_load != Imm_op_t ||
                ALU_s1_load != ALU_s1_t ||
                ALU_s2_load != ALU_s2_t || 
                ALU_op_load != ALU_op_t ||
                DataMem_rd_load != DataMem_rd_t || 
                Data_op_load != Data_op_t ||
                Data_s_load != Data_s_t || 
                Bc_Op_load != Bc_Op_t ||
                Data_we_load != Data_we_t
             ) begin
             
              $display("Test Failed!, test value =   ");
                $display(opcode_load," ", bc_load," ", PC_s_load," ", PC_we_load," ", Instr_rd_load," ", RegFile_s_load," ", RegFile_we_load," ", Imm_op_load," ", ALU_s1_load," ", ALU_s2_load," ", ALU_op_load," ", DataMem_rd_load," ", Data_op_load," ", Data_s_load," ", Bc_Op_load," ",  Data_we_load);
                $display("actual value:");
                $display(opcode_t," ", bc_t," ", PC_s_t," ", PC_we_t," ", Instr_rd_t," ", RegFile_s_t," ", RegFile_we_t," ", Imm_op_t," ", ALU_s1_t," ", ALU_s2_t," ", ALU_op_t," ", DataMem_rd_t," ", Data_op_t," ", Data_s_t," ", Bc_Op_t," ", Data_we_t);
                testFailNum = testFailNum + 1;

                
             end
             
             else if (
              PC_s_load == PC_s_t &&
                PC_we_load == PC_we_t && 
                Instr_rd_load == Instr_rd_t && 
                RegFile_s_load == RegFile_s_t &&
                RegFile_we_load == RegFile_we_t &&
                Imm_op_load == Imm_op_t &&
                ALU_s1_load == ALU_s1_t &&
                ALU_s2_load == ALU_s2_t &&
                ALU_op_load == ALU_op_t &&
                DataMem_rd_load == DataMem_rd_t && 
                Data_op_load == Data_op_t &&
                Data_s_load == Data_s_t && 
                Bc_Op_load == Bc_Op_t &&
                Data_we_load == Data_we_t
              ) begin
                $display("pass");
                testPassNum = testPassNum + 1;
             end
             
             end
        if(testFailNum == 0) $display("Yay, All tests passed,     passed:", testPassNum, "        failed:",testFailNum);
        $fclose(file_pointer);
        
    end
endmodule
