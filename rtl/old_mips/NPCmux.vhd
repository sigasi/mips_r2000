library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NPCmux is
	port(Bus_A :in std_logic_vector(31 downto 0);
			regM : in std_logic_vector(31 downto 0);
			regNPC : in std_logic_vector(31 downto 0);
			zero,jump,Branch,ne_eq: in std_logic;
			npcmux_out :out std_logic_vector(31 downto 0));
end NPCmux;

architecture Behavioral of NPCmux is
signal mux_out : std_logic_vector(31 downto 0);
signal sel : std_logic;

begin
	
	mux_out<= regM when sel = '1' else regNPC;
	npcmux_out <= Bus_A when jump = '1' else mux_out;
	
	sel <=Branch and (zero xor ne_eq);


end Behavioral;

