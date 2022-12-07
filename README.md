# NYU-6463-RV32I_Processor_Design

---

- Fred Zhao, netId: yz8751. Components: Control Unit, Mux, PC, Instruction Decode, imm_extension, Top Level Head 
- Rongze LI, netId: rl4670. Components: ALU, ALU control, 
- Junqing Zhao, netId: jz5954.  Components: Instr Mem, Data Mem, 
---
The NYU-6463-RV32I processor is a 32-bit architecture which executes a subset of the open source RISC-V RV32I
instruction set. 
---
***module***
1. ALU 
- Variables:
takes in alu_ctrl, operand1, operand2
returns alu_out

- Des:
ALU implements the four categories calculation according to the ALU control obtained from ALU control including addition, substraction, AND and OR.

- Testbench:
The testbench of the ALU go through all the basic calculation. The outputs are as expected currently, but more cases need to be validated in the future.

---
2. ALU Control 
- Variables:
takes in clk, rst, ALUop, funct3, funct7
returns alu_ctrl

- Des:
ALU Control implements the calculation instruction recognition according to the input instruction, which includes add, sub, and, or calculation.

- Testbench:
The testbench of the ALU go through all the instruction combination basically. The outputs are as expected currently, but more cases need to be validated in the future.

---
3. Control Unit 
- Variables: 
takes in Opcode, reset, enable, branch control signal;
returns PC_s, PC_we, Instr_rd, RegFile_s, RegFile_we, Imm_op, ALU_s1, ALU_s2, DataMem_rd, Data_op, Data_s, Bc_Op, Data_we, ALU_op

- Des: 
Control unit is a FSM that indicates what to do for the whole CPU by giving singal to different components. 
For now the Control Unit will only has 3 stages, we will add more stages if we realized more stages will be beneficial. 
The 3 stages are: Fetch, Execute, Write Memory.

- Testbench: 
The testbench of the Control unit go through all the opcode of all R, I, S, B, U, J types command. They all output the correct values as expected, even though the expected values may be changed in the future for design needs or when stages are added, but right now they all work as intended.  

---
4. Register File
- Variables: 
takes in reset, enable, readS1, readS2, readRd, data_in
returns r1_data, r2_data

- Des: 
The register file is the component that contains all the general purpose registers, it can store and read data depends on instrcution and the address provided. 

- Testbench: 
The testbench of the register file test if the register file can store the data provided to the address provided, with correct output data. And makes sure it can handle enable and reset signal correctly. 

---
5. Instruction Memory 
- Variables:
takes in read_instr(read instruction), addr_in
returns instr_out

- Des:
The instruction memory is a ROM which means the memory file cannot be load or delete. The instruction memory can store up to 512 32-bits instructions. These instruction read from memory. We still have some testing variables in here. 

- Testbench:
The test file instruction.mem contain memory data for test. You might need to readded it manually to test it.

---
6. Data Memory
- Variables:
takes in w_mode, r_mode, addr_in, din, func3
returns dout

- Des:
The functions of data memory include stroing, reading and resetting operations. User could switch read mode to read data or write mode to write data in memory file. This data memory program supports all byte-addressing operations.

- Testbench:
The testbench testing the memory program by storing data into different place by using various addresses, then read the data and check if read data match with expected value. 

---
7. Other small components: PC, MUX will not be tested for milestone 1. 

