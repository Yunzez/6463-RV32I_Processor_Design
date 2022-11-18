library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Instruction is
  Port ( 
    clk : in std_logic := '0';
    rst : in std_logic := '1';
    read_instr: in std_logic := '1'; 
    addr_in: in std_logic_vector(31 downto 0) := X"01000000";
    addr_in2: in std_logic_vector(31 downto 0) := (others => '0');
    read_enable: in std_logic_vector(2 downto 0) := "000";
    instr_out: out std_logic_vector(31 downto 0);
    instr_out2: out std_logic_vector(31 downto 0)
  );
end Instruction;

architecture im_ach of Instruction is 
type rom is array(0 to 511) of std_logic_vector(31 downto 0);

impure function readInstruction(FileName : STRING) return rom;
signal rom_words: rom := readInstruction("instruction.mem");
signal addr_word: std_logic_vector(31 downto 0) := x"00000000";
signal addr1: std_logic_vector(31 downto 0);
signal addr_word2: std_logic_vector(31 downto 0) := x"00000000";
signal addr2: std_logic_vector(31 downto 0);

--This function cited from https://vhdlwhiz.com/impure-function/ and GitHub
impure function readInstruction(FileName : STRING) return rom is
    file FileHandle : TEXT open READ_MODE is FileName;
    variable CurrentLine : LINE;
    variable CurrentWord : std_logic_vector(31 downto 0);
    variable Result : rom := (others => (others => 'X'));
    
    begin
    --store up to 512 instructions
    for i in 0 to 511 loop
        exit when endfile(FileHandle);
        readline(FileHandle, CurrentLine);
        hread(CurrentLine, CurrentWord);
        for j in 0 to 3 loop
            Result(i)( ((j+1)*8)-1 downto (j*8)) := CurrentWord( ((4-j)*8)-1 downto (4-(j+1))*8 );
        end loop;
    end loop;
    
    return Result;
    
end function;
begin

--split stored memory as seperate instructions to register
addr1 <= addr_in and (not X"01000000");
addr_word(29 downto 0) <= addr1(31 downto 2);
process(clk) begin
    if rising_edge(clk) then
        if(read_instr = '1') then
            instr_out(31 downto 24) <= rom_words(to_integer(unsigned(addr_word)))( 7 downto  0);
            instr_out(23 downto 16) <= rom_words(to_integer(unsigned(addr_word)))(15 downto  8);
            instr_out(15 downto  8) <= rom_words(to_integer(unsigned(addr_word)))(23 downto 16);
            instr_out( 7 downto  0) <= rom_words(to_integer(unsigned(addr_word)))(31 downto 24);
        end if;
    end if;
end process;

addr2 <= addr_in2 and (not X"01000000");
addr_word2(29 downto 0) <= addr2(31 downto 2);
process(rst,clk) begin
    if(rst = '0') then
        instr_out2 <= (others => '0');
    elsif rising_edge(clk) then
        if(addr2 < 4) then
            if(read_enable = "111") then
                --Little-endian
                instr_out2(31 downto 24) <= rom_words(to_integer(unsigned(addr_word2)))( 7 downto  0);
                instr_out2(23 downto 16) <= rom_words(to_integer(unsigned(addr_word2)))(15 downto  8);
                instr_out2(15 downto  8) <= rom_words(to_integer(unsigned(addr_word2)))(23 downto 16);
                instr_out2( 7 downto  0) <= rom_words(to_integer(unsigned(addr_word2)))(31 downto 24);
            else
                instr_out2 <= (others => '0');
            
            end if;
        else
            instr_out2 <= (others => '0');
            
        end if;
    end if;
end process;

end im_ach;