LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Receive_Port IS
	PORT
	(   clk25, clk50, reset, rdv : IN STD_LOGIC;
		input_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		frame_valid_out : OUT STD_LOGIC;	--going to forwarding
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	--going to forwarding
		
		frame_to_monitoring : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- going to monitoring.
		frame_available_monitoring : OUT STD_LOGIC -- going to monitoring.
		);
END Receive_Port;

ARCHITECTURE test_arch OF Receive_Port IS
	
	COMPONENT test_bench1
		PORT(
		clk25, clk50, reset, rdv : IN STD_LOGIC;
		input_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		frame_valid_out : OUT STD_LOGIC;	--going to forwarding
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	--going to forwarding
		
		frame_to_monitoring : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- going to monitoring.
		frame_available_monitoring : OUT STD_LOGIC -- going to monitoring.
		);
	END COMPONENT;
	
	BEGIN
	
	test_bench_inst : test_bench1  PORT MAP (
		clk25 => clk25,
		 clk50 => clk50, 
		 reset => reset, 
		 rdv => rdv,
		input_4bit => input_4bit,
		
		length_buffer_out_11bit => length_buffer_out_11bit,
		frame_valid_out => frame_valid_out,
		data_buffer_out_8bit => data_buffer_out_8bit,
		
		frame_to_monitoring => frame_to_monitoring,
		frame_available_monitoring => frame_available_monitoring
		);
	
	
	END test_arch;