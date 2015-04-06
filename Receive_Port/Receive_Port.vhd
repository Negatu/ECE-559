LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Receive_Port IS
	PORT (	
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		receive_data_valid : IN STD_LOGIC;
		data_in_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		length_buffer_read_empty : OUT STD_LOGIC ;	--going to forwarding
		length_valid : OUT STD_LOGIC;	--going to forwarding
		
		data_buffer_read_empty : OUT STD_LOGIC;	--going to forwarding
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	--going to forwarding
		
		frame_sequence : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);	--going to monitoring
		frame_available_flag : OUT STD_LOGIC	--going to monitoring
		
		);

END Receive_Port;
