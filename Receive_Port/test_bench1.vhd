LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_bench1 IS
	PORT
	(   clk25, clk50, reset, rdv : IN STD_LOGIC;
		input_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		frame_valid_out : OUT STD_LOGIC;	--going to forwarding
		
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	--going to forwarding
		
		);
END test_bench1;

ARCHITECTURE tb_arch OF test_bench1 IS 

	SIGNAL CRC_rdv : STD_LOGIC;
	SIGNAL check_result_valid : STD_LOGIC;
	SIGNAL check_result : STD_LOGIC;
	SIGNAL length_valid : STD_LOGIC;
	SIGNAL length_buffer_write_enable : STD_LOGIC;
	SIGNAL frame_valid : STD_LOGIC;
	SIGNAL  frame_length_and_valid : STD_LOGIC_VECTOR(11 DOWNTO 0); -- concatenation of frame valid and length
	SIGNAL data_buffer_write_enable : STD_LOGIC;
	SIGNAL data_buffer_full : STD_LOGIC;
	SIGNAL data_buffer_read_enable : STD_LOGIC;
	SIGNAL data_to_forwarding : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL length_buffer_output : STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL length_read_enable : STD_LOGIC;
	SIGNAL length_buffer_full : STD_LOGIC;
	SIGNAL length_buffer_empty : STD_LOGIC;
	
	COMPONENT SFD_FSM
		PORT (	Clock	: IN	STD_LOGIC;
			sfd_rdv 	: IN	STD_LOGIC;
			Reset	: IN	STD_LOGIC;
			dataIn	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
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
	
	COMPONENT LengthCounterSystem
		PORT( 
			 clock, CRC_rdv, reset: in std_logic; 
			 lengthValid,  buffer_WE: out std_logic;
			 lengthValue: out std_logic_vector(10 downto 0)
		); 
	END COMPONENT;
	
	COMPONENT Length_DCFF
		PORT(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC 
		);
	END COMPONENT;
	
	
	COMPONENT Data_Buffer
		PORT(
		reset, write_enable, write_clk, read_enable, read_clk : IN STD_LOGIC;
		data_in_4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		read_empty, write_full : OUT STD_LOGIC;
		data_out_8 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;


BEGIN

	sfd_fsm_inst : SFD_FSM  PORT MAP (
			Clock => clk25,
			sfd_rdv => rdv,
			Reset => reset,
			dataIn => input_4bit,
			crc_rdv => CRC_rdv
	);
	
	crc_system_inst : CRC_System PORT MAP (
		Clk => clk25,
		reset => reset, 
		rdv => CRC_rdv, 
		data_in_4 => input_4bit,
		CRC_result_valid => check_result_valid,
		CRC_check_result => check_result
	);
	
	
	data_buffer_inst : Data_Buffer PORT MAP (
		reset => reset, 
		write_enable => data_buffer_write_enable,
		write_clk => clk25,
		data_in_4 => input_4bit,
		write_full => data_buffer_full,
		read_enable => data_buffer_read_enable,
		read_clk => clk50,
		data_out_8 => data_to_forwarding
	);

	length_buffer_inst : Length_DCFF PORT MAP (
		wrclk => clk25,
		aclr => reset, 
		data =>  frame_length_and_valid,
		wrreq => length_buffer_write_enable,
		rdclk => clk50,
		rdreq => length_read_enable,
		q	  => length_buffer_output,
		rdempty => length_buffer_empty,
		wrfull => length_buffer_full
	);
	
	length_counter_sys_inst : LengthCounterSystem PORT MAP (
			clock => clk25,
			reset => reset,
			CRC_rdv => CRC_rdv,
			lengthValid => length_valid,
			buffer_WE => length_buffer_write_enable,
			lengthValue =>  frame_length_and_valid (10 DOWNTO 0)
	);
	
	frame_valid <= (length_valid AND check_result AND check_result_valid); 
	frame_length_and_valid(11) <= frame_valid;
	length_buffer_out_11bit <= length_buffer_output(10 DOWNTO 0);	--going to forwarding
	frame_valid_out <= length_buffer_output(11);	--going to forwarding
	data_buffer_out_8bit <= data_to_forwarding;	--going to forwarding


END tb_arch;