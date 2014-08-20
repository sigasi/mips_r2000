library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul is
	port( Bus_A,Bus_B : in std_logic_vector(31 downto 0);
			flag_move : in std_logic;
			Bus_hi,Bus_low : out std_logic_vector(31 downto 0));
end mul;

architecture Behavioral of mul is
signal MUL_Out : std_logic_vector(63 downto 0);

begin

	MUL_Out <= std_logic_vector( signed( Bus_A) * signed(Bus_B) );
	Bus_hi <= MUL_Out(63 downto 32) when flag_move='0' else Bus_A;
	Bus_low <= MUL_Out(31 downto 0) when flag_move='0' else Bus_B;

end Behavioral;
