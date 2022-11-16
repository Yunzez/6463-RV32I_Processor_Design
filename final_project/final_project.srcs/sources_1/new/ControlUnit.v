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
    input clk, rst, en,
    input [6:0]opcode,
    input [2:0]funct3,
    
    output  reg Branch, // true for branch not equal BNE
    output  reg PCUpdate, // set to true when we fetch next instruction, or when unconditional jump
    output  reg RegWrite,
    output  reg IRWrite,                 // write instruction register
    output  reg MemRead, // enable memory read
    output  reg MemWrite, // enable memory write
    output  reg AdrSrc, // address input to the memory
    output  reg ResultSrc, // which reseult to take to write back
    output  reg [1:0] ALUSrcB,
    output  reg [1:0] ALUSrcA,
    output  reg [1:0] ALUOptions // 00: add. 01:sub. 1-: look at func3
    );
    
    reg [2:0]curr_state;
    reg [2:0]next_state;
    
    parameter FETCH  = 3'b000;
    parameter DECODE    = 3'b001;
    parameter EXECUTION    = 3'b010;
    parameter MEMREAD    = 3'b011;
    parameter MEMWRITEBACK   = 3'b100;
   
      reg Branch_temp; // true for branch not equal BNE
      reg PCUpdate_temp; // set to true when we fetch next instruction, or when unconditional jump
      reg RegWrite_temp;
      reg IRWrite_temp ;                // write instruction register
      reg MemRead_temp; // enable memory read
      reg MemWrite_temp; // enable memory write
      reg AdrSrc_temp ;// address input to the memory
      reg ResultSrc_temp; // which reseult to take to write back
      reg [1:0] ALUSrcB_temp;
      reg [1:0] ALUSrcA_temp;
      reg [1:0] ALUOptions_temp; // 00: add. 01:sub. 1-: look at func3
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state   <= IF;
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
    
    always @(*) begin
     case(state)
        FETCH: begin
        // we set:
                AdrSrc_temp = 1'b0;// get the address
                IRWrite_temp = 1'b1; // read the AdrSrc 
                ALUSrcA_temp  = 2'b00; // tell ALU srcA to choose program counter 
                ALUSrcB_temp = 2'b00; // tell ALU srcB to do nothing
                ResultSrc_temp = 2'b10; // choose the result of the pc+4
                ALUOptions_temp = 2'b00; // indicate adds
                PCUpdate_temp = 1'b1; // increment PC counter so it loads the next instruction as we read the first one
        end
        
        DECODE : begin
            // wait to read out value of rs1 
            // wait to get immediate
        end
        
        
        
        INSRUCTIONLOAD: begin 
            case(opcode)
                7'b0110111: begin //LUI
    //            Loads the immediate value into the upper
    //            20 bits of the target register rd and sets
    //            the lower bits to 0
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
    
                end
                
                7'b0010111: begin // AUIPC
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b1101111: begin // JAL
//                Jump to PC=PC+(sign-extended
//                immediate value) and store the current PC
                    Branch_tmp      = 1'b1;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b1100111: begin //JALR
//                Jump to PC=rs1 register value
//                +(sign-extended immediate value) and
//                store the current PC address+4 in register
//                rd
                    Branch_tmp      = 1'b1;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b1100011: begin //BEQ...
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                end
                
                7'b0000011: begin //LB: load, calculate address
                    Branch_temp; // true for branch not equal BNE
                    PCUpdate_temp; // set to true when we fetch next instruction, or when unconditional jump
                    RegWrite_temp;
                    IRWrite_temp ;                // write instruction register
                    MemRead_temp; // enable memory read
                    MemWrite_temp; // enable memory write
                    AdrSrc_temp ;// address input to the memory
                    ResultSrc_temp; // which reseult to take to write back
                    ALUSrcB_temp = 2'b01;
                    ALUSrcA_temp = 2'b10;
                    ALUOptions_temp = 2'b00; // 00: add.
                end 
                
                7'b0100011: begin // SB
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b0010011: begin //ADDI 
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b0110011: begin //ADD
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b0001111: begin //FENCE 
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
                
                7'b1110011: begin //ECALL
                    Branch_tmp      = 1'b0;
                    ALUSrc_temp       = 1'b0;
                    MemRead_tmp     = 1'b0;
                    MemWrite_tmp    = 4'b0000;
                    ALUOptions_temp   = 2'b00;
                    MemtoReg_temp    = 1'b0;       
                    RegWrite_tmp    = 1'b0;
                 end
           endcase
        end
        
        MEMREAD: begin
            ResultSrc_temp  = 2'b00; // we choose to load in data we just calculated in ALU reg
            AdrSrc_temp = 1;
        end
        
        MEMWRITEBACK: begin 
            ResultSrc_temp  = 2'b01; // choose the data as the data we wanna right in
            RegWrite_temp = 1; // tell register file we are writing in 
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
