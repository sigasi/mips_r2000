library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity MIPS_toplevel is
	port(clk,rst : in std_logic;
		  datain : in std_logic_vector(31 downto 0);
		  Dmem_write_out : out std_logic;
		  IR_outt,DMAR_out,RFmux_outt,Bus_W_out,Bus_S_out : out std_logic_vector(31 downto 0);
		  status_reg : out std_logic_vector(1 downto 0);
		  dataout, dataout2,pc_out : out std_logic_vector(31 downto 0));
end MIPS_toplevel;

architecture Behavioral of MIPS_toplevel is


Component ControlUnit
	port(clk,rst : in std_logic;
		  instruction : in std_logic_vector(31 downto 0);
		  RegImm,jump,branch,Link,DM_ALU,sel_ext : out std_logic;
		  ALU_op : out std_logic_vector(3 downto 0);
		  Reg_write,Dmem_write,PC_write : out std_logic);
end component;

component reg 
	port(clk, rst, en : in std_logic;
	     di : in std_logic_vector(31 downto 0);
		  do : out std_logic_vector(31 downto 0));
end component;
---------------------------------------------------------------
component INC
	port(pc : in std_logic_vector(31 downto 0);
		  inc_out : out std_logic_vector(31 downto 0));
end component;

component IMEM_rom64x32
    Port ( ADDR : in std_logic_vector(5 downto 0);
           DOUT : out std_logic_vector(31 downto 0));
end component;

component Regfile_bl
	port( Clk : in std_logic;
			Reg_Write : in std_logic;
			Reg_Imm_not : in std_logic;
			rs : in std_logic_vector(4 downto 0);
			rt : in std_logic_vector(4 downto 0);
			rd : in std_logic_vector(4 downto 0);
			Bus_W : in std_logic_vector(31 downto 0);
			Bus_A : out std_logic_vector(31 downto 0);
			Bus_B : out std_logic_vector(31 downto 0));
end component;

component Extension
	port(datain : in std_logic_vector(15 downto 0);
			sel_ext : in std_logic;
			dataout : out std_logic_vector(31 downto 0));
end component;

component ALU 
	port( shamt : in std_logic_vector(4 downto 0);
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALU_op :in std_logic_vector(3 downto 0);
			--sv : in std_logic;
			Bus_S : out std_logic_vector(31 downto 0);
			zero,notequal : out std_logic);
end component;

component ALUmux_outunit
	port( regB,regI : in std_logic_vector(31 downto 0);
			RegImm : in std_logic;
			ALUmux_out: out std_logic_vector(31 downto 0));			
end component;

component SL2_add
	port( NPC_in : in std_logic_vector(31 downto 0);
			regI_in : in std_logic_vector(31 downto 0);
			SL2_out : out std_logic_vector(31 downto 0));
end component;

component DMEM_blockram32x32 
 port (
   di  : in std_logic_vector(31 downto 0); 
	a   : in std_logic_vector(4 downto 0); 
	we  : in std_logic; 
	clk : in std_logic; 
 	do  : out std_logic_vector(31 downto 0));
end component; 

component NPCmux
	port(Bus_A :in std_logic_vector(31 downto 0);
			regM : in std_logic_vector(31 downto 0);
			regNPC : in std_logic_vector(31 downto 0);
			zero,jump,Branch,ne_eq: in std_logic;
			npcmux_out :out std_logic_vector(31 downto 0));
end component;

component RFmux 
	port( regNPC : in std_logic_vector(31 downto 0);
			regS,MDRout : in std_logic_vector(31 downto 0);
			Link,DM_ALU : in std_logic;
			RFmux_out : out std_logic_vector(31 downto 0));
end component;




-------------------------------------------------------------
signal ALU_op :std_logic_vector(3 downto 0);
signal Bus_S,Bus_W,regMAR : std_logic_vector(31 downto 0);
signal reg_fileA_out,regA,regB,reg_fileB_out: std_logic_vector(31 downto 0);
signal sv,RegImm,sel_ext,regZ,we : std_logic;
signal ALUmux_out,regI : std_logic_vector(31 downto 0);
signal EXT_out : std_logic_vector(31 downto 0);
signal ir_out,Im_out : std_logic_vector(31 downto 0);

signal Reg_Write,Branch,jump,Link,DM_ALU,notequal: std_logic;
signal pc,npcmux_out,regMDRin,regMDRout,RFmux_out : std_logic_vector(31 downto 0);
signal npc_reg,inc_out,SL2_out:std_logic_vector(31 downto 0);
signal regM,regS,Dmemout : std_logic_vector(31 downto 0);
signal Dmem_write,PC_write,zero : std_logic;

begin

	pc_out <= pc;
	Dmem_write_out <= Dmem_write;
	IR_outt <= IR_out;
	DMAR_out <= regMAR;
	RFmux_outt <= RFmux_out;
	Bus_W_out <= Bus_W;
	Bus_S_out <= Bus_S;
	status_reg <= zero & notequal;
	
	dataout2 <= npcmux_out; 
	dataout <= Bus_W;
