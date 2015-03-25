-- Top level design entity for CRC_register and CRC_FSM
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity CRC_System is
	port(Clk, reset, rdv: in std_logic; 
		 data_in_4 : in std_logic_vector(3 downto 0);
		 CRC_result_valid,  CRC_check_result: out std_logic);
end CRC_System;

architecture combined of CRC_System is

	component CRC_FSM is 
	port(
			clk			: IN STD_LOGIC ;
			reset_sig	: IN STD_LOGIC ;
			rdv			: IN STD_LOGIC ;
			CRC_out		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
			init_sig	: OUT STD_LOGIC ;
			compute_enable: OUT STD_LOGIC ;
			check_result: OUT STD_LOGIC ;
			crv			: OUT STD_LOGIC -- crv = check_result_valid
			); 
	end component;
	
	component crc32x4r is
	port 
		(	Clock			: IN		STD_LOGIC;
			Reset			: IN		STD_LOGIC;
			compute_enable	: IN		STD_LOGIC;
            init	        : IN	    STD_LOGIC;
			u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CRC_out			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	end component;

	signal CRC_out_sig 	: std_logic_vector(31 downto 0);
	signal init_sig, compute_enable_sig : std_logic;
	
	begin
	
	CRC_FSM_inst : CRC_FSM PORT MAP (
		clk			 => Clk,
		reset_sig	 => reset,
		rdv			 => rdv,
		CRC_out		 => CRC_out_sig,
		init_sig	 => init_sig,
		compute_enable => compute_enable_sig,
		check_result =>   CRC_check_result,
		crv			 => CRC_result_valid
	);
	
	crc32x4r_inst : crc32x4r PORT MAP (	
			Clock		=> Clk,
			Reset		=> reset,
			init		=> init_sig,
            u4        => data_in_4,
            compute_enable  => compute_enable_sig,
			CRC_out		=> CRC_out_sig
	);

end combined;