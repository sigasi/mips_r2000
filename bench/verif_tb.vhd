LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY verif_tb IS
END verif_tb;
 
ARCHITECTURE behavior OF verif_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DFT_Mult_32x32
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Bus_A : IN  std_logic_vector(31 downto 0);
         Bus_B : IN  std_logic_vector(31 downto 0);
         DFT_M : IN  std_logic_vector(1 downto 0);
         seed : IN  std_logic_vector(63 downto 0);
         ver_ready : OUT  std_logic;
         P : OUT  std_logic_vector(63 downto 0);
         Stall : OUT  std_logic;
         PassFail : OUT  std_logic);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal Bus_A : std_logic_vector(31 downto 0) := (others => '0');
   signal Bus_B : std_logic_vector(31 downto 0) := (others => '0');
   signal DFT_M : std_logic_vector(1 downto 0) := (others => '0');
   signal seed : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal ver_ready : std_logic;
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
          seed => X"0000000000000001",
          ver_ready => ver_ready,
          P => P,
          Stall => Stall,
          PassFail => PassFail);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	rst_proces: process
	begin
		wait for 95ns;
			rst <= '0';
		wait;
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 100 ns;	
		DFT_M <= "11";
		wait for 1100 ns;
		DFT_M <= "01";			--LFSR
		wait for 800 ns;
		DFT_M <= "10";			--dtrm
      wait;
   end process;

END;
