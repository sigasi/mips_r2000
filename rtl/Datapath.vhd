library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
	port( clk,rst : in std_logic;
			Bus_A_test,Bus_B_test : out std_logic_vector(31 downto 0);
			PC_write,sel_ext,Reg_Write,Reg_Imm,Dmem_write : in std_logic;
			ALU_op : in std_logic_vector(3 downto 0);
			sel_HiLow : in std_logic_vector(1 downto 0);
			sv,lui,jump,Branch,ne_eq,j_jal_flag : in std_logic;
			Branchzero_flag,Reg32_flag,en_Hi,en_Low,Link,DM_ALU : in std_logic;
			SEL_sig : in std_logic_vector(3 downto 0);
			Bus_W_test,Bus_IMD_out : out std_logic_vector(31 downto 0));
end Datapath;

architecture Behavioral of Datapath is

component reg 
	generic (w : integer);
	port(clk, rst, en : in std_logic;
	     di : in std_logic_vector(w-1 downto 0);
		  do : out std_logic_vector(w-1 downto 0));
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

component NPCmux
	port( regN, regD,regA,regM : in std_logic_vector(31 downto 0);
			zero,jump,Branch,ne_eq,j_jal_flag: in std_logic;
			npcmux_out :out std_logic_vector(31 downto 0));
end component;

component ALUmux_outunit
	port( regB,regI : in std_logic_vector(31 downto 0);
			RegImm : in std_logic;
			ALUmux_out: out std_logic_vector(31 downto 0));			
end component;

component RFmux 
	port( regN,regHi,regLow : in std_logic_vector(31 downto 0);
			regS,MDRout : in std_logic_vector(31 downto 0);
			Link,DM_ALU : in std_logic;
			sel_HiLow : in std_logic_vector(1 downto 0);
			RFmux_out : out std_logic_vector(31 downto 0));
end component;

component SEL
port(Zero, Ne : in std_logic;
			 SEL_sig : in std_logic_vector(3 downto 0);
			 sel_NPC : out std_logic_vector(1 downto 0));
end component;
--===========================================================================
signal WE,opcode,regP : std_logic_vector(3 downto 0);
signal pc,regN,regALU_out : std_logic_vector(31 downto 0);
signal zero,Ne,overflow,E : std_logic;
signal EXT_out,ALU_out,Bus_IMA,npcmux_out : std_logic_vector(31 downto 0);
signal DatatoDM,DatafromDM,MDRout,regD : std_logic_vector(31 downto 0);
signal regI,regA,regB,regHi,regLow,regZero,regNe : std_logic_vector(31 downto 0);
signal MDRin,inc_out,SL2_out,regM : std_logic_vector(31 downto 0);
signal Bus_hi,Bus_low,Bus_IMD,data_out,PSD : std_logic_vector(31 downto 0);
signal Bus_A,Bus_B,Bus_W,ALUmux_out : std_logic_vector(31 downto 0);
signal status_reg_in,status_reg_out : std_logic_vector(3 downto 0);
signal Bus_DMA : std_logic_vector(10 downto 0);

signal sel_NPC : std_logic_vector(1 downto 0);
begin

Bus_A_test <= Bus_A;
Bus_B_test <= Bus_B;
Bus_W_test <= Bus_W;
status_reg_in <= zero & Ne & overflow & E;
statusreg : reg generic map(w=>4) port map(clk=>clk,rst=>rst,en=>'1',di=>status_reg_in,do=>status_reg_out);
Bus_IMD_out <= Bus_IMD;
--========================INSTRUCTION FETCH==================================
regPC_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>PC_write,di=>npcmux_out,do=>Bus_IMA);
regN_unit  : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>INC_out,do=>regN);
regP_unit  : reg generic map(w=>4) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_IMA(31 downto 28),do=>regP);
	
	U0_Imem : imem 
	port map(clk => clk,
				en => '1',					
				address => Bus_IMA(12 downto 2),
				data_out => Bus_IMD);
				
	U1_inc : INC
	port map( pc => Bus_IMA,
				INC_out => INC_out);
				
