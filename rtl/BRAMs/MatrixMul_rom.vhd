library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Rom_verif is
	port(	clk,load : in std_logic;
			load_addr : out std_logic_vector(10 downto 0);
			dout : out std_logic_vector(31 downto 0));
end Rom_verif;

architecture Behavioral of Rom_verif is

type ROMmem is array (0 to 31) of std_logic_vector(7 downto 0);
signal ROM : ROMmem := (X"9e",X"94",X"8E",X"49",X"9A",X"4C",X"D9",X"84",X"9B",X"48",X"F8",X"8F",X"4F",X"A6",X"89",X"54",X"01",X"95",X"20",X"89",X"C9",X"12",X"F9",X"26",X"A9",X"52",X"09",X"29",X"00",X"60",X"89",X"15");
signal address : natural := 0;																																																	
begin

	load_addr <= std_logic_vector(to_unsigned(address, 11));

	process(clk)
	begin
	if(rising_edge(clk))then
			dout <= X"000000" &  ROM(address);
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

