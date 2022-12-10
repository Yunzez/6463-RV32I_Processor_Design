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

Head Head(
    .clk        (clk    ), 
    .rst_n      (rst    )
);

reg [4:0] round_count = 4'b0;
// load values
wire [31:0]pc_address_load = Head.ProgramCounter.PC_outputAddress;
wire [31:0]instr_address_load = Head.Instruction.read_instr;
wire [31:0]instr_output_load = Head.Instruction.instr_out;

wire [31:0]decoded_rd_addr_load = Head.rd_addr;
wire [31:0]decoded_rs1_addr_load = Head.Instruction_decode.rs1_addr;
wire [31:0]decoded_rs2_addr_load = Head.Instruction_decode.rs2_addr;
wire [6:0]decoded_opcode_load = Head.Instruction_decode.opcode;
wire [2:0]decoded_funct3 = Head.Instruction_decode.funct;

wire [2:0]next_state = Head.ControlUnit.testing_stage;

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
//Rst
initial begin
    #100
    rst = 1;
end 

always @(*) begin
    if(next_state  == 3'b010) round_count = round_count + 1'b1;
    $display("current cycle %d", round_count - 1'b1);
    if(round_count == 13) begin
        $display("current cycle %d", round_count - 1'b1, "enetering check for R-type");
        $display("values %d", r1, " %d", r2, " %d", r3," %d", r4," %d", r5," %d", r6," %d", r7," %d", r8," %d", r9," %d", r10," %d", r11," %d", r12 );
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
        #100
        $display("Rtype Test case passed");
        $finish;
    end 
    
//    $display("After Rtype Test, RESET");
//    rst = 1;
    
//     $display("Running Rtype Test, RESET");
    //     03208093	// addi x1,x1,50
    //81408113	// addi x2,x1,-2028
    //8140A193	// slti x3,x1,-2028
    //8140B213	// sltiu x4,x1,-2028
    //8140C293	// xori x5,x1,-2028
    //8140E313	// ori x6,x1,-2028
    //8140F393	// andi x7,x1,-2028
    //00311413	// slli x8,x2,3
    //00315493	// srli x9,x2,3
    
end 
//Instruction Memory Initialisation
reg [31:0] test =  Head.Instruction.rom_words[0];
reg [31:0] operand1 = 32'b000000110010;
reg [31:0] operand2 = 32'b000001100100;

// initial load command
//initial begin
//     $display("add insttuction to memory");
//    Head.Instruction.rom_words[0] = 32'b00000011001000001_000_00001_0010011; // addi x1,x1,50
//    $display("%b", Head.Instruction.rom_words[0]);
//    Head.Instruction.rom_words[1] = {operand2[11:0],20'b00010_000_00010_0010011}; // addi x2,x2,100
//    Head.Instruction.rom_words[2] = 32'b0000000_00010_00001_000_00011_0110011;    // add x3,x1,x2
//    Head.Instruction.rom_words[3] = 32'b0100000_00010_00001_000_00100_0110011;    // sub x4,x1,x2
    
//    Head.Instruction.rom_words[4] = 32'b0000000_00010_00001_001_00101_0110011;    // sll x5,x1,x2  
//    Head.Instruction.rom_words[5] = 32'b0000000_00010_00001_010_00110_0110011;    // slt x6,x1,x2  
    
//    Head.Instruction.rom_words[6] = 32'b0000000_00010_00001_011_00111_0110011;    // sltu x7,x1,x2  
    
//    Head.Instruction.rom_words[7] = 32'b0000000_00010_00001_100_01000_0110011;    // xor x8,x1,x2 
    
//    Head.Instruction.rom_words[8] = 32'b0000000_00010_00001_101_01001_0110011;    // srl x9,x1,4 
    
//    Head.Instruction.rom_words[9] = 32'b0100000_00010_00001_101_01010_0110011;    // sra x10,x1,x2 
    
//    Head.Instruction.rom_words[10]= 32'b0000000_00010_00001_110_01011_0110011;    // or x11,x1,x2 
//    Head.Instruction.rom_words[11]= 32'b0000000_00010_00001_111_01100_0110011;    // and x12,x1,x2 
//    $display("add insttuction successfully");
//end

//Verify
wire [31:0] signed_op1 = {{20{operand1[11]}},operand1[11:0]};
wire [31:0] signed_op2 = {{20{operand2[11]}},operand2[11:0]};



   
   



//clk
initial begin
    forever #(PERIOD/2)  clk=~clk;
end

endmodule
