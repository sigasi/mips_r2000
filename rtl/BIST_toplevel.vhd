library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BIST_toplevel is
	port( clk,rst : in std_logic;
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			verification : in std_logic_vector(1 downto 0);
			Bus_hi,Bus_low : out std_logic_vector(31 downto 0));
end BIST_toplevel;

architecture Behavioral of BIST_toplevel is

component ROM_mem_vectors 
	port( clk,rst : in std_logic;
			do : out std_logic_vector(63 downto 0));
end component;

component mul 
	port( Bus_A,Bus_B : in std_logic_vector(31 downto 0);
			flag_move_to : in std_logic;
			Bus_hi,Bus_low : out std_logic_vector(31 downto 0));
end component;

signal flag_move_to : std_logic;
begin

	ROM : ROM_mem_vectors 
	port map(clk => clk, rst =>rst,
				do => do);
	
	process
	begin
		case verification is 
			when "00" => Bus_A <= Bus_A;
							 Bus_B <= Bus_B;
			when "01" => Bus_A <= do(31 downto 0);		-- ATPG method
							 Bus_B <= do(63 downto 32);
			when "10" => 
			when "11" => 
		end case;
	end process;
	
	Mult : mul 
	port map(Bus_A => Bus_A,
				Bus_B => Bus_B,
				flag_move_to => flag_move_to, 
				Bus_hi => Bus_hi,
				Bus_low => Bus_low);

end Behavioral;

