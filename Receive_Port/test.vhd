LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test IS
	PORT
	(   clock25, clock50, reset : IN STD_LOGIC;
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		length_valid_out : OUT STD_LOGIC;	--going to forwarding
		
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	--going to forwarding
		
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
		length_valid_out : OUT STD_LOGIC;	
		
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	
		
			
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
			length_valid_out => length_valid_out,	
			
			data_buffer_out_8bit => data_buffer_out_8bit 	
	);
	
	phy_inst : MII_to_RCV PORT MAP (
			Clock25	=> clock25,
			Resetx	=> reset,
			rcv_data_valid	=> rdv_signal,
			rcv_data => data_signal	
	);
	
	
	END test_arch;