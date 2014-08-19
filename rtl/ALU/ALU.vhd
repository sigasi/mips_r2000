library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity ALU is

	port( shamt : in std_logic_vector(4 downto 0);
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op :in std_logic_vector(3 downto 0);
			--sv : in std_logic;
			Bus_S : out std_logic_vector(31 downto 0);
			zero,notequal : out std_logic);

end ALU;

architecture Behavioral of ALU is


component add_sub is
port(	Bus_A : in std_logic_vector(31 downto 0);
		Bus_B : in std_logic_vector(31 downto 0);
		ALU_op : in std_logic_vector(1 downto 0);
		Bus_F : out std_logic_vector(32 downto 0);
		OV: out STD_LOGIC
		);
end component;


component logic_unit is
	port(	Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			Bus_F : out std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0)
		);
end component;


component shifter
	port( shamt : in std_logic_vector(4 downto 0);
			--sv : in std_logic;
			Bus_A : in std_logic_vector(4 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op : in std_logic_vector(1 downto 0);
			Bus_F : out std_logic_vector(31 downto 0));
end component;

component OR_tree
	port(dataIn : in std_logic_vector(31 downto 0);
			Zero : out std_logic);
end component;

signal SLTbus : std_logic_vector(31 downto 0);
signal logicunit_out,shifter_out : std_logic_vector(31 downto 0);
signal mux_out : std_logic_vector(31 downto 0);
signal subadd_out : std_logic_vector(32 downto 0);



begin


SLTbus <= X"0000000"&"000"&subadd_out(32);
notequal <=subadd_out(32);
	u1 : add_sub
	port map(	Bus_A =>Bus_A,
					Bus_B =>Bus_B,
					ALU_op =>ALU_op(1 downto 0),
					Bus_F =>subadd_out);
					
	u2 : shifter
	port map( shamt => shamt,
			--sv => sv,
			Bus_A => Bus_A(4 downto 0),
			Bus_B => Bus_B,
			ALU_op => ALU_op(1 downto 0),
			Bus_F => shifter_out);
			
	u3 : logic_unit
	port map(Bus_A=> Bus_A, 
			Bus_B=> Bus_B,
			Bus_F => logicunit_out,
			ALU_op => ALU_op(1 downto 0));
			
			
	u4 : process(logicunit_out,shifter_out,subadd_out, ALU_op,SLTbus)
		begin
			case ALU_op(3 downto 2) is
				when "00" => mux_out <=shifter_out;
				when "01" => mux_out <=SLTbus;
				when "10" => mux_out <=subadd_out(31 downto 0);
				when "11" => mux_out <=logicunit_out;
				when others => mux_out <=(others => '0');			
			end case;
	end process;
	
	Bus_S<= mux_out;
	
	u5 : OR_tree
	port map(dataIn =>mux_out ,
			Zero =>zero);
			
end Behavioral;

