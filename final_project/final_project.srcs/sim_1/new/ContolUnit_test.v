`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2022 04:50:33 PM
// Design Name: 
// Module Name: ContolUnit_test
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2022 01:25:19 PM
// Design Name: 
// Module Name: leftRotateVerilogTest
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


module ContolUnit_test();
    // original 
    reg clk_t;
    reg rst_t;
    
    reg [6:0]opcode_t;
    reg bc_t;
    
    wire PC_s_load, PC_we_load, Instr_rd_load, RegFile_s_load, 
    RegFile_we_load, Imm_op_load, ALU_s1_load, ALU_s2_load, 
    ALU_op_load, DataMem_rd_load, Data_op_load, data_s_load, Branch_load;
    
    wire [3:0]Data_we;
    wire [1:0]ALU_op_temp;
    
    // loader form test file
    reg [6:0]opcode_load;
    reg bc_load;
    reg [6:0]opcode_t;
    reg bc_t;


    integer testPassNum = 0;
    integer testFailNum = 0;
    
    localparam period = 10; 
    integer file_pointer; // file pointer
    
    ContolUnit dut (
        .clk(clk_t),
        .rst(rst_t ),
        .e_in(e_in_t ),
        .di_vld(di_vld_t ),
        .e_out(e_out_t ),
        .do_rdy(do_rdy_t)
    );
    
    initial begin
    $display("testing RC5 encoding");
        file_pointer = $fopen("decode_cycle_test.csv", "r");
        if(file_pointer == 0 ) begin 
            $display("cannot open testfile");
            $stop;
        end 
        $display("load test file successfully");
        
//        $fscanf(file_pointer, "%*[^\n]\n"); // skip first line
        while(!$feof(file_pointer)) begin
            $display("testing one line");
            #10;
            $fscanf(file_pointer, "%h,%h,%h", e_in_load, di_vld_load, e_out_load);
            $display("testing", e_in_load, di_vld_load, e_out_load);
                
            $display("initialize counter with rst");
                e_in_t =e_in_load;
                di_vld_t = di_vld_load;
                clk_t = 0;
                rst_t = 0;
                #period;
                rst_t = 1;
               
                
            while(do_rdy_t != 1) begin
                #period;
                clk_t = 1;
                #period;
                clk_t = 0;
            end
               
             if(do_rdy_t == 1 && e_out_load != e_out_t) begin
            
                $display("Test Failed!, test value =   ",e_out_load, "      actual value:", e_out_t);
                testFailNum = testFailNum + 1;
             end
             else if (e_out_load == e_out_t) begin
                $display("pass");
                testPassNum = testPassNum + 1;
             end
       
        end
        if(testFailNum == 0) $display("Yay, All tests passed,     passed:", testPassNum, "        failed:",testFailNum);
        $fclose(file_pointer);
        
    end

endmodule

