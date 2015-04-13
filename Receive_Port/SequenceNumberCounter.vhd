LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY SequenceNumberCounter IS

	PORT
	(
		Clk25Mhz, FrameValid, CRV, Reset : IN STD_LOGIC;
		PortID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		FrameAvailable : OUT STD_LOGIC;
		Frame : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
		
	);
		
END SequenceNumberCounter;


ARCHITECTURE SequenceNumberCounter_arch OF SequenceNumberCounter IS 	
	
	SIGNAL invalidBit : STD_LOGIC;
	SIGNAL sequenceCounter : STD_LOGIC_VECTOR(8 DOWNTO 0);
		
COMPONENT SequenceNumberCounter9BitVHD
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
END COMPONENT;
		
		
BEGIN
	
	SequenceNumberCounterNineBit_inst : SequenceNumberCounter9BitVHD PORT MAP (
		aclr	 => Reset,
		clock	 => Clk25Mhz,
		cnt_en	 => CRV,
		q		 => sequenceCounter
	);
	
	-- state update 
	PROCESS(Clk25Mhz)
	BEGIN
		
		invalidBit <= NOT frameValid;
		
		Frame <= PortID & sequenceCounter & invalidBit;
		
				
	END PROCESS;
	
		
END SequenceNumberCounter_arch; 