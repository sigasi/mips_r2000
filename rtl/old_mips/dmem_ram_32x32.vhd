library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Only XST supports RAM inference
-- Infers Single Port Block Ram

entity DMEM_blockram32x32 is 
 port (
   di  : in std_logic_vector(31 downto 0); 
	a   : in std_logic_vector(4 downto 0); 
	we  : in std_logic; 
	clk : in std_logic; 
 	do  : out std_logic_vector(31 downto 0));
 end DMEM_blockram32x32; 
 
 architecture syn of DMEM_blockram32x32 is 
 
 type ram_type is array (0 to 31) of std_logic_vector (31 downto 0); 
 signal RAM : ram_type :=( X"00000001", X"00000003", X"00000004", X"00000002", X"0000000A",
									X"00000020", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00000000", X"00000000");
 
 begin 
 
 
process (clk) 
 begin 
 	if (clk'event and clk = '1') then
 	   	if (we = '1') then 
				RAM(conv_integer(a)) <= di; 
			else										--
				do <= RAM(conv_integer(a)); 	-- implementation Block RAM
			end if;	  
 	end if; 
 end process; 
 
-- do <= RAM(conv_integer(a));  			   implementation Distributed RAM
 
 end syn;
