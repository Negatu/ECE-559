LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY SequenceNumberCounter IS

	PORT
	(
		Clk25Mhz, FrameValid, CRV, Reset : IN STD_LOGIC; --changed clock to a 50 MHz clock
		
		FrameAvailable : OUT STD_LOGIC;
		SequenceCount : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
		
END SequenceNumberCounter;


ARCHITECTURE SequenceNumberCounter_arch OF SequenceNumberCounter IS 	
		
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
		q		 => sequenceCount
	);
	
	-- status update 
	PROCESS(Clk25Mhz)
	BEGIN
		if rising_edge(Clk25Mhz) then
			FrameAvailable <= CRV;
		end if;
				
	END PROCESS;
	
		
END SequenceNumberCounter_arch; 