------------------

	cu_unit: ControlUnit
	port map(clk => clk,rst => rst,
            instruction => ir_out,
		      RegImm => RegImm,
				jump => jump,
				branch => branch,
				Link => link,
				DM_ALU => DM_ALU,
				sel_ext => sel_ext,
		      ALU_op => ALU_op,
		      Reg_write => Reg_write,
				Dmem_write => Dmem_write,
				PC_write => PC_write);
				



-- Instruction Fetch (IF) ---------------------------------------
pc_reg : reg port map(clk=>clk,rst=>rst,en=>PC_write,di=>npcmux_out,do=>pc);
npc_reg_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>inc_out,do=>npc_reg);
ir_out_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Im_out,do=>ir_out);
--	u_pc : process(clk)
--		begin
--			if(rising_edge(clk))then
--				if(rst = '1') then
--					pc<= (others =>'0');
--					npc_reg <=(others =>'0');
--					ir_out <=(others =>'0');
--				else
--					if(PC_write = '1')then
--						pc<=npcmux_out;
--					end if;
--					npc_reg <= inc_out;
--					ir_out <= Im_out;
--				end if;	
--			end if;
--	end process;
	
	u0 : INC
	port map(pc =>pc,
		  inc_out =>inc_out);
		  
	u1: IMEM_rom64x32
    Port map( ADDR=>pc(5 downto 0),
           DOUT=>Im_out);
	
-----------------------------------------------------------------	

-- Instruction Decode (ID) --------------------------------------	
	u2 : Regfile_bl
	port map(Clk => Clk,
		Reg_Write => Reg_Write,
		Reg_Imm_not => RegImm,--mhpws to exw xrhsimopoihsei hdh?
		rs => ir_out(25 downto 21),
		rt =>ir_out(20 downto 16),
		rd =>ir_out(15 downto 11),
		Bus_W =>Bus_W,
		Bus_A =>reg_fileA_out,
		Bus_B =>reg_fileB_out);
	
	
	u3 : Extension
	port map(datain => ir_out(15 downto 0),
			sel_ext => sel_ext,
			dataout => EXT_out);
	
	
regA_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>reg_fileA_out,do=>regA);
regB_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>reg_fileB_out,do=>regB);
regI_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>EXT_out,do=>regI);	
--	u_reg : process (clk)
--		begin
--		if(rising_edge(clk))then
--			regA <= reg_fileA_out;
--			regB <= reg_fileB_out;
--			regI <= EXT_out;
--		end if;
--	end process;
-----------------------------------------------------------------
	
	
-- Instruction Execution (IEx) ----------------------------------
--	ALUmux_out <= regB when RegImm = '1' else regI;
	p : ALUmux_outunit
	port map(regB=> regB,
				regI=>regI,
				RegImm=>RegImm,
				ALUmux_out=>ALUmux_out);	

	u4 : ALU
	port map( shamt =>ir_out(10 downto 6), 
			Bus_A => regA,
			Bus_B =>ALUmux_out,
			ALU_op => ALU_op,
			--sv => '1',
			Bus_S => Bus_S,
			zero => zero,
			notequal=>notequal);
			
	u5 : SL2_add
	port map( NPC_in=>npc_reg,
			regI_in =>regI,
			SL2_out =>SL2_out);

regM_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>SL2_out,do=>regM);	
regS_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_S,do=>regS);		
	u_reg1 : process (clk)
		begin
			if(rising_edge(clk))then
				regZ <= zero;
			end if;
		end process;
		
	
-----------------------------------------------------------------

-- Memory Write (MW) --------------------------------------------

	u8 : DMEM_blockram32x32 
	port map(di =>regMDRin,
				a => regMAR(4 downto 0),
				we=>Dmem_write,
				clk=>clk, 
				do  => Dmemout);
				
regMDR_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>regB,do=>regMDRin);	
regMAR_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Bus_S,do=>regMAR);	
--regMDRout_unit : reg port map(clk=>clk,rst=>rst,en=>'1',di=>Dmemout,do=>regMDRout);	
regMDRout<=Dmemout;
--	u_reg2 : process(clk)
--		begin
--			if(rising_edge(clk))then
--				regMDRin <= regB;
--				regMAR <= Bus_S;
--				regMDRout <= Dmemout;
--			end if;
--		end process;
--	
-----------------------------------------------------------------

-- Write Back (WB) ----------------------------------------------
	u6 : NPCmux
	port map(Bus_A => regA,
			regM =>regM,
			regNPC =>npc_reg,
			zero=>zero,
			jump=>jump,
			Branch=>Branch,
			ne_eq=> '1',--notequal,--ne_eq,
			npcmux_out =>npcmux_out );
			
			
 -- ===================================================================
 -- To shma ne_eq den DEN einai to shma "Ne" (Negative) ths ALU
 -- to shma ne_eq erxetai apo th CU kai kathorizei an exeis
 -- entolh BNE h BEQ, otan BNE -> ne_eq = '1' otan BEQ -> ne_eq = '0'
 -- epeidh exeis mono BNE bazoyme to ne_eq tou MUX NPC monima se '1'
 -- Diafaneia: 449
 -- ==================================================================== 
			
	u7 : RFmux 
	port map(
	regNPC =>npc_reg,
			regS => regS,
			MDRout=> regMDRout,
			Link=> Link,
			DM_ALU=>DM_ALU,
			RFmux_out=> Bus_W);
			
-----------------------------------------------------------------
			
end Behavioral;

