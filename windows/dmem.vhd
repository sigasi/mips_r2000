library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Only XST supports RAM inference
-- Infers Single Port Block Ram

entity dmem is 
port (
	clk : in std_logic;
	we  : in std_logic_vector(3 downto 0); 
	en  : in std_logic_vector(3 downto 0);
	ssr : in std_logic_vector(3 downto 0);
	address   : in std_logic_vector(10 downto 0); 
	data_in : in std_logic_vector(37 downto 0);
	data_out : out std_logic_vector(37 downto 0));
end dmem; 
 
architecture structural of dmem is

component spdistram8_0 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in std_logic;
	dop : out std_logic_vector(0 downto 0);
 	a   : in std_logic_vector(10 downto 0); 
 	di  : in std_logic_vector (7  downto 0); 
 	do  : out std_logic_vector(7 downto 0));
end component;

component spdistram8_1 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in std_logic;
	dop : out std_logic_vector(0 downto 0);
 	a   : in std_logic_vector(10 downto 0); 
 	di  : in std_logic_vector (7  downto 0); 
 	do  : out std_logic_vector(7 downto 0));
end component;

component spdistram8_2 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in std_logic;
	dop : out std_logic_vector(0 downto 0);
 	a   : in std_logic_vector(10 downto 0); 
 	di  : in std_logic_vector (7  downto 0); 
 	do  : out std_logic_vector(7 downto 0));
end component;

component spdistram8_3 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in std_logic;
	dop : out std_logic_vector(0 downto 0);
 	a   : in std_logic_vector(10 downto 0); 
 	di  : in std_logic_vector (7  downto 0); 
 	do  : out std_logic_vector(7 downto 0));
end component;

	type Ram_type is array(0 to 2047) of std_logic_vector(5 downto 0);
	signal Ram : Ram_type := (others=>(others=>'0'));
--- 2K X 32 RAM 

begin 
--	-- This module uses 4 2Kx8 block RAMs
--	R : for I in 0 to 3 generate
--		RI : spdistram port map (
--			clk => clk,
--			we => we(I),
--			en => en(I),
--			ssr => ssr(I),
--			a => address,
--			di => data_in(((8*I)+7) downto (8*I)),
--			do => data_out(((8*I)+7) downto (8*I))
--		);
--	end generate R;

	 R0 : spdistram8_0 port map (
			  clk => clk,
			  we => we(0),
			  en => en(0),
			  ssr => ssr(0),
			  a => address,
			  di => data_in(7 downto 0),
			  do => data_out(7 downto 0));

	 R1 : spdistram8_1 port map (
			  clk => clk,
			  we => we(1),
			  en => en(1),
			  ssr => ssr(1),
			  a => address,
			  di => data_in(15 downto 8),
			  do => data_out(15 downto 8));

	 R2 : spdistram8_2 port map (
			  clk => clk,
			  we => we(2),
			  en => en(2),
			  ssr => ssr(2),
			  a => address,
			  di => data_in(23 downto 16),
			  do => data_out(23 downto 16));

	 R3 : spdistram8_3 port map (
			  clk => clk,
			  we => we(3),
			  en => en(3),
			  ssr => ssr(3),
			  a => address,
			  di => data_in(31 downto 24),
			  do => data_out(31 downto 24));
			  
process(clk)
begin
	if(rising_edge(clk))then
		if(we(0) = '1')then
			Ram( to_integer(unsigned(address))) <= data_in(37 downto 32);
		end if;
			
			data_out(37 downto 32) <= RAM( to_integer(unsigned(address)));
		end if;
end process;

end structural;
