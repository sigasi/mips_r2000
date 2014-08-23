library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;

entity RFmux is
	port( regN,regHi,regLow : in std_logic_vector(31 downto 0);
			regS,MDRout : in std_logic_vector(31 downto 0);
			Link,DM_ALU : in std_logic;
			sel_HiLow : in std_logic_vector(1 downto 0);
			RFmux_out : out std_logic_vector(31 downto 0));
end RFmux;

architecture Behavioral of RFmux is
signal mux_out1,mux_out2,mux_out3 : std_logic_vector(31 downto 0);

begin
	mux_out1 <= regS when DM_ALU='0' else MDRout;
	mux_out2 <= mux_out1 when Link = '0' else regN;
	
	mux_out3 <= regHi when sel_HiLow(0)='0' else regLow;
	
	RFmux_out <= mux_out3 when  sel_HiLow(1)='1' else mux_out2;
	
--signal sel_HiLow coding
-- 00 : nothing
-- 01 : nothing
-- 10 : move to high or move from hi
-- 11 : move to low or move from low

end Behavioral;

