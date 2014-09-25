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
		  sv,lui_sig,ne_eq,j_jal_flag : out std_logic;
		  SEL_sig : out std_logic_vector(3 downto 0);
		  Branchzero_flag,Reg32_flag,en_Hi,en_Low : out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is

------------------Instructions----------------------------
--LOAD INSTR
	constant LB : std_logic_vector(5 downto 0)     := "100000";	--I
	constant LBU : std_logic_vector(5 downto 0)    := "100100";	--I
	constant LH : std_logic_vector(5 downto 0)     := "100001";	--I
	constant LHU : std_logic_vector(5 downto 0)    := "100101";	--I
	constant LW : std_logic_vector(5 downto 0)   := "100011";	--I
	constant LUI : std_logic_vector(5 downto 0)    := "001111";	--I

--STORE INSTR
	constant SB : std_logic_vector(5 downto 0)     := "101000";	--I
	constant SH : std_logic_vector(5 downto 0)     := "101001";	--I
	constant SW : std_logic_vector(5 downto 0)   := "101011";	--I
--LOGICAL
	constant ADDI : std_logic_vector(5 downto 0)   := "001000";	--I
	constant ADDIU : std_logic_vector(5 downto 0)  := "001001";	--I
	constant ANDI : std_logic_vector(5 downto 0) := "001100";	--I
	constant ORI : std_logic_vector(5 downto 0)    := "001101";	--I
	constant XORI : std_logic_vector(5 downto 0)   := "001110";	--I
--MOVE INSTR
	constant MFHI : std_logic_vector(5 downto 0)    := "010000";	--R
	constant MFLO : std_logic_vector(5 downto 0)    := "010010";	--R
	constant MTHI : std_logic_vector(5 downto 0)    := "010001";	--R
	constant MTLO : std_logic_vector(5 downto 0)    := "010011";	--R
--R INSRT
	constant ADD  : std_logic_vector(5 downto 0)    := "100000";	--R
	constant ADDU : std_logic_vector(5 downto 0) := "100001";		--R
	CONSTANT SUB : std_logic_vector(5 downto 0)   := "100010";		--R
	constant SUBU : std_logic_vector(5 downto 0) := "100011";		--R
	constant MULT : std_logic_vector(5 downto 0)  := "011000";		--R
	constant AND_op : std_logic_vector(5 downto 0):= "100100";		--R
	constant OR_op : std_logic_vector(5 downto 0) := "100101";		--R
	constant XOR_op : std_logic_vector(5 downto 0):= "100110";		--R
	constant NOR_op : std_logic_vector(5 downto 0):= "100111";		--R
--SHIFT	
	constant SLL_op : std_logic_vector(5 downto 0) := "000000";		--R
	constant SRL_op : std_logic_vector(5 downto 0) := "000010";		--R
	constant SRA_op : std_logic_vector(5 downto 0) := "000011";
	constant SLLV : std_logic_vector(5 downto 0)  := "000100";
	constant SRLV : std_logic_vector(5 downto 0)  := "000110";
	constant SRAV : std_logic_vector(5 downto 0)  := "000111";
	constant SLTI : std_logic_vector(5 downto 0)  := "001010";
	constant SLTIU : std_logic_vector(5 downto 0) := "001011";
	constant SLT : std_logic_vector(5 downto 0)  := "101010";
	constant SLTU : std_logic_vector(5 downto 0)  := "101011";
--BRANCH
	constant BEQ : std_logic_vector(5 downto 0)   := "000100";		--I
	constant BNE : std_logic_vector(5 downto 0)  := "000101";     	--I
	constant BLEZ : std_logic_vector(5 downto 0)  := "000110";		--I
	constant BGTZ : std_logic_vector(5 downto 0)  := "000111";
	constant Bxxx : std_logic_vector(5 downto 0)  := "000001"; --BLTZ BGEZ BLTZAL BGEZAL
--JUMP
	constant JR : std_logic_vector(5 downto 0)   := "001000";
	constant JALR : std_logic_vector(5 downto 0) := "001001";
	constant J : std_logic_vector(5 downto 0)     := "000010";
	constant JAL : std_logic_vector(5 downto 0)   := "000011";
-----------------------------------------------------------------------------------	

	signal RegImm_sig, branch_sig : std_logic;
	signal aluop1,aluop2 : std_logic_vector (3 downto 0);
	signal opcode : std_logic_vector(5 downto 0);
	signal func : std_logic_vector(5 downto 0);
	type state_type is (Instr_fetch,instr_decode,execution,memory,execution_wb,mem_wb,write_back);
	signal current_state,next_state : state_type;
	signal rt : std_logic_vector(4 downto 0);
