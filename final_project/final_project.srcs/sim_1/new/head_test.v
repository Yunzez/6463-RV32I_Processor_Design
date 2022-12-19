`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 08:31:21 PM
// Design Name: 
// Module Name: head_test
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


module head_test();
    // original wire 
parameter f = 200;                   //Mhz
parameter PERIOD = 1/(f*0.001);
reg clk = 0;
reg rst = 0;
reg reset_mem = 0;


wire [15:0] placeholderLEDs;
wire [15:0] placeholderSwitches = 16'b0;
Head Head(
    .clk        (clk    ), 
    .rst_n      (rst    ),
   .boardLEDs (placeholderLEDs), 
   .boardSwitches(placeholderSwitches)
);

//Data Memory Initialisation
reg [31:0] data0 = 32'b1;
reg [31:0] data1 = 32'b1111;
reg [31:0] data2 = 32'b1;

initial begin
    Head.data.dmem[0] = data0;
    Head.data.dmem[1] = data1;
    Head.data.dmem[2] = data2; 
end

reg [6:0] round_count = 6'b0;
// load values

wire [31:0] data_addr_in = Head.data.addr;
wire [31:0]pc_address_load = Head.ProgramCounter.PC_outputAddress;
wire [31:0]instr_address_load = Head.Instruction.read_instr;
wire [31:0]instr_output_load = Head.Instruction.instr_out;

wire [31:0]decoded_rd_addr_load = Head.rd_addr;
wire [31:0]decoded_rs1_addr_load = Head.Instruction_decode.rs1_addr;
wire [31:0]decoded_rs2_addr_load = Head.Instruction_decode.rs2_addr;
wire [6:0]decoded_opcode_load = Head.Instruction_decode.opcode;
wire [2:0]decoded_funct3 = Head.Instruction_decode.funct;

wire [31:0] r0 = Head.RegisterFile.rf[0]; 
wire [31:0] r1 = Head.RegisterFile.rf[1]; 
wire [31:0] r2 = Head.RegisterFile.rf[2];  
wire [31:0] r3 = Head.RegisterFile.rf[3]; 
wire [31:0] r4 = Head.RegisterFile.rf[4]; 
wire [31:0] r5 = Head.RegisterFile.rf[5]; 
wire [31:0] r6 = Head.RegisterFile.rf[6];  
wire [31:0] r7 = Head.RegisterFile.rf[7]; 
wire [31:0] r8 = Head.RegisterFile.rf[8]; 
wire [31:0] r9 = Head.RegisterFile.rf[9]; 
wire [31:0] r10 = Head.RegisterFile.rf[10]; 
wire [31:0] r11 = Head.RegisterFile.rf[11];  
wire [31:0] r12 = Head.RegisterFile.rf[12]; 
wire [31:0] r13 = Head.RegisterFile.rf[13]; 
wire [31:0] r14 = Head.RegisterFile.rf[14]; 
wire [31:0] r15= Head.RegisterFile.rf[15];  
wire [31:0] r16 = Head.RegisterFile.rf[16]; 
wire [31:0] r17 = Head.RegisterFile.rf[17]; 
wire [31:0] r18 = Head.RegisterFile.rf[18]; 
wire [31:0] r19 = Head.RegisterFile.rf[19];  
wire [31:0] r20 = Head.RegisterFile.rf[20]; 
wire [31:0] r21 = Head.RegisterFile.rf[21]; 
wire [31:0] r22 = Head.RegisterFile.rf[22]; 
wire [31:0] r23 = Head.RegisterFile.rf[23]; 
wire [31:0] r24 = Head.RegisterFile.rf[24];  
wire [31:0] r25 = Head.RegisterFile.rf[25]; 

wire [31:0] d1 = Head.data.dmem[1];
wire [31:0] d2 = Head.data.dmem[2];
wire [31:0] d3 = Head.data.dmem[3];
wire [31:0] d4 = Head.data.dmem[4];
wire [31:0] d5 = Head.data.dmem[5];

wire [31:0] alu_out = Head.ALU.alu_out;
wire [31:0] dmem_val_in = Head.data.dmem_in;
wire [2:0] dmem_func3_in = Head.data.func3;
wire [31:0] dmem_tmp = Head.data.dmem_tmp;
wire  dmem_rd = Head.ControlUnit.DataMem_rd;

wire [31:0] rs2_val = Head.RegisterFile.rs2; 
wire [31:0] rs1_val = Head.RegisterFile.rs1; 

wire Data_we = Head.ControlUnit.Data_we;
//value converting holder 


//Rst
initial begin
    #100
    rst = 1;
end 



//Instruction Memory Initialisation
reg [31:0] operand1 = 32'b000000110010;
reg [31:0] operand2 = 32'b000001100100;

//Verify
wire [31:0] signed_op1 = {{20{operand1[11]}},operand1[11:0]};
wire [31:0] signed_op2 = {{20{operand2[11]}},operand2[11:0]};     

// testing stage 
wire [3:0]next_state = Head.ControlUnit.test_state;

always @(*) begin
    if(next_state  == 4'd2) round_count = round_count + 1;
end 



    
always @(round_count) begin    
    if(round_count == 6'd13) begin
        $display("current cycle %d", round_count - 1'b1, "enetering check for R-type");
        if(r3 != signed_op1 + signed_op2)                       $display("Test case 'add' failed, actual value %d", r3, "  operand value: %d", operand1, "%d", operand2); // add x3,x1,x2
        if(r4 != signed_op1 - signed_op2)                       $display("Test case 'sub' failed,  operand value: 1, 2  %d", operand1, "%d", operand2, "expected %d", signed_op1 + signed_op2); // sub x4,x1,x2
        if(r5 != signed_op1 << signed_op2[4:0])                 $display("Test case 'sll' failed"); // sll x5,x1,x2 
        if(r6 != $signed(signed_op1) < $signed(signed_op2))     $display("Test case 'slt' failed");// slt x6,x1,x2 
        if(r7 != signed_op1 < signed_op2)                       $display("Test case 'sltu' failed");// sltu x7,x1,x2 
        if(r8 != (signed_op1 ^ signed_op2))                     $display("Test case 'xor' failed");// xor x8,x1,x2 
        if(r9 != signed_op1 >> signed_op2[4:0])                 $display("Test case 'srl' failed");// srl x9,x1,4 
        if(r10!= ($signed(signed_op1)) >>> signed_op2[4:0])     $display("Test case 'sra' failed");// sra x10,x1,x2 
        if(r11!= (signed_op1 | signed_op2))                     $display("Test case 'or' failed");// or x11,x1,x2 
        if(r12!= (signed_op1 & signed_op2))                     $display("Test case 'and' failed");// and x12,x1,x2 
        
        $display("Rtype Test case passed");
    end 
    
    else if(round_count == 6'd24) begin
        $display("current cycle %d", round_count - 1'b1, "enetering check for I-type");
        if(32'd50 != r13 )          $display("Ityp, addi failed");
        if(32'hfffff814 != r14 )          $display("Ityp, addi 2 failed");
        if(32'b0 != r15 )          $display("Ityp, slti failed");
        if(32'b1 != r16 )          $display("Ityp, sltiu failed");
        if(32'hfffff814 != r17 )          $display("Ityp, xori failed");
        if(32'hfffff814 != r18 )          $display("Ityp, ori failed");
        if(32'b0 != r19 )          $display("Ityp, andi failed");
        if(32'b11001000 != r20 )          $display("Ityp, slli failed");
        if(32'h3ffffe05 != r21 )          $display("Ityp, srli failed");
        if(32'b0 != r22 )          $display("Ityp, srai failed");
        $display("Itype test case passed");
        #100;
    end
    
    else if(round_count == 6'd28) begin 
        $display("testing LUI");   // lui  x1, imm,  10000000000000000001
        // lui stored restore value in x1  
        if(32'b10000000000000000001000000000000 != r1 ) $display("LUI failed");
        else  $display("LUI passed");
        $display("testing Load");
        if(32'b1 != r2) $display("Load word to r2 failed");
        if(32'b1111 != r3) $display("Load half to r3 failed");
        if(32'b1 != r4) $display("Load byte to r4 failed");
        $display("testing Load passed");
        #100;
    end
    // start at memory file line 27 for branch test
    else if(round_count == 6'd42) begin // ! we only wait till 35 because some command is jumped 
    // only one addi get executed 
    // r5 should be 1 
        if(r5 != 32'b1) $display("branch not passed");
        else $display("branch passed");
        
        if(r2 != 32'd13000639) $display("did not load first n-number passed");
        if(r3 != 32'd10923038) $display("did not load second n-number passed");
        if(r4 != 32'd19039807) $display("did not load third n-number passed");
        else $display("load n number passed");
         
    end
    // branch tests instruction at line 48 
     
     // store command tests starts at line 49 
     else if(round_count == 45) begin
        if(Head.data.dmem[3] != {{24{1'b0}},data2[7:0]})     $display("Test case 'SB' failed"); 
        if(Head.data.dmem[4] != {{16{1'b0}},data2[15:0]})    $display("Test case 'SH' failed"); 
        if(Head.data.dmem[5] != data2)                     $display("Test case 'SW' failed"); 
        $display("store passed");
     end
     // store command ends at line 51
     
     
     else if(round_count == 48) begin
//010002ef jump 4, store pc+ 4
//00000000
//00000000
//00000000
//00000000
        if(r5 != 32'h010000d0) $display("JAL not working");
//01020367
        if(r6 != 32'h0122864f) $display("JALR not working"); // r4 + 16
//00000000
//00000000
//00000000
//10000397 
       if(r7 != 32'h110000f0) $display("AUIPC not working"); // r4 + 16
        $display("Jtype test passed");
        
     end 
     
     else if (round_count == 42) begin
         $display("automatic halt --- ");
         $display("there are three fake instruction after halt, halt fails if see the commands 00000001, 00000002, 00000003");
         $finish;
     end 
     else begin 
     end
end 



//clk
initial begin
    forever #(PERIOD/2)  clk=~clk;
end

endmodule
