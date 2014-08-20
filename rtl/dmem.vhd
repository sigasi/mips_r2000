library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
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
	data_in : in std_logic_vector(31 downto 0);
	data_out : out std_logic_vector(31 downto 0));
end dmem; 
 
architecture structural of dmem is

component spdistram is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in std_logic;
	dop : out std_logic_vector(0 downto 0);
 	a   : in std_logic_vector(10 downto 0); 
 	di  : in std_logic_vector (7  downto 0); 
 	do  : out std_logic_vector(7 downto 0));
end component; 
 
--- 2K X 32 RAM 

begin 
	-- This module uses 4 2Kx8 block RAMs
	R : for I in 0 to 3 generate
		RI : spdistram port map (
			clk => clk,
			we => we(I),
			en => en(I),
			ssr => ssr(I),
			a => address,
			di => data_in(((8*I)+7) downto (8*I)),
			do => data_out(((8*I)+7) downto (8*I))
		);
	end generate R;
end structural;
