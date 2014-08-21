library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
	port( clk,rst : in std_logic;
			Bus_A,Bus_B : in std_logic_vector(31 downto 0);
			Bus_W : out std_logic_vector(31 downto 0);
			reg_IR : out std_logic_vector(31 downto 0)
			);
end Datapath;

architecture Behavioral of Datapath is

component reg 
	port(clk, rst, en : in std_logic;
	     di : in std_logic_vector(31 downto 0);
		  do : out std_logic_vector(31 downto 0));
end component;

component ALU 
	port(Bus_A : in std_logic_vector(31 downto 0);
		 Bus_B : in std_logic_vector(31 downto 0);
		 shamt : in std_logic_vector(4 downto 0);	
		 ALU_op :in std_logic_vector(3 downto 0);
		 sv,lui : in std_logic;
		 flag_move_to : in std_logic;		
		 ALU_out : out std_logic_vector(31 downto 0);
		 zero,Ne,overflow : out std_logic;
		 Bus_hi,Bus_low : out std_logic_vector(31 downto 0));
end component;

component Regfile_bl 
	port(	Clk : in std_logic;
			Reg_Write : in std_logic;
			Reg_Imm_not : in std_logic;
			rs : in std_logic_vector(4 downto 0);
			rt : in std_logic_vector(4 downto 0);
			rd : in std_logic_vector(4 downto 0);
			Branchzero_flag : in std_logic;		--6 entoles
			Reg32_flag : in std_logic;
			Bus_W : in std_logic_vector(31 downto 0);
			Bus_A : out std_logic_vector(31 downto 0);
			Bus_B : out std_logic_vector(31 downto 0));
end component;
--===========================================================================
signal ALU_op : std_logic_vector(3 downto 0);
signal sv,lui,flag_move_to,Branchzero_flag : std_logic;
signal zero,Ne,overflow : std_logic;
signal Reg32_flag,Reg_Imm_not : std_logic;
signal EXT_out,ALU_out : std_logic_vector(31 downto 0);
signal regI,regA,regB,regHi,regLow,reg_IR : std_logic_vector(31 downto 0);
signal ir_out,Reg_Imm,Reg_Write : std_logic_vector(31 downto 0);
signal Bus_hi,Bus_low : std_logic_vector(31 downto 0);
begin
	u1_ALU : ALU 
	port map(Bus_A => Bus_A,
				Bus_B => ALU_out,
				shamt => reg_IR(10 downto 6),
				ALU_op => ALU_op,							--FROM CU
				sv => sv,lui => lui,						--from CU
				flag_move_to => flag_move_to,			--from Cu
				ALU_out => ALU_out,
				zero =>zero,Ne => Ne,
				overflow => overflow ,					--
				Bus_hi => Bus_hi,
				Bus_low=> Bus_low );

	u2_RF : Regfile_bl 
	port map(Clk => clk,
				Reg_Write => Reg_Write, --come from CU
s				Reg_Imm_not => Reg_Imm,
				rs => ir_out(25 downto 21),
				rt =>ir_out(20 downto 16),
				rd =>ir_out(15 downto 11),
				Branchzero_flag => Branchzero_flag, --from CU
				Reg32_flag => Reg32_flag,
				Bus_W => Bus_W,
				Bus_A => Bus_A,
				Bus_B => Bus_B);




----------------------------REGISTERS------------------------------
regHi_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_hi,do=>regHi);
regLow_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_low,do=>regLow);
--regAlu_out : reg port map(clk=>clk,rst=>rst,en=>'1',di=>,do=>);

regA_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_A,do=>regA);
regB_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_B,do=>regB);
regI_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>EXT_out,do=>regI);	

	u_reg : process (clk)
		begin
		if(rising_edge(clk))then
			regA <= Bus_A;
			regB <= Bus_B;
			regI <= EXT_out;
		end if;
	end process;
ALU_out <= regB when Reg_Imm_not = '1' else regI;----check reg_im_not

end Behavioral;

