module Instruction
(
	input clk ,
	input rst,
	input read_instr,
	input [31:0] addr_in,
	output reg [31:0] instr_out
);
reg [31:0] rom_words[0:511];

initial begin
	 $readmemh ("instruction.mem", rom_words);
end 
wire [31:0] addr1 ;
assign addr1 = addr_in & (~(32'h01000000));
wire [31:0] addr_word;
assign addr_word = {2'b0,addr1[31:2]};//instead [29:2]
always @(posedge clk) 
begin
    if(read_instr ) begin
       instr_out <= rom_words[addr_word];
    end 
end 
endmodule
