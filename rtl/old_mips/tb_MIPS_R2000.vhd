-- TestBench Template                                              
                                                                   
LIBRARY ieee;                                                    
USE ieee.std_logic_1164.ALL;                                     
USE ieee.numeric_std.ALL;                                        
                                                                 
ENTITY tb_MIPS_R2000 IS                                              
END tb_MIPS_R2000;                                                   
                                                                 
ARCHITECTURE Bench OF tb_MIPS_R2000 IS                            
                                                                   
-- Component Declaration

COMPONENT MIPS_toplevel
	port(clk,rst : in std_logic;
		  datain : in std_logic_vector(31 downto 0);
		  Dmem_write_out: out std_logic;
		  IR_outt,DMAR_out,RFmux_outt,Bus_W_out,Bus_S_out : out std_logic_vector(31 downto 0);
		  status_reg : out std_logic_vector(1 downto 0);
		  dataout, dataout2,pc_out : out std_logic_vector(31 downto 0));
end COMPONENT;
 
	 SIGNAL tb_reset, tb_clock,tb_Dmem_write_out:std_logic;
	 SIGNAL tb_IR_outt,DMAR_out,tb_RFmux_outt,tb_Bus_W_out,tb_DMAR_out,tb_pc_out : std_logic_vector(31 downto 0);
	 SIGNAL tb_status_reg : std_logic_vector(1 downto 0);
    SIGNAL tB_dataout2,tb_dataOut,tb_Bus_S_out : std_logic_vector(31 downto 0);                                                                                                                           
BEGIN                                                            
                                                                   
-- Component Instantiation                                       
   uut: MIPS_toplevel 
	PORT MAP(rst => tb_reset, clk => tb_clock,
				datain => X"00000000",
				pc_out=>tb_pc_out,
				Dmem_write_out=>tb_Dmem_write_out,

				IR_outt=>tb_IR_outt,
				DMAR_out=>tb_DMAR_out,
				RFmux_outt=>tb_RFmux_outt,
				Bus_W_out=>tb_Bus_W_out,
				Bus_S_out => tb_Bus_S_out,
				status_reg => tb_status_reg,
   		   dataout => tb_dataOut,
				dataout2=>tb_dataout2);
   													


-- Process: Reset
	 Reset: PROCESS
				  BEGIN 
				   tb_reset <= '1';
				 	 wait for 400 ns;
				 	 tb_reset <= '0';
				 	 wait;	
				  END PROCESS;


-- Process: Clock, Current Frequency 50 MHz = Period 20 ns         
	 Clock: PROCESS
	 			  BEGIN
	 				 tb_clock <= '1';
	 				 wait for 50 ns;
	 				 tb_clock <= '0';
	 				 wait for 50 ns;
     		  END PROCESS;
                                                                                                                                                                    
END;                                                             