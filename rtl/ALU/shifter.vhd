library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity shifter is
	port( shamt : in std_logic_vector(4 downto 0);
			--sv : in std_logic;
			Bus_A : in std_logic_vector(4 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0);
			Bus_F : out std_logic_vector(31 downto 0)
			);
end shifter;

architecture Behavioral of shifter is
signal shifts : std_logic_vector(4 downto 0);

begin
--	shifts <= shamt when(SV = '0') else Bus_A(4 downto 0);

u : process(Bus_A,Bus_B,ALU_op)
	begin
		case ALU_op is
			when "00" => Bus_F <= to_stdlogicvector(to_bitvector(Bus_B) SLL to_integer(unsigned(shamt))		); 
			when "01" => Bus_F <= Bus_B; 
			when "10" => Bus_F <= to_stdlogicvector(to_bitvector(Bus_B) SRL to_integer(unsigned(shamt))		); 
			when "11" => Bus_F <= to_stdlogicvector(to_bitvector(Bus_B) SRA to_integer(unsigned(shamt))		); 
			when others => Bus_F <= (others => '0');
		end case;

	end process;
end Behavioral;

