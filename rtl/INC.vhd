library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity INC is
	port( pc : in std_logic_vector(31 downto 0);
			inc_out : out std_logic_vector(31 downto 0)
			);

end INC;

architecture Behavioral of INC is

begin

	--increment by 1 because of the memory
	inc_out <= std_logic_vector(unsigned(pc) + X"00000001");
	
end Behavioral;

