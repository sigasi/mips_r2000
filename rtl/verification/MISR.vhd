library IEEE;
use IEEE.std_logic_1164.all;

entity MISR is
port (
  clock    : in std_logic;
  reset    : in std_logic;
  data_in   : in std_logic_vector(63 downto 0);
  signature : out std_logic_vector(63 downto 0)
);
end MISR;

architecture modular of MISR is

  signal lfsr_reg : std_logic_vector(63 downto 0):= (others=>'0');

begin

  process (clock)
    variable lfsr_tap :  std_logic;
	
  begin
    if clock'EVENT and clock='1' then
      if reset = '1' then
        lfsr_reg <= data_in;
	   else
        lfsr_tap := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(3) xor lfsr_reg(4);
        lfsr_reg <= (lfsr_reg(62 downto 0) & lfsr_tap) xor data_in;
      end if;
    end if;
  end process;
  
  signature <= lfsr_reg;
  
end modular;


