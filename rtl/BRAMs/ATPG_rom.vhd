library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Rom_verif is
	port(	clk,load : in std_logic;
			dout : out std_logic_vector(31 downto 0));
end Rom_verif;

architecture Behavioral of Rom_verif is

type ROMmem is array (0 to 87) of std_logic_vector(31 downto 0);
signal ROM : ROMmem;-- :=(X"00060004",);
signal address : natural := 0;																																																	
begin

	process(clk)
	begin
	if(rising_edge(clk))then
			dout <= ROM(address);
		end if;
	end process;
	
	process(clk)
	begin
		if(rising_edge(clk))then
			if( load ='1') then
				address<=address + 1;
			end if;
		end if;
		
	end process;
	

end Behavioral;

