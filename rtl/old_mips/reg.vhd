library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
	port(clk, rst, en : in std_logic;
	     di : in std_logic_vector(31 downto 0);
		  do : out std_logic_vector(31 downto 0));
end reg;

architecture Behavioral of reg is
begin

-- Process: Register
	process(clk)
	begin
	if(rising_edge(clk))then
		if(rst = '1')then
			do <= (others => '0');
		else
			if(en = '1')then
				do <= di;
			end if;
		end if;
	end if;
	end process;


end Behavioral;

