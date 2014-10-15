--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:25:07 10/10/2014
-- Design Name:   
-- Module Name:   C:/Users/Chris/Desktop/mips/bench/DecodingHamming_tb.vhd
-- Project Name:  mipsR2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HamDecoding
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DecodingHamming_tb IS
END DecodingHamming_tb;
 
ARCHITECTURE behavior OF DecodingHamming_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT HamDecoding
    PORT(
         word38bit : IN  std_logic_vector(37 downto 0);
         word32bit : OUT  std_logic_vector(31 downto 0);
         errorflag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal word38bit : std_logic_vector(37 downto 0) := (others => '0');

 	--Outputs
   signal word32bit : std_logic_vector(31 downto 0);
   signal errorflag : std_logic;
  
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: HamDecoding PORT MAP (
          word38bit => word38bit,
          word32bit => word32bit,
          errorflag => errorflag   );
   -- Stimulus process
   stim_proc: process
   begin		

      wait for 100 ns;	
--		word38bit<= "11100000000000000000000000000000100111";
--		wait for 10 ns;
--		word38bit<= "11100000000000000000000000000001100111";
		
--		without error
		word38bit<= "11000000010010101010101010010001000100"; --input 12aaa444 with no error
		--with error
		wait for 10 ns;
		
		
		
		
		word38bit<= "11000000010010101010101010010001000101"; --input 12aaa444 with no error
		--with error
		wait for 10 ns;
		word38bit<="10011111100010000000000000000000000000";
		wait for 50 ns;
		word38bit<= "11000000010010101010101010010001000101"; -- error in the first bit
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010001000110"; -- error in the second bit
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010001000000"; -- error in the 3rd bit
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010001001100"; -- error in the 4rd bit
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010001010100"; -- error in the 5rd bit
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010001100100"; -- 6
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010000000100"; -- 7
		wait for 10 ns;
		word38bit<= "11000000010010101010101010010011000100"; -- 8
		wait for 50 ns;
--		
--		word38bit<= "10010010101010101010010001000100110000"; -- 31
--		wait for 10 ns;
--		word38bit<= "01010010101010101010010001000100110000"; -- 30
--		wait for 10 ns;
--		word38bit<= "00110010101010101010010001000100110000"; -- 29
--		wait for 10 ns;
--		word38bit<= "00000010101010101010010001000100110000"; -- 28
--		wait for 10 ns;
--		word38bit<= "00011010101010101010010001000100110000"; -- 27
--		wait for 10 ns;
--		
--		word38bit<= "00010110101010101010010001000100110000"; -- 26
--		wait for 10 ns;
--		
--		
--		word38bit<= "00010000101010101010010001000100110000"; -- 25
--		wait for 10 ns;
--		word38bit<= "00010011101010101010010001000100110000"; -- 24
--		wait for 10 ns;
--		word38bit<= "00010010001010101010010001000100110000"; -- 23
--		wait for 10 ns;
--		word38bit<= "00010010111010101010010001000100110000"; -- 22
--		wait for 10 ns;
--		word38bit<= "00010010100010101010010001000100110000"; -- 21
--		wait for 10 ns;
--		word38bit<= "00010010101110101010010001000100110000"; -- 20
--		wait for 10 ns;
--		word38bit<= "00010010101000101010010001000100110000"; -- 19
--		wait for 10 ns;
--		word38bit<= "00010010101011101010010001000100110000"; -- 18
--		wait for 10 ns;
--		word38bit<= "00010010101010001010010001000100110000"; -- 17
--		wait for 10 ns;
--		word38bit<= "00010010101010111010010001000100110000"; -- 16
--		wait for 10 ns;
--		word38bit<= "00010010101010100010010001000100110000"; -- 15
--		wait for 10 ns;
--		word38bit<= "00010010101010101110010001000100110000"; -- 14
--		wait for 10 ns;
--		word38bit<= "00010010101010101000010001000100110000"; -- 13
--		wait for 10 ns;
--		word38bit<= "00010010101010101011010001000100110000"; -- 13
--		wait for 10 ns;
--		word38bit<= "00010010101010101010110001000100110000"; -- 12
--		wait for 10 ns;
--		word38bit<= "00010010101010101010000001000100110000"; -- 11
--		wait for 10 ns;
--		word38bit<= "00010010101010101010011001000100110000"; -- 10
--		wait for 10 ns;
--		word38bit<= "00010010101010101010010101000100110000"; -- 9
--		wait for 10 ns;
--		word38bit<= "00010010101010101010010011000100110000"; -- 8
--		wait for 10 ns;
		
		wait for 10 ns;
	   --00010010101010101010010001000100110000
	
      wait;
   end process;

END;
