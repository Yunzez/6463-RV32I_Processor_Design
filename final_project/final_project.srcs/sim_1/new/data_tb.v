`timescale 1ns / 1ps

module Testbench_DM;
   
   
   reg             clk = 0;
   reg             clr = 1;
   reg [2:0]       wm = 3'b000;
   reg [2:0]       rm = 3'b000;
   reg [(32-1):0]  addr_t = 32'h8000_0000;
   reg [(32-1):0]  din_s = 0;
   wire [(32-1):0] dout_s ;
   reg [9:0]       opc_in;
   
   
   Data dut(.clk(clk), 
	.rst(clr),
	.w_mode(wm), 
	.r_mode(rm), 
	.addr_in(addr_t), 
	.din(din_s), 
	.opc_in(opc_in), 
	.dout(dout_s));
  
   always
   begin: clk_process
      clk <= 1'b0;

      #5;
      clk <= 1'b1;
      #5;
   end
   
   
	initial begin
      #10;
      wm <= 3'b111;
      din_s <= 32'h11abcdef;
      #10;
      addr_t <= addr_t + 8;
      #10;
      
      addr_t <= addr_t + 8;
      wm <= 3'b000;
      din_s <= 32'h00000011;
      #(10);
      addr_t <= addr_t + 1;
      #(10);
      
      wm <= 3'b001;
      #(10);
      
      wm <= 3'b011;
      din_s <= 32'h00002333;
      addr_t <= addr_t + 1;
      #(10);
      
      opc_in <= 10'b0000000000;
      wm <= 3'b000;
      addr_t <= addr_t - 2;
      rm <= 3'b111;
      #(10);
      if ((dout_s != 32'h23331100))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      addr_t <= addr_t + 1;
      #(10);
      if ((dout_s[23:0] != 24'h233311))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      rm <= 3'b001;
      #(10);
      if ((dout_s != 32'h00000011))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      rm <= 3'b011;
      addr_t <= addr_t + 1;
      #(10);
      if ((dout_s != 32'h00002333))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      rm <= 3'b001;
      addr_t <= addr_t - (8 + 2);
      #(10);
      if ((dout_s != 32'h000000ef))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      rm <= 3'b111;
      #(10);
      if ((dout_s != 32'h11abcdef))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      clr <= 1'b0;
      #(10);
      if ((dout_s != 32'h00000000))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      clr <= 1'b1;
      rm <= 3'b000;
      #(10);
      if ((dout_s != 32'h00000000))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      rm <= 3'b111;
      addr_t <= addr_t - 8;
      #(10);
      if ((dout_s != 32'h11abcdef))
      begin
         $write("FAILURE: ");
         $display("failed");
      end
      
      $display("All tests passed successfully!");
     
      end
      
endmodule

