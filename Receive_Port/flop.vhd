LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY flop IS PORT(
		d, clock, clear : IN STD_LOGIC; 
		q : OUT STD_LOGIC);
END flop;

ARCHITECTURE flop_rtl OF flop IS 
BEGIN
  PROCESS (clock, clear)
    BEGIN
	   IF  (clear = '1') THEN
		  q <= '0';
		ELSIF (rising_edge(clock)) THEN
		  q <= d;  
		END IF;
  END PROCESS; 
END flop_rtl;