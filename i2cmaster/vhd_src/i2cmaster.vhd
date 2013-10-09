library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity i2cmaster is

generic (
	system_clk	: integer := 50_000_000;--20;
	bus_clk		: integer :=  400_000-- 2500;
);



port
(
	clk 		 : in std_logic;
	areset_n	 : in std_logic;
	ena		 : in std_logic;
	addr		 : in std_logic_vector(6 downto 0);
	rnw		 : in std_logic;
	data_wr	 : in std_logic_vector(7 downto 0);
	data_rd	 : out std_logic_vector(7 downto 0);
	busy		 : out std_logic;
	ack_error : inout std_logic;
	sda 		 : inout std_logic;
	scl		 : inout std_logic
);
	end entity i2cmaster;
	
	architecture top_level of i2cmaster is
	
	type statetype is (sSTART,sACK1,sACK2,sIDLE,sWRITE,sREAD,sADDR,sMACK,sSTOP);
	-- Internal signal declaration
	
	
	signal state 		: 	statetype;
	signal state_ena	:	std_logic;
	signal scl_high_ena	:	std_logic;
	signal scl_clk		:	std_logic;
	signal scl_oe		:	std_logic;
	signal ack_error_i:	std_logic;
	signal rnw_i		:	std_logic;	
	signal sda_int		:	std_logic;
	signal addr_rnw	:	std_logic_vector(7 downto 0);
	signal data_tx		:	std_logic_vector(7 downto 0);
	signal data_rx		:	std_logic_vector(7 downto 0);
	signal bit_count	:	integer range 0 to 7;
	
	begin
	
		state_proc: process (clk,areset_n)
		begin
		case state is			
			when sSTART =>
				if state_ena = '1' then	
					state <= sADDR;
				end if;
			when sADDR =>
				if state_ena = '1' and bit_count = 0 then
					state <= sACK1;
				end if;
			when sACK1 =>
				if state_ena = '1' and rnw_i = '0' then
					state <= sWRITE;
				elsif state_ena = '1' and rnw_i = '1' then	
					state <= sREAD;
				end if;
			when sWRITE =>
				if state_ena = '1' and bit_count = 0 then 
					state <= sACK2;
				end if;
			when sACK2 => 
				if state_ena = '1' and ena = '0' then
					state <= sSTOP;
				elsif state_ena = '1' and ena = '1' and rnw = '0' then	
					state <= sWRITE;
				elsif state_ena = '1' and ena = '1' and rnw = '1' then	
						state <= sSTART;
				end if;
				
			when sREAD =>
				if state_ena = '1' and bit_count = 0 then 
					state <= sMACK;
				end if;
			when sMACK =>
				if state_ena = '1' and ena = '0' then
					state <= sSTOP;
				elsif state_ena = '1' and ena = '1' and rnw = '0' then	
					state <= sSTART;
				elsif state_ena = '1' and ena = '1' and rnw = '1' then	
						state <= sREAD;
				end if;
			when sSTOP =>
				if state_ena = '1' then	
					state <= sIDLE;
				end if;
			when sIDLE =>
				if state_ena = '1' and ena = '1' then
					state <= sSTART;
				end if;
			end case;
		end process;
		
		
		output_proc: process (state)
		begin
			case state is 
				when sIDLE => -- Missing sample data_wr usw
					busy <= '0';
					if ena = '1' then	
						addr_rnw <= addr & rnw;
					end if;
					sda_int <= '1';
				when sSTART => -- Ok
					busy <= '1';
					sda_int <= '1';
					if scl_high_ena = '1' then
						sda_int <= '0';
					end if;
					
				when sADDR => -- Ok
					busy <= '1';
					sda_int <= addr_rnw(bit_count) ;
					if bit_count = 0 then	
						bit_count <= 7;
					else 
						bit_count <= (bit_count -1);
					end if;
				when sACK1 => -- Ok
					busy <= '0';
					sda_int <= '1';
					if scl_high_ena = '1' then		
						if sda_int = '1' then
							ack_error <= '1';
						end if;
					end if;
				when sWRITE => -- Ok
					busy <= '1';
					sda_int <= data_tx(bit_count);
					if bit_count = 0 then	
						bit_count <= 7;
					else 
						bit_count <= (bit_count -1);
					end if;
				when sREAD =>
					busy <= '1';
					sda_int <= '1';
					if scl_high_ena = '1' then
						sda <= data_rx(bit_count);
					end if;
					if bit_count = 0 then	
						bit_count <= 7;
					else 
						bit_count <= (bit_count -1);
					end if;
				when sACK2 => -- Eventuellement a reprendre
					sda_int <= '1';
					busy <= '0';
					if ena = '1' and rnw = '0' then	
						data_tx <= data_wr;
						addr_rnw <= addr & rnw;
					elsif ena = '1'  and rnw = '1' then
						addr_rnw <= addr & rnw;
						data_tx <= data_wr;
					end if;
					if scl_high_ena = '1' then
						if sda = '1' then
							ack_error <= '1';
						end if;
				end if;
				when sMACK =>
					sda_int <= '1';
					busy <= '0';
					if ena = '1' and rnw = '0' then -- restart condition
						sda_int <= '1';
						if scl_high_ena = '1' then
							sda_int <= '0';
						end if;
						elsif ena = '0' and state_ena = '1' then
							sda_int <= '0';
					end if;
				when sSTOP =>
					busy <= '1';
					if scl_high_ena = '1' then	
						sda_int <= '1';
					end if;
			end case;
		
		end process;
		
		
		-- This process creates a clock divider used by our bus
		clk_proc: process (clk)
			variable counter : integer := 0;
			variable divider : integer := system_clk/bus_clk;
		
		begin
		-- bus_clk  is the same as i2c_clk
			if state_ena = '0' and scl_high_ena = '0' then	
				counter := 0;
				scl_clk <= '0';
			
			elsif rising_edge(clk) then
				state_ena<= '0';
				counter := counter+1;
					
					if counter = ((divider /2 )-1) then
						scl_clk <= '1';
			
					elsif counter = (divider -1) then	
						state_ena <= '1';
						scl_clk <= '0';
						counter :=0;					
					end if;	
		
		end if;		
		end process;
	
	end architecture top_level;
	
