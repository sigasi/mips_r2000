library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
--use UNISIM.VComponents.all;

entity RFmux is
	port( regNPC : in std_logic_vector(31 downto 0);
			regS,MDRout : in std_logic_vector(31 downto 0);
			Link,DM_ALU : in std_logic;
			RFmux_out : out std_logic_vector(31 downto 0));
end RFmux;

architecture Behavioral of RFmux is
signal sig : std_logic_vector(31 downto 0);

begin
	sig <= regS when DM_ALU='0' else MDRout;
	RFmux_out<= sig when Link = '0' else regNPC;

end Behavioral;

