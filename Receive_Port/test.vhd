LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test IS
	PORT
	(   clock25, clock50, reset : IN STD_LOGIC;
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		frame_valid_out : OUT STD_LOGIC;	--going to forwarding
		
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	--going to forwarding
		
		test_crc_rdv : OUT STD_LOGIC;
		test_length_value : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		test_length_valid : OUT STD_LOGIC;
		test_length_we : OUT STD_LOGIC;
		test_crc_crv : OUT STD_LOGIC;
		test_crc_cr : OUT STD_LOGIC;
		test_frame_valid : OUT STD_LOGIC;
		test_input4bit : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
		);
END test;

ARCHITECTURE test_arch OF test IS 

	SIGNAL rdv_signal : STD_LOGIC;
	SIGNAL data_signal : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	
	
	COMPONENT test_bench1
		PORT(
			clk25, clk50, reset, rdv : IN STD_LOGIC;
			input_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	
			frame_valid_out : OUT STD_LOGIC;	
			
			data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			
			test_crc_rdv : OUT STD_LOGIC;
			test_length_value : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			test_length_valid : OUT STD_LOGIC;
			test_length_we : OUT STD_LOGIC;
			test_crc_crv : OUT STD_LOGIC;
			test_crc_cr : OUT STD_LOGIC;
			test_frame_valid : OUT STD_LOGIC;
			test_input4bit : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
		);
	END COMPONENT;
	
	COMPONENT MII_to_RCV
		PORT(
			Clock25		: IN		STD_LOGIC;
			Resetx		: IN		STD_LOGIC;
			rcv_data_valid	: OUT	STD_LOGIC;
			rcv_data	:OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	BEGIN
	
	test_bench_inst : test_bench1  PORT MAP (
			clk25 => clock25, 
			clk50 => clock50,
			reset => reset,
			
			rdv => rdv_signal,
			input_4bit => data_signal,
			
			length_buffer_out_11bit => length_buffer_out_11bit,
			frame_valid_out => frame_valid_out,	
			
			data_buffer_out_8bit => data_buffer_out_8bit,
			
			test_crc_rdv => test_crc_rdv,
			test_length_value => test_length_value,
			test_length_valid => test_length_valid,
			test_length_we => test_length_we,
			test_crc_crv => test_crc_crv,
			test_crc_cr => test_crc_cr,
			test_frame_valid => test_frame_valid,
			test_input4bit => test_input4bit
	);
	
	phy_inst : MII_to_RCV PORT MAP (
			Clock25	=> clock25,
			Resetx	=> reset,
			rcv_data_valid	=> rdv_signal,
			rcv_data => data_signal	
	);
	
	
	END test_arch;