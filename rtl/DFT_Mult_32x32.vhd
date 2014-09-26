library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFT_Mult_32x32 is
	port( clk,rst : in std_logic;
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			DFT_M : in std_logic_vector(1 downto 0);
			P   : out std_logic_vector(63 downto 0);
			Stall : out std_logic;
			PassFail : out std_logic);
end DFT_Mult_32x32;

architecture Behavioral of DFT_Mult_32x32 is

component ATPG 
	port( clk,rst : in std_logic;
			do : out std_logic_vector(63 downto 0));
end component;

component LFSR
port (clock    : in std_logic;
		reset    : in std_logic;
		seed     : in std_logic_vector(63 downto 0);
		data_out : out std_logic_vector(63 downto 0));
end component;

component DTRM
    port (clock_top : in std_logic;
			clear_top : in std_logic;	       
			count_top : in std_logic;			
			Q:	in std_logic_vector(7 downto 0);
			P_top     : out std_logic_vector(63 downto 0));
end component;      

component counter 
  port(clock:	in std_logic;
		clear:	in std_logic;
		count:	in std_logic;
		Q:	out std_logic_vector(7 downto 0)	);
end component;

component mul_32x32 
	port( Bus_A,Bus_B : in std_logic_vector(31 downto 0);
			flag_move_to : in std_logic;
			Bus_hi,Bus_low : out std_logic_vector(31 downto 0));
end component;

component MISR
	port( clock    : in std_logic;
		   reset    : in std_logic;
		   data_in   : in std_logic_vector(63 downto 0);
		   signature : out std_logic_vector(63 downto 0));
end component;

signal Bus_A_sig,Bus_B_sig : std_logic_vector(31 downto 0);
signal flag_move_to, count : std_logic;
signal do,BUS_AB : std_logic_vector(63 downto 0);
signal data_out,P_top : std_logic_vector(63 downto 0);
signal Q: std_logic_vector(7 downto 0);

begin

	Stall <= '0' when DFT_M = "00" else '1';
	BUS_AB <= Bus_A & Bus_B;
	ATPG_P : ATPG 
	port map(clk => clk, rst => rst,
				do => do);
				
	LFSR_P : LFSR
	port map(clock => clk,reset => rst,
				seed  => BUS_AB,
				data_out => data_out); 
				
	counter_p : counter 
   port map(clock => clk,clear => rst,
				count => count,
				Q => Q);
	
	DTRM_P : DTRM
    port map(clock_top => clk,
				 clear_top => rst,
				 count_top => count,
				 Q => Q,
				 P_top => P_top);
		
	process(DFT_M,Bus_A,Bus_B)
	begin
		case DFT_M is 
			when "00" => Bus_A_sig <= Bus_A;
							 Bus_B_sig <= Bus_B;
			when "01" => Bus_A_sig <= data_out(63 downto 32);     --LFSR		
							 Bus_B_sig <= data_out(31 downto 0);
							 
			when "10" => Bus_A_sig <= P_top(63 downto 32);			--DTRM
							 Bus_B_sig <= P_top(31 downto 0);
							 count <= '1';  --enable counter
			
			when "11" => Bus_A_sig <= do(63 downto 32); 				-- ATPG method
							 Bus_B_sig <= do(31 downto 0);
			when others => Bus_A_sig <=(others =>'0');
							   Bus_B_sig <=(others =>'0');
		end case;
	end process;
	
	Mult : mul_32x32 
	port map(Bus_A => Bus_A_sig,
				Bus_B => Bus_B_sig,
				flag_move_to => flag_move_to, 
				Bus_hi => P(63 downto 32),
				Bus_low => P(31 downto 0));
				
	MISR_p : MISR
	port map(clock => clk,reset => rst,
				data_in => Mult_out,
				signature => signature);
end Behavioral;

