library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity ALUmux_outunit is

	port( regB,regI : in std_logic_vector(31 downto 0);
			RegImm : in std_logic;
			ALUmux_out: out std_logic_vector(31 downto 0));
			
end ALUmux_outunit;

architecture Behavioral of ALUmux_outunit is

begin

ALUmux_out <= regB when RegImm = '1' else regI;

end Behavioral;