--========================INSTRUCTION DECODE==================================
regA_unit  : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_A,do=>regA);
regB_unit  : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_B,do=>regB);
regI_unit  : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>EXT_out,do=>regI);	
regD_unit  : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>PSD,do=>regD); 

	PSD <= regP & Bus_IMD(25 downto 0) & "00";		--PWD unit
	U2_ext : Extension
		port map(datain => Bus_IMD(15 downto 0),		
					sel_ext => sel_ext,						--from CU
					dataout => EXT_out);

	U3_RF : Regfile_bl 
	port map(Clk => clk,
				Reg_Write => Reg_Write,					 --come from CU
				Reg_Imm_not => Reg_Imm,
				rs => Bus_IMD(25 downto 21),
				rt => Bus_IMD(20 downto 16),
				rd => Bus_IMD(15 downto 11),
				Branchzero_flag => Branchzero_flag, --from CU
				Reg32_flag => Reg32_flag,
				Bus_W => Bus_W,
				Bus_A => Bus_A,
				Bus_B => Bus_B);

--========================INSTRUCTION EXECUTION==================================
regM_unit  : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>SL2_out,do=>regM);	
--zero_unit  : reg generic map(w=>1) port map(clk=>clk,rst=>rst,en=>'1',di=>zero,do=>regZero);	
--Ne_unit    : reg generic map(w=>1) port map(clk=>clk,rst=>rst,en=>'1',di=>Ne,do=>regNe);	
regHi_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>en_Hi,di=>Bus_hi,do=>regHi);
regLow_unit : reg generic map(w=>32)port map(clk=>clk,rst=>rst,en=>en_Low,di=>Bus_low,do=>regLow);
regAlu_out_u : reg generic map(w=>32)port map(clk=>clk,rst=>rst,en=>'1',di=>ALU_out,do=>regALU_out);

	U4 : ALUmux_outunit
	port map(regB=> regB,		
				regI=>regI,
				RegImm=>Reg_Imm,				---???
				ALUmux_out=>ALUmux_out);

	U5_ALU : ALU 
	port map(Bus_A => Bus_A,
				Bus_B => ALUmux_out,
				shamt => Bus_IMD(10 downto 6),
				ALU_op => ALU_op,							--FROM CU
				sv => sv,lui => lui,						--from CU
				flag_move_to => sel_HiLow(1),			--from Cu
				ALU_out => ALU_out,
				zero =>zero,Ne => Ne,
				overflow => overflow,					--
				Bus_hi => Bus_hi,
				Bus_low=> Bus_low );
	
	U6_SL2 : SL2_add
	port map( NPC_in => regN,					--FROM NPC?
				regI_in => regI,
				SL2_out => SL2_out);
				

--========================MEMORY WRITE==================================
MDRin_unit : reg generic map(w=>32) port map(clk=>clk,rst=>rst,en=>'1',di=>regB,do=>MDRin);
	
	U6_DMcontr : DMcontrol 
	port map( ALUout => regALU_out(12 downto 0),
				MDRin => MDRin,
				DatatoDM => DatatoDM,
				WE => WE, 						-- COMES FROM CU(3 downto 0);
				Bus_DMA => Bus_DMA,
				DatafromDM => DatafromDM, 	--comes from the SRAM!!!!!
				MDRout => MDRout,				
				E => E,
				Dmem_write => Dmem_write,
				opcode => Bus_IMD(31 downto 26));			
	
	U7_dmem : dmem 
	port map(clk => clk,
				we => WE,
				en => "1111",
				ssr => "0000",
				address => Bus_DMA,
				data_in => DatatoDM,
				data_out => DatafromDM);
				
--========================WRITE back==================================
				
--	U8 : NPCmux
--	port map(regN=>regN,
--				regD=>regD,regA=>regA,
--				regM=>regM,zero=>status_reg_out(3),
--				jump=>jump,Branch=>Branch,
--				ne_eq=>ne_eq,j_jal_flag=>j_jal_flag,
--				npcmux_out =>npcmux_out);

	U9 : RFmux 
	port map(regN=>regN,
				regHi=>regHi,
				regLow=>regLow,
				regS=>regALU_out,
				MDRout=>MDRout,
				Link =>Link,
				DM_ALU =>DM_ALU,
				sel_HiLow =>sel_HiLow,
				RFmux_out=>Bus_W);
				
				
				
				sel_unt: SEL
				port map(Zero => status_reg_out(3),
				         Ne => status_reg_out(2),
			            SEL_sig => SEL_sig,
			            sel_NPC => sel_NPC);
							
	process(sel_NPC, regN,regD, regA, regM)
	begin
		case sel_NPC is
			when "00" => npcmux_out <= regN;
			when "01" => npcmux_out <= regD;
			when "10" => npcmux_out <= regA;
			when "11" => npcmux_out <= regM;
			when others => npcmux_out <= (others =>'0');
		end case;
	end process;
end Behavioral;

