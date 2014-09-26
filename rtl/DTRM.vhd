library IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.all;

entity DTRM is	
    port (clock_top : in std_logic;
			clear_top : in std_logic;	       
			count_top : in std_logic;			--enable counter
			Q:	in std_logic_vector(7 downto 0);
			P_top     : out std_logic_vector(63 downto 0));
end DTRM;      

architecture Stractural of DTRM is

Signal Q_signal  : std_logic_vector(7 downto 0):= (others=>'0');
Signal QA_signal : std_logic_vector(31 downto 0):= (others=>'0');
Signal QB_signal : std_logic_vector(31 downto 0):= (others=>'0');

begin

Q_signal <= Q;

QA_signal <= 	Q_signal(7 downto 4) & Q_signal(7 downto 4) & 
					Q_signal(7 downto 4) & Q_signal(7 downto 4) & 
					Q_signal(7 downto 4) & Q_signal(7 downto 4) & 
					Q_signal(7 downto 4) & Q_signal(7 downto 4);
					
QB_signal <= 	Q_signal(3 downto 0) & Q_signal(3 downto 0) & 
					Q_signal(3 downto 0) & Q_signal(3 downto 0) & 
					Q_signal(3 downto 0) & Q_signal(3 downto 0) & 
					Q_signal(3 downto 0) & Q_signal(3 downto 0);

P_top <= QA_signal & QB_signal;


end Stractural;

