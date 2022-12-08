`timescale 1ns / 1ps

module data(
    input wire          clk,
    input wire [31:0]   addr,
    input wire [3:0]    we,             //0001--SB, 0011--SH, 1111--SW, 0000--write disable
    input wire          re,
    input wire [31:0]   dmem_in,
    output wire [31:0]   dmem_out
    );
    
    //declaraction
    parameter   depth = 1024;
    reg     [31:0]  dmem [1023:0];
    reg     [31:0]  rom  [0:7];
    wire    [9:0]   dmem_addr;
    wire    [31:0]  dmem_out_tmp;
    wire            w_en;
    wire    [7:0]   dmem_in_0;
    wire    [7:0]   dmem_in_1;
    wire    [7:0]   dmem_in_2;
    wire    [7:0]   dmem_in_3;
    wire    [31:0]  dmem_tmp;
    reg     [31:0]  data_out;


    //initialize data memory and rom    
    initial begin
        $readmemh("dmem_zeros.txt",dmem);
    end

    (*rom_style = "block" *) reg [32:0] rom_data;
    always @(posedge clk) begin
        if(re)
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

    assign dmem_in_0 = we[0] ? dmem_in[7:0] : dmem[dmem_addr][7:0];
    assign dmem_in_1 = we[1] ? dmem_in[15:8] : dmem[dmem_addr][15:8];
    assign dmem_in_2 = we[2] ? dmem_in[23:16] : dmem[dmem_addr][23:16];
    assign dmem_in_3 = we[3] ? dmem_in[31:24] : dmem[dmem_addr][31:24];
    assign dmem_tmp   = {dmem_in_3,dmem_in_2,dmem_in_1,dmem_in_0};

    //DATA MEMORY 
    always@(posedge clk) begin
        if(we) begin
            dmem[dmem_addr]    <= dmem_tmp;
        end
    end

    always@(posedge clk) begin
        if(re) begin 
            data_out <= dmem[dmem_addr];
        end
    end

    assign dmem_out = addr[31]? data_out
                    : addr[20]? rom_data
                    : 'hz;
endmodule