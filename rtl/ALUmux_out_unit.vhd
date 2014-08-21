library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_out_unit is
	port( regB,regI : in std_logic_vector(31 downto 0);
			RegImm : in std_logic;
			ALU_out: out std_logic_vector(31 downto 0));			
end ALU_out_unit;

architecture Behavioral of ALU_out_unit is

begin


end Behavioral;

