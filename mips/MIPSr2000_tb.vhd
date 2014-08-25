LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY MIPSr2000_tb IS
END MIPSr2000_tb;
 
ARCHITECTURE behavior OF MIPSr2000_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MIPS_r2000
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Bus_A_test : OUT  std_logic_vector(31 downto 0);
         Bus_B_test : OUT  std_logic_vector(31 downto 0);
         Bus_W_test : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal Bus_A_test : std_logic_vector(31 downto 0);
   signal Bus_B_test : std_logic_vector(31 downto 0);
   signal Bus_W_test : std_logic_vector(31 downto 0);
	SIGNAL tb_reset, tb_clock : std_logic;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MIPS_r2000 PORT MAP (
          clk => tb_clock,
          rst => tb_reset,
          Bus_A_test => Bus_A_test,
          Bus_B_test => Bus_B_test,
          Bus_W_test => Bus_W_test);
 

 -- Process: Reset
	 Reset: PROCESS
				  BEGIN 
				   tb_reset <= '1';
				 	 wait for 400 ns;
				 	 tb_reset <= '0';
				 	 wait;	
				  END PROCESS;


-- Process: Clock, Current Frequency 50 MHz = Period 20 ns         
	 Clock: PROCESS
	 			  BEGIN
	 				 tb_clock <= '1';
	 				 wait for 50 ns;
	 				 tb_clock <= '0';
	 				 wait for 50 ns;
     		  END PROCESS;
END;