begin

	SEL_sig <= X"1" when(opcode = beq) else
	 						X"2" when(opcode = bne) else
	 						X"3" when(opcode = blez) else
	 						X"4" when(opcode = bgtz) else
	 						X"5" when(opcode = bxxx and (rt = "00000" or rt = "10000")) else
	 						X"6" when(opcode = bxxx and (rt = "00001" or rt = "10001")) else
	 						X"7" when(RegImm_sig = '1' and (func = jr or func = jalr)) else
	 						X"8" when(opcode = j or opcode = jal) else
	 						X"0";

	opcode   <= instruction(31 downto 26);
	rt 		<= instruction(20 downto 16);
	func		<= instruction(5 downto 0);
	

	ne_eq <= '1' when(opcode = bne) else '0';

	RegImm <= RegImm_sig or branch_sig;
	ALU_op <= aluop1 when RegImm_sig='1' else aluop2; 
	ne_eq <= '1' when(opcode = bne) else '0';
	ne_eq <= '1' when(opcode = bne) else '0';
--------------------------------------------------------------------------------------------------	
	jump <= '1' when(((func = JR or
							func = JALR) and RegImm_sig = '1') or 
							func = JAL or
							func = J ) else '0';
--------------------------------------------------------------------------------------------------				
	branch_sig <= '1' when(opcode = BNE  or
								  opcode = BEQ  or
								  opcode = BLEZ or
								  opcode = BGTZ or
								  opcode = Bxxx )and RegImm_sig = '0' else '0';
	branch <= branch_sig;
--------------------------------------------------------------------------------------------------	
	link <= '1' when(func = JALR or 
						  func = JAL or
						  (func = Bxxx and (rt ="00010" or rt = "00011" ))) else '0';
							--bgezal bltzal		
--------------------------------------------------------------------------------------------------	
	sv <= '1' when (func = SLLV or
						 func = SRLV or 
						 func = SRAV		)else  '0';
--------------------------------------------------------------------------------------------------	
	RegImm_sig <= '1' when opcode = "000000" else '0';
--------------------------------------------------------------------------------------------------
	lui_sig <=  '1' when( opcode = LUI) else '0';

--------------------------------------------------------------------------------------------------			  
	sel_HiLow <= "10" when ((func = MTHI or func = MFHI) AND RegImm_sig = '1')
                         else "11" when  ((func= MFLO or func = MTLO) AND RegImm_sig = '1')
                         else "00";		  

--------------------------------------------------------------------------------------------------
	sel_HiLow <= "10" when ((func = MTHI or func = MFHI) AND RegImm_sig = '1')
			  else "11" when  ((func= MFLO or func = MTLO) AND RegImm_sig = '1')
			  else "00";

--------------------------------------------------------------------------------------------------
	Branchzero_flag <= '0' when( opcode = BLEZ or opcode = BGTZ or
										  (opcode = Bxxx and (rt = "00000" or rt = "00001" or rt = "10000" or rt = "10001"))  )  else '0';
--------------------------------------------------------------------------------------------------	
	Reg32_flag <= '1' when(	opcode = JAL or (opcode = Bxxx and (rt = "10000" or rt = "10001"))		) else '0';
--------------------------------------------------------------------------------------------------	
	j_jal_flag <= '1' when( opcode = JAL or opcode = J ) else '0';
--------------------------------------------------------------------------------------------------	
	sel_ext <= '0' when ( opcode = ANDI or		
								 opcode = XORI or
								 opcode = ORI  ) else '1';
--------------------------------------------------------------------------------------------------
	DM_ALU <= '1' when( (opcode = LW or
							   opcode = LB or
							   opcode = LBU or
							   opcode = LH or
							   opcode = LHU )		and RegImm_sig = '0') else '0';
--------------------------------------------------------------------------------------------------	

	 SEL_sig <= X"1" when(opcode = beq) else
	 						X"2" when(opcode = bne) else
	 						X"3" when(opcode = blez) else
	 						X"4" when(opcode = bgtz) else
	 						X"5" when(opcode = bxxx and (rt = "00000" or rt = "10000")) else
	 						X"6" when(opcode = bxxx and (rt = "00001" or rt = "10001")) else
	 						X"7" when(RegImm_sig = '1' and (func = jr or func = jalr)) else
	 						X"8" when(opcode = j or opcode = jal) else
	 						X"0";
	 	
--------------------------------------------------------------------------------------------------	
	
-- I-type Control Signals ------------------------
	 aluop2 <=   "1000" when(opcode = addi) else
			       "1001" when(opcode = addiu) else
			       "1100" when(opcode = andi) else
			       "1101" when(opcode = ori) else
			       "1110" when(opcode = xori) else
			       "0000" when(opcode = lui) else
			       "1000" when(opcode = lb or opcode = lh or opcode = lw or opcode = lbu or opcode = lhu) else
			       "1000" when(opcode = sb or opcode = sh or opcode = sw) else
			       "1010" when(opcode = beq) else
			       "1010" when(opcode = bne) else
			       "0110" when(opcode = slti) else
			       "0111" when(opcode = sltiu) else
			       "1010" when(opcode = blez) else
			       "1010" when(opcode = bgtz) else
			       "1010" when(opcode = bxxx and (rt = "00000" or rt = "00001" or rt = "10000" or rt = "10001")) else
			       "0000";

