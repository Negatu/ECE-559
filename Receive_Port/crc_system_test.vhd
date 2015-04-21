LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc_system_test IS
	PORT
	(   
		clock25		: IN		STD_LOGIC;
		reset		: IN		STD_LOGIC;
		
		mii_rdv_out : OUT STD_LOGIC;
		crc_rdv_out : OUT STD_LOGIC;
		
		check_result : OUT STD_LOGIC;
		check_result_valid : OUT STD_LOGIC
		);
END crc_system_test;

ARCHITECTURE crc_arch OF crc_system_test IS 
	SIGNAL rdv_signal : STD_LOGIC;
	SIGNAL crc_rdv_signal : STD_LOGIC;
	SIGNAL data_to_crc : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL data_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
	

	COMPONENT MII_to_RCV
		PORT(
			Clock25		: IN	STD_LOGIC;
			Resetx		: IN	STD_LOGIC;
			rcv_data_valid	: OUT	STD_LOGIC;
			rcv_data	:OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT SFD_FSM
		PORT (	Clock	: IN	STD_LOGIC;
			sfd_rdv 	: IN	STD_LOGIC;
			Reset	: IN	STD_LOGIC;
			dataIn	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			dataOut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			crc_rdv		: OUT	STD_LOGIC 
			);
	END COMPONENT;
	
	COMPONENT CRC_System
		 PORT(
			 Clk, reset, rdv: IN	STD_LOGIC; 
			 data_in_4 : IN	STD_LOGIC_VECTOR(3 downto 0);
			 CRC_result_valid,  CRC_check_result: OUT STD_LOGIC
		 );
	END COMPONENT;
	
	BEGIN
	
	phy_inst : MII_to_RCV PORT MAP (
			Clock25	=> clock25,
			Resetx	=> reset,
			rcv_data_valid	=> rdv_signal,
			rcv_data => data_signal	
		);
		
	sfd_fsm_inst : SFD_FSM  PORT MAP (
			Clock => clock25,
			sfd_rdv => rdv_signal,
			Reset => reset,
			dataIn => data_signal,
			dataOut => data_to_crc,
			crc_rdv => crc_rdv_signal
	);

		
	crc_system_inst : CRC_System PORT MAP (
		Clk => clock25,
		reset => reset, 
		rdv => crc_rdv_signal, 
		data_in_4 => data_to_crc,
		CRC_result_valid => check_result_valid,
		CRC_check_result => check_result 
	);
	
		mii_rdv_out <= rdv_signal;
		crc_rdv_out <= crc_rdv_signal;


END crc_arch;