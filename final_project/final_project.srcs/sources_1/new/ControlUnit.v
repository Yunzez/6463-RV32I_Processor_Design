`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 01:14:08 AM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input clk, rst,
    input [6:0]opcode,
    input [2:0]funct3,
     
    output PC_s, PC_we, Instr_rd, RegFile_s, RegFile_we, Imm_op, ALU_s1, ALU_s2, ALU_op, DataMem_rd, Data_op, data_s, Branch,
    output [3:0]Data_we
    );
    
    reg [2:0]curr_state;
    reg [2:0]next_state;
    
    parameter FETCH  = 3'b000;
    parameter DECODE    = 3'b001;
    parameter EXECUTION    = 3'b010;
    parameter MEMREAD    = 3'b011;
    parameter BRANCH   = 3'b100;
   
   reg PC_s_temp, PC_we_temp, Instr_rd_temp, RegFile_s_temp, RegFile_we_temp, Imm_op_temp, ALU_s1_temp, ALU_s2_temp, ALU_op_temp, DataMem_rd_temp, Data_op_temp, data_s_temp, Branch_temp; 
   reg [3:0]Data_we_temp;                                              
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state   <= FETCH;
        else
            state   <= next_state;
    end
    
    // cases we have for op module 
    // 0110111 // R-type
    // 0010111 //Auipc//
    // 1101111 //Jal
    // 1100111 //Jalr
    // 1100011 //Branch
    // 0000011 //Load
    // 0100011 //Store
    // 0010011 I_TYPE
    // 0110011 //Lui
    
    always @(posedge clk) begin
     case(state)
        FETCH: begin
        // we set:
                PC_s_temp = 1'b1, // we set when pc s is 1, program counter plus 4
                PC_we_temp = 1'b1, // allow adder write to pc  
                Instr_rd_temp = 1'b1, // get the current memory
                RegFile_s_temp = 1'b1,  
                // that's all the signal we need to get the command 
                RegFile_we_temp = 1'b0, 
                Imm_op_temp = 1'b0, 
                ALU_s1_temp = 1'b0, 
                ALU_s2_temp = 1'b0, 
                ALU_op_temp = 1'b0,
                DataMem_rd_temp = 1'b0, 
                Data_op_temp = 1'b0, 
                Data_s_temp = 1'b0,
                Data_we_temp = 4'b0000
                Branch_temp = 1'b0
               
        end
        
        EXECUTION: begin 
            case(opcode)
                7'b0010011: begin // R-type
                    PC_s_temp = 1'b1, 
                    PC_we_temp = 1'b0, 
                    Instr_rd_temp = 1'b0,
                    RegFile_s_temp = 1'b1, // notigy reg to write 

                    RegFile_we_temp = 1'b1, // we need to store data in regfile 
                    Imm_op_temp = 1'b0, 
                    ALU_s1_temp = 1'b1, // enable both s1 s2 since we will need them for R-type
                    ALU_s2_temp = 1'b1, 
                    ALU_op_temp = 1'b1, // we will need ALU to calculate values
                    DataMem_rd_temp = 1'b0, 
                    Data_op_temp = 1'b0, 
                    Data_s_temp = 1'b0,
                    Data_we_temp = 4'b0000 // we do not need to change this too 
                    Branch_temp = 1'b0
                end

                7'b0000011: begin // I-type load and store
                    PC_s_temp = 1'b1, 
                    PC_we_temp = 1'b0, 
                    Instr_rd_temp = 1'b0,
                    RegFile_s_temp = 1'b1, // notigy reg to write 

                    RegFile_we_temp = 1'b1, // we need to store data in regfile 
                    Imm_op_temp = 1'b1, 
                    ALU_s1_temp = 1'b0, // enable both s1 s2 since we will need them for R-type
                    ALU_s2_temp = 1'b0, 
                    ALU_op_temp = 1'b0, // we will need ALU to calculate values
                    DataMem_rd_temp = 1'b0, 
                    Data_op_temp = 1'b0, 
                    Data_s_temp = 1'b0,
                    Data_we_temp = 4'b0000
                    Branch_temp = 1'b0
                end

                 7'b0100011: begin // S-type store 
                    PC_s_temp = 1'b1, 
                    PC_we_temp = 1'b0, 
                    Instr_rd_temp = 1'b0,
                    RegFile_s_temp = 1'b0, 

                    RegFile_we_temp = 1'b0, // we need to store data in regfile 
                    Imm_op_temp = 1'b0, 
                    ALU_s1_temp = 1'b0, // disable since we save it before we need ALU
                    ALU_s2_temp = 1'b0, 
                    ALU_op_temp = 1'b0, 
                    DataMem_rd_temp = 1'b0, 
                    Data_op_temp = 1'b0, 
                    Data_s_temp = 1'b0,
                    Data_we_temp = 4'b1111 // need to double check 
                    Branch_temp = 1'b0
                end

                7'b1100011: begin // B-type branch
                    PC_s_temp = 1'b1, 
                    PC_we_temp = 1'b0, 
                    Instr_rd_temp = 1'b0,
                    RegFile_s_temp = 1'b0, 

                    RegFile_we_temp = 1'b0, // we need to store data in regfile 
                    Imm_op_temp = 1'b0, 
                    ALU_s1_temp = 1'b1, // check if it can end branch
                    ALU_s2_temp = 1'b1, 
                    ALU_op_temp = 1'b1, 
                    DataMem_rd_temp = 1'b0, 
                    Data_op_temp = 1'b0, 
                    Data_s_temp = 1'b0,
                    Data_we_temp = 4'b1111 // need to double check 
                    Branch_temp = 1'b1 // there will be branch
                end


                 7'b0110111: begin // U-type load
                    PC_s_temp = 1'b1, 
                    PC_we_temp = 1'b0, 
                    Instr_rd_temp = 1'b0,
                    RegFile_s_temp = 1'b0, 

                    RegFile_we_temp = 1'b0, // we need to store data in regfile 
                    Imm_op_temp = 1'b1, // set since we load imm
                    ALU_s1_temp = 1'b0, // select pc
                    ALU_s2_temp = 1'b0, // select imm
                    ALU_op_temp = 1'b1, // alu do something
                    DataMem_rd_temp = 1'b1, // store in rd
                    Data_op_temp = 1'b0, 
                    Data_s_temp = 1'b0,
                    Data_we_temp = 4'b0000 // need to double check 
                    Branch_temp = 1'b1 // there will be branch
                end

                7'b0110111: begin // J-type jump and link 
                    PC_s_temp = 1'b0, // select output to be stored
                    PC_we_temp = 1'b0, 
                    Instr_rd_temp = 1'b0,
                    RegFile_s_temp = 1'b0, 

                    RegFile_we_temp = 1'b0, // we need to store data in regfile 
                    Imm_op_temp = 1'b1, // set since we load imm
                    ALU_s1_temp = 1'b0, // select pc
                    ALU_s2_temp = 1'b0, // select imm
                    ALU_op_temp = 1'b1, // alu do something
                    DataMem_rd_temp = 1'b1, // store in rd
                    Data_op_temp = 1'b0, 
                    Data_s_temp = 1'b0,
                    Data_we_temp = 4'b0000 // need to double check 
                    Branch_temp = 1'b1 // there will be branch
                end
            endcase
        end
        
    endcase
   end
   
   
   //FSM
always @(*) begin
    case(state)
        FETCH:
            if(!rst_n)
                next_state = FETCH;
            else
                next_state = DECODE;
        DECODE:
            if(!rst_n)
                next_state = FETCH;
            else
                next_state = EXECUTION;
        EXECUTION:
            if(!rst_n)
                next_state = FETCH;
            else
                next_state = MEMREAD;
        MEMREAD:
            if(!rst_n)
                next_state = FETCH;
            else
                next_state = MEMWRITEBACK;
        default:
            next_state = FETCH;
    endcase
end
            
    
endmodule
