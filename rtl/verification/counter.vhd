library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

----------------------------------------------------

entity counter is
	port(	clock:	in std_logic;
			clear:	in std_logic;
			count:	in std_logic;
			counter_ready : out std_logic;
			Q:	out std_logic_vector(7 downto 0));
end counter;

----------------------------------------------------

architecture behv of counter is		 	  
	
    signal Pre_Q: std_logic_vector(7 downto 0):=(others => '0');
	 signal counter_ready_sig : std_logic;
begin

    process(clock, clear)
    begin
		
		if (clock='1' and clock'event) then
		
			if clear = '1' then --reset
				Pre_Q <= (others=>'0');
			else
				if count = '1' then --enable
					if (Pre_Q <"11111111")then
						Pre_Q <=Pre_Q + X"01"; 
					end if;
				end if;
			end if;
		end if;
    end process;	
	 
	counter_ready_sig <= '1' when Pre_Q = "11111111" else '0';
	counter_ready <= counter_ready_sig;
    Q <= Pre_Q;

end behv;


-----------------------------------------------------
