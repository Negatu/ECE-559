LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc_computer IS
	PORT
	(   
		clock25		: IN		STD_LOGIC;
		reset		: IN		STD_LOGIC;
		
		init : IN STD_LOGIC;
		comp_en : IN STD_LOGIC;
		
		out_input : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		outCRC		:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
		
		);
END crc_computer;

ARCHITECTURE test_arch OF crc_computer IS 

	SIGNAL rdv_signal : STD_LOGIC;
	SIGNAL data_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL crc_comp_enable : STD_LOGIC;

	COMPONENT crc32x4r
	PORT 
		(	Clock			: IN		STD_LOGIC;
			Reset			: IN		STD_LOGIC;
			
			compute_enable	: IN		STD_LOGIC;
            init	        : IN	    STD_LOGIC;
            
			u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CRC_out			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT MII_to_RCV
		PORT(
			Clock25		: IN	STD_LOGIC;
			Resetx		: IN	STD_LOGIC;
			rcv_data_valid	: OUT	STD_LOGIC;
			rcv_data	:OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	BEGIN
	
	phy_inst : MII_to_RCV PORT MAP (
			Clock25	=> clock25,
			Resetx	=> reset,
			rcv_data_valid	=> rdv_signal,
			rcv_data => data_signal	
		);
	
	crc_inst : crc32x4r PORT MAP (
			Clock => clock25, 
			Reset => reset,
			compute_enable => comp_en,
			init => init, 
			u4 => data_signal,
			CRC_out => outCRC
		);
	
	out_input <= data_signal;



END test_arch;