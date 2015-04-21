LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_bench1 IS
	PORT
	(   clk25, clk50, reset, rdv : IN STD_LOGIC;
		input_4bit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		length_buffer_out_11bit : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);	--going to forwarding
		frame_valid_out : OUT STD_LOGIC;	--going to forwarding
		
		data_buffer_out_8bit : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	--going to forwarding
		
		frame_to_monitoring : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- going to monitoring.
		frame_available_monitoring : OUT STD_LOGIC; -- going to monitoring.
		
		
		--test different outputs of test_bench1
		test_crc_rdv : OUT STD_LOGIC;
		test_length_value : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		test_length_valid : OUT STD_LOGIC;
		test_length_we : OUT STD_LOGIC;
		test_crc_crv : OUT STD_LOGIC;
		test_crc_cr : OUT STD_LOGIC;
		test_frame_valid : OUT STD_LOGIC;
		test_input4bit : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
		test_sequence_counter: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		test_sequence_invalidBit : OUT STD_LOGIC
		);
END test_bench1;

ARCHITECTURE tb_arch OF test_bench1 IS 

	SIGNAL CRC_rdv : STD_LOGIC;
	SIGNAL data_to_crc : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL check_result_valid : STD_LOGIC;
	SIGNAL check_result : STD_LOGIC;
	SIGNAL length_valid : STD_LOGIC;
	SIGNAL length_buffer_write_enable : STD_LOGIC;
	SIGNAL frame_valid : STD_LOGIC;
	SIGNAL frame_length_and_valid : STD_LOGIC_VECTOR(11 DOWNTO 0); -- concatenation of frame valid and length
	--SIGNAL data_buffer_write_enable : STD_LOGIC;
	SIGNAL data_buffer_full : STD_LOGIC;
	SIGNAL data_buffer_read_enable : STD_LOGIC;
	SIGNAL data_to_forwarding : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL length_buffer_output : STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL length_read_enable : STD_LOGIC;
	SIGNAL length_buffer_full : STD_LOGIC;
	SIGNAL length_buffer_empty : STD_LOGIC;
	SIGNAL invalidBit_sig : STD_LOGIC;
	SIGNAL SequenceCount_sig : STD_LOGIC_VECTOR(8 DOWNTO 0);
	
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
	
	COMPONENT shift2bit IS
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			shiftin		: IN STD_LOGIC ;
			shiftout		: OUT STD_LOGIC 
		);
	END COMPONENT;

	COMPONENT SequenceNumberCounter IS
	PORT
	(
		Clk25Mhz, FrameValid, CRV, Reset : IN STD_LOGIC; 
		
		FrameAvailable : OUT STD_LOGIC;
		SequenceCount : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		invalidBit : OUT STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT FwdOutputCntrlr IS
	PORT(clock,reset : in std_logic; 
		 inFrameLengthValue: in std_logic_vector(11 downto 0);
		 lengthBuffer_RE,  dataBuffer_RE, fwdFrameValid: out std_logic;
		 fwdFrameLengthValue: out std_logic_vector(10 downto 0));
	END COMPONENT;

BEGIN

	sfd_fsm_inst : SFD_FSM  PORT MAP (
			Clock => clk25,
			sfd_rdv => rdv,
			Reset => reset,
			dataIn => input_4bit,
			dataOut => data_to_crc,
			crc_rdv => CRC_rdv
	);
	
	crc_system_inst : CRC_System PORT MAP (
		Clk => clk25,
		reset => reset, 
		rdv => CRC_rdv, 
		data_in_4 => data_to_crc,
		CRC_result_valid => check_result_valid,
		CRC_check_result => check_result
	);
	
	data_buffer_inst : Data_Buffer PORT MAP (
		reset => reset, 
		write_enable => CRC_rdv, --data_buffer_write_enable,
		write_clk => clk25,
		data_in_4 => data_to_crc, --input_4bit,
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
	
		FwdOutputCntrlr_inst : FwdOutputCntrlr PORT MAP(
		 clock => clk50,
		 reset => reset,
		 inFrameLengthValue => length_buffer_output,
		 lengthBuffer_RE => length_read_enable,
		 dataBuffer_RE => data_buffer_read_enable,
		 fwdFrameValid => frame_valid_out,
		 fwdFrameLengthValue => length_buffer_out_11bit
		  );
	
	seq_counter_inst : SequenceNumberCounter PORT MAP (
		Clk25Mhz => clk25,
		FrameValid => frame_valid,
		CRV => check_result_valid,
		Reset => reset,
		FrameAvailable => frame_available_monitoring,
		invalidBit => invalidBit_sig,
		SequenceCount => SequenceCount_sig
	);
	
	frame_valid <= (length_valid AND check_result AND check_result_valid); 
	frame_length_and_valid(11) <= frame_valid;
	--length_buffer_out_11bit <= length_buffer_output(10 DOWNTO 0);	--going to forwarding
	--frame_valid_out <= length_buffer_output(11);	--going to forwarding
	data_buffer_out_8bit <= data_to_forwarding;	--going to forwarding
	
	frame_to_monitoring <= "00" & SequenceCount_sig & invalidBit_sig;
	
	--test - probe inside wires of test_bench1;
	test_crc_rdv <= data_buffer_read_enable;
	test_input4bit <= input_4bit;
	test_length_value <= frame_length_and_valid(10 DOWNTO 0);
	test_length_valid <= length_valid;
	test_length_we <= length_buffer_write_enable;
	test_crc_crv <= check_result_valid;
	test_crc_cr <= check_result;
	test_frame_valid <= frame_valid;
	test_sequence_counter <= SequenceCount_sig;
	test_sequence_invalidBit <= invalidBit_sig;

END tb_arch;