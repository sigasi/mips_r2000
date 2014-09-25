library IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.all;

entity DTRM is		
    port (
		clock_top : in std_logic;
		clear_top : in std_logic;	       
		count_top : in std_logic;			--enable counter
		X_top     : in std_logic_vector(31 DOWNTO 0);
		Y_top     : in std_logic_vector(31 DOWNTO 0);
		P_top     : out std_logic_vector(63 downto 0)	
	);
end DTRM;      


architecture Stractural of DTRM is

component counter 
  generic(n: positive :=8);
  port(	
		clock:	in std_logic;
		clear:	in std_logic;
		count:	in std_logic;
		Q:	out std_logic_vector(n-1 downto 0)
	);
end component;


Signal Q_signal  : std_logic_vector(7 downto 0):= (others=>'0');
Signal QA_signal : std_logic_vector(31 downto 0):= (others=>'0');
Signal QB_signal : std_logic_vector(31 downto 0):= (others=>'0');
--Signal X_signal  : std_logic_vector(31 downto 0);
--Signal Y_signal  : std_logic_vector(31 downto 0);
begin

Inst_counter: counter port map (
	clock=>clock_top,
	clear=>clear_top,
	count=>count_top,
	Q=>Q_signal);

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

