library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFT_Mult_32x32 is
	port( clk,rst : in std_logic;
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			DFT_M : in std_logic_vector(1 downto 0);
			seed  : in std_logic_vector(63 downto 0);
			flag_move_to : in std_logic;
			ver_ready : out std_logic;
			Bus_hi : out std_logic_vector(31 downto 0);
			Bus_low : out std_logic_vector(31 downto 0);
			Stall : out std_logic;
			PassFail : out std_logic);
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
		data_out : out std_logic_vector(63 downto 0);
		rdy : out std_logic);
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

signal Bus_A_sig,Bus_B_sig,Bus_hi_sig,Bus_low_sig : std_logic_vector(31 downto 0);
signal count,atpg_ready,lfsr_ready,delay_rdy,delay_rdy2,ver_ready_int,rst_misr : std_logic;
signal do,P_sig : std_logic_vector(63 downto 0);
signal data_out,P_top : std_logic_vector(63 downto 0);
signal Q: std_logic_vector(7 downto 0);
signal counter_ready,flag_move_to_sig : std_logic;
signal rst_atpg,rst_dtrm,rst_lfsr,rst_intern : std_logic := '0';
signal DFT_M_reg : std_logic_vector(1 downto 0);
signal signature, signature_reg : std_logic_vector(63 downto 0);

begin
	
	flag_move_to_sig <= '0' when DFT_M /= "00" else flag_move_to;
	Stall <= '0' when DFT_M = "00" else '1';
	P_sig <= Bus_hi_sig & Bus_low_sig;
	Bus_hi <=Bus_hi_sig;
	Bus_low <= Bus_low_sig;
	ATPG_P : ATPG 
	port map(clk => clk, rst => rst_atpg,
				atpg_ready => atpg_ready,
				do => do);
				
	LFSR_P : LFSR
	port map(clock => clk,reset => rst_lfsr,
				seed  => seed,
				data_out => data_out,
				rdy => lfsr_ready); 
				
	counter_p : counter 
   port map(clock => clk,clear => rst_dtrm,
				count => count,
				counter_ready => counter_ready,
				Q => Q);
	
	DTRM_p : DTRM
    port map(clock_top => clk,
				 Q => Q,
				 P_top => P_top);
		
	process(DFT_M,Bus_A,Bus_B,do,P_top,data_out,signature_reg)
	begin
		case DFT_M is 
			when "00" => Bus_A_sig <= Bus_A;
							 Bus_B_sig <= Bus_B;
							 count <='0';
							 PassFail <= '0';
							 
			when "01" => Bus_A_sig <= data_out(63 downto 32);     --LFSR		
							 Bus_B_sig <= data_out(31 downto 0);
							 count <= '0';
							 
							 if(signature_reg = X"f4f4a8891e1bd356")then
								PassFail <= '1';
							 else
								PassFail <= '0';
							 end if;
							 
			when "10" => Bus_A_sig <= P_top(63 downto 32);			--DTRM
							 Bus_B_sig <= P_top(31 downto 0);
							 count <= '1';

							 if(signature_reg = X"F4DA9748F9DBB48A")then
								PassFail <= '1';
							 else
								PassFail <= '0';
							 end if;
			
			when "11" => Bus_A_sig <= do(63 downto 32); 				-- ATPG method
							 Bus_B_sig <= do(31 downto 0);
							 count <= '0';
							 
							 if(signature_reg = X"8323281648aaa71b")then
								PassFail <= '1';
							 else
								PassFail <= '0';
							 end if;
							 
							 
			when others => Bus_A_sig <=(others =>'0');
							   Bus_B_sig <=(others =>'0');
								count <= '0';
								PassFail <= '0';
		end case;
	end process;
	
	ver_ready <= ver_ready_int;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			DFT_M_reg <= DFT_M;
			
			delay_rdy <= atpg_ready;
			delay_rdy2 <= delay_rdy OR counter_ready;
			ver_ready_int <= delay_rdy2 OR lfsr_ready;
		end if;
	end process;
	
	rst_intern<= '1' when (DFT_M /= DFT_M_reg) else '0';
	rst_lfsr <= '1' when ((DFT_M ="01" and rst_intern= '1') or rst = '1' or DFT_M /= "01") else '0';
	rst_dtrm <= '1' when ((DFT_M ="10" and rst_intern= '1') or rst = '1' or DFT_M /= "10") else '0';
	rst_atpg <= '1' when ((DFT_M ="11" and rst_intern= '1') or rst = '1' or DFT_M /= "11") else '0';
	
	rst_misr <= rst or rst_intern;
	
	Mult : mul_32x32 
	port map(Bus_A => Bus_A_sig,
				Bus_B => Bus_B_sig,
				flag_move_to => flag_move_to, 
				Bus_hi => Bus_hi_sig,
				Bus_low => Bus_low_sig);
				
	MISR_p : MISR
	port map(clock => clk,reset => rst_misr,
				data_in => P_sig,
				signature => signature);
				
-- Process: Signature Register				
	process(clk)
	begin
		if (rising_edge(clk)) then	
			if(rst = '1')then
				signature_reg <= (others => '0');
			else
				if(ver_ready_int = '0')then
					signature_reg <= signature;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

