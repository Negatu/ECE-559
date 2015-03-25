LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY LengthCounter IS PORT(
	Clock, CountInit: IN STD_LOGIC;
	LengthValue : OUT STD_VECTOR(8 DOWNTO 0)); 
END LengthCounter;

ARCHITECTURE LengthCounter_rtl OF LengthCounter IS 
BEGIN
	PROCESS (clock, clear) BEGIN
	
		VARIABLE temp:STD_LOGIC_VECTOR(8 DOWNTO 0);

		IF (CountInit = '1') THEN 
			temp := "000000000";
		ELSIF (rising_edge(clock)) THEN 
			temp := temp+1;
		END IF; 

		LengthCounter <= temp;

	END PROCESS;
END LengthCounter_rtl;