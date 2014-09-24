----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:      
-- Design Name: 
-- Module Name:     - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEL is
	port(Zero, Ne : in std_logic;
			 SEL_sig : in std_logic_vector(3 downto 0);
			 sel_NPC : out std_logic_vector(1 downto 0));
end SEL;

architecture Behavioral of SEL is

begin

-- MUX NPC: 	
-- "00" --> PC <= N	 
-- "01" --> PC <= D		 
-- "10" --> PC <= A		 
-- "11" --> PC <= M	
	 
-- Process: SEL
	 process(SEL_sig, Zero, Ne)
	 begin
	 
	 	Case SEL_sig is
	 	
	 		when X"1" => -- BEQ	-------------------
	 			sel_NPC <= Zero & Zero;
	 			
	 			
	 		when X"2" => -- BNE -------------------
	 			sel_NPC <= (NOT Zero) & (NOT Zero);
	 			
	 		
	 		when X"3" => -- BLEZ -------------------
	 			sel_NPC <= (Zero OR Ne) & (Zero OR Ne);
	 		
	 		
	 		when X"4" => -- BGTZ -------------------
	 			sel_NPC <= (Zero NOR Ne) & (Zero NOR Ne);
	 		
	 		
	 		when X"5" => -- BLTZ or BLTZAL -------- 			
	 				sel_NPC <= Ne & Ne;
	 			
	 		
	 		when X"6" => -- BGEZ or BGEZAL --------
	 			sel_NPC <= (NOT Ne) & (NOT Ne);
	 	
	 		
	 		when X"7" => -- JR or JALR -----------
	 			sel_NPC <= "10";
	 			
	 		
	 		when X"8" => -- J or JAL -------------
	 			sel_NPC <= "01";
	 			
	 		
	 		when others =>
	 			sel_NPC <= "00";
	 		
	 		
	 	end case;
	 	
	 end process;


end Behavioral;