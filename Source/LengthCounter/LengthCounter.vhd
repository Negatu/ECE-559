LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY LengthCounter IS PORT(
	Clock, CountInit, LengthValid : IN STD_LOGIC;
	LengthValue : OUT STD_VECTOR(10 DOWNTO 0)); 
END LengthCounter;

ARCHITECTURE LengthCounter_rtl OF LengthCounter IS 
BEGIN
	PROCESS (clock, clear) BEGIN
	
		VARIABLE temp:STD_LOGIC_VECTOR(10 DOWNTO 0);

		IF (CountInit = '1') THEN 
			temp := "00000000000";
		ELSIF (rising_edge(clock)) THEN 
			temp := temp+1;
		END IF; 

		LengthCounter <= temp;

	END PROCESS;
END LengthCounter_rtl;