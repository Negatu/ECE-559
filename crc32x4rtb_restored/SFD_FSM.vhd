LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SFD_FSM IS
	PORT (	Clock	: IN	STD_LOGIC;
			sfd_rdv 	: IN	STD_LOGIC;
			Reset	: IN	STD_LOGIC;
			dataIn	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			crc_rdv		: OUT	STD_LOGIC );

END SFD_FSM;


ARCHITECTURE behavior OF SFD_FSM IS
	-- A is the wait state
	-- B is the state to go to after seeing SFD's 1st nibble
	--C is the reset state where crcEnable is asserted
	TYPE State_type IS ( A, B, C);
	SIGNAL y_current, y_next	: State_type;
BEGIN
-- state update 
	PROCESS(Reset,Clock)
	BEGIN
		IF Reset = '1' THEN y_current <= A;
		ELSIF Clock'EVENT AND Clock = '1' THEN
			y_current <= y_next;
		END IF;
	END PROCESS;
	
-- logic for determining next state
	PROCESS(dataIn, sfd_rdv, y_current)
	BEGIN		
		CASE y_current IS
			WHEN A =>
				IF dataIn = '1010' THEN y_next <= B;
				END IF;
			WHEN B =>
				IF dataIn = '1011' THEN y_next <= C;
				ELSE y_next <= A;
				END IF;
			WHEN C =>
				IF sfd_rdv = '0' THEN y_next <= A;
				ELSE y_next <= C;
				END IF;				
		END CASE;
	END PROCESS;
	
-- output logic
	PROCESS(y_current)
	BEGIN
		IF (y_current = C) THEN crc_rdv <= '1';
		ELSE crc_rdv <= '0';
		END IF;
	END PROCESS;

END behavior;