-- R-type Control Signals ------------------------							 
	 aluop1 <=   "1000" when(func = add) else
	 			    "1001" when(func = addu) else
	 			    "1010" when(func = sub) else
	 			    "1011" when(func = subu) else
	 			    "1100" when(func = and_op) else
	 			    "1101" when(func = or_op) else
	 			    "1110" when(func = xor_op) else
	 			    "1111" when(func = nor_op) else
					 
	 			    "0000" when(func = SLL_op) else
	 			    "0010" when(func = SRL_op) else
	 			    "0011" when(func = SRA_op) else
					 
	 			    "0000" when(func = SLLV) else	
	 			    "0010" when(func = SRLV) else
	 			    "0011" when(func = SRAV) else
	 			    "0110" when(func = SLT) else
	 			    "0111" when(func = SLTU) else
	 			    "0000"; 
					 
------------------------------------FSM--------------------------------------	
	fsm : process(rst,clk)
	begin
			if(rst = '1')then
				current_state <= Instr_fetch;
			elsif(rising_edge(clk))then
				current_state <= next_state;
			end if;
		end process;		
-----------------------------------
	process(current_state,opcode,func,rt,RegImm_sig)
		begin
		case current_state is
						when Instr_fetch =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							en_Hi  <= '0';
							en_Low <= '0';
							next_state<=instr_decode;
							
						when instr_decode=>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							en_Hi  <= '0';
							en_Low <= '0';
							if( (	(func = JR or func = JALR or func = MFHI or func = MFLO)	and RegImm_sig = '1') or opcode = J or opcode = JAL  )then
								next_state<= write_back;
							elsif(	RegImm_sig = '1' and (func = MTHI or func = MTLO)	)then
								next_state <=  execution_wb;	
							else 
								next_state<= execution;
							end if;
						
						when execution =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							en_Hi  <= '0';
							en_Low <= '0';

							if(opcode = LW or opcode = LB or opcode = LBU or opcode = LH or opcode = LHU)then
								next_state <=  memory;								
							elsif(opcode = SW or opcode = SB or opcode = SH)then
								next_state <= mem_wb;
							else
								next_state <= write_back;
							end if;
							
							
						when memory =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							en_Hi  <= '0';
							en_Low <= '0';
							next_state <= write_back;
							
						
						when write_back => 
							if  (opcode = BNE or 
								opcode = BEQ or
								opcode = BLEZ or
								opcode = BGTZ or
								opcode = J or
								(opcode = Bxxx and (rt = "00000" or rt = "00001")) or
								(RegImm_sig = '1' and func = JR))then
										Reg_write <= '0';
										Dmem_write <= '0';
										PC_write <= '1';
										en_Hi  <= '0';
										en_Low <= '0';

							elsif(	RegImm_sig = '1' and func = MULT	)then			
										Reg_write <= '0';
										Dmem_write <= '0';
										PC_write <= '1';
										en_Hi  <= '1';
										en_Low <= '1';

							else			
										Reg_write <= '1';
										Dmem_write <= '0';
										PC_write <= '1';
										en_Hi  <= '0';
										en_Low <= '0';
							end if;
	
							next_State <=  Instr_fetch;
------------------------------------------------------------------------
						
						when execution_wb =>
							if(	RegImm_sig = '1' and func = MTLO	)then
										Reg_write <= '0';
										Dmem_write <= '0';
										PC_write <= '1';
										en_Hi  <= '0';
										en_Low <= '1';

							elsif(	RegImm_sig = '1' and func = MTHI )then
										Reg_write <= '0';
										Dmem_write <= '0';
										PC_write <= '1';
										en_Hi  <= '1';
										en_Low <= '0';
							else
										Reg_write <= '0';
										Dmem_write <= '0';
										PC_write <= '1';
										en_Hi  <= '0';
										en_Low <= '0';
							end if;
							next_State <=  Instr_fetch;
							
							
							
						when mem_wb =>
							Reg_write <= '0';
							Dmem_write <= '1';
							PC_write <= '1';
							en_Hi  <= '0';
							en_Low <= '0';

							next_state <=Instr_fetch;
							
						when others =>
							Reg_write <= '0';
							Dmem_write <= '0';
							PC_write <= '0';
							en_Hi  <= '0';
							en_Low <= '0';

							next_state <=Instr_fetch;
		end case;			
	end process;

end Behavioral;