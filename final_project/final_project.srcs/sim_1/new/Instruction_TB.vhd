--copilot used
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Instruction_TB is
--  Port ( );
end Instruction_TB;

architecture arcInstruction_TB of Instruction_TB is 

signal t_clk : std_logic := '0';
signal t_rst : std_logic := '1';
signal t_read_instr: std_logic := '1';
signal t_addr_in: std_logic_vector(31 downto 0) := X"01000000";
signal t_instr_out: std_logic_vector(31 downto 0);
signal t_read_enable: std_logic_vector(2 downto 0) := "000"; 

begin
--entity instantiation
--reference: https://vhdlwhiz.com/entity-instantiation-and-component-instantiation/
dut: entity work.Instruction
    Port map( 
    clk => t_clk,
    rst => t_rst,
    read_instr => t_read_instr,
    addr_in => t_addr_in,
    instr_out => t_instr_out,
    read_enable => t_read_enable
  );

clk_process:process 
begin 
    t_clk <= '0';
    wait for 5ns;
    t_clk <= '1';
    wait for 5ns;
end process;

main: process
file file_pointer: text;
variable l:line;
variable file_instr: std_logic_vector(31 downto 0);

begin
    --read all text
    file_open(file_pointer,"instruction.mem",read_mode);
    readline(file_pointer,l);
    hread(l,file_instr);
    t_read_instr <= '1';
    wait for 10 ns;
    assert(t_instr_out=file_instr) report "Do not match (instruction)" severity FAILURE;
    t_read_instr <= '0';
    wait for 40 ns;
    
    --load all text
    while not endfile(file_pointer)loop
        readline(file_pointer,l);
        hread(l,file_instr);
        t_read_instr <= '1';
        t_addr_in <= t_addr_in + 4;
        wait for 10 ns;
        assert(t_instr_out=file_instr) report "Do not match" severity FAILURE;
        t_read_instr <= '0';
        wait for 40 ns;
    end loop;
    t_read_enable <= "111";
    wait for 10 ns;
    
    t_read_enable <= "011";
    wait for 10 ns;
    
    t_read_enable <= "001";
    wait for 10 ns;
        
    wait for 28 ns;
    t_rst <= '0';
    wait for 2 ns;
    t_rst <= '1';
    
    report "Test finished";
    std.env.stop;

end process;

end arcInstruction_TB;