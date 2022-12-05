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
    clk,
    rst_n
    );
    
    input  wire                     clk;
    input  wire                     rst_n;

//processor_ctrl
// output wire
    wire PC_s; 
    wire PC_we; // pc enable signal
    wire Instr_rd; // control instruction enable
    wire RegFile_s; 
    wire RegFile_we; 
    wire Imm_op; 
    wire ALU_s1; 
    wire ALU_s2; 
    wire DataMem_rd; 
    wire Data_op; 
    wire Data_s; 
    wire Bc_Op; 
    wire Data_we;

// pc  
    wire PC_inputAddress;
    wire PC_outputAddress;
    
 
//instr_mem

wire addr_in;
wire instr_out;


//registor_file
wire                            RegWrite;
wire    [31:0]                  rd_data_in;
wire    [31:0]                  rs1_data;
wire    [31:0]                  rs2_data;

//imm_gen
reg     [31:0]                  imm_ext;
wire    [31:0]                  imm_ext_tmp;

//alu_ctrl
wire    [3:0]                   alu_op;

//alu
wire    [31:0]                  operand1;
wire    [31:0]                  operand2;
wire    [31:0]                  alu_out_tmp;
reg     [31:0]                  alu_out;

//data_mem
wire                            MemRead;
wire    [3:0]                   MemWrite;
wire    [31:0]                  dmem_out;                  

//data_ext
wire    [31:0]                  data_ext_out;

//branch
wire    [2:0]                   funct3;
wire                            branch_true;
wire                            alu_true;
    //////////////////////////////////////////////////////////////////////////////////
    //Module
    //////////////////////////////////////////////////////////////////////////////////
    ControlUnit ControlUnit(
    // input
    .clk                         (clk                ),
    .rst                         (rst_n              ),
    .opcode                      (instruction[6:0]   ),
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
        .PC_inputAddress                  (PC_inputAddress             ),
        // output
        .PC_outputAddress                 (PC_outputAddress                 )
    );
    
    Instruction Instruction(
        .clk                         (clk                ),
        .rst                         (rst_n              ),
        .read_instr                  (Instr_rd),
        .addr_in(addr_in),
        .instr_out(instr_out)
    );
    
    RegisterFile RegisterFile(
        .clk  (clk),
        .rst  (rst_n),
        .en   (reg_en),
        .readS1 (readS1),
        .readS2(readS2),
        .readRd(readRd),
        .data_in(data_in),
        .rs1(rs1),
        .rs2(rs2)
    );
    
    Instruction_decode Instruction_decode(
        clk(clk), 
        instr_in(instr_in),
        rd_addr(rd_addr),
        rs1_addr(rs1_addr),
        rs2_addr(rs2_addr),
        opcode(opcode),
        funct(funct),
        imm_ext(imm_ext)
    );
    
    ALU_Control ALU_Control(
        .clk(clk),
        .rst(rst),
        .funct7(funct7),
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
     .addr_in(addr_in),
     .din(din),
     .opc_in(opc_in),
     .dout(dout)
    );
endmodule
