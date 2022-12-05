`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2022 05:55:11 PM
// Design Name: 
// Module Name: Head
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


module Head(
    input   clk,
    input   rst_n
    );

//processor_ctrl
// output wire
    wire PC_s; 
    wire PC_we; // pc enable signal
    wire Instr_rd; // control instruction enable
    wire RegFile_s; 
    wire RegFile_we; // this is reg_enable
    wire Imm_op; 
    wire ALU_s1; 
    wire ALU_s2; 
    wire DataMem_rd; 
    wire Data_op; 
    wire Data_s; 
    wire Bc_Op; 
    wire Data_we;

    //TODO: add data memory read/write enable

// pc  
    wire [31:0]PC_inputAddress;
    wire [31:0]PC_outputAddress;
    
 
//instr_mem

    wire [31:0] Instr_addr_in;
    wire [31:0]instr_out;


//registor_file
    
    
    wire [4:0]readS1;
    wire [4:0]readS2;
    wire [4:0]readRd;
    wire [31:0] data_in;
    // output
    wire [31:0] rs1;
    wire [31:0] rs2;

//instruction decode
    
    wire [31:0]instr_in;
    
    // output
    wire [4:0] rd_addr;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [6:0] opcode;
    wire [2:0] funct;
    wire [31:0] imm_ext;

//alu_ctrl
    wire    [1:0]                   ALUop;
    wire    [2:0]                   funct3;
    wire                            has_funct7;

    // output 
    wire     [3:0]                   alu_ctrl;


//alu
    wire    [31:0]                  operand1;
    wire    [31:0]                  operand2;

    // output
    wire     [31:0]                  alu_out;

//data_mem
    wire    [2:0]                   w_mode;
    wire    [2:0]                   r_mode;
    wire    [31:0]                  data_addr_in;
    wire    [31:0]                  din;
    wire    [9:0]                   opc_in;

    // dout 
    wire    [31:0]                  dout;                  


// TODO: will add after branch contorl is done 
// //branch
// wire    [2:0]                   funct3;
// wire                            branch_true;
// wire                            alu_true;
    //////////////////////////////////////////////////////////////////////////////////
    //Module
    //////////////////////////////////////////////////////////////////////////////////
    ControlUnit ControlUnit(
    // input
    .clk                         (clk                ),
    .rst                         (rst_n              ),
    .opcode                      (opcode   ),
    .bc                          (branch_info),
    
    //output
    .PC_s(PC_s), 
    .PC_we(PC_we), 
    .Instr_rd(Instr_rd), 
    .RegFile_s(RegFile_s), 
    .RegFile_we(RegFile_we), 
    .Imm_op(Imm_op), 
    .ALU_s1(ALU_s1), 
    .ALU_s2(ALU_s2), 
    .DataMem_rd(DataMem_rd), 
    .Data_op(Data_op), 
    .Data_s(Data_s), 
    .Bc_Op(Bc_Op), 
    .Data_we(Data_we)
    );

    ProgramCounter ProgramCounter(
        .clk                         (clk                ),
        .rst                         (rst_n              ),
        .en                          (PC_we              ),
        .PC_inputAddress             (PC_inputAddress             ),
        // output
        .PC_outputAddress            (PC_outputAddress                 )
    );
    
    Instruction Instruction(
        .clk                         (clk                ),
        .rst                         (rst_n              ),
        .read_instr                  (Instr_rd),
        .addr_in(Instr_addr_in),

        // output
        .instr_out(instr_out)
    );
    
    RegisterFile RegisterFile(
        .clk  (clk),
        .rst  (rst_n),
        .en   (RegFile_we), 
        .readS1 (readS1),
        .readS2(readS2),
        .readRd(readRd),
        .data_in(data_in),
        .rs1(rs1),
        .rs2(rs2)
    );
    
    Instruction_decode Instruction_decode(
        .clk(clk), 
        .instr_in(instr_in),
        .rd_addr(rd_addr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .opcode(opcode),
        .funct(funct),
        .imm_ext(imm_ext)
    );
    
    ALU_Control ALU_Control(
        .clk(clk),
        .rst(rst),
        .funct7(has_funct7),
        .ALUop(ALUop),
        .funct3(funct3),
        
        // output 
        .alu_ctrl(alu_ctrl)
    );
    
    ALU ALU(
        .alu_ctrl(alu_ctrl),
        .operand1(operand1),
        .operand2(operand2),
        .alu_out(alu_out)
    );
    
    Data Data(
     .clk(clk),
     .rst(data_rst),
     .w_mode(w_mode),
     .r_mode(r_mode),
     .addr_in(data_addr_in),
     .din(din),
     .opc_in(opc_in),
     .dout(dout)
    );
    
endmodule
