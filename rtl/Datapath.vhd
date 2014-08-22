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
	generic (w : integer);
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

component DMcontrol 
	port( ALUout : in std_logic_vector(12 downto 0);
			MDRin : in std_logic_vector(31 downto 0);
			DatatoDM : out std_logic_vector(31 downto 0);
			WE : out std_logic_vector(3 downto 0);
			Bus_DMA : out std_logic_vector(10 downto 0);
			DatafromDM : in std_logic_vector(31 downto 0);
			MDRout : out std_logic_vector(31 downto 0);
			E : out std_logic;
			Dmem_write : in std_logic;
			opcode : in std_logic_vector(5 downto 0));
end component;

component imem 
	port (clk : in std_logic;
		en  : in std_logic;
		address   : in std_logic_vector(10 downto 0); 
		data_out : out std_logic_vector(31 downto 0));
end component;

component dmem 
port (clk : in std_logic;
		we  : in std_logic_vector(3 downto 0); 
		en  : in std_logic_vector(3 downto 0);
		ssr : in std_logic_vector(3 downto 0);
		address   : in std_logic_vector(10 downto 0); 
		data_in : in std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0));
end component; 

component Extension
	port(datain : in std_logic_vector(15 downto 0);
			sel_ext : in std_logic;
			dataout : out std_logic_vector(31 downto 0));
end component;

component INC
	port( pc : in std_logic_vector(31 downto 0);
			inc_out : out std_logic_vector(31 downto 0));
end component;

component SL2_add
	port( NPC_in : in std_logic_vector(31 downto 0);
			regI_in : in std_logic_vector(31 downto 0);
			SL2_out : out std_logic_vector(31 downto 0));
end component;
--===========================================================================
signal ALU_op,WE : std_logic_vector(3 downto 0);
signal pc,regN : std_logic_vector(31 downto 0);
signal sv,lui,flag_move_to,Branchzero_flag,sel_ext : std_logic;
signal zero,Ne,overflow,E : std_logic;
signal Reg32_flag,Reg_Imm_not : std_logic;
signal EXT_out,ALU_out : std_logic_vector(31 downto 0);
signal regI,regA,regB,regHi,regLow,reg_IR,regZero,regNe : std_logic_vector(31 downto 0);
signal Reg_Imm,Reg_Write,MDRin : std_logic_vector(31 downto 0);
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
				Reg_Imm_not => Reg_Imm,
				rs => reg_IR(25 downto 21),
				rt => reg_IR(20 downto 16),
				rd => reg_IR(15 downto 11),
				Branchzero_flag => Branchzero_flag, --from CU
				Reg32_flag => Reg32_flag,
				Bus_W => Bus_W,
				Bus_A => Bus_A,
				Bus_B => Bus_B);

	u3_DMcontr : DMcontrol 
	port map( ALUout => ALU_out,
				MDRin => MDRin,
				DatatoDM => DatatoDM,
				WE => WE, 						-- COMES FROM CU(3 downto 0);
				Bus_DMA => Bus_DMA,
				DatafromDM => DatafromDM, 	--comes from the SRAM!!!!!
				MDRout => MDRout,				 --its not a register
				E => E,
				Dmem_write => Dmem_write,
				opcode => opcode);

	u4_Imem : imem 
	port map(clk => clk,
				en => en,					
				address => Bus_IMA,
				data_out => Bus_IMD);
				
	u8_dmem : dmem 
	port map(clk => clk,
				we => WE,
				en => en,
				ssr =>
				address =>
				data_in => Bus_DMA,
				data_out => data_out);
				
	u5_ext : Extension
	port map(datain => reg_IR(15 downto 0),
				sel_ext => sel_ext,		--from CU
				dataout => EXT_out);
				
	u6_inc : INC
	port map( pc => pc,
				inc_out => inc_out);
				
	u7_sl2 : SL2_add
	port map( NPC_in=>npc_reg,
				regI_in =>regI,
				SL2_out =>SL2_out);

----------------------------REGISTERS------------------------------
regHi_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_hi,do=>regHi);
regLow_unit : reg generic map(w=>32)port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_low,do=>regLow);
--regAlu_out : reg port map(clk=>clk,rst=>rst,en=>'1',di=>,do=>);
--regIR_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_IMD,do=>reg_IR);
regA_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_A,do=>regA);
regB_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_B,do=>regB);
regI_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>EXT_out,do=>regI);	
MDRin_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_B,do=>MDRin);
zero_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>zero,do=>regZero);	
Ne_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Ne,do=>regNe);	
regN_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>inc_out,do=>regN);	

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

