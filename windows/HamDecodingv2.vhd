----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:32:37 10/12/2014 
-- Design Name: 
-- Module Name:    HamDecodingv2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HamDecodingv2 is
	port( word38bit : in std_logic_vector(37 downto 0);
			word32bit : out std_logic_vector(31 downto 0);
			errorflag : out std_logic);
end HamDecodingv2;

architecture Behavioral of HamDecodingv2 is
	
	signal data : std_logic_vector(31 downto 0);
	signal pars, p : std_logic_vector(5 downto 0);
	signal word32bit_sig : std_logic_vector(31 downto 0);
	signal word,  word2 : std_logic_vector(1 to 32);
	signal code_word : std_logic_vector(1 to 38);
	
	signal errorarray : std_logic_vector(5 downto 0);
	signal addition1,addition2,addition3,addition4,addition5,addition6 : std_logic_vector(5 downto 0);
	signal errorbit   : std_logic_vector(5 downto 0);
	

	signal din : std_logic_vector(1 to 38);
	signal dout : std_logic_vector(1 to 38);
	signal sig : std_logic_vector(31 downto 0);
	signal sig2 : std_logic_vector(37 downto 0);
	
begin

	data <= word38bit(37 downto 6);
	pars <= word38bit(5 downto 0);
	word <= word38bit(37 downto 6);
	
-- Process:		
		process(word)
		begin
			for i in 1 to 32 loop
				word2(i) <= word(33-i);
			end loop;
		end process;
		
		
		code_word <= pars(0) & pars(1) & word2(1) & pars(2) & word2(2 to 4) & pars(3) & word2(5 to 11) &
		             pars(4) & word2(12 to 26) & pars(5) & word2(27 to 32);
						 
			
	   word32bit_sig <= word38bit(37 downto 6);
		P(0) <= word32bit_sig(0)xor word32bit_sig(1)xor word32bit_sig(3)xor word32bit_sig(4)xor word32bit_sig(6)xor word32bit_sig(8)xor word32bit_sig(10)xor word32bit_sig(11)xor word32bit_sig(13)xor word32bit_sig(15)xor word32bit_sig(17)xor word32bit_sig(19)xor word32bit_sig(21)xor word32bit_sig(23)xor word32bit_sig(25)xor word32bit_sig(26)xor word32bit_sig(28)xor word32bit_sig(30);
		P(1) <= word32bit_sig(0)xor word32bit_sig(2)xor word32bit_sig(3)xor word32bit_sig(5)xor word32bit_sig(6)xor word32bit_sig(9)xor word32bit_sig(10)xor word32bit_sig(12)xor word32bit_sig(13)xor word32bit_sig(16)xor word32bit_sig(17)xor word32bit_sig(20)xor word32bit_sig(21)xor word32bit_sig(24)xor word32bit_sig(25)xor word32bit_sig(27)xor word32bit_sig(28)xor word32bit_sig(31);
		P(2) <= word32bit_sig(1)xor word32bit_sig(2)xor word32bit_sig(3)xor word32bit_sig(7)xor word32bit_sig(8)xor word32bit_sig(9)xor word32bit_sig(10)xor word32bit_sig(14)xor word32bit_sig(15)xor word32bit_sig(16)xor word32bit_sig(17)xor word32bit_sig(22)xor word32bit_sig(23)xor word32bit_sig(24)xor word32bit_sig(25)xor word32bit_sig(29)xor word32bit_sig(30)xor word32bit_sig(31);
		P(3) <= word32bit_sig(4)xor word32bit_sig(5)xor word32bit_sig(6)xor word32bit_sig(7)xor word32bit_sig(8)xor word32bit_sig(9)xor word32bit_sig(10)xor word32bit_sig(18)xor word32bit_sig(19)xor word32bit_sig(20)xor word32bit_sig(21)xor word32bit_sig(22)xor word32bit_sig(23)xor word32bit_sig(24)xor word32bit_sig(25);
		P(4) <= word32bit_sig(11)xor word32bit_sig(12)xor word32bit_sig(13)xor word32bit_sig(14)xor word32bit_sig(15)xor word32bit_sig(16)xor word32bit_sig(17)xor word32bit_sig(18)xor word32bit_sig(19)xor word32bit_sig(20)xor word32bit_sig(21)xor word32bit_sig(22)xor word32bit_sig(23)xor word32bit_sig(24)xor word32bit_sig(25);
		P(5) <= word32bit_sig(26)xor word32bit_sig(27)xor word32bit_sig(28)xor word32bit_sig(29)xor word32bit_sig(30)xor word32bit_sig(31);
		
		errorarray <= P xor word38bit(5 downto 0);
		
		addition1 <= "000001" when errorarray(5)='1' else "000000";
		addition2 <= "000010" when errorarray(4)='1' else "000000";
		addition3 <= "000100" when errorarray(3)='1' else "000000";
		addition4 <= "001000" when errorarray(2)='1' else "000000";
		addition5 <= "010000" when errorarray(1)='1' else "000000";
		addition6 <= "100000" when errorarray(0)='1' else "000000";
		
		errorbit <= addition1 + addition2 + addition3 + addition4 + addition5 + addition6;

		din <= code_word;--'0' & '0' & word(1) & 
		 --din <= word;
		
		 process(errorbit, din)
		 begin
        dout <= din; 
        
		  case errorbit is
        --case errorbit is 
				when "000001" => dout(1)  <= not din(1); 
            when "000010" => dout(2)  <= not din(2); 
            when "000011" => dout(3)  <= not din(3);
				when "000100" => dout(4)  <= not din(4);				
            when "000101" => dout(5)  <= not din(5); 
            when "000110" => dout(6)  <= not din(6); 
            when "000111" => dout(7)  <= not din(7); 
            when "001000" => dout(8)  <= not din(8); 
            when "001001" => dout(9)  <= not din(9); 
            when "001010" => dout(10) <= not din(10); 
            when "001011" => dout(11) <= not din(11); 
            when "001100" => dout(12) <= not din(12); 
            when "001101" => dout(13) <= not din(13); 
            when "001110" => dout(14) <= not din(14); 
            when "001111" => dout(15) <= not din(15); 
            when "010000" => dout(16) <= not din(16); 
            when "010001" => dout(17) <= not din(17); 
            when "010010" => dout(18) <= not din(18); 
            when "010011" => dout(19) <= not din(19); 
            when "010100" => dout(20) <= not din(20); 
            when "010101" => dout(21) <= not din(21); 
            when "010110" => dout(22) <= not din(22); 
            when "010111" => dout(23) <= not din(23); 
            when "011000" => dout(24) <= not din(24); 
            when "011001" => dout(25) <= not din(25); 
            when "011010" => dout(26) <= not din(26); 
            when "011011" => dout(27) <= not din(27); 
            when "011100" => dout(28) <= not din(28); 
            when "011101" => dout(29) <= not din(29); 
            when "011110" => dout(30) <= not din(30); 
            when "011111" => dout(31) <= not din(31);
				when "100000" => dout(32) <= not din(32); 				
            when others => dout <= din;
        end case;
    end process;
	 

-- Process:		
		process(dout)
		begin
			for i in 0 to 37 loop
				sig2(i) <= dout(38-i);
			end loop;
		end process;





end Behavioral;

