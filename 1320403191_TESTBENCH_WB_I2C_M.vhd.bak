--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:51:49 11/03/2011
-- Design Name:   
-- Module Name:   C:/Users/tomue/Desktop/Torsten Mueller/C1080-3807_PCIeV4BASE/I2C DDR FLASH auslesen/VHDL USBs6/inkl I2C/src/sim_tb/TESTBENCH_WB_I2C_M.vhd
-- Project Name:  Original
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: i2c_master_top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TESTBENCH_WB_I2C_M IS
END TESTBENCH_WB_I2C_M;
 
ARCHITECTURE behavior OF TESTBENCH_WB_I2C_M IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT i2c_master_top
  
    PORT(
         wb_clk_i : IN  std_logic;
         wb_rst_i : IN  std_logic;
         arst_i : IN  std_logic;
         wb_adr_i : IN  std_logic_vector(2 downto 0);
         wb_dat_i : IN  std_logic_vector(7 downto 0);
         wb_dat_o : OUT  std_logic_vector(7 downto 0);
         wb_we_i : IN  std_logic;
         wb_stb_i : IN  std_logic;
         wb_cyc_i : IN  std_logic;
         wb_ack_o : OUT  std_logic;
         wb_inta_o : OUT  std_logic;
         scl_pad_i : IN  std_logic;
         scl_pad_o : OUT  std_logic;
         scl_padoen_o : OUT  std_logic;
         sda_pad_i : IN  std_logic;
         sda_pad_o : OUT  std_logic;
         sda_padoen_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal wb_clk_i : std_logic := '0';
   signal wb_rst_i : std_logic := '0';
   signal arst_i : std_logic := '0';
   signal wb_adr_i : std_logic_vector(2 downto 0) := (others => '0');
   signal wb_dat_i : std_logic_vector(7 downto 0) := (others => '0');
   signal wb_we_i : std_logic := '0';
   signal wb_stb_i : std_logic := '0';
   signal wb_cyc_i : std_logic := '0';
   signal scl_pad_i : std_logic := '0';
   signal sda_pad_i : std_logic := '0';

 	--Outputs
   signal wb_dat_o : std_logic_vector(7 downto 0);
   signal wb_ack_o : std_logic;
   signal wb_inta_o : std_logic;
   signal scl_pad_o : std_logic;
   signal scl_padoen_o : std_logic;
   signal sda_pad_o : std_logic;
   signal sda_padoen_o : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
	signal SCL : std_logic;
	signal SDA : std_logic;

   signal clock : std_logic := '0';
   constant clock_period : time := 10 ns;
   
   constant a_period : time := 100 ns;
   constant b_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: i2c_master_top 
 
	PORT MAP (
          wb_clk_i => wb_clk_i,
          wb_rst_i => wb_rst_i,
          arst_i => arst_i,
          wb_adr_i => wb_adr_i,
          wb_dat_i => wb_dat_i,
          wb_dat_o => wb_dat_o,
          wb_we_i => wb_we_i,
          wb_stb_i => wb_stb_i,
          wb_cyc_i => wb_cyc_i,
          wb_ack_o => wb_ack_o,
          wb_inta_o => open,
          scl_pad_i => scl_pad_i,
          scl_pad_o => open,				-- 0
          scl_padoen_o => scl_padoen_o,
          sda_pad_i => sda_pad_i,
          sda_pad_o => open, 				-- 0
          sda_padoen_o => sda_padoen_o
	);

	wb_clk_i 	<= clock;
	--wb_rst_i 	<= '0';
	arst_i 		<= '1';
	
	wb_stb_i <= wb_cyc_i;
	
	SCL <= '0' when (scl_padoen_o = '0') else 'Z';
	SDA <= '0' when (sda_padoen_o = '0') else 'Z';


	
   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- hold reset state for 100 ns.
		wb_rst_i <= '1';
		wait for 5.1 ns;	
		wb_rst_i <= '0';

		wait for clock_period*10;
		
--		--disable
--		wb_adr_i <= "010";
--		wb_dat_i <= "00000000";
--		wb_we_i  <= '1';
--		wb_cyc_i <= '1';
--		wait for 2*clock_period;
--		wb_cyc_i <= '0';
--		wait for 2*clock_period;
--
--
		wb_adr_i <= "000"; --low
		wb_dat_i <= "00000001";
		wb_we_i  <= '1';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;
		

		wb_adr_i <= "001";--hi
		wb_dat_i <= "00000000";
		wb_we_i  <= '1';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;
		

		--enable
		wb_adr_i <= "010";
		wb_dat_i <= "11000000";
		wb_we_i  <= '1';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;


		--fülle Transmit Register
		wb_adr_i <= "011";
		wb_dat_i <= "10101010";
		wb_we_i  <= '1';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;


		--Starte Kommunikation
		wb_adr_i <= "100";
		wb_dat_i <= "10010000";
		wb_we_i  <= '1';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;

		--Read Status Register
		wb_adr_i <= "100";
		wb_dat_i <= "10101000";
		wb_we_i  <= '0';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;

	
		--Read Status Register
		wb_adr_i <= "100";
		wb_dat_i <= "10101000";
		wb_we_i  <= '0';
		wb_cyc_i <= '1';
		wait for 2*clock_period;
		wb_cyc_i <= '0';
		wait for 2*clock_period;




		wait;

   end process;

END;
