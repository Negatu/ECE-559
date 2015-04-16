library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity FwdOutputCntrlr is
	port(clock,reset : in std_logic; 
		 inFrameLengthValue: in std_logic_vector(11 downto 0);
		 lengthBuffer_RE,  dataBuffer_RE: out std_logic;
		 fwdFrameLengthValue: out std_logic_vector(11 downto 0));
end FwdOutputCntrlr;

architecture RegCountArch of FwdOutputCntrlr is
	
	component lengthValidReg IS
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		enable		: IN STD_LOGIC ;
		q		    : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
    END component;

	component outFrameLengthCounter IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
   END component;
   
   component frameLengthValueComp IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		AeB		    : OUT STD_LOGIC 
	);
    END component;
    	
	TYPE State_type IS ( NotEqual, Equal);
	SIGNAL y_current, y_next	: State_type;
	signal counter_reset_sig, int_lengthBufferRE, equal_true : std_logic; -- used to clear the counter after each frame
	signal int_FrameLengthValue : std_logic_vector(11 downto 0);
	signal counterValue : std_logic_vector (10 downto 0);
	
	begin
	
	lengthValidReg_inst : lengthValidReg PORT MAP (
		    aclr		=>  reset,
		    clock		=> clock,
			data     	=> inFrameLengthValue,
			enable		=> int_lengthBufferRE,
			q           => int_FrameLengthValue
	
		);
	outFrameLengthCounter_inst : outFrameLengthCounter PORT MAP (
		clock	=> clock,
		sclr	=> counter_reset_sig,
		q		=> counterValue
	
	);
	
	frameLengthValueComp_inst : frameLengthValueComp PORT MAP (
		dataa			=> int_FrameLengthValue (10 downto 0),
		datab			=> counterValue,
		AeB				=> equal_true
	);
	
	PROCESS(reset,clock)
	BEGIN
		IF Reset = '1' THEN y_current <= Equal;
		ELSIF clock'EVENT AND clock = '1' THEN
			y_current <= y_next;
		END IF;
	END PROCESS;
	
-- logic for determining next state
	PROCESS(equal_true,y_current)
	BEGIN		
		CASE y_current IS
			WHEN NotEqual =>
				IF equal_true = '1' THEN y_next <= Equal;
				ELSE y_next <= NotEqual;
				END IF;
			WHEN Equal =>
				y_next <=  NotEqual;
		END CASE;
	END PROCESS;
	
-- output logic
	PROCESS(y_current)
	BEGIN
		IF (y_current = Equal) THEN 
				dataBuffer_RE <= '0';
				int_lengthBufferRE <= '1';
				counter_reset_sig <= '1';
		ELSE 
			dataBuffer_RE <= '1';
			int_lengthBufferRE <= '0';
			counter_reset_sig <= '0';
		END IF;
	END PROCESS;
	fwdFrameLengthValue <= int_FrameLengthValue;
	lengthBuffer_RE <= int_lengthBufferRE;
end RegCountArch;