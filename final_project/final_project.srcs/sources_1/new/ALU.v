`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 01:14:08 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    alu_ctrl,
    operand1,
    operand2,
    alu_out
    );
input wire [3:0] alu_ctrl;
input wire [31:0] operand1;
input wire [31:0] operand2;
output reg [31:0] alu_out;


wire        [31:0]  alu_add;
wire        [31:0]  alu_sub;
wire        [31:0]  alu_sll;
wire                less_then;
wire                u_less_then;
wire        [31:0]  alu_xor;
wire        [31:0]  alu_srl;
wire        [31:0]  alu_sra;
wire        [31:0]  alu_or;
wire        [31:0]  alu_and;
wire        [31:0]  shift_out;
wire        [31:0]  add1;
wire        [31:0]  add2;
wire        [31:0]  add_out;
wire                direction; //if direction = 1 -> left rotate, if direction = 0 -> right rotate


assign alu_sll = operand1 << operand2[4:0];
assign less_then = $signed(operand1) < $signed(operand2);
assign u_less_then = operand1 < operand2;
assign alu_xor = operand1 ^ operand2;
assign alu_sra = ({{31{operand1[31]}}, 1'b0} << (~operand2[4:0])) | (operand1 >> operand2[4:0]);
assign alu_or = operand1 | operand2;
assign alu_and = operand1 & operand2;

assign add1 = operand1;
assign add2 = alu_ctrl == 4'b1000 ? (~operand2 + 1'b1) : operand2;
assign add_out = add1 + add2;
assign direction = alu_ctrl == 4'b0001 ? 1'b1 : 1'b0;
    
// shifting 

wire    [4:0]   shift = operand2[4:0];

wire    [31:0]  right_string;
wire    [31:0]  srl_res;
wire	[31:0]	sll_res;
wire	[31:0]	shift_string;



assign right_string = {
                    operand1[0],operand1[1],operand1[2],operand1[3],operand1[4],operand1[5],operand1[6],operand1[7],
                    operand1[8],operand1[9],operand1[10],operand1[11],operand1[12],operand1[13],operand1[14],operand1[15],
                    operand1[16],operand1[17],operand1[18],operand1[19],operand1[20],operand1[21],operand1[22],operand1[23],
                    operand1[24],operand1[25],operand1[26],operand1[27],operand1[28],operand1[29],operand1[30],operand1[31]
                    };

assign shift_string = direction ? operand1 : right_string; 
assign sll_res = shift_string << shift;
assign srl_res = {
               sll_res[0],sll_res[1],sll_res[2],sll_res[3],
               sll_res[4],sll_res[5],sll_res[6],sll_res[7],
               sll_res[8],sll_res[9],sll_res[10],sll_res[11],
               sll_res[12],sll_res[13],sll_res[14],sll_res[15],
               sll_res[16],sll_res[17],sll_res[18],sll_res[19],
               sll_res[20],sll_res[21],sll_res[22],sll_res[23],
               sll_res[24],sll_res[25],sll_res[26],sll_res[27],
               sll_res[28],sll_res[29],sll_res[30],sll_res[31]
               };

assign shift_out = direction ? sll_res : srl_res;
   


always @(*) begin
    case(alu_ctrl)
        4'b0000: alu_out = add_out;
        4'b1000: alu_out = add_out;       
        4'b0001: alu_out = shift_out;       
        4'b0010: alu_out = less_then;
        4'b0011: alu_out = u_less_then;
        4'b0100: alu_out = alu_xor;
        4'b0101: alu_out = shift_out;
        4'b1101: alu_out = alu_sra;
        4'b0110: alu_out = alu_or;
        4'b0111: alu_out = alu_and;
        default: alu_out = 32'd0;
     endcase
        
end
  
    
    
    
endmodule
