library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DMcontrol is
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
end DMcontrol;

architecture Behavioral of DMcontrol is
	constant LB  : std_logic_vector(5 downto 0)   := "100000";	
	constant LBU : std_logic_vector(5 downto 0)   := "100100";	
	constant LH  : std_logic_vector(5 downto 0)   := "100001";	
	constant LHU : std_logic_vector(5 downto 0)   := "100101";	
	constant LW  : std_logic_vector(5 downto 0)   := "100011";	
	constant SB  : std_logic_vector(5 downto 0)   := "101000";
	constant SH  : std_logic_vector(5 downto 0)   := "101001";
	constant SW  : std_logic_vector(5 downto 0)   := "101011";

signal WE_sig : std_logic_vector(3 downto 0);
begin
	Bus_DMA <= ALUout(12 downto 2);
	WE <= WE_sig and (Dmem_write & Dmem_write & Dmem_write & Dmem_write);
	u : process(opcode,ALUout,DatafromDM,MDRin)
	begin
		case opcode is
			when LB =>
				E <='0';
				WE_sig <="0000";
				DatatoDM <= (others=>'0');
				if DatafromDM(7) = '0' then --code for sign extension
						MDRout(31 downto 8) <= (others=>'0');
				else
						MDRout(31 downto 8) <= (others=>'1');
				end if;
				case ALUout(1 downto 0) is
					when "00" => MDRout(7 downto 0)   <= DatafromDM(7 downto 0);
					when "01" => MDRout(7 downto 0)   <= DatafromDM(15 downto 8);
					when "10" => MDRout(7 downto 0)   <= DatafromDM(23 downto 16);
					when "11" => MDRout(7 downto 0)   <= DatafromDM(31 downto 24);
					when others =>	MDRout<=(others=>'0');
				end case;
---------------------------------------------------------------------------------					
			when LBU => 
				E <='0';
				WE_sig <="0000";
				DatatoDM <= (others=>'0');
				MDRout(31 downto 8) <= (others=>'0');
				case ALUout(1 downto 0) is
					when "00" => MDRout(7 downto 0)   <= DatafromDM(7 downto 0);
					when "01" => MDRout(7 downto 0)   <= DatafromDM(15 downto 8);
					when "10" => MDRout(7 downto 0)   <= DatafromDM(23 downto 16);
					when "11" => MDRout(7 downto 0)   <= DatafromDM(31 downto 24);
					when others =>	MDRout<=(others=>'0');
				end case;
---------------------------------------------------------------------------------			
			when LH  => 
				E <= ALUout(0);
				WE_sig <="0000";
				DatatoDM <= (others=>'0');
				if DatafromDM(15) = '0' then --sign extension
						MDRout(31 downto 16) <= (others=>'0');
				else
						MDRout(31 downto 16) <= (others=>'1');
				end if;
				case ALUout(1 downto 0) is
					when "00" => MDRout(15 downto 0) <= DatafromDM(15 downto 0);
					when "10" => MDRout(15 downto 0) <= DatafromDM(31 downto 16);
					when others => MDRout <= (others=>'0');
				end case;
---------------------------------------------------------------------------------
			when LHU => 
				E <= ALUout(0);
				WE_sig <="0000";
				DatatoDM <= (others=>'0');
				MDRout(31 downto 16) <= (others=>'0');--zero extension
				case ALUout(1 downto 0) is
					when "00" => MDRout(15 downto 0) <= DatafromDM(15 downto 0);
					when "10" => MDRout(15 downto 0) <= DatafromDM(31 downto 16);
					when others => MDRout<=(others=>'0');
				end case;
---------------------------------------------------------------------------------
			when LW  => 
				E <= ALUout(0) or ALUout(1);
				WE_sig <="0000";
				DatatoDM <= (others=>'0');
				if ALUout(1 downto 0) = "00" then 
					MDRout <= DatafromDM;
				else 
					MDRout <= (others=>'0');
				end if;
---------------------------------------------------------------------------------
			when SB  => 
				E <='0';
				MDRout <= (others=>'0');
				DatatoDM <= (others=>'0');
				case ALUout(1 downto 0) is
					when "00" => DatatoDM(7 downto 0)   <= MDRin(7 downto 0);
									 WE_sig <= "0001"; 
					when "01" => DatatoDM(15 downto 8)  <= MDRin(7 downto 0);
									 WE_sig <= "0010"; 
					when "10" => DatatoDM(23 downto 16) <= MDRin(7 downto 0);
									 WE_sig <= "0100"; 
					when "11" => DatatoDM(31 downto 24) <= MDRin(7 downto 0);
									 WE_sig <= "1000"; 
					when others => DatatoDM<=(others=>'0'); WE_sig <= "0000";
				end case;
---------------------------------------------------------------------------------
			when SH  => 
				E <= ALUout(0);
				MDRout <= (others=>'0');
				
				WE_sig <= "0000";--0010
				DatatoDM <= (others=>'0');
				case ALUout(1 downto 0) is
					when "00" => DatatoDM(15 downto 0)  <= MDRin(15 downto 0);
							WE_sig <= "0011"; 
					when "10" => DatatoDM(31 downto 16) <= MDRin(31 downto 16);
							WE_sig <= "1100";
					when others =>  DatatoDM<=(others=>'0');WE_sig <= "0000";
				end case;
---------------------------------------------------------------------------------
			when SW  => 
				E <= ALUout(1) or ALUout(0);
				MDRout <= (others=>'0');
				WE_sig <= "1111";
				DatatoDM <= (others=>'0');
				
				if ALUout(1 downto 0) = "00" then 
					DatatoDM <= MDRin;
				else 
					DatatoDM <= (others=>'0');
				end if;
---------------------------------------------------------------------------------
			when others => MDRout<=(others=>'0');
								WE_sig <= "0000";E <= '0';
								DatatoDM<=(others=>'0');
---------------------------------------------------------------------------------
		end case;--case opcode
	end process;

end Behavioral;

