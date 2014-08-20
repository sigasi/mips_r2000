library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Extension is
	port(datain : in std_logic_vector(15 downto 0);
			sel_ext : in std_logic;
			dataout : out std_logic_vector(31 downto 0)
			);
end Extension;

architecture Behavioral of Extension is
signal intern_sig : std_logic_vector(31 downto 0);

begin

	intern_sig <= X"0000"&datain when datain(15)='0' else X"FFFF"&datain;
	dataout <=  intern_sig when sel_ext = '1' else X"0000"&datain;


end Behavioral;

