library ieee;
use ieee.std_logic_1164.all;

entity InputPort is
	port(
	clk, reset: in std_logic;
	read_input: out std_logic;
	phy_input: in std_logic_vector(3 downto 0));
	end InputPort;
	
architecture behaviour of InputPort is
	type state_type is (reset_state, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, read_state);
	signal state_reg, state_next: state_type;
	
begin 
	process(clk,reset)
	begin 
		if (reset='1') then
			state_reg <= reset_state;
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
		end if;
	end process;
	
	process(state_reg, phy_input)
	begin 
		case state_reg is
			when reset_state =>
				if (phy_input="0101") then
					state_next <= s1;
				else 
					state_next <= reset_state;
				end if;
			when s1=>
			if (phy_input="0101") then
					state_next <= s2;
				else 
					state_next <= reset_state;
				end if;
			when s2=>
			if (phy_input="0101") then
					state_next <= s3;
				else 
					state_next <= reset_state;
				end if;
			when s3=>
			if (phy_input="0101") then
					state_next <= s4;
				else 
					state_next <= reset_state;
				end if;	
			when s4=>
			if (phy_input="0101") then
					state_next <= s5;
				else 
					state_next <= reset_state;
				end if;
			when s5=>
			if (phy_input="0101") then
					state_next <= s6;
				else 
					state_next <= reset_state;
				end if;
			when s6=>
			if (phy_input="0101") then
					state_next <= s7;
				else 
					state_next <= reset_state;
				end if;
			when s7=>
			if (phy_input="0101") then
					state_next <= s8;
				else 
					state_next <= reset_state;
				end if;
			when s8=>
			if (phy_input="0101") then
					state_next <= s9;
				else 
					state_next <= reset_state;
				end if;
			when s9=>
			if (phy_input="0101") then
					state_next <= s10;
				else 
					state_next <= reset_state;
				end if;
			when s10=>
			if (phy_input="0101") then
					state_next <= s11;
				else 
					state_next <= reset_state;
				end if;
			when s11=>
			if (phy_input="0101") then
					state_next <= s12;
				else 
					state_next <= reset_state;
				end if;
			when s12=>
			if (phy_input="0101") then
					state_next <= s13;
				else 
					state_next <= reset_state;
				end if;	
			when s13=>
			if (phy_input="0101") then
					state_next <= s14;
				else 
					state_next <= reset_state;
				end if;
			when s14=>
			if (phy_input="0101") then
					state_next <= s15;
				else 
					state_next <= reset_state;
				end if;
			when s15=>
			if (phy_input="1101") then
					state_next <= read_state;
				else 
					state_next <= s15;
				end if;
			when read_state=>
					state_next <= read_state;		end case;
	end process;
	
	process(state_reg)
	begin
		case state_reg is 
			when reset_state=>
				read_input<='0';
			when s1=>
				read_input<='0';
			when s2=>
				read_input<='0';	
			when s3=>
				read_input<='0';	
			when s4=>
				read_input<='0';	
			when s5=>
				read_input<='0';	
			when s6=>
				read_input<='0';
			when s7=>
				read_input<='0';
			when s8=>
				read_input<='0';
			when s9=>
				read_input<='0';
			when s10=>
				read_input<='0';
			when s11=>
				read_input<='0';
			when s12=>
				read_input<='0';
			when s13=>
				read_input<='0';
			when s14=>
				read_input<='0';
			when s15=>
				read_input<='0';	
			when read_state=>
				read_input<='1';			
		end case;
	end process;
	

end behaviour;