`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2022 12:24:53 PM
// Design Name: 
// Module Name: Data_mem
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


module data_mem(
    input wire          clk,
    input wire [31:0]   addr,
    input wire [3:0]    we,             //we will assume 0001--SB, 0011--SH, 1111--SW, 0000--write disable
    input wire          read,
    input wire [31:0]   data_in,
    output wire [31:0]   data_out
    );
    
    //declaraction
    parameter   depth = 1024;
    reg     [31:0]  dmem [depth-1:0];
    reg     [31:0]  rom  [0:7];
    wire    [9:0]   dmem_addr;
    wire    [31:0]  data_out_tmp;
    wire            w_en;
    wire    [7:0]   data_in_0;
    wire    [7:0]   data_in_1;
    wire    [7:0]   data_in_2;
    wire    [7:0]   data_in_3;
    wire    [31:0]  dmem_tmp;
    reg     [31:0]  data_out;


    //initialize data memory and rom    
    initial begin
        $readmemh("dmem_zeros.txt",dmem);
    end

    (*rom_style = "block" *) reg [32:0] rom_data;
    always @(posedge clk) begin
        if(read)
            case(addr[3:2])
                2'b00: rom_data <=32'd11311762;
                2'b01: rom_data <=32'd19816562;
                2'b10: rom_data <=32'd17003972;        
                2'b11: rom_data <=32'd0;
            endcase
    end

    //STORE INSTRUCTION DECODE
    assign w_en = we == 4'b0000;
    assign dmem_addr = addr[11:2];

    assign data_in_0 = we[0] ? data_in[7:0] : dmem[dmem_addr][7:0];
    assign data_in_1 = we[1] ? data_in[15:8] : dmem[dmem_addr][15:8];
    assign data_in_2 = we[2] ? data_in[23:16] : dmem[dmem_addr][23:16];
    assign data_in_3 = we[3] ? data_in[31:24] : dmem[dmem_addr][31:24];
    assign dmem_tmp   = {data_in_3,data_in_2,data_in_1,data_in_0};

    //DATA MEMORY 
    always@(posedge clk) begin
        if(we) begin
            dmem[dmem_addr]    <= dmem_tmp;
        end
    end

    always@(posedge clk) begin
        if(read) begin 
            data_out <= dmem[dmem_addr];
        end
    end

    assign data_out = addr[31]? data_out
                    : addr[20]? rom_data
                    : 'hz;
    

endmodule
