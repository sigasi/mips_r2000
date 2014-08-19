library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity toplevel is

	port( shamt : in std_logic;
			Bus_A : in std_logic_vector(31 downto 0);
			Bus_B : in std_logic_vector(31 downto 0);
			ALUop :in std_logic_vector(4 downto 0);
			Bus_S : out std_logic
			);

end toplevel;

architecture Behavioral of toplevel is


component add_sub is
port(	Bus_A : in std_logic_vector(31 downto 0);
		Bus_B : in std_logic_vector(31 downto 0);
		alu_op : in std_logic_vector(1 downto 0);
		Bus_F : out std_logic
		);
end component;

signal Bus_Asig : std_logic_vector(31 downto 0);
signal Bus_Bsig : std_logic_vector(31 downto 0);
signal Bus_Fsig : std_logic_vector(31 downto 0);
signal alu_opsig : std_logic_vector(1 downto 0);
begin

	u1 : add_sub
	port map(	Bus_A =>Bus_Asig,
					Bus_B =>Bus_Bsig,
					alu_op =>alu_opsig,
					Bus_F =>Bus_Fsig);

end Behavioral;

