library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity ALU is
port(  clk,rst : in std_logic;
	    Bus_A : in std_logic_vector(31 downto 0);
		 Bus_B : in std_logic_vector(31 downto 0);
		 shamt : in std_logic_vector(4 downto 0);	--shamt=16 when lui=1
		 ALU_op :in std_logic_vector(3 downto 0);
		 sv,lui : in std_logic;
		 flag_move_to : in std_logic;		--for the multiplier for the high and low registers
		 ALU_out : out std_logic_vector(31 downto 0);
		 zero,Ne,overflow : out std_logic;
		 Bus_hi,Bus_low : out std_logic_vector(31 downto 0);
		 DFT_M : in std_logic_vector(1 downto 0);
		 seed  : in std_logic_vector(63 downto 0);
		 ver_ready : out std_logic;
		 Stall : out std_logic;
		 PassFail : out std_logic);
end ALU;

architecture Behavioral of ALU is


component add_sub is
   port(	Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0);
			Bus_F : out std_logic_vector(32 downto 0);
			overflow: out STD_LOGIC);
end component;

component logic_unit is
	port(	Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0);
			Bus_F : out std_logic_vector(31 downto 0));
end component;

component shifter
	port( shamt : in std_logic_vector(4 downto 0);
		  	sv : in std_logic;
			Bus_A : in std_logic_vector(4 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0);
			Bus_S : out std_logic_vector(31 downto 0));
end component;

component OR_tree
	port(	dataIn : in std_logic_vector(31 downto 0);
			Zero : out std_logic);
end component;

--component mul 
--	port( Bus_A,Bus_B : in std_logic_vector(31 downto 0);
--			flag_move_to : in std_logic;
--			Bus_hi,Bus_low : out std_logic_vector(31 downto 0));
--end component;

component DFT_Mult_32x32 
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
end component;

signal SLTbus : std_logic_vector(31 downto 0);
signal logicunit_out,shifter_out : std_logic_vector(31 downto 0);
signal mux_out : std_logic_vector(31 downto 0);
signal subadd_out : std_logic_vector(32 downto 0);
signal shamt_sig : std_logic_vector(4 downto 0);
--signal Bus_hi,Bus_low : std_logic_vector(31 downto 0);

begin

	SLTbus   <= X"0000000" & "000" & subadd_out(32);
	Ne <= subadd_out(32);
	ALU_out  <= mux_out;
	shamt_sig <= "10000" when lui = '1' else shamt ; --shift 16

	u1 : add_sub
	port map(	Bus_A  => Bus_A,
				Bus_B  => Bus_B,
				ALU_op => ALU_op(1 downto 0),
				Bus_F  => subadd_out,
				overflow => overflow);
					
	u2 : shifter
	port map(	shamt => shamt_sig,
				sv => sv,
				Bus_A => Bus_A(4 downto 0),
				Bus_B => Bus_B,
				ALU_op => ALU_op(1 downto 0),
				Bus_S => shifter_out);
			
	u3 : logic_unit
	port map(	Bus_A=> Bus_A, 
				Bus_B=> Bus_B,
				Bus_F => logicunit_out,
				ALU_op => ALU_op(1 downto 0));
				
			
	u4 : process(logicunit_out,shifter_out,subadd_out,ALU_op,SLTbus)
		begin
			case ALU_op(3 downto 2) is
				when "00" => mux_out <= shifter_out;
				when "01" => mux_out <= SLTbus;
				when "10" => mux_out <= subadd_out(31 downto 0);
				when "11" => mux_out <= logicunit_out;
				when others => mux_out <=(others => '0');			
			end case;
	end process;
	
	u5 : OR_tree
	port map(dataIn => mux_out ,
			 Zero   => zero);
	
--	u6 :mul 
--	port map(Bus_A => Bus_A,
--				Bus_B => Bus_B,
--				flag_move_to => flag_move_to, 
--				Bus_hi => Bus_hi,
--				Bus_low => Bus_low);
--				
	DFT : DFT_Mult_32x32
	port map( clk => clk,rst => rst,
			Bus_A =>Bus_A,
			Bus_B => Bus_B,
			DFT_M => DFT_M,
			seed  => seed,
			flag_move_to => flag_move_to, 
			ver_ready => ver_ready,
			Bus_hi=> Bus_hi,
			Bus_low => Bus_low,
			Stall => Stall,
			PassFail => PassFail);

end Behavioral;

