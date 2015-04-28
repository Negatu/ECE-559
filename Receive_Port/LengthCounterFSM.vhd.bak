library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity LengthCounterFSM is 
port( clk, reset_sig, crc_RDV:	in std_logic;
	  bufferWE, CntEnable, reset_counter:		out std_logic); --bufferWE = buffer write enable, CntEnable = counter enable
end LengthCounterFSM;


architecture lengthCounterArch of LengthCounterFSM is
	type state_type is
				(RESET, WAITING, COUNT, WRITEOUT);
	signal state_reg, state_next: state_type;
	
	begin
		process(clk, reset_sig)  -- STATE REGISTER UPDATE
		begin 
			if(reset_sig = '1') then 
				state_reg <= RESET;
			elsif(clk'event and clk='1') then
				state_reg <= state_next;
			end if;
		end process;

		process(state_reg, crc_RDV) -- NEXT STATE LOGIC
		begin
			case state_reg is 
				when RESET =>
					state_next <= WAITING;
				when WAITING =>
					if (crc_RDV='1') then
						state_next <= COUNT;
					else
						state_next <= WAITING;
					end if;
				when COUNT =>
					if (crc_RDV='0') then
						state_next <= WRITEOUT;
					else
						state_next <= COUNT;
					end if;
				when WRITEOUT =>
					state_next <= RESET;	
			end case;
		end process;

		process(state_reg) -- MOORE Machine
		begin
			case state_reg is
				when RESET =>
					bufferWE <= '0';
					CntEnable <= '0';
					reset_counter <= '1';
				when WAITING =>
					bufferWE <= '0';
					CntEnable <= '0';
					reset_counter <= '0';
				when COUNT =>
					bufferWE <= '0';
					CntEnable <= '1';
					reset_counter <= '0';
				when WRITEOUT =>
					bufferWE <= '1';
					CntEnable <= '0';
					reset_counter <= '0';
			end case;
		end process;
	
	end lengthCounterArch;