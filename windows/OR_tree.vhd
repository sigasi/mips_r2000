library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;

entity OR_tree is
	port(dataIn : in std_logic_vector(31 downto 0);
		Zero : out std_logic);
end OR_tree;

architecture Behavioral of OR_tree is
signal sig : std_logic;

begin
sig <= dataIn(31) or dataIn(30) or dataIn(29) or dataIn(28) or dataIn(27) or dataIn(26) or dataIn(25) or dataIn(24) or
		 dataIn(23) or dataIn(22) or dataIn(21) or dataIn(20) or dataIn(19) or dataIn(18) or dataIn(17) or dataIn(16) or
		 dataIn(15) or dataIn(14) or dataIn(13) or dataIn(12) or dataIn(11) or dataIn(10) or dataIn(9)  or dataIn(8)  or
		 dataIn(7)  or dataIn(6)  or dataIn(5)  or dataIn(4)  or dataIn(3)  or dataIn(2)  or dataIn(1)  or dataIn(0);
				 
	Zero <= not sig;
end Behavioral;

