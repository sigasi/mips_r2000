library IEEE;
use IEEE.std_logic_1164.all;

entity LFSR is
port (clock    : in std_logic;
		reset    : in std_logic;
	   seed     : in std_logic_vector(63 downto 0);
	   data_out : out std_logic_vector(63 downto 0);
		rdy : out std_logic);
end LFSR;

architecture modular of LFSR is

signal lfsr_reg : std_logic_vector(63 downto 0):=(others=>'0');
signal cnt : natural;

begin

  process (clock)
    variable lfsr_tap : std_logic;
  begin
    if clock'EVENT and clock='1' then
      if reset = '1' then
        lfsr_reg <= seed;
      else
        lfsr_tap := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(3) xor lfsr_reg(4);
        lfsr_reg <= lfsr_reg(62 downto 0) & lfsr_tap;
      end if;
    end if;
  end process;
  
  data_out <= lfsr_reg;
  
  
-- Process: Ready Counter
	process(clock)
	begin
	if(rising_edge(clock))then
		if(reset = '1')then
			cnt <= 0;
			rdy <= '0';
		else
			if(cnt < 60)then
				cnt <=  cnt + 1;
			else
				rdy <= '1';
			end if;
		end if;
	end if;
	end process;
  
end modular;


