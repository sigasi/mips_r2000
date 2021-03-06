-- IMEM for test program "Simple_Example_1"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IMEM_rom64x32 is
    Port ( ADDR : in std_logic_vector(5 downto 0);
           DOUT : out std_logic_vector(31 downto 0));
end IMEM_rom64x32;

architecture Behavioral of IMEM_rom64x32 is

subtype Imem_word is bit_vector(31 downto 0);
type    Imem_array is array (0 to 63)of Imem_word;

constant Imem : Imem_array := (

X"8c010000", X"8c020001", X"8c030002", X"8c040003", X"8c1f0004", X"8c1e0005",
X"00222821", X"ac05000a", X"00643023", X"30a70010", X"00064100", X"00e8482a",
X"0120f809", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000");


Begin

DOUT <= To_X01(Imem(conv_integer(ADDR)));

End Behavioral;
