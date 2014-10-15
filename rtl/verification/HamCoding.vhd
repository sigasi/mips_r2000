library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HamCoding is
	port( word32bit : in std_logic_vector(31 downto 0);
			word38bit : out std_logic_vector(37 downto 0)	);
end HamCoding;

architecture Behavioral of HamCoding is

signal word38bit_sig : std_logic_vector(37 downto 0);
signal P0,P1,P2,P3,P4,P5		: std_logic;
begin

		--parity bits
		P0 <= word32bit(0)xor word32bit(1)xor word32bit(3)xor word32bit(4)xor word32bit(6)xor word32bit(8)xor word32bit(10)xor word32bit(11)xor word32bit(13)xor word32bit(15)xor word32bit(17)xor word32bit(19)xor word32bit(21)xor word32bit(23)xor word32bit(25)xor word32bit(26)xor word32bit(28)xor word32bit(30);
		P1 <= word32bit(0)xor word32bit(2)xor word32bit(3)xor word32bit(5)xor word32bit(6)xor word32bit(9)xor word32bit(10)xor word32bit(12)xor word32bit(13)xor word32bit(16)xor word32bit(17)xor word32bit(20)xor word32bit(21)xor word32bit(24)xor word32bit(25)xor word32bit(27)xor word32bit(28)xor word32bit(31);
		P2 <= word32bit(1)xor word32bit(2)xor word32bit(3)xor word32bit(7)xor word32bit(8)xor word32bit(9)xor word32bit(10)xor word32bit(14)xor word32bit(15)xor word32bit(16)xor word32bit(17)xor word32bit(22)xor word32bit(23)xor word32bit(24)xor word32bit(25)xor word32bit(29)xor word32bit(30)xor word32bit(31);
		P3 <= word32bit(4)xor word32bit(5)xor word32bit(6)xor word32bit(7)xor word32bit(8)xor word32bit(9)xor word32bit(10)xor word32bit(18)xor word32bit(19)xor word32bit(20)xor word32bit(21)xor word32bit(23)xor word32bit(24)xor word32bit(25);
		P4 <= word32bit(11)xor word32bit(12)xor word32bit(13)xor word32bit(14)xor word32bit(15)xor word32bit(16)xor word32bit(17)xor word32bit(18)xor word32bit(19)xor word32bit(20)xor word32bit(21)xor word32bit(22)xor word32bit(23)xor word32bit(24)xor word32bit(25);
		P5 <= word32bit(26)xor word32bit(27)xor word32bit(28)xor word32bit(29)xor word32bit(30)xor word32bit(31);
		
		word38bit_sig<=word32bit & P5 & P4 & P3 & P2 & P1 & P0;
		word38bit <= word38bit_sig;
end Behavioral;

