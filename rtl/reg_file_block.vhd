library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Regfile_bl is
port(
		Clk : in std_logic;
		Reg_Write : in std_logic;
		Reg_Imm_not : in std_logic;
		rs : in std_logic_vector(4 downto 0);
		rt : in std_logic_vector(4 downto 0);
		rd : in std_logic_vector(4 downto 0);
		Branchzero_flag : in std_logic;		--6 entoles
		Reg32_flag : in std_logic;
		Bus_W : in std_logic_vector(31 downto 0);
		Bus_A : out std_logic_vector(31 downto 0);
		Bus_B : out std_logic_vector(31 downto 0)
);
end entity Regfile_bl;

architecture Regfile_block of Regfile_bl is

-- Declarations of Register File type & signal
type Regfile_type is array (natural range<>) of std_logic_vector(31 downto 0);

signal Regfile_Coff : Regfile_type(0 to 31):= ((others=> (others=>'0')));
signal Addr_in,Addr_in2 : std_logic_vector(4 downto 0);

begin

process(Clk,Reg_Write,Reg_Imm_not,rs,rt,rd,Bus_W,Regfile_Coff,Branchzero_flag,Reg32_flag)
begin
-- Regfile_Read Assignments
if(FALLING_EDGE(Clk))then
	Bus_A <= Regfile_Coff(conv_integer(rs));
	if (Branchzero_flag ='1')then
		Bus_B <= X"00000000";
	else
		Bus_B <= Regfile_Coff(conv_integer(rt));
	end if;
end if;
	
-- Write Address Assignment
if (Reg_Imm_Not = '1') then
		Addr_in <= rd;
	elsif (Reg_Imm_Not = '0') then
		Addr_in <= rt;
end if;

if (Reg32_flag ='1') then
	Addr_in2 <= "1111";
else
	Addr_in2 <= Addr_in;
end if;

-- Regfile_Write Assignments
if(RISING_EDGE(Clk))then
	if(Reg_Write = '1' and Addr_in2 /= "00000") then
		Regfile_Coff(conv_integer(Addr_in2)) <= Bus_W;
	end if;
end if;

end process;
end architecture Regfile_block;
