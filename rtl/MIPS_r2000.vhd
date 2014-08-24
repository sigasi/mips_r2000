library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_r2000 is
	port(clk,rst : in std_logic;
		Bus_A_test,Bus_B_test,Bus_W_test : out std_logic_vector(31 downto 0));
end MIPS_r2000;


architecture Behavioral of MIPS_r2000 is
component Datapath 
	port( clk,rst : in std_logic;
			Bus_A_test,Bus_B_test : out std_logic_vector(31 downto 0);
			PC_write,sel_ext,Reg_Write,Reg_Imm,Dmem_write : in std_logic;
			ALU_op : in std_logic_vector(3 downto 0);
			sel_HiLow : in std_logic_vector(1 downto 0);
			sv,lui,jump,Branch,ne_eq,j_jal_flag : in std_logic;
			Branchzero_flag,Reg32_flag,en_Hi,en_Low,Link,DM_ALU : in std_logic;
			Bus_W_test,Bus_IMD_out : out std_logic_vector(31 downto 0));
end component;

component ControlUnit
	port(clk,rst : in std_logic;
		  instruction : in std_logic_vector(31 downto 0);
		  RegImm,jump,branch,Link,DM_ALU,sel_ext : out std_logic;
		  ALU_op : out std_logic_vector(3 downto 0);
		  Reg_write,Dmem_write,PC_write : out std_logic;
		  sel_HiLow : out std_logic_vector(1 downto 0);
		  sv,lui_sig,ne_eq,j_jal_flag : out std_logic;
		  Branchzero_flag,Reg32_flag,en_Hi,en_Low : out std_logic);
end component;

signal PC_write,sel_ext,Reg_Write,Reg_Imm,Dmem_write : std_logic;
signal sel_HiLow : std_logic_vector(1 downto 0);
signal ALU_op : std_logic_vector(3 downto 0);
signal sv,lui_sig,jump,Branch,ne_eq,j_jal_flag : std_logic;
signal Branchzero_flag,Reg32_flag,en_Hi,en_Low,Link,DM_ALU : std_logic;
signal Bus_IMD_out : std_logic_vector(31 downto 0);
begin

	Datapath_unit : Datapath
		port map(
			clk             => clk,
			rst             => rst,
			Bus_A_test      => Bus_A_test,
			Bus_B_test      => Bus_B_test,
			PC_write        => PC_write,
			sel_ext         => sel_ext,
			Reg_Write       => Reg_Write,
			Reg_Imm         => Reg_Imm,
			Dmem_write      => Dmem_write,
			ALU_op          => ALU_op,
			sel_HiLow       => sel_HiLow,
			sv              => sv,
			lui		       => lui_sig,
			jump            => jump,
			Branch          => Branch,
			ne_eq           => ne_eq,
			j_jal_flag      => j_jal_flag,
			Branchzero_flag => Branchzero_flag,
			Reg32_flag      => Reg32_flag,
			en_Hi           => en_Hi,
			en_Low          => en_Low,
			Link            => Link,
			DM_ALU          => DM_ALU,
			Bus_W_test      => Bus_W_test,
			Bus_IMD_out		 => Bus_IMD_out);
			
		CU_unit :  ControlUnit
		port map(
			clk             => clk,
			rst             => rst,
			instruction     => Bus_IMD_out,
			RegImm          => Reg_Imm,
			jump            => jump,
			branch          => branch,
			Link            => Link,
			DM_ALU          => DM_ALU,
			sel_ext         => sel_ext,
			ALU_op          => ALU_op,
			Reg_write       => Reg_write,
			Dmem_write      => Dmem_write,
			PC_write        => PC_write,
			sel_HiLow       => sel_HiLow,
			sv              => sv,
			lui_sig         => lui_sig,
			ne_eq           => ne_eq,
			j_jal_flag      => j_jal_flag,
			Branchzero_flag => Branchzero_flag,
			Reg32_flag      => Reg32_flag,
			en_Hi           => en_Hi,
			en_Low          => en_Low);

end Behavioral;

