library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.std_logic_unsigned.all;


entity add_sub is
port(	Bus_A : in std_logic_vector(31 downto 0);
		Bus_B : in std_logic_vector(31 downto 0);
		ALU_op : in std_logic_vector(1 downto 0);
		Bus_F : out std_logic_vector(32 downto 0);
		OV: out STD_LOGIC
		);
end add_sub;

architecture Behavioral of add_sub is

signal Bus_sig : std_logic_vector(32 downto 0) := (others => '0');
signal bit_33_a,bit_33_b : std_logic;
begin

bit_33_a <= '0' when (ALU_op(0)= '1') else Bus_A(31);
bit_33_b <= '0' when (ALU_op(0)= '1') else Bus_B(31);


p_addsub : process(alu_op,Bus_A,Bus_B)
	begin
	
	case ALU_op(1) is
		when '0' => Bus_sig <= (bit_33_a&Bus_A) + (bit_33_b&Bus_B);
		when '1' => Bus_sig <= (bit_33_a&Bus_A) - (bit_33_b&Bus_B);
		when others => Bus_sig<=(others => '0');
	end case;
	
	end process;
	OV <= Bus_sig(32) xor Bus_sig(31);
	Bus_F <= Bus_sig;

end Behavioral;

