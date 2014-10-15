library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Only XST supports RAM inference
-- Infers Single Port Block Ram

entity imem is 
port (
	clk : in std_logic;
	en  : in std_logic;
	address   : in std_logic_vector(10 downto 0); 
	data_out : out std_logic_vector(31 downto 0));
end imem; 
 
architecture structural of imem is

component spdistram32_0 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in  std_logic;
	dop : out std_logic_vector (3 downto 0);
 	a   : in std_logic_vector(8 downto 0); 
 	di  : in std_logic_vector (31 downto 0); 
 	do  : out std_logic_vector(31 downto 0));
end component; 

component spdistram32_1 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in  std_logic;
	dop : out std_logic_vector (3 downto 0);
 	a   : in std_logic_vector(8 downto 0); 
 	di  : in std_logic_vector (31 downto 0); 
 	do  : out std_logic_vector(31 downto 0));
end component; 

component spdistram32_2 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in  std_logic;
	dop : out std_logic_vector (3 downto 0);
 	a   : in std_logic_vector(8 downto 0); 
 	di  : in std_logic_vector (31 downto 0); 
 	do  : out std_logic_vector(31 downto 0));
end component; 

component spdistram32_3 is 
port (clk : in std_logic; 
 	we  : in std_logic;
	en  : in std_logic;
	ssr : in  std_logic;
	dop : out std_logic_vector (3 downto 0);
 	a   : in std_logic_vector(8 downto 0); 
 	di  : in std_logic_vector (31 downto 0); 
 	do  : out std_logic_vector(31 downto 0));
end component; 
 
signal sl: std_logic_vector(3 downto 0);
type do_array_type is array (natural range<>) of std_logic_vector(31 downto 0);
signal do_internal : do_array_type(0 to 3);
  
--- 2K X 32 RAM (serial concatenation of four 512x32 block RAMs)

begin 
	-- This module uses 4 512x32 block RAMs
	
		RI_0 : spdistram32_0 
		port map (
			clk => clk,
			we => '0',
			en => en,
			ssr => sl(0),
			a => address (8 downto 0),
			di => "00000000000000000000000000000000",
			do => do_internal(0)
		);
		
		RI_1 : spdistram32_1 
		port map (
			clk => clk,
			we => '0',
			en => en,
			ssr => sl(1),
			a => address (8 downto 0),
			di => "00000000000000000000000000000000",
			do => do_internal(1)
		);
		
		RI_2 : spdistram32_2 
		port map (
			clk => clk,
			we => '0',
			en => en,
			ssr => sl(2),
			a => address (8 downto 0),
			di => "00000000000000000000000000000000",
			do => do_internal(2)
		);
		
		RI_3 : spdistram32_3 
		port map (
			clk => clk,
			we => '0',
			en => en,
			ssr => sl(3),
			a => address (8 downto 0),
			di => "00000000000000000000000000000000",
			do => do_internal(3)
		);
		
	process (address)
	
	begin
	case  address (10 downto 9) is
            when "00" => sl <= "1110";
            when "01" => sl <= "1101";
            when "10" => sl <= "1011";
            when "11" => sl <= "0111";
            when others => sl <= "1111";
    end case;
	end process;
	
data_out <= do_internal(0) or do_internal(1) or do_internal(2) or do_internal(3);
	
end structural;
