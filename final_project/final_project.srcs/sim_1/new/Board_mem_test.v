`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2022 03:20:03 PM
// Design Name: 
// Module Name: Board_mem_test
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


module Board_mem_test(

    );
    
parameter f = 200;                   //Mhz
parameter PERIOD = 1/(f*0.001);
reg clk = 0;
reg rst = 0;
reg reset_mem = 0;


wire [15:0] placeholderLEDs;
wire [15:0] placeholderSwitches = 16'b11;

Head Head(
    .clk        (clk    ), 
    .rst_n      (rst    ),
   .boardLEDs (placeholderLEDs), 
   .boardSwitches(placeholderSwitches)
);
wire [31:0] r0 = Head.RegisterFile.rf[0]; 
wire [31:0] r1 = Head.RegisterFile.rf[1]; 
wire [31:0] r2 = Head.RegisterFile.rf[2];  
wire [31:0] r3 = Head.RegisterFile.rf[3]; 
wire [31:0] r4 = Head.RegisterFile.rf[4]; 
wire [31:0] r5 = Head.RegisterFile.rf[5]; 
//wire [31:0] r6 = Head.RegisterFile.rf[6];  
//wire [31:0] r7 = Head.RegisterFile.rf[7]; 
//wire [31:0] r8 = Head.RegisterFile.rf[8]; 
//wire [31:0] r9 = Head.RegisterFile.rf[9]; 
wire [31:0] r10 = Head.RegisterFile.rf[10]; 
wire toBranch = Head.Branch_control.bc_out;
wire [31:0]instr_output_load = Head.Instruction.instr_out;
wire [31:0]pc_address_load = Head.ProgramCounter.PC_outputAddress;
wire [31:0]decoded_rd_addr_load = Head.rd_addr;
wire [31:0] rs2_val = Head.RegisterFile.rs2; 
wire [31:0] rs1_val = Head.RegisterFile.rs1; 
wire [6:0]decoded_opcode_load = Head.Instruction_decode.opcode;
wire [2:0]decoded_funct3 = Head.Instruction_decode.funct;
wire [31:0] dmem_board = Head.data.board;
wire [15:0] led_temp = Head.data.LED_temp;
wire [31:0] alu_out = Head.ALU.alu_out;
wire [31:0] dmem_val_in = Head.data.dmem_in;
wire [31:0] dmem_address = Head.data.addr;
wire [31:0] dmem_switch = Head.data.dmem[16'h100010];
wire  [31:0] dmem [1023:0] = Head.data.dmem;
wire [31:0] dmem_led = Head.data.dmem[16'h00100014];

wire [31:0] branchControl_operand1 = Head.Branch_control.operand1;
wire [31:0] branchControl_operand2 = Head.Branch_control.operand2;
wire bc_out =  Head.Branch_control.bc_out;
wire [3:0] state = Head.ControlUnit.test_state;

wire PC_we = Head.ControlUnit.PC_we;
wire Instr_rd = Head.ControlUnit.Instr_rd;
wire RegFile_s = Head.ControlUnit.RegFile_s;
wire RegFile_we = Head.ControlUnit.RegFile_we;
//wire Imm_op = Head.ControlUnit.Imm_op
wire ALU_s1 = Head.ControlUnit.ALU_s1;
wire ALU_s2 = Head.ControlUnit.ALU_s2;
wire DataMem_rd = Head.ControlUnit.DataMem_rd;
wire Data_op = Head.ControlUnit.Data_op;
wire Data_s = Head.ControlUnit.Data_s;
wire Bc_Op = Head.ControlUnit.Bc_Op;
wire Data_we = Head.ControlUnit.Data_we;

initial begin
    #100
    rst = 1;
end 

//clk
initial begin
    forever #(PERIOD/2)  clk=~clk;
end

endmodule
