library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

use IEEE.NUMERIC_STD.ALL;


entity Testbench_DM is
--  Port ( );
end Testbench_DM;

architecture tdm_ach of Testbench_DM is

signal clk : std_logic := '0';
signal clr : std_logic := '1'; 
signal wm: std_logic_vector(2 downto 0) := "000";
signal rm: std_logic_vector(2 downto 0) := "000";
signal addr_t: std_logic_vector((32-1) downto 0) := X"80000000";
signal din_s: std_logic_vector((32-1) downto 0) := (others => '0');
signal dout_s: std_logic_vector((32-1) downto 0) := (others => '0');
signal opc_in: std_logic_vector(9 downto 0);
    
begin

--entity instantiation
--reference: https://vhdlwhiz.com/entity-instantiation-and-component-instantiation/
dut: entity work.Data
    Port map( 
        clk => clk,
        rst => clr,
        w_mode => wm,
        r_mode => rm,
        addr_in => addr_t,
        din => din_s,
        opc_in => opc_in,
        dout => dout_s
  );

clk_process:process begin 
    clk <= '0';
    wait for 5ns;
    clk <= '1';
    wait for 5ns;
end process;

main: process begin
    wait for 10ns;
    
    wm <= "111";
    din_s <= X"11abcdef";
    wait for 10ns;
    addr_t <= addr_t + 8;
    wait for 10ns;
    
    addr_t <= addr_t + 8;
    wm <= "000";
    din_s <= X"00000011";
    wait for 10ns;
    addr_t <= addr_t + 1;
    wait for 10ns;

    wm <= "001"; 
    wait for 10ns;

    wm <= "011"; 
    din_s <= X"00002333";
    addr_t <= addr_t + 1;
    wait for 10ns;
    
    opc_in <= "0000000000";
    wm <= "000";
    addr_t <= addr_t - 2;
    rm <= "111";
    wait for 10ns;
    assert(dout_s = X"23331100") report "failed" severity FAILURE;
    addr_t <= addr_t + 1;
    wait for 10ns;
    assert(dout_s(23 downto 0) = X"233311") report "failed" severity FAILURE;
   
    rm <= "001";
    wait for 10ns;
    assert(dout_s = X"00000011") report "failed" severity FAILURE;

    rm <= "011";
    addr_t <= addr_t + 1;
    wait for 10ns;
    assert(dout_s = X"00002333") report "failed" severity FAILURE;
       
    rm <= "001";
    addr_t <= addr_t - (8+2);
    wait for 10ns;
    assert(dout_s = X"000000ef") report "failed" severity FAILURE;
    
    rm <= "111";
    wait for 10ns;
    assert(dout_s = X"11abcdef") report "failed" severity FAILURE;
    
    clr <= '0';
    wait for 10ns;
    assert(dout_s = X"00000000") report "failed" severity FAILURE;
    
    clr <= '1';
    rm <= "000";
    wait for 10ns;
    assert(dout_s = X"00000000") report "failed" severity FAILURE;
    
    rm <= "111";
    addr_t <= addr_t - 8;
    wait for 10ns;
    assert(dout_s = X"11abcdef") report "failed" severity FAILURE;
    
    report "All tests passed successfully!";
    std.env.stop;
    
end process;

end tdm_ach;
