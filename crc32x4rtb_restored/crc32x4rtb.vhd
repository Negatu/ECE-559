LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc32x4rtb IS
	PORT (	Clock		: IN		STD_LOGIC;
			Reset		: IN		STD_LOGIC;
            test_start	: IN	    STD_LOGIC;
			test_good	: OUT		STD_LOGIC;
            crc_lo8     : out       std_logic_vector(7 downto 0);
            start_out	: OUT		STD_LOGIC
			);			

END crc32x4rtb;

ARCHITECTURE test_bench OF crc32x4rtb IS
	

COMPONENT crc32x4r
	PORT (	Clock			: IN		STD_LOGIC;
			Reset			: IN		STD_LOGIC;
			compute_enable	: IN		STD_LOGIC;
            init	        : IN	    STD_LOGIC;
			u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CRC_out			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0) );
END COMPONENT;

component tbrom4
	PORT
	(
        aclr        : in STD_LOGIC;
        address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
end component;


component counter12
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
end component;

component shift2
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		shiftin		: IN STD_LOGIC ;
		shiftout		: OUT STD_LOGIC 
	);
end component;


	
	TYPE State_type IS (resetz,init,wait4start,run,check,done);
	SIGNAL y_current, y_next			: State_type;	
	SIGNAL crc_enable, crc_init			: STD_LOGIC;
    signal crc_enable_x : std_logic;    -- for delay by 2
	SIGNAL crc_input					: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL count_enable	: STD_LOGIC;
	SIGNAL mem_out		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL count_val	: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL crc_result	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	CONSTANT check_val	: STD_LOGIC_VECTOR(31 DOWNTO 0) := "11000111000001001101110101111011";
    constant  count_len : std_logic_vector(11 downto 0) := "000010001001";
    


BEGIN

-- instantiate the components and map the ports

delayby2 : shift2 PORT MAP (
		aclr	 => Reset,
		clock	 => Clock,
		shiftin	 => crc_enable_x,
		shiftout	 => crc_enable
	);


  
crc_reg:  crc32x4r PORT MAP (
		Clock				=> Clock,
		Reset				=> Reset,
        init                => crc_init,
		compute_enable		=> crc_enable,
		u4					=> crc_input,
		CRC_out				=> crc_result
	);

crc_test_mem : tbrom4 PORT MAP (
		address	 => count_val,
        aclr => Reset,
		clock	 => Clock,
		q	 => mem_out
	);

cntr12bit : counter12 PORT MAP (
		aclr	 => Reset,
		clock	 => Clock,
		cnt_en	 => count_enable,
		q	 => count_val
	);



-- state update 
	PROCESS(Reset,Clock)
	BEGIN
		IF Reset = '1' THEN y_current <= resetz;
		ELSIF Clock'EVENT AND Clock = '1' THEN
			y_current <= y_next;
		END IF;
	END PROCESS;

-- logic for next_state and output
	PROCESS(y_current,count_val,crc_result,test_start)
	BEGIN
		count_enable <= '0';
		crc_enable_x <= '0';
        crc_init <= '0';
		test_good <= '0';
		start_out <= '0';
		CASE y_current IS
			WHEN resetz =>
              y_next <= init;
			WHEN init =>
                crc_init <= '1';
				y_next <= wait4start;
            when wait4start =>
              y_next <= wait4start;
              if test_start = '1' then
                y_next <= run;
                count_enable <= '1';    -- Mealy output
                start_out <= '1';
              end if;
            WHEN run =>
				count_enable <= '1';
				crc_enable_x <= '1';
				IF count_val = count_len THEN 
					y_next <= check;
                    count_enable <= '0';
				ELSE y_next <= run;
			END IF;			
			WHEN check =>
				y_next <= done;
                crc_init <= '1';
                IF crc_result = check_val THEN test_good <= '1';
				ELSE test_good <= '0';
				END IF;
			WHEN done =>
				y_next <= done;

		END CASE;
	END PROCESS;
	
	crc_input <= mem_out;

    crc_lo8 <= crc_result(7 downto 0);


END test_bench;






