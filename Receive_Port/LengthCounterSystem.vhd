-- Top level design entity for CRC_register and CRC_FSM
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity LengthCounterSystem is
	port(clock, CRC_rdv, reset: in std_logic; 
		 lengthValid,  buffer_WE: out std_logic;
		 lengthValue: out std_logic_vector(10 downto 0));
end LengthCounterSystem;

architecture combined of LengthCounterSystem is

	component LengthCounterFSM is 
	port(
			clk			: IN STD_LOGIC ;
			reset_sig	: IN STD_LOGIC ;
			CRC_rdv			: IN STD_LOGIC ;
			bufferWE	: OUT STD_LOGIC ;
			CntEnable	: OUT STD_LOGIC ;
			reset_counter: OUT STD_LOGIC
			); 
	end component;
	
	component LengthCounter
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	end component;

	signal CntEnable_sig : std_logic;
	signal odd_nibbles : std_logic;
	signal counter_reset_sig : std_logic; -- used to clear the counter after each frame
	signal nibble_length : std_logic_vector(11 downto 0);
	signal int_lengthValue : std_logic_vector(10 downto 0);
	
	begin
	
	LengthCounterFSM_int : LengthCounterFSM PORT MAP (
			clk			=> clock,
			reset_sig	=> reset,
			CRC_rdv		=> CRC_rdv,
			bufferWE	=> buffer_WE,
			CntEnable	=> CntEnable_sig,
			reset_counter => counter_reset_sig
			); 
	
	LengthCounter_inst : LengthCounter PORT MAP (
		aclr	 => reset,
		clock	 => clock,
		cnt_en	 => CntEnable_sig,
		sclr	 => counter_reset_sig,
		q		=> nibble_length
	);
	
 int_lengthValue <= nibble_length(11 downto 1);
 odd_nibbles 	 <= nibble_length(0);

	--check length validity
	PROCESS(int_lengthValue,odd_nibbles)
	BEGIN
		IF ((odd_nibbles = '1') or int_lengthValue < "00001000000") or (int_lengthValue > "10111101110") THEN
			lengthValid <= '0';
		ELSE lengthValid <= '1';
		END IF;
	END PROCESS;
	lengthValue <= int_lengthValue;
end combined;