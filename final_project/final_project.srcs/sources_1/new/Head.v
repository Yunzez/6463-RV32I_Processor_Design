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

// * processor_ctrl
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

// * pc  
    wire [31:0] current_pc;
    wire [31:0]PC_inputAddress;
    wire [31:0]PC_outputAddress;
    
    wire [31:0] added4_pc;
 
// * instr_mem
    wire [31:0]mem_instr_out;


// * registor_file
    
    // output
    wire [31:0] rs1;
    wire [31:0] rs2;

// * instruction decode
  
    // output
    wire [4:0] rd_addr;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [31:0] imm_ext_data;

// * alu_ctrl
    wire    [1:0]                   ALUop;
    wire                            has_funct7;

    // output 
    wire     [3:0]                   alu_ctrl;


//* alu
    wire    [31:0]                  operand1;
    wire    [31:0]                  operand2;

    // output
    wire     [31:0]                  alu_out;

// * data_mem
    wire    [2:0]                   w_mode;
    wire    [2:0]                   r_mode;
    wire    [9:0]                   opc_in;

    // dout 
    wire    [31:0]                  dout;                  
// * data ext 
    wire    [31:0]                  dout_ext;
// * testing variable 
    
    wire [2:0] control_next_stage;
     wire [31:0] instr_mem_addr_test;

// TODO: will add after branch contorl is done 

// //branch
    
    wire                            branch_true;
    wire                            alu_true;
    //////////////////////////////////////////////////////////////////////////////////
    //Module
    //////////////////////////////////////////////////////////////////////////////////
    ControlUnit ControlUnit(
    // input
    .clk                         (clk                ),
    .rst                         (rst_n              ),
    .opcode                      (opcode   ), // ! this will get opcode (last 7 bits of instr output from memory)
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
    .Data_we(Data_we),
    
    // ! testing purpose only 
    .testing_stage(control_next_stage)
    );

    ProgramCounter ProgramCounter(
        .clk                         (clk                ),
        .rst                         (rst_n              ),
        .write_en                    (PC_we              ),
        .PC_inputAddress             (PC_inputAddress    ),
        // output
        .PC_outputAddress            (PC_outputAddress   )
    );
    assign current_pc = PC_inputAddress;
    
    
    Instruction Instruction(
        .clk                         (clk                ),
        .rst                         (rst_n              ),
        .read_instr                  (Instr_rd),
        .addr_in(PC_outputAddress),
        
        
        .test_addr(instr_mem_addr_test),

        // output
        .instr_out(mem_instr_out)
    );
    
    RegisterFile RegisterFile(
        .clk  (clk),
        .rst  (rst_n),
        .en   (RegFile_we), 
        .readS1(rs1_addr), // take it from instr_decode
        .readS2(rs2_addr), // take it from instr_decode
        .readRd(rd_addr),// take it from instr_decode
        .data_in(readRd), // this is generated in reg mux
        
        //output 
        .rs1(rs1),
        .rs2(rs2)
    );
   Instruction_decode Instruction_decode(
        .clk(clk), 
        .instr_in(mem_instr_out), // memory output will be take in here
        
        // output
        .rd_addr(rd_addr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .opcode(opcode),
        .funct(funct3)
    );
    
    // after decode, we will go to imm_ext if needed
    imm_ext imm_ext(
        .clk(clk),
        .opcode(opcode),
        .instr_in(mem_instr_out),
        
        // output 
        .imm_ext(imm_ext_data)
    );

    Branch_control Branch_control(
        .operand1(operand1),
        .operand2(operand2),
        .bc_enable(Bc_Op),// take in control unit branch enable
        .funct3(funct3),
        .bc_out(branch_info)
    );
    
    ALU_Control ALU_Control(
        .clk(clk),
        .rst(rst_n),
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
        // output
        .alu_out(alu_out)
    );
    
    data data(     
     .clk(clk),
     .we_en(Data_we),
     .func3(funct3),   //0001--SB, 0011--SH, 1111--SW, 0000--write disable
     .re(DataMem_rd),
     .addr(alu_out), // alu output will be send to data as address
     .dmem_in(rs2), // reg 2 will be send as data in 
     
     // output 
     .dmem_out(dout)
    );
    
    data_ext data_ext(
        .data_in(dout),
        .funt3(funct3),
        .data_out(dout_ext)
    );

    // ! for data imm mux output

    reg [31:0] data_imm_s;

    // ! here we will start implement muxes that are needed for different area 

    // * mux variable 
    reg [31:0] PC_input_addr_temp;
    reg [4:0] readRd_temp;
    reg [31:0] operand1_temp;
    reg [31:0] operand2_temp;

    // *pc_adder
    assign added4_pc = PC_outputAddress + 32'd4;
        
    // *pc_mux
    // ! the input address will get assigned to output directly
    always @(posedge clk or negedge rst_n) begin
        if(PC_s == 0) PC_input_addr_temp = added4_pc;
        else PC_input_addr_temp = alu_out;
    end
    
    assign PC_inputAddress = PC_input_addr_temp;

    // *regfile mux
    always @(posedge clk or negedge rst_n) begin
        if(RegFile_s == 0) readRd_temp = added4_pc;
        else readRd_temp = data_imm_s;
    end
    assign readRd = readRd_temp;
        
    // *ALU mux 1
    always @(posedge clk or negedge rst_n) begin
        if(ALU_s1 == 0) operand1_temp = rs1;
        else operand1_temp = PC_inputAddress;
    end
    assign operand1 = operand1_temp;
     
    // *ALU mux 2
    always @(posedge clk or negedge rst_n) begin
        if(ALU_s2 == 1) operand2_temp = rs2;
        else operand2_temp = imm_ext_data;
    end
    assign operand2 = operand2_temp;
    
    // *Data mem mux
    always @(posedge clk or negedge rst_n) begin
        if(Data_s == 0) data_imm_s = dout_ext;
        else data_imm_s = alu_out;
    end

endmodule
