library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NPCmux is
	port( regN, regD,regA,regM : in std_logic_vector(31 downto 0);
			zero,jump,Branch,ne_eq,j_jal_flag: in std_logic;
			npcmux_out :out std_logic_vector(31 downto 0));
end NPCmux;

architecture Behavioral of NPCmux is
signal mux_out,mux_out2 : std_logic_vector(31 downto 0);
signal sel : std_logic;

begin
	
	sel <= Branch and (zero xor ne_eq);
	mux_out <= regM when sel = '1' else regN;
	mux_out2<= regA when jump = '1' else mux_out;
	
	npcmux_out <= regD when j_jal_flag='1' else mux_out2;
	

end Behavioral;

