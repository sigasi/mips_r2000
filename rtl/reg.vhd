library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
	generic (w : integer);
	port(clk, rst, en : in std_logic;
	     di : in std_logic_vector(w-1);
		  do : out std_logic_vector(w-1));
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

