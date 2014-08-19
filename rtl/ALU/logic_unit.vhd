library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity logic_unit is
	port(	Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			Bus_F : out std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0)
		);
end logic_unit;

architecture Behavioral of logic_unit is

begin

u : process(Bus_A,Bus_B,ALU_op)
	begin
		case ALU_op is
			when "00" => Bus_F <= Bus_A AND Bus_B;
			when "01" => Bus_F <= Bus_A OR Bus_B;
			when "10" => Bus_F <= Bus_A XOR Bus_B;
			when "11" => Bus_F <= Bus_A NOR Bus_B;
			when others => Bus_F<=(others => '0');
			
		end case;
		
	end process;
end Behavioral;

