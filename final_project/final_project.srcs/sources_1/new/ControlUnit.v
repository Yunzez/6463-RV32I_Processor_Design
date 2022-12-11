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
//    input [2:0]funct3,
    input bc, // branch info
    output [2:0] testing_stage,
    output reg PC_s, PC_we, Instr_rd, RegFile_s, RegFile_we, Imm_op, ALU_s1, ALU_s2, DataMem_rd, Data_op, Data_s, Bc_Op,Data_we,
    output reg [1:0]ALU_op
    );
    
    reg [2:0]curr_state;
    reg [2:0]next_state;
    
    parameter INITALIZE  = 3'b000;
    parameter FETCH_INSTRUCTION  = 3'b001;
    parameter FETCH_DECODE  = 3'b010;
    parameter EXECUTION    = 3'b011;
    parameter MEM    = 3'b100;
    parameter WRITEBACK    = 3'b101;
    parameter HALT  = 3'b110;
   
   reg PC_s_temp, PC_we_temp, Instr_rd_temp, RegFile_s_temp, RegFile_we_temp, Imm_op_temp, ALU_s1_temp, ALU_s2_temp, DataMem_rd_temp, Data_op_temp, Data_s_temp, Bc_Op_temp, Data_we_temp; 
   reg [1:0] ALU_op_temp;      
 
    assign testing_stage = curr_state;
    always @(posedge clk or negedge rst) begin
        if(!rst)
            curr_state   <= INITALIZE;
        else
            curr_state   <= next_state;
            
    end
    
    always @(posedge clk) begin
     case(curr_state)
        INITALIZE: begin
        // we set:
                PC_s_temp = 1'b0; // we set when pc s is 1; program counter plus 4
                PC_we_temp = 1'b0; // allow adder write to pc  
                Instr_rd_temp = 1'b1; // get the current memory
                RegFile_s_temp = 1'b0; 
                // that's all the signal we need to get the command 
                RegFile_we_temp = 1'b0; 
                Imm_op_temp = 1'b0; 
                ALU_s1_temp = 1'b0; 
                ALU_s2_temp = 1'b0; 
                ALU_op_temp = 2'b00;
                DataMem_rd_temp = 1'b0; 
                Data_op_temp = 2'b00; 
                Data_s_temp = 1'b0;
                Data_we_temp = 1'b0;
                Bc_Op_temp = 1'b0;
               
        end
        
        FETCH_INSTRUCTION: begin
                PC_s_temp = 1'b0; 
                PC_we_temp = 1'b0; // allow adder write to pc  
                Instr_rd_temp = 1'b1; // get the current memory
                RegFile_s_temp = 1'b0; 
                // that's all the signal we need to get the command 
                RegFile_we_temp = 1'b0; 
                Imm_op_temp = 1'b0; 
                ALU_s1_temp = 1'b0; 
                ALU_s2_temp = 1'b0; 
                ALU_op_temp = 2'b00;
                DataMem_rd_temp = 1'b0; 
                Data_op_temp = 2'b00; 
                Data_s_temp = 1'b0;
                Data_we_temp = 1'b0;
                Bc_Op_temp = 1'b0;
        end
        
        FETCH_DECODE: begin
                PC_s_temp = 1'b0; 
                PC_we_temp = 1'b0; // allow adder write to pc  
                Instr_rd_temp = 1'b1; // get the current memory
                RegFile_s_temp = 1'b0; 
                // that's all the signal we need to get the command 
                RegFile_we_temp = 1'b0; 
                Imm_op_temp = 1'b0; 
                ALU_s1_temp = 1'b0; 
                ALU_s2_temp = 1'b0; 
                ALU_op_temp = 2'b00;
                DataMem_rd_temp = 1'b0; 
                Data_op_temp = 2'b00; 
                Data_s_temp = 1'b0;
                Data_we_temp = 1'b0;
                Bc_Op_temp = 1'b0;
        end
        
        EXECUTION: begin 
            case(opcode)
                7'b0110011: begin // R-type
                //rd = rs1 + rs2
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0;  
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; // let both s1 s2 take in rs data
                    ALU_s2_temp = 1'b1; 
                    ALU_op_temp = 2'b10; // enable alu R-type

                    // we do store in next stage
                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // set data swith to 1 so we get alu output
                    Data_we_temp = 1'b0; 
                    Bc_Op_temp = 1'b0;
                end

                7'b0000011: begin // I-type load and store in rd

                //rd=sign_ext(data[rs1+sign_ext(imm)][7:0])

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0;  
                    Imm_op_temp = 1'b1; 
                    ALU_s1_temp = 1'b0; // load rs1
                    ALU_s2_temp = 1'b0; // load imm
                    ALU_op_temp = 2'b00; // indicate store

                    DataMem_rd_temp = 1'b1; 
                    Data_op_temp = 1'b1; // enable data ext
                    Data_s_temp = 1'b0; // load data
                    Data_we_temp = 1'b0; 
                    Bc_Op_temp = 1'b0;
                end
                
                 7'b0010011: begin // for I type addi, ORI... 
                 // ! also implement fence here since it says to do the same as addi.

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0;  
                    Imm_op_temp = 1'b1; 
                    ALU_s1_temp = 1'b0; // load rs1
                    ALU_s2_temp = 1'b0; // load imm
                    ALU_op_temp = 2'b00; // indicate store

                    DataMem_rd_temp = 1'b1; 
                    Data_op_temp = 1'b1; // enable data ext
                    Data_s_temp = 1'b0; // load data
                    Data_we_temp = 1'b0; 
                    Bc_Op_temp = 1'b0;
                end
                
                7'b0001111: begin // this is the same as above 
                 // ! also implement fence here since it says to do the same as addi.

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0;  
                    Imm_op_temp = 1'b1; 
                    ALU_s1_temp = 1'b0; // load rs1
                    ALU_s2_temp = 1'b0; // load imm
                    ALU_op_temp = 2'b00; // indicate store

                    DataMem_rd_temp = 1'b1; 
                    Data_op_temp = 1'b1; // enable data ext
                    Data_s_temp = 1'b0; // load data
                    Data_we_temp = 1'b0; 
                    Bc_Op_temp = 1'b0;
                end

                 7'b0100011: begin // S-type store 
                 //e.g. data[rs1+sign_ext(imm)][7:0] = rs2[7:0]

                    PC_s_temp = 1'b1; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; 
                    Imm_op_temp = 1'b1; 
                    ALU_s1_temp = 1'b0;  // get rs 1
                    ALU_s2_temp = 1'b0;  // get imm
                    ALU_op_temp = 2'b00;  // add two address

                    // we need to wait for this step and then store
                    DataMem_rd_temp = 1'b0; // store to data
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0;
                    Data_we_temp = 1'b1; // TODO: check value  
                    Bc_Op_temp = 1'b0;
                end
                

                7'b1100011: begin // B-type Store ... of rs2 to memory
                // e.g. PC=(rs1==rs2) ? PC+sign_ext(imm) : PC+4

                    PC_s_temp = 1'b0; // take pc value from ALU
                    PC_we_temp = 1'b0;
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; // we need to store data in regfile 
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; // get rs1 value
                    ALU_s2_temp = 1'b1; // get rs2
                    ALU_op_temp = 2'b01; // cal: check branch

                    // may need to wait here 
                    DataMem_rd_temp = 1'b0; // 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0;
                    Data_we_temp = 1'b0; // TODO: check value 
                    Bc_Op_temp = 1'b1; // there will be branch
                end


                 7'b0110111: begin // U-type load
                    //e.g. rd={imm[31:12]; 12'b0}
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; 
                    Imm_op_temp = 1'b1; // set since we load imm
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0; // select imm
                    ALU_op_temp = 2'b00; // alu load

                    DataMem_rd_temp = 1'b1; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0;
                    Data_we_temp = 1'b0;  
                    Bc_Op_temp = 1'b0;
                end

                7'b1101111: begin // J-type jump and link 
                    
                //rd=PC+4; PC=PC+sign_ext(imm)
                    // we do rd=PC+4 this step
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; // take pc + 4 

                    RegFile_we_temp = 1'b1; // write pc + 4
                    Imm_op_temp = 1'b1; // set since we load imm
                    ALU_s1_temp = 1'b1; // select pc
                    ALU_s2_temp = 1'b0; // select imm
                    ALU_op_temp = 2'b10; // alu do plus

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0;
                    Data_we_temp = 1'b0; // need to double check 
                    Bc_Op_temp = 1'b0;
                end
            endcase
        end
        

        MEM: begin
            // this stage stores data back to reg or mem
            case(opcode)
                7'b0110011: begin // R-type
                //rd = rs1 + rs2
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; // add pc counter while store value, so we can continue
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; // select alu result

                    RegFile_we_temp = 1'b0;  // write alu result
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0;  
                    ALU_s2_temp = 1'b1; 
                    ALU_op_temp = 1'b00; 

                    //store 
                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // take ALU result
                    Data_we_temp = 1'b0; 
                    Bc_Op_temp = 1'b0;
                end

               7'b0000011: begin // I-type load and store in rd

                //rd=sign_ext(data[rs1+sign_ext(imm)][7:0])

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; // select data 

                    RegFile_we_temp = 1'b0;  // write data to reg
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00; 

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0; 
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end
                
                7'b0010011: begin // I-type addi ori andi ....
                // ! also implement fence here since it says to do the same as addi.
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; // select data 

                    RegFile_we_temp = 1'b0;  // write data to reg
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00; 

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // take alu cal output 
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end
                
                7'b0001111: begin // this is the same as above
                // ! also implement fence here since it says to do the same as addi.
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; // select data 

                    RegFile_we_temp = 1'b0;  // write data to reg
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00; 

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // take alu cal output 
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end

                 7'b0100011: begin // S-type store 
                 //e.g. data[rs1+sign_ext(imm)][7:0] = rs2[7:0]

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; 
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0;  
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00;  // store 
                    
                    // we need to wait for this step and then store
                    DataMem_rd_temp = 1'b1; // store to data
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0;
                    Data_we_temp = 1'b0; // TODO: check value  may depend on funct3
                    Bc_Op_temp = 1'b0;
                end

                 7'b1100011: begin // B-type Store ... of rs2 to memory
                // e.g. PC=(rs1==rs2) ? PC+sign_ext(imm) : PC+4

                    PC_s_temp = 1'b0; // choose what to take base on bc
                    PC_we_temp = 1'b0; // write pc 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; 
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b1; 
                    ALU_op_temp = 2'b01; // cal: check branch

                    // may need to wait here 
                    DataMem_rd_temp = 1'b0; // 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0; // ! branch info based on branch control 
                    Data_we_temp = 1'b0; // TODO: check value 
                    Bc_Op_temp = 1'b1; // use branch control
                end


                  7'b0110111: begin // U-type load
                    //e.g. rd={imm[31:12]; 12'b0}
                    PC_s_temp = 1'b1; 
                    PC_we_temp = 1'b0; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; // select ALu

                    RegFile_we_temp = 1'b0; // enable reg write
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0; 
                    ALU_op_temp = 2'b00; // alu load

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // choose alu
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end


                7'b1101111: begin // J-type jump and link 

                //rd=PC+4; PC=PC+sign_ext(imm)
                    // we do PC=PC+sign_ext(imm) this step
                    PC_s_temp = 1'b0; // choose alu value
                    PC_we_temp = 1'b0; // write alu value to pc
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; // write  PC=PC+sign_ext
                    Imm_op_temp = 1'b0;
                    ALU_s1_temp = 1'b0;
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00;

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0; //select ALU
                    Data_we_temp = 1'b0; // need to double check 
                    Bc_Op_temp = 1'b0;
                end  
            endcase
        end
        
        WRITEBACK: begin
                   case(opcode)
                7'b0110011: begin // R-type
                //rd = rs1 + rs2
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b1; // add pc counter while store value, so we can continue
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b1; // select alu result

                    RegFile_we_temp = 1'b1;  // write alu result
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0;  
                    ALU_s2_temp = 1'b1; 
                    ALU_op_temp = 1'b00; 

                    //store 
                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // take ALU result
                    Data_we_temp = 1'b0; 
                    Bc_Op_temp = 1'b0;
                end

               7'b0000011: begin // I-type load and store in rd

                //rd=sign_ext(data[rs1+sign_ext(imm)][7:0])

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b1; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b1; // select data 

                    RegFile_we_temp = 1'b1;  // write data to reg
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00; 

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0; 
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end
                
                7'b0010011: begin // I-type addi ori andi ....
                // ! also implement fence here since it says to do the same as addi.
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b1; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b1; // select data 

                    RegFile_we_temp = 1'b1;  // write data to reg
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00; 

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // take alu cal output 
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end
                
                7'b0001111: begin // this is the same as above
                // ! also implement fence here since it says to do the same as addi.
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b1; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b1; // select data 

                    RegFile_we_temp = 1'b1;  // write data to reg
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00; 

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // take alu cal output 
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end

                 7'b0100011: begin // S-type store 
                 //e.g. data[rs1+sign_ext(imm)][7:0] = rs2[7:0]

                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b1; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; 
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0;  
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00;  // store 
                    
                    // we need to wait for this step and then store
                    DataMem_rd_temp = 1'b1; // store to data
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0;
                    Data_we_temp = 1'b0; // TODO: check value  may depend on funct3
                    Bc_Op_temp = 1'b0;
                end

                 7'b1100011: begin // B-type Store ... of rs2 to memory
                // e.g. PC=(rs1==rs2) ? PC+sign_ext(imm) : PC+4

                    PC_s_temp = bc; // choose what to take base on bc
                    PC_we_temp = 1'b1; // write pc 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b0; 
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0; 
                    ALU_op_temp = 2'b01; // cal: check branch

                    // may need to wait here 
                    DataMem_rd_temp = 1'b0; // 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = bc; // ! branch info based on branch control 
                    Data_we_temp = 1'b0; // TODO: check value 
                    Bc_Op_temp = 1'b1; // use branch control
                end


                  7'b0110111: begin // U-type load
                    //e.g. rd={imm[31:12]; 12'b0}
                    PC_s_temp = 1'b0; 
                    PC_we_temp = 1'b1; 
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b1; // select ALu

                    RegFile_we_temp = 1'b1; // enable reg write
                    Imm_op_temp = 1'b0; 
                    ALU_s1_temp = 1'b0; 
                    ALU_s2_temp = 1'b0; 
                    ALU_op_temp = 2'b00; // alu load

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b1; // choose alu
                    Data_we_temp = 1'b0;
                    Bc_Op_temp = 1'b0;
                end


                7'b1101111: begin // J-type jump and link 

                //rd=PC+4; PC=PC+sign_ext(imm)
                    // we do PC=PC+sign_ext(imm) this step
                    PC_s_temp = 1'b1; // choose alu value
                    PC_we_temp = 1'b1; // write alu value to pc
                    Instr_rd_temp = 1'b0;
                    RegFile_s_temp = 1'b0; 

                    RegFile_we_temp = 1'b1; // write  PC=PC+sign_ext
                    Imm_op_temp = 1'b0;
                    ALU_s1_temp = 1'b0;
                    ALU_s2_temp = 1'b0;
                    ALU_op_temp = 2'b00;

                    DataMem_rd_temp = 1'b0; 
                    Data_op_temp = 1'b0; 
                    Data_s_temp = 1'b0; //select ALU
                    Data_we_temp = 1'b0; // need to double check 
                    Bc_Op_temp = 1'b0;
                end  
            endcase
        end
    endcase
   end
   
