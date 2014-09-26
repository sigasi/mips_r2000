LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY DFT_mul_tb IS
END DFT_mul_tb;
 
ARCHITECTURE behavior OF DFT_mul_tb IS 
 
    COMPONENT DFT_Mult_32x32
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Bus_A : IN  std_logic_vector(31 downto 0);
         Bus_B : IN  std_logic_vector(31 downto 0);
         DFT_M : IN  std_logic_vector(1 downto 0);
         P : OUT  std_logic_vector(63 downto 0);
         Stall : OUT  std_logic;
         PassFail : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Bus_A : std_logic_vector(31 downto 0) := (others => '0');
   signal Bus_B : std_logic_vector(31 downto 0) := (others => '0');
   signal DFT_M : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal P : std_logic_vector(63 downto 0);
   signal Stall : std_logic;
   signal PassFail : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DFT_Mult_32x32 PORT MAP (
          clk => clk,
          rst => rst,
          Bus_A => Bus_A,
          Bus_B => Bus_B,
          DFT_M => DFT_M,
          P => P,
          Stall => Stall,
          PassFail => PassFail);
			 
	Reset: PROCESS
				  BEGIN 
				   rst <= '1';
				 	 wait for 400 ns;
				 	 rst <= '0';
				 	 wait;	
				  END PROCESS;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		Bus_A <=X"0000000"&"0011"; --3
		Bus_B <=X"0000000"&"0010"; --2
      -------------ATPG---------------
		DFT_M<= "11";
		wait for 20 ns;	
      -------------DTRM---------------
		DFT_M<= "10";
		wait for 20 ns;
      -------------LFSR---------------
		DFT_M<= "01";
		wait for 20 ns;

      wait;
   end process;

END;
