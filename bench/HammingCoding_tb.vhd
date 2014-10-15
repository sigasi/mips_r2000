--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:11:19 10/10/2014
-- Design Name:   
-- Module Name:   C:/Users/Chris/Desktop/mips/bench/HammingCoding_tb.vhd
-- Project Name:  mipsR2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HamCoding
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
 
ENTITY HammingCoding_tb IS
END HammingCoding_tb;
 
ARCHITECTURE behavior OF HammingCoding_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT HamCoding
    PORT(
         word32bit : IN  std_logic_vector(31 downto 0);
         word38bit : OUT  std_logic_vector(37 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal word32bit : std_logic_vector(31 downto 0) := (others => '0');
 	--Outputs
   signal word38bit : std_logic_vector(37 downto 0);
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: HamCoding PORT MAP (
          word32bit => word32bit,
          word38bit => word38bit);

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
-- 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		word32bit <= X"12aaa445";	

      

      -- insert stimulus here 

      wait;
   end process;

END;
