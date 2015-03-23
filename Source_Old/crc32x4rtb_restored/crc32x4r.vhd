LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc32x4r IS
	PORT (	Clock			: IN		STD_LOGIC;
			Reset			: IN		STD_LOGIC;
			compute_enable	: IN		STD_LOGIC;
            init	        : IN	    STD_LOGIC;
			u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CRC_out			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0) );

END crc32x4r;

--	for the input u4, the leftmost bit u4(3) is the first bit received

ARCHITECTURE rtlreg OF crc32x4r IS


component crcreg32
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		enable		: IN STD_LOGIC ;
		load		: IN STD_LOGIC ;
		sset		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

	SIGNAL Q_next		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Q_current	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal crcreg_clock_enable : std_logic;

BEGIN


-- map the ports of the register ...

crcreg32r : crcreg32 PORT MAP (
		aclr	 => Reset,
		clock	 => Clock,
		data	 => Q_next,
		enable	 => crcreg_clock_enable,
		load	 => '1',
		sset	 => init,
		q	 => Q_current
	);
	
-- logic for determining next state
	PROCESS(u4,Q_current)
	VARIABLE ux4	: STD_LOGIC_VECTOR(3 DOWNTO 0);	

	BEGIN
		ux4(0) := Q_current(31) XOR u4(3);
		ux4(1) := Q_current(30) XOR u4(2);
		ux4(2) := Q_current(29) XOR u4(1);
		ux4(3) := Q_current(28) XOR u4(0);

        Q_next(31) <= Q_current(27);
		Q_next(30) <= Q_current(26);
		Q_next(29) <= Q_current(25) XOR ux4(0);
		Q_next(28) <= Q_current(24) XOR ux4(1);
		Q_next(27) <= Q_current(23) XOR ux4(2);
		Q_next(26) <= Q_current(22) XOR ux4(3) XOR ux4(0);
		Q_next(25) <= Q_current(21) XOR ux4(1) XOR ux4(0);
		Q_next(24) <= Q_current(20) XOR ux4(2) XOR ux4(1);
		Q_next(23) <= Q_current(19) XOR ux4(3) XOR ux4(2);
		Q_next(22) <= Q_current(18) XOR ux4(3);		
		Q_next(21) <= Q_current(17);
		Q_next(20) <= Q_current(16);
		Q_next(19) <= Q_current(15) XOR ux4(0);
		Q_next(18) <= Q_current(14) XOR ux4(1);
		Q_next(17) <= Q_current(13) XOR ux4(2);
		Q_next(16) <= Q_current(12) XOR ux4(3);
		Q_next(15) <= Q_current(11) XOR ux4(0);
		Q_next(14) <= Q_current(10) XOR ux4(1) XOR ux4(0);
		Q_next(13) <= Q_current(9) XOR ux4(2) XOR ux4(1) XOR ux4(0);
		Q_next(12) <= Q_current(8) XOR ux4(3) XOR ux4(2) XOR ux4(1);
		Q_next(11) <= Q_current(7) XOR ux4(3) XOR ux4(2) XOR ux4(0);
		Q_next(10) <= Q_current(6) XOR ux4(3) XOR ux4(1) XOR ux4(0);
		Q_next(9) <= Q_current(5) XOR ux4(2) XOR ux4(1);
		Q_next(8) <= Q_current(4) XOR ux4(3) XOR ux4(2) XOR ux4(0);
		Q_next(7) <= Q_current(3) XOR ux4(3) XOR ux4(1) XOR ux4(0);
		Q_next(6) <= Q_current(2) XOR ux4(2) XOR ux4(1);
		Q_next(5) <= Q_current(1) XOR ux4(3) XOR ux4(2) XOR ux4(0);
		Q_next(4) <= Q_current(0) XOR ux4(3) XOR ux4(1) XOR ux4(0);
		Q_next(3) <= ux4(2) XOR ux4(1) XOR ux4(0);
		Q_next(2) <= ux4(3) XOR ux4(2) XOR ux4(1);
		Q_next(1) <= ux4(3) XOR ux4(2);
		Q_next(0) <= ux4(3);
		

	END PROCESS;

    crcreg_clock_enable <= init or compute_enable;

-- output
	CRC_out <= Q_current;

END rtlreg;
