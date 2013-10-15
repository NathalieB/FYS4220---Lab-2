library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_i2cmaster is
end;

architecture testbench of tb_i2cmaster is

Component i2cmaster
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
end component;

		signal clk 			 : 	std_logic := '0';
		signal areset_n	 :  	std_logic := '0';
		signal ena			 :  	std_logic := '1';
		signal addr	 		 :  	std_logic_vector(6 downto 0) := (others => '0');
		signal rnw		 	 : 	std_logic := '0';
		signal data_wr	 	 : 	std_logic_vector(7 downto 0) := (others => '0');
		signal data_rd	 	 : 	std_logic_vector(7 downto 0) := (others => '0');
		signal busy		 	 : 	std_logic := '0';
		signal ack_error 	 : 	std_logic := '0';
		signal sda 	 		 : 	std_logic := '0';
		signal scl			 : 	std_logic := '0';

begin

   UUT : i2cmaster
	port map(
			clk => clk,
			areset_n => areset_n,
			ena => ena,
			addr => addr,
			rnw => rnw,
			data_wr => data_wr,
			data_rd => data_rd,
			busy => busy,
			ack_error => ack_error,
			sda => sda,
			scl => scl
	);

	areset_n <= '1';
	areset_n <= '0';
	
	clock_process : process
	begin
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
	end process;
	
	-- process used to fix the temperature resolution
	resolution_process : process
	begin
		addr <= "1001000";
		rnw <= '0';
		wait for 100 ns;
		addr <= "0000000";
		rnw <= '1';
		wait for 100 ns;
		addr <= "0110000";
		rnw <= '0';
		wait for 100 ns;
		
	-- fixe the temperature register address
		addr <= "1001000";
		rnw <= '1';
		wait for 100 ns;
	
	--read the value of the temperature register
		addr <= "1001000";
		rnw <= '1'; -- 1 to read
		wait for 100 ns;
			
	end process;
	
end architecture testbench;