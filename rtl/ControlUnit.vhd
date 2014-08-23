library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
	port(clk,rst : in std_logic;
		  instruction : in std_logic_vector(31 downto 0);
		  RegImm,jump,branch,Link,DM_ALU,sel_ext : out std_logic;
		  ALU_op : out std_logic_vector(3 downto 0);
		  Reg_write,Dmem_write,PC_write : out std_logic;
		  sel_HiLow : out std_logic_vector(1 downto 0);
		  sv,lui,ne_eq,j_jal_flag : out std_logic;
		  Branchzero_flag,Reg32_flag,en_Hi,en_Low : out std_logic);
end ControlUnit;


--rs => Bus_IMD(25 downto 21),
--				rt => instruction(20 downto 16)
--				rd => Bus_IMD(15 downto 11),
--



--		  RegImm
--		  DM_ALU
--		  sel_ext
--		  sel_HiLow
--		  sv,
--		  lui,
--		  ne_eq,
--		  j_jal_flag
--		  Branchzero_flag,
--		  Reg32_flag,


--FSM
--		  Reg_write
--		  Dmem_write,
--		  PC_write
--		  en_Hi
--		  en_Low 


architecture Behavioral of ControlUnit is

	constant lw : std_logic_vector(5 downto 0)   := "100011";		--I
	constant sw : std_logic_vector(5 downto 0)   := "101011";		--I
	constant jr : std_logic_vector(5 downto 0)   := "001000";
	constant jalr : std_logic_vector(5 downto 0) := "001001";
	constant addu : std_logic_vector(5 downto 0) := "100001";
	constant subu : std_logic_vector(5 downto 0) := "100011";
	constant andi : std_logic_vector(5 downto 0) := "001100";	 --I
	constant slll : std_logic_vector(5 downto 0) := "000000";	
	constant bne : std_logic_vector(5 downto 0)  := "000101";     --I
	constant slt : std_logic_vector(5 downto 0)  := "101010";
	----------------------------------------------------------
	constant LB : std_logic_vector(5 downto 0)     := "100000";	--I
	constant LBU : std_logic_vector(5 downto 0)    := "100100";	--I
	constant LH : std_logic_vector(5 downto 0)     := "100001";	--I
	constant LHU : std_logic_vector(5 downto 0)    := "100101";	--I
	constant SB : std_logic_vector(5 downto 0)     := "101000";	--I
	constant SH : std_logic_vector(5 downto 0)     := "101001";	--I
	constant ADDI : std_logic_vector(5 downto 0)   := "001000";	--I
	constant ADDIU : std_logic_vector(5 downto 0)  := "001001";	--I
	constant ORI : std_logic_vector(5 downto 0)    := "001101";	--I
	constant XORI : std_logic_vector(5 downto 0)   := "001110";	--I
	constant LUI : std_logic_vector(5 downto 0)    := "001111";	--I
	-----------------------------------------------------------
	constant MFHI : std_logic_vector(5 downto 0)    := "010000";	--R
	constant MFLO : std_logic_vector(5 downto 0)    := "010010";	--R
	constant MTHI : std_logic_vector(5 downto 0)    := "010001";	--R
	constant MTLO : std_logic_vector(5 downto 0)    := "010011";	--R
	constant ADD  : std_logic_vector(5 downto 0)    := "100000";	--R
	CONSTANT sub : std_logic_vector(5 downto 0)   := "100010";
	CONSTANT mult : std_logic_vector(5 downto 0)  := "011000";
	CONSTANT and_op : std_logic_vector(5 downto 0):= "100100";
	CONSTANT or_op : std_logic_vector(5 downto 0) := "100101";
	-----------------------------------------------
	CONSTANT xor_op : std_logic_vector(5 downto 0):= "100110";
	CONSTANT nor_op : std_logic_vector(5 downto 0):= "100111";
	CONSTANT srlv : std_logic_vector(5 downto 0)  := "000110";
	CONSTANT srav : std_logic_vector(5 downto 0)  := "000111";
	CONSTANT sllv : std_logic_vector(5 downto 0)  := "000100";
	CONSTANT srlv : std_logic_vector(5 downto 0)  := "000110";
	CONSTANT srav : std_logic_vector(5 downto 0)  := "000111";
	CONSTANT slti : std_logic_vector(5 downto 0)  := "001010";
	CONSTANT sltiu : std_logic_vector(5 downto 0) := "001011";
	CONSTANT sltu : std_logic_vector(5 downto 0)  := "101011";
	--------------------------------
	CONSTANT beq : std_logic_vector(5 downto 0)   := "000100";
	CONSTANT blez : std_logic_vector(5 downto 0)  := "000110";
	CONSTANT bgtz : std_logic_vector(5 downto 0)  := "000111";
	CONSTANT bxxx : std_logic_vector(5 downto 0)  := "000001";
	CONSTANT j : std_logic_vector(5 downto 0)     := "000010";
	CONSTANT jal : std_logic_vector(5 downto 0)   := "000011";
	
	
	signal RegImm_sig, branch_sig : std_logic;
	signal aluop1,aluop2 : std_logic_vector (3 downto 0);
	type state_type is (Instr_fetch,instr_decode,execution,memory,mem_wb,write_back);
	signal current_state,next_state : state_type;
	
begin

	RegImm_sig <= '1' when instruction(31 downto 26) = "000000" else '0';
	RegImm<= RegImm_sig or branch_sig;
	
	jump <= '1' when(((instruction(5 downto 0) = jr or
							instruction(5 downto 0) = jalr) and RegImm_sig = '1') or 
							instruction(5 downto 0) = jal or
							instruction(5 downto 0) = j ) else '0';
							
