# NYU-6463-RV32I_Processor_Design

---
By
**Fred Zhao, netId: yz8751**
**Rongze LI, netId: rl4670**
**Junqing Zhao, netId: jz5954***
---
The NYU-6463-RV32I processor is a 32-bit architecture which executes a subset of the open source RISC-V RV32I
instruction set. 
---
***module***
1. ALU 
---
2. ALU Control 
---
3. Control Unit 
- Des: 
takes in Opcode, reset, enable, branch control signal;
returns PC_s, PC_we, Instr_rd, RegFile_s, RegFile_we, Imm_op, ALU_s1, ALU_s2, DataMem_rd, Data_op, Data_s, Bc_Op, Data_we, ALU_op

Control unit is a FSM that indicates what to do for the whole CPU by giving singal to different components. 
For now the Control Unit will only has 3 stages, we will add more stages if we realized more stages will be beneficial. 
The 3 stages are: Fetch, Execute, Write Memory.

- Testbench: 
The testbench of the Control unit go through all the opcode of all R, I, S, B, U, J types command. They all output the correct values as expected, even though the expected values may be changed in the future for design needs or when stages are added, but right now they all work as intended.  

---
4. Register File
---
5. Data Memory
---
6. Instruction Memory 
---
7. Branch Control Unit
---
