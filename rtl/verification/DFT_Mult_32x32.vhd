library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFT_Mult_32x32 is
	port( clk,rst : in std_logic;
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			DFT_M : in std_logic_vector(1 downto 0);
			seed  : in std_logic_vector(63 downto 0);
			ver_ready : out std_logic_vector(1 downto 0);
			P   : out std_logic_vector(63 downto 0);
			Stall : out std_logic;
			PassFail : out std_logic;
			signature : out std_logic_vector(63 downto 0));
end DFT_Mult_32x32;

architecture Behavioral of DFT_Mult_32x32 is

component ATPG 
	port( clk,rst : in std_logic;
			atpg_ready : out std_logic;
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
			Q:	in std_logic_vector(7 downto 0);
			P_top     : out std_logic_vector(63 downto 0));
end component;      

component counter 
  port(clock:	in std_logic;
		clear:	in std_logic;
		count:	in std_logic;
		counter_ready : out std_logic;
		Q :	out std_logic_vector(7 downto 0)	);
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
signal flag_move_to,count,atpg_ready : std_logic;
signal do,P_sig : std_logic_vector(63 downto 0);
signal data_out,P_top : std_logic_vector(63 downto 0);
signal Q: std_logic_vector(7 downto 0);
signal counter_ready : std_logic;
signal rst_sig1,rst_sig2,rst_sig3 : std_logic;
begin
--	ver_ready <= "01" when atpg_ready = '1' else		--counter_ready OR readyfromATPBG-- if ver_ready=1 then DTRM or LFSR is done
--					 "10" when counter_ready = "01" else
--					 "11" when counter_ready = "10" else "00";
--					 
					 
--	Bus_hi_store<= Bus_hi;		
--   if (Bus_hi_store OR Bus_hi) =X"00000000" then
	rst_sig3 <= rst;
	flag_move_to <='0';
	P <= P_sig;
	Stall <= '0' when DFT_M = "00" else '1';
	
	ATPG_P : ATPG 
	port map(clk => clk, rst => rst_sig1,
				atpg_ready => atpg_ready,
				do => do);
				
	LFSR_P : LFSR
	port map(clock => clk,reset => rst_sig3,
				seed  => seed,
				data_out => data_out); 
				
	counter_p : counter 
   port map(clock => clk,clear => rst_sig2,
				count => count,
				counter_ready => counter_ready,
				Q => Q);
	
	DTRM_p : DTRM
    port map(clock_top => clk,
				 Q => Q,
				 P_top => P_top);
		
	process(DFT_M,Bus_A,Bus_B,do,P_top,data_out)
	begin
		case DFT_M is 
			when "00" => Bus_A_sig <= Bus_A;
							 Bus_B_sig <= Bus_B;
							 count <='0';
							 
			when "01" => Bus_A_sig <= data_out(63 downto 32);     --LFSR		
							 Bus_B_sig <= data_out(31 downto 0);
							 count <= '0'; 
							 rst_sig3<='0';
							 
			when "10" => Bus_A_sig <= P_top(63 downto 32);			--DTRM
							 Bus_B_sig <= P_top(31 downto 0);
							 count <= '1';  
			
			when "11" => Bus_A_sig <= do(63 downto 32); 				-- ATPG method
							 Bus_B_sig <= do(31 downto 0);
							 count <= '0'; 
			when others => Bus_A_sig <=(others =>'0');
							   Bus_B_sig <=(others =>'0');
								count <= '0'; 
		end case;
	end process;
	
	
--	process(DFT_M)
--	begin
--		if (DFT_M="01") then
--			rst_sig3 <='1';
--		else
--			rst_sig3 <='0';
--		end if;
--	end process;
	
	process(atpg_ready,counter_ready)
	begin
		if (atpg_ready ='1') then
			rst_sig1 <='1';
		elsif (counter_ready='1') then
			rst_sig2 <='1';
		else
			rst_sig1 <='0';
			rst_sig2 <='0';
		end if;
--		rst_sig <='0' when DFT_M="00" else '1';
	end process;
	
	
	Mult : mul_32x32 
	port map(Bus_A => Bus_A_sig,
				Bus_B => Bus_B_sig,
				flag_move_to => flag_move_to, 
				Bus_hi => P_sig(63 downto 32),
				Bus_low => P_sig(31 downto 0));
				
	MISR_p : MISR
	port map(clock => clk,reset => rst,
				data_in => P_sig,
				signature => signature);
end Behavioral;