--------------------------------------------------------------------------------------------------
							
	branch_sig <= '1' when(instruction(31 downto 26) = bne  or
								  instruction(31 downto 26) = beq  or
								  instruction(31 downto 26) = blez or
								  instruction(31 downto 26) = bgtz or
								  instruction(31 downto 26) = bxxx )and RegImm_sig = '0' else '0';
	branch <= branch_sig;
--------------------------------------------------------------------------------------------------	
	link <= '1' when(instruction(5 downto 0) = jalr or 
						  instruction(5 downto 0) = jal or
						  (instruction(5 downto 0) = bxxx and (instruction(20 downto 16)="00010" or instruction(20 downto 16) = "00011" ))) else '0';
							--bgezal bltzal		
--------------------------------------------------------------------------------------------------	
	
	DM_ALU <= '1' when(instruction(31 downto 26) = lw and RegImm_sig = '0') else '0';
		
--------------------------------------------------------------------------------------------------	
	sel_ext <= '0' when(instruction(31 downto 26) = andi) else '1';
	
	-- I-type Control Signals ------------------------
	 aluop2 <= "1000" when(instruction(31 downto 26) = addi) else
			       "1001" when(instruction(31 downto 26) = addiu) else
			       "1100" when(instruction(31 downto 26) = andi) else
			       "1101" when(instruction(31 downto 26) = ori) else
			       "1110" when(instruction(31 downto 26) = xori) else
			       "0000" when(instruction(31 downto 26) = lui) else
			       "1000" when(instruction(31 downto 26) = lb or instruction(31 downto 26) = lh or instruction(31 downto 26) = lw or instruction(31 downto 26) = lbu or instruction(31 downto 26) = lhu) else
			       "1000" when(instruction(31 downto 26) = sb or instruction(31 downto 26) = sh or instruction(31 downto 26) = sw) else
			       "1010" when(instruction(31 downto 26) = beq) else
			       "1010" when(instruction(31 downto 26) = bne) else
			       "0110" when(instruction(31 downto 26) = slti) else
			       "0111" when(instruction(31 downto 26) = sltiu) else
			       "1010" when(instruction(31 downto 26) = blez) else
			       "1010" when(instruction(31 downto 26) = bgtz) else
			       "1010" when(instruction(31 downto 26) = bxxx and (instruction(20 downto 16) = "00000" or instruction(20 downto 16) = "00001" or instruction(20 downto 16) = "10000" or instruction(20 downto 16) = "10001")) else
			       "0000";

-- R-type Control Signals ------------------------							 
	 aluop1 <= "1000" when(instruction(5 downto 0) = add) else
	 			    "1001" when(instruction(5 downto 0) = addu) else
	 			    "1010" when(instruction(5 downto 0) = sub) else
	 			    "1011" when(instruction(5 downto 0) = subu) else
	 			    "1100" when(instruction(5 downto 0) = and_op) else
	 			    "1101" when(instruction(5 downto 0) = or_op) else
	 			    "1110" when(instruction(5 downto 0) = xor_op) else
	 			    "1111" when(instruction(5 downto 0) = nor_op) else
	 			    "0000" when(instruction(5 downto 0) = slll) else
	 			    "0010" when(instruction(5 downto 0) = sllv) else-----------
	 			    "0011" when(instruction(5 downto 0) = shra) else-------------
	 			    "0000" when(instruction(5 downto 0) = sllv) else
	 			    "0010" when(instruction(5 downto 0) = srlv) else
	 			    "0011" when(instruction(5 downto 0) = srav) else
	 			    "0110" when(instruction(5 downto 0) = slt) else
	 			    "0111" when(instruction(5 downto 0) = sltu) else
	 			    "0000";

	ALU_op <= aluop1 when RegImm_sig='1' else aluop2; 
	
	
	fsm : process(rst,clk)
	begin
			if(rst = '1')then
				current_state <= Instr_fetch;
			elsif(rising_edge(clk))then
				current_state <= next_state;
			end if;
		end process;
		
		
-----------------------------------
	process(current_state)
		begin
		case current_state is
						when Instr_fetch =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							
							next_state<=instr_decode;
							
						when instr_decode=>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
						
							if(	(instruction(5 downto 0) = jr or instruction(5 downto 0) = jalr)	and RegImm_sig = '1') then
								next_state<= write_back;
							else 
								next_state<= execution;
							end if;
						
						when execution =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							
							if(instruction(31 downto 26) = lw)then
								next_state <=  memory;
							elsif(instruction(31 downto 26) = sw)then
								next_state <= mem_wb;
							else
								next_state <= write_back;
							end if;
							
							
						when memory =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							
							next_state <= write_back;
							
						
						when write_back =>
							Dmem_write <= '0';
							PC_write <= '1';
							
							if(instruction(31 downto 26) = bne or (RegImm_sig = '1' and instruction(5 downto 0) = jr))then
								Reg_write <= '0';
							else
								Reg_write <= '1';
							end if;
	
							next_State <=  Instr_fetch;
------------------------------------------------------------------------

						when mem_wb =>
							Reg_write <= '0';
							Dmem_write <= '1';
							PC_write <= '1';
							
							next_state <=Instr_fetch;
							
						when others =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							
							next_state <=Instr_fetch;
		end case;			
	end process;

end Behavioral;