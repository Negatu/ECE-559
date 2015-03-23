LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_misc.all;

ENTITY crcFSM IS
	PORT (	clock		: IN		STD_LOGIC;
			reset		: IN		STD_LOGIC;
			crc_rdv			: IN		STD_LOGIC;
            dataIn           : IN        STD_LOGIC_VECTOR(3 DOWNTO 0);
            comp_enable  : out   STD_LOGIC;
			check_result	: out	STD_LOGIC;
			check_result_valid	:out	STD_LOGIC;
			outCRC		: out	STD_LOGIC_VECTOR(31 DOWNTO 0));
			
			

END crcFSM;

ARCHITECTURE behavior OF crcFSM IS
-- A is reset state, B is init state, C is wait, D is run, E is check state
	TYPE State_type IS ( A, B, C, D, E);
	SIGNAL y_current, y_next	: State_type;
	SIGNAL crc_init		: STD_LOGIC;
	SIGNAL crc_comp_enable		: STD_LOGIC;
	SIGNAL crc_out		: STD_LOGIC_VECTOR(15 DOWNTO 0); 
component crc32x4r
	PORT (	Clock		: IN		STD_LOGIC;
			Reset		: IN		STD_LOGIC;
			compute_enable  : IN    STD_LOGIC;
			init		: IN		STD_LOGIC;
            u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CRC_out		: out   	STD_LOGIC_VECTOR(31 DOWNTO 0) );
end component;

BEGIN


-- instantiate the register
    crc32x4r_inst : crc32x4r PORT MAP (
		Reset	 => reset,
		Clock	 => clock,
		compute_enable	=> crc_comp_enable,
		init	 => crc_init,
		u4		 => dataIn,
		CRC_out	 => crc_out);

	
	
-- state update 
	PROCESS(Reset,Clock)
	BEGIN
		
		IF reset = '1' THEN y_current <= A;
		ELSIF clock'EVENT AND clock = '1' THEN
				y_current <= y_next;
		END IF;
	END PROCESS;
	
-- logic for determining next state
	PROCESS(reset, crc_rdv, y_current)
	BEGIN		
		CASE y_current IS
			WHEN A =>
				IF reset = '0' THEN y_next <= B;
				END IF;
			WHEN B =>
				y_next <= C;
			WHEN C =>
				IF crc_rdv = '0' THEN y_next <= C;
				ELSIF crc_rdv = '1' THEN y_next <= D;
				END IF;				
			WHEN D =>
				IF crc_rdv = '0' THEN y_next <= E;
				ELSIF crc_rdv = '1' THEN y_next <= D;
				END IF;	
			WHEN E =>
				y_next <= B;		
		END CASE;
	END PROCESS;
	
-- output logic
	PROCESS(y_current)
	BEGIN
		CASE y_current IS
			WHEN A =>
				crc_init <= '0';
				crc_comp_enable <= '0';
				check_result_valid <= '0';
			WHEN B =>
				crc_init <= '1';
				crc_comp_enable <= '0';
				check_result_valid <= '0';
			WHEN C =>
				crc_init <= '1';
				crc_comp_enable <= '0';
				check_result_valid <= '0';				
			WHEN D =>
				crc_init <= '0';
				crc_comp_enable <= '1';
				check_result_valid <= '0';	
			WHEN E =>
				crc_init <= '0';
				crc_comp_enable <= '0';
				check_result_valid <= '1';		
		END CASE;
	END PROCESS;
	check_result <= not(or_reduce(crc_out));	
	comp_enable <= crc_comp_enable;
	outCRC <= crc_out;
END behavior;
