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
			seed  : in std_logic_vector(63 downto 0);
			ver_ready : out std_logic_vector(1 downto 0);
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
	signal seed  : std_logic_vector(63 downto 0) := (others => '0');
	SIGNAL tb_reset, tb_clock : std_logic;
 	--Outputs
	signal ver_ready : std_logic_vector(1 downto 0);
   signal P : std_logic_vector(63 downto 0);
   signal Stall : std_logic;
   signal PassFail : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DFT_Mult_32x32 PORT MAP (
          clk => tb_clock,
          rst => tb_reset,
          Bus_A => Bus_A,
          Bus_B => Bus_B,
          DFT_M => DFT_M,
			 seed  => seed,
			 ver_ready =>ver_ready,
          P => P,
          Stall => Stall,
          PassFail => PassFail);
			 
	Reset: PROCESS
				  BEGIN 
				   tb_reset <= '1';
				 	 wait for 400 ns;
				 	 tb_reset <= '0';
				 	 wait;	
				  END PROCESS;
	 
	 Clock: PROCESS
					  BEGIN
						 tb_clock <= '1';
						 wait for 50 ns;
						 tb_clock <= '0';
						 wait for 50 ns;
				  END PROCESS;
				  
				  
   -- Stimulus process
--   stim_proc1: process(ver_ready)
--   begin		
--      --wait for clk_period*10;
--		Bus_A <=X"0000000"&"0011"; --3
--		Bus_B <=X"0000000"&"0010"; --2
--      -------------ATPG---------------
--		DFT_M<= "11";
--      -------------DTRM---------------
--		if ver_ready ="01" then  --teleiwse h ATPG
--			DFT_M<= "10";
----		-------------LFSR---------------
--		elsif ver_ready="11"then 
--			DFT_M<= "01";
--		end if;
--   end process;
	
	stim_proc2: process
	begin
	
		seed<=X"000000000000"&"0000000000000011";
	--hold reset state for 100 ns.
--      wait for 100 ns;
--		DFT_M<= "11";
--		wait for 9000 ns;  --LFSR
		DFT_M<= "01";
		
--		wait for 26000 ns;	
--		DFT_M<= "10";
		wait;
	end process;

END;
