library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data is
  Port ( 
    clk : in std_logic := '0';
    rst : in std_logic := '1'; 
    w_mode: in std_logic_vector(2 downto 0) := "000"; 
    r_mode: in std_logic_vector(2 downto 0) := "000"; 
    addr_in: in std_logic_vector(31 downto 0) :=  X"80000000";
    din: in std_logic_vector(31 downto 0) := (others => '0');
    opc_in: in std_logic_vector(9 downto 0);
    dout: out std_logic_vector(31 downto 0) := (others => '0')
  );
end Data;

architecture achData of Data is
type data_ram is array(0 to 1023) of std_logic_vector(7 downto 0);
signal dmem1: data_ram := (others => (others => '0'));
signal dmem2: data_ram := (others => (others => '0'));
signal dmem3: data_ram := (others => (others => '0'));
signal dmem4: data_ram := (others => (others => '0')); 
signal row: std_logic_vector(31 downto 0) := x"00000000";
signal addr_dmem: std_logic_vector(31 downto 0);
signal index_dmem: std_logic_vector(31 downto 0):= x"00000000";
signal index : integer;
signal dO: std_logic_vector(31 downto 0);
signal d_t: std_logic_vector(31 downto 0);         
signal dout_se: std_logic;
signal opcode: std_logic_vector(9 downto 0);
signal func7 : std_logic_vector(6 downto 0);
signal func3 : std_logic_vector(2 downto 0);

begin
addr_dmem <= (addr_in and (not  X"80000000"));
row(29 downto 0) <= addr_dmem(31 downto 2); 
index_dmem <= (addr_in and X"00000003"); 
index <= to_integer(unsigned(index_dmem));

opcode <= opc_in;
with opcode select dout_se <=
        '1' when "0000000011" | "0010000011",
        '0' when others; 

func7 <= opc_in(6 downto 0);
func3 <= opc_in(9 downto 7);

--reference: https://github.com/elvislzy/4-stage-rv32i
process(rst,clk) begin 
    if(rst = '0') then
        dO <= (others => '0');
    elsif rising_edge(clk) then
        if(addr_dmem < 4096) then
            if(r_mode = "001") then 
                case index is
                    when 0 => dO <= X"000000" & dmem1(to_integer(unsigned(row)));
                    when 1 => dO <= X"000000" & dmem2(to_integer(unsigned(row)));
                    when 2 => dO <= X"000000" & dmem3(to_integer(unsigned(row)));
                    when 3 => dO <= X"000000" & dmem4(to_integer(unsigned(row)));
                    when others => NULL;
                end case;
            
            elsif(r_mode = "011") then
                case index is
                    when 0 => dO <= X"0000" & dmem2(to_integer(unsigned(row))) & dmem1(to_integer(unsigned(row)));
                    when 1 => dO <= X"0000" & dmem3(to_integer(unsigned(row))) & dmem2(to_integer(unsigned(row)));
                    when 2 => dO <= X"0000" & dmem4(to_integer(unsigned(row))) & dmem3(to_integer(unsigned(row)));
                    when 3 => dO <= X"0000" & dmem1(to_integer(unsigned(row))+1) & dmem4(to_integer(unsigned(row)));
                    when others => NULL;
                end case;    
                
            elsif(r_mode = "111") then 
                case index is
                    when 0 => dO <= dmem4(to_integer(unsigned(row))) & dmem3(to_integer(unsigned(row))) & dmem2(to_integer(unsigned(row))) & dmem1(to_integer(unsigned(row)));
                    when 1 => dO <= dmem1(to_integer(unsigned(row))+1) & dmem4(to_integer(unsigned(row))) & dmem3(to_integer(unsigned(row))) & dmem2(to_integer(unsigned(row)));
                    when 2 => dO <= dmem2(to_integer(unsigned(row))+1) & dmem1(to_integer(unsigned(row))+1) & dmem4(to_integer(unsigned(row))) & dmem3(to_integer(unsigned(row)));
                    when 3 => dO <= dmem3(to_integer(unsigned(row))+1) & dmem2(to_integer(unsigned(row))+1) & dmem1(to_integer(unsigned(row))+1) & dmem4(to_integer(unsigned(row)));
                    when others => NULL;
                end case; 
                
            else
                dO <= (others => '0');
            end if;
        else
            dO <= (others => '0');
        end if;
    end if;
end process;