//   PC_s_temp, PC_we_temp, Instr_rd_temp, RegFile_s_temp, RegFile_we_temp, Imm_op_temp, ALU_s1_temp, ALU_s2_temp, DataMem_rd_temp, Data_op_temp, data_s_temp, Bc_Op_temp;
   always @(posedge clk or negedge rst) begin
    if(!rst) begin
        PC_s   = 1'b0;
        PC_we     = 1'b0;
        Instr_rd    = 1'b0;
        RegFile_s     = 1'b0;
        RegFile_we      = 1'b0;
        Imm_op = 1'b0;
        ALU_s1    = 1'b0;
        ALU_s2      = 2'b00;
        ALU_op_temp = 2'b00;
        DataMem_rd    = 1'b0;
        Data_op    = 1'b0;
        Data_s       = 1'b0; 
        Data_we  = 1'b0; 
        Bc_Op        = 1'b0; 
    end
    else begin
        PC_s         = PC_s_temp;
        PC_we        = PC_we_temp;
        Instr_rd     = Instr_rd_temp;
        RegFile_s    = RegFile_s_temp;
        RegFile_we   = RegFile_we_temp;
        Imm_op       = Imm_op_temp;
        ALU_s1       = ALU_s1_temp;
        ALU_s2       = ALU_s2_temp;
        ALU_op       = ALU_op_temp;
        DataMem_rd   = DataMem_rd_temp;
        Data_op      = Data_op_temp;
        Data_s       = Data_s_temp;
        Data_we      = Data_we_temp; 
        Bc_Op        = Bc_Op_temp;
    end
end
   
   //FSM
always @(*) begin
    case(curr_state)
        INITALIZE : 
            if(!rst)
                next_state = INITALIZE;
            else
                next_state = FETCH_INSTRUCTION;
                
        FETCH_INSTRUCTION :
            if(!rst)
                next_state = INITALIZE;
            else
                next_state = FETCH_DECODE;
                
        FETCH_DECODE: 
            if(!rst)
                next_state = INITALIZE;
            else if(opcode == 7'b1110011)
                next_state = HALT;
            else
                next_state = EXECUTION;
                
        EXECUTION :
            if(!rst)
                next_state = INITALIZE;
            else
                next_state = MEM;
                
        MEM : 
         if(!rst)
                next_state = INITALIZE;
         else
                next_state = WRITEBACK;
                
        WRITEBACK  : 
         if(!rst)
                next_state = INITALIZE;
         else
                next_state = FETCH_INSTRUCTION;
         HALT:
            if(!rst)
                next_state = INITALIZE;
            else
                next_state = HALT;
                
        default:
            next_state = INITALIZE;
    endcase
end
            
    
endmodule
