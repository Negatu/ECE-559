library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity LengthCounterFSM is 
port( clk, reset_sig, crc_RDV:	in std_logic;
	  lengthVal: 			out std_logic_vector(9 downto 0);
	  bufferWE, lengthValid:			out std_logic); --bufferWE = buffer write enable, 
end LengthCounterFSM;


architecture lengthCounterArch of LengthCounterFSM is
	type state_type is
				(RESET, WAITING, COUNT, WRITEOUT);
	signal state_reg, state_next: state_type;
	signal pre_count: std_logic_vector(9 downto 0);

	begin
		process(clk, reset_sig)  -- STATE REGISTER UPDATE
		begin 
			if(reset_sig = '1') then state_reg <= RESET;
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
						state_next <= WAITING; -- could leave out this statement, included it for completeness
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
					pre_count <= "0000000000";
					bufferWE <= '0';
				when WAITING => 
					pre_count <= pre_count; -- might be unneccessary, included it so that FSM has output in all states
					bufferWE <= '0';
				when COUNT =>
					pre_count <= pre_count + '1';
					bufferWE <= '0';
				when WRITEOUT =>
					pre_count <= pre_count; -- might be unneccessary, included it so that FSM has output in all states
					bufferWE <= '1';
			end case;
		end process;
		
		--assigned module outputs
		lengthVal <= pre_count;
		lengthValid <= (or_reduce(pre_count(9 downto 5))) AND (not(pre_count(0)));
		
	end lengthCounterArch;