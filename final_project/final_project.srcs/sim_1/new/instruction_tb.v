

module Instruction_TB;
   
   
   reg         t_clk=0;
   reg         t_rst=0;
   reg         t_read_instr = 0;
   reg [31:0]  t_addr_in;
   wire [31:0] t_instr_out;
   
   
   Instruction dut(.clk(t_clk), .rst(t_rst), .read_instr(t_read_instr), .addr_in(t_addr_in), .instr_out(t_instr_out));
   
   
   always
   begin: clk_process
      t_clk <= 1'b0;
      #5;
      t_clk <= 1'b1;
      #5;
   end
   reg[31:0] file_instr;
   reg [31:0] instr_ram[0:511];
	initial begin   
		#1;
	   $readmemh ("instruction.mem", instr_ram);
		t_read_instr <= 1'b1;
		t_addr_in = 32'h01000000;
		file_instr = instr_ram[t_addr_in[23:2]] ;
		#10 ;
		if(t_instr_out != file_instr) begin
			t_read_instr = 0;
			$display("FAILURE: ");
			$display("Do not match (instruction)");
			$stop;
		end 
		else begin
			t_read_instr = 0;
		end 
		#40 ;
			
		repeat(511) 
		begin
			t_read_instr <= 1'b1;
			t_addr_in = t_addr_in + 4;
			file_instr = instr_ram[t_addr_in[23:2]]; //instead [31:2]
			#10 ;
			if(t_instr_out != file_instr) begin
				$display("FAILURE: ");
				$display("Do not match (instruction)");
				$stop;
			end 
			else begin
				t_read_instr = 0;
			end 
			#40 ;
		end 
			
		#28 t_rst =0;
		#2  t_rst = 1;
   
      $display("Test finished");
    end
      
endmodule

