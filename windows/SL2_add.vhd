library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity SL2_add is
	port( NPC_in : in std_logic_vector(31 downto 0);
			regI_in : in std_logic_vector(31 downto 0);
			SL2_out : out std_logic_vector(31 downto 0));

end SL2_add;

architecture Behavioral of SL2_add is
signal sig : std_logic_vector(31 downto 0);

begin
	sig <= regI_in(29 downto 0) &"00";
	SL2_out <= sig + NPC_in;
	
end Behavioral;
