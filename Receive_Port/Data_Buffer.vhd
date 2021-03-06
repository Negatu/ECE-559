LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Data_Buffer IS
	PORT
	(
		reset, write_enable, write_clk, read_enable, read_clk : IN STD_LOGIC;
		data_in_4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		read_empty, write_full : OUT STD_LOGIC;
		data_out_8 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END Data_Buffer;


ARCHITECTURE Data_FSM_arch OF Data_Buffer IS 
	
	COMPONENT Data_DCFF 
	PORT (
			wrclk	: IN STD_LOGIC ;
			rdempty	: OUT STD_LOGIC ;
			rdreq	: IN STD_LOGIC ;
			aclr	: IN STD_LOGIC ;
			wrfull	: OUT STD_LOGIC ;
			rdclk	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			wrreq	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (3 DOWNTO 0)
		 );
	END COMPONENT;
	
	
	
	BEGIN
	DCFF_inst : Data_DCFF PORT MAP (
		wrclk => write_clk,
		rdempty => read_empty,
		rdreq => read_enable,
		aclr => reset,
		wrfull => write_full,
		rdclk => read_clk,
		q => data_out_8,
		wrreq => write_enable,
		data => data_in_4
	);
	
	
	
	
	END Data_FSM_arch; 