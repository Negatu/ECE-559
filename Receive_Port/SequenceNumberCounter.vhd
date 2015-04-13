LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY SequenceNumberCounter IS
	PORT
	(
		Clk25Mhz, FrameValid, Reset : IN STD_LOGIC;
		PortID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		SequenceNumberPortID : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
		);
END SequenceNumberCounter;


ARCHITECTURE SequenceNumberCounter_arch OF SequenceNumberCounter IS 	
	
	signal sequenceCounter : std_logic_vector(8 downto 0);
		
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
		cnt_en	 => FrameValid,
		q		 => sequenceCounter
	);
	
	-- state update 
	PROCESS(Clk25Mhz)
	BEGIN
		
		SequenceNumberPortID <= sequenceCounter & PortID;
				
	END PROCESS;
	
		
END SequenceNumberCounter_arch; 