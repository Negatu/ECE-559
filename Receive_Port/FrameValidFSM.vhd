library ieee ;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

entity FrameValidFSM is 
port( clk, Check_Result, CRV, lengthValid, reset:	in std_logic;
	  FrameValid:			out std_logic;
	  invalidBit : OUT STD_LOGIC);
end FrameValidFSM;


architecture simple_arch of FrameValidFSM is
	type state_type is
				(WAITING, LENGTH_IS_VALID, FRAME_IS_VALID);
	
	signal state_reg, state_next: state_type;

	begin
		process(clk, reset)  -- STATE REGISTER UPDATE
		begin 
			if(reset = '1') then state_reg <= WAITING;
			elsif(clk'event and clk='1') then
				state_reg <= state_next;
			end if;
		end process;

		process(state_reg, Check_Result, CRV, lengthValid) -- NEXT STATE LOGIC
		begin
			case state_reg is 
				when WAITING =>
					if (lengthValid='1') then
						state_next <= LENGTH_IS_VALID;
					else 
						state_next <= WAITING;
					end if;
				when LENGTH_IS_VALID =>
					state_next <= WAITING;
					if (Check_Result='1') then
						if (CRV = '1') then
							state_next <= FRAME_IS_VALID;
						end if;
					end if;
				when FRAME_IS_VALID =>
					state_next <= WAITING;
			end case;
		end process;

		process(state_reg) -- MOORE OUTPUT
		begin
			case state_reg is
				when WAITING =>
					FrameValid <= '0';
					invalidBit <= '1';
				when LENGTH_IS_VALID => 
					FrameValid <= '0';
					invalidBit <= '1';
				when FRAME_IS_VALID =>
					FrameValid <= '1';
					invalidBit <= '0';
			end case;
		end process;
	end simple_arch;