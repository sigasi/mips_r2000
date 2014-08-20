LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY ALU_tb IS
END ALU_tb;
 
ARCHITECTURE behavior OF ALU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         Bus_A : IN  std_logic_vector(31 downto 0);
         Bus_B : IN  std_logic_vector(31 downto 0);
         shamt : IN  std_logic_vector(4 downto 0);
         ALU_op : IN  std_logic_vector(3 downto 0);
         sv : IN  std_logic;
         lui : IN  std_logic;
         ALU_out : OUT  std_logic_vector(31 downto 0);
         zero : OUT  std_logic;
         Ne : OUT  std_logic;
         overflow : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Bus_A : std_logic_vector(31 downto 0) := (others => '0');
   signal Bus_B : std_logic_vector(31 downto 0) := (others => '0');
   signal shamt : std_logic_vector(4 downto 0) := (others => '0');
   signal ALU_op : std_logic_vector(3 downto 0) := (others => '0');
   signal sv : std_logic := '0';
   signal lui : std_logic := '0';

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   signal zero : std_logic;
   signal Ne : std_logic;
   signal overflow : std_logic;
	
--   constant <clock>_period : time := 10 ns;
 
BEGIN
   uut: ALU PORT MAP (
          Bus_A => Bus_A,
          Bus_B => Bus_B,
          shamt => shamt,
          ALU_op => ALU_op,
          sv => sv,
          lui => lui,
          ALU_out => ALU_out,
          zero => zero,
          Ne => Ne,
          overflow => overflow);

--   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
-- 
--	
   -- Stimulus process
	--			RESULTS :: 00000001/ 22F0D168 / E2600CFA / 22AE86F37 / 62370000 / 00000001
   stim_proc: process
   begin		
      wait for 100 ns;	
		--------------------------------1	ADDUI	with result : 00000001
		Bus_A <= X"00000000";
		Bus_B <= X"00000001";
		ALU_op <= "1001";	
		wait for 20 ns;
		--------------------------------2	ADDIU with result : 22F0D168
		Bus_A <= X"02A86F31";
		Bus_B <= X"20486237";
		ALU_op <= "1001"; 
		wait for 20 ns;
		-------------------------------3		SUBU with result : E2600CFA
		Bus_A <= X"02A86F31";
		Bus_B <= X"20486237";
		ALU_op <= "1011";
		wait for 20 ns;
		-------------------------------4		OR with result : 22AE86F37
		Bus_A <= X"02A86F31";
		Bus_B <= X"20486237";
		ALU_op <= "1101"; 
		wait for 20 ns;
		-------------------------------5		SLLV with result : 62370000
		Bus_A <= X"00000010";
		Bus_B <= X"20486237";
		ALU_op <= "0000"; 
		wait for 20 ns;
		-------------------------------6		SLTI with result : 00000001
		Bus_A <= X"02A86F31";
		Bus_B <= X"20486237";
		ALU_op <= "0110";
		wait for 20 ns;
		-------------------------------7		ORI
		ALU_op <= "1101";
		wait for 20 ns;
		-------------------------------8		XORI
		ALU_op <= "1110";
		wait for 20 ns;
		-------------------------------9		LUI
		lui <= '1';
		ALU_op <= "0000";
		wait for 20 ns;
		lui <='0';
		-------------------------------10	BGTZ
		ALU_op <= "0111";
		wait for 20 ns;
		-------------------------------
		ALU_op <= "0110";
		wait for 20 ns;
		-------------------------------
		ALU_op <= "0110";
		wait for 20 ns;
		-------------------------------
		Bus_A <= X"FFFFFFFF";
		Bus_B <= X"FFFFFFFF";
		ALU_op <= "1001";	
		wait for 20 ns;
		
		ALU_op <= "1000"; --ADD ADDI LW SW
		wait for 20 ns;
		ALU_op <= "1001"; --ADDU ADDIU
		wait for 20 ns;
		ALU_op <= "1010"; --SUB BEQ BNE  
		wait for 20 ns;
		ALU_op <= "1011"; --SUBU
		wait for 20 ns;
		ALU_op <= "1100"; --AND ANDI
		wait for 20 ns;
		ALU_op <= "1101"; --OR ORI
		wait for 20 ns;
		ALU_op <= "1110"; --XOR XORI
		wait for 20 ns;
		ALU_op <= "1111"; --NOR
		wait for 20 ns;
		--SHIFT
		ALU_op <= "0000"; --SLL LUI
		wait for 20 ns;
		lui<='1';
		ALU_op <= "0000"; --SLL LUI
		wait for 20 ns;
		lui <='0';
		ALU_op <= "0010"; --SRA
		wait for 20 ns;
		ALU_op <= "0011"; --SLLV
		SV <= '1';
		wait for 20 ns;
		ALU_op <= "0000"; --SLLV
		wait for 20 ns;
		ALU_op <= "0010"; --SRLV
		wait for 20 ns;
		ALU_op <= "0011"; --SRAV
		wait for 20 ns;
		ALU_op <= "0110"; --SLT SLTI
		wait for 20 ns;
		ALU_op <= "0111"; --SLTU SLTIU
		wait for 20 ns;
      wait;
   end process;
END;
