LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test IS
	PORT
	(   clock25, clock50, reset : IN STD_LOGIC;
		port_id	   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		frame_valid_out : OUT STD_LOGIC;	--going to forwarding
		
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	--going to forwarding
		
		frame_to_monitoring : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- going to monitoring.
		frame_available_monitoring : OUT STD_LOGIC; -- going to monitoring.
		triggerStart					   : OUT STD_LOGIC; --trigger for logic analyzer
		triggerEnd						   : OUT STD_LOGIC;
		--test_crc_rdv : OUT STD_LOGIC;
		--test_length_value : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		--test_length_valid : OUT STD_LOGIC;
		--test_length_we : OUT STD_LOGIC;
		--test_crc_crv : OUT STD_LOGIC;
		--test_crc_cr : OUT STD_LOGIC;
		--test_frame_valid : OUT STD_LOGIC;
		--test_input4bit : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		--test_sequence_counter: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		test_sequence_counter_fwd : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		--test_length_read_empty : OUT STD_LOGIC;
		--test_data_read_empty : OUT STD_LOGIC;
		--test_length_read_enable : OUT STD_LOGIC;
		--test_data_read_enable : OUT STD_LOGIC;
		--test_length_buffer_output : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		--test_sequence_invalidBit : OUT STD_LOGIC
		
		);
END test;

ARCHITECTURE test_arch OF test IS 

	SIGNAL rdv_signal : STD_LOGIC;
	SIGNAL data_signal : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL Flip	: STD_LOGIC;
	SIGNAL NotFlip	: STD_LOGIC;
	
	--supressed as signals for logic analyzer
	SIGNAL test_crc_rdv :  STD_LOGIC;
	SIGNAL test_length_value : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL test_length_valid : STD_LOGIC;
	SIGNAL test_length_we : STD_LOGIC;
    SIGNAL test_crc_crv : STD_LOGIC;
	SIGNAL test_crc_cr : STD_LOGIC;
	SIGNAL test_frame_valid : STD_LOGIC;
	SIGNAL test_input4bit : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL test_sequence_counter: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL test_length_read_empty : STD_LOGIC;
	SIGNAL test_data_read_empty : STD_LOGIC;
	SIGNAL test_length_read_enable : STD_LOGIC;
	SIGNAL test_data_read_enable : STD_LOGIC;
	SIGNAL test_length_buffer_output : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL test_sequence_invalidBit :  STD_LOGIC;
	
	COMPONENT shift1_1bit IS
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		shiftin		: IN STD_LOGIC ;
		shiftout    : OUT STD_LOGIC 
	);
	END COMPONENT;
	
	COMPONENT test_bench1
		PORT(
			clk25, clk50, reset, rdv : IN STD_LOGIC;
			input_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			port_id	   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	
			frame_valid_out : OUT STD_LOGIC;	
			
			data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			
			frame_to_monitoring : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			frame_available_monitoring : OUT STD_LOGIC; 
			
			test_crc_rdv : OUT STD_LOGIC;
			test_length_value : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			test_length_valid : OUT STD_LOGIC;
			test_length_we : OUT STD_LOGIC;
			test_crc_crv : OUT STD_LOGIC;
			test_crc_cr : OUT STD_LOGIC;
			test_frame_valid : OUT STD_LOGIC;
			test_input4bit : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			test_sequence_counter: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			test_sequence_counter_fwd : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			test_length_read_empty : OUT STD_LOGIC;
			test_data_read_empty : OUT STD_LOGIC;
			test_length_read_enable : OUT STD_LOGIC;
			test_data_read_enable : OUT STD_LOGIC;
			test_length_buffer_output : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			test_sequence_invalidBit : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT MII_to_RCV IS
		PORT(
			Clock25		: IN		STD_LOGIC;
			Resetx		: IN		STD_LOGIC;
			rcv_data_valid	: OUT	STD_LOGIC;
			rcv_data	:OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	

	
	BEGIN
	
	shift1_1bit_instFlip : shift1_1bit PORT MAP
	(
		aclr		=> '0',
		clock		=> clock50,
		shiftin		=> NotFlip,
		shiftout    => Flip
	);
	
	test_bench_inst : test_bench1  PORT MAP (
			clk25 => Flip, 
			clk50 => clock50,
			reset => reset,
			
			rdv => rdv_signal,
			input_4bit => data_signal,
			port_id => port_id,
			length_buffer_out_11bit => length_buffer_out_11bit,
			frame_valid_out => frame_valid_out,	
			
			data_buffer_out_8bit => data_buffer_out_8bit,
			
			frame_to_monitoring => frame_to_monitoring,
			frame_available_monitoring => frame_available_monitoring,
			
			test_crc_rdv => test_crc_rdv,
			test_length_value => test_length_value,
			test_length_valid => test_length_valid,
			test_length_we => test_length_we,
			test_crc_crv => test_crc_crv,
			test_crc_cr => test_crc_cr,
			test_frame_valid => test_frame_valid,
			test_input4bit => test_input4bit,
			test_sequence_counter => test_sequence_counter,
			test_sequence_counter_fwd => test_sequence_counter_fwd,
			test_sequence_invalidBit => test_sequence_invalidBit,
			test_length_read_empty => test_length_read_empty,
			test_length_read_enable => test_length_read_enable,
			test_data_read_enable => test_data_read_enable,
			test_length_buffer_output => test_length_buffer_output,
			test_data_read_empty => test_data_read_empty
	);
	
	phy_inst : MII_to_RCV PORT MAP (
			Clock25	=> Flip,
			Resetx	=> reset,
			rcv_data_valid	=> rdv_signal,
			rcv_data => data_signal	
	);
	
	NotFlip <= not(Flip);
	triggerStart <= reset;
	triggerEnd   <= test_data_read_enable;
	END test_arch;