process(opc_in, dout_se, dO) begin
                if(dout_se = '1') then
                    case func3 is
                        when "000" => 
                            d_t <= std_logic_vector(resize(signed(dO(7 downto 0)), dO'length));
                        when "001" => 
                            d_t <= std_logic_vector(resize(signed(dO(15 downto 0)), dO'length));
                        when others => d_t <= dO;
                    end case;      
                else
                    case func3 is
                        when "100" => 
                            d_t <= std_logic_vector(resize(unsigned(dO(7 downto 0)), dO'length));
                        when "101" => 
                            d_t <= std_logic_vector(resize(unsigned(dO(15 downto 0)), dO'length));
                        when others => d_t <= dO;
                    end case;
                end if;
end process;
    
dout <= d_t;
process(clk) begin 
    if rising_edge(clk) then
        if(addr_dmem < 4096) then
            if(w_mode = "001") then 
                if(index = 0) then
                    dmem1(to_integer(unsigned(row))) <= din( 7 downto 0);
                end if;
            
            elsif(w_mode = "011") then 
                case index is       
                    when 0 => dmem1(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 3 => dmem1(to_integer(unsigned(row))+1) <= din( 15 downto  8);
                    when others => NULL;
                end case;              
    
            elsif(w_mode = "111") then 
                case index is       
                    when 0 => dmem1(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 1 => dmem1(to_integer(unsigned(row))+1) <= din( 31 downto 24);  
                    when 2 => dmem1(to_integer(unsigned(row))+1) <= din( 23 downto 16);  
                    when 3 => dmem1(to_integer(unsigned(row))+1) <= din( 15 downto  8);   
                    when others => NULL;             
                end case;
            
            end if; 
       end if;
    end if;
end process;

process(clk) begin 
    if rising_edge(clk) then
        if(addr_dmem < 4096) then
            if(w_mode = "001") then 
                if(index = 1) then
                    dmem2(to_integer(unsigned(row))) <= din( 7 downto 0);
                end if;
            
            elsif(w_mode = "011") then 
                case index is       
                    when 1 => dmem2(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 0 => dmem2(to_integer(unsigned(row))) <= din( 15 downto  8);
                    when others => NULL;
                end case;              
    
            elsif(w_mode = "111") then 
                case index is       
                    when 1 => dmem2(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 2 => dmem2(to_integer(unsigned(row))+1) <= din( 31 downto 24);  
                    when 3 => dmem2(to_integer(unsigned(row))+1) <= din( 23 downto 16);  
                    when 0 => dmem2(to_integer(unsigned(row))) <= din( 15 downto  8); 
                    when others => NULL;               
                end case;
            
            end if;  
        end if;
    end if;
end process;

process(clk) begin 
    if rising_edge(clk) then
        if(addr_dmem < 4096) then
            if(w_mode = "001") then
                if(index = 2) then
                    dmem3(to_integer(unsigned(row))) <= din( 7 downto 0);
                end if;
            
            elsif(w_mode = "011") then
                case index is       
                    when 2 => dmem3(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 1 => dmem3(to_integer(unsigned(row))) <= din( 15 downto  8);
                    when others => NULL;
                end case;              
    
            elsif(w_mode = "111") then 
                case index is       
                    when 2 => dmem3(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 3 => dmem3(to_integer(unsigned(row))+1) <= din( 31 downto 24);  
                    when 0 => dmem3(to_integer(unsigned(row))) <= din( 23 downto 16);  
                    when 1 => dmem3(to_integer(unsigned(row))) <= din( 15 downto  8);  
                    when others => NULL;              
                end case;
            
            end if;  
        end if;
    end if;
end process;

process(clk) begin 
    if rising_edge(clk) then
        if(addr_dmem < 4096) then
            if(w_mode = "001") then 
                if(index = 3) then
                    dmem4(to_integer(unsigned(row))) <= din( 7 downto 0);
                end if;
            
            elsif(w_mode = "011") then 
                case index is       
                    when 3 => dmem4(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 2 => dmem4(to_integer(unsigned(row))) <= din( 15 downto  8);
                    when others => NULL;
                end case;              
    
            elsif(w_mode = "111") then 
                case index is       
                    when 3 => dmem4(to_integer(unsigned(row))) <= din(  7 downto  0);
                    when 0 => dmem4(to_integer(unsigned(row))) <= din( 31 downto 24);  
                    when 1 => dmem4(to_integer(unsigned(row))) <= din( 23 downto 16);  
                    when 2 => dmem4(to_integer(unsigned(row))) <= din( 15 downto  8);
                    when others => NULL;                
                end case;
            
            end if; 
        end if;
    end if;
end process;

end achData;