library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library std;  -- This is added for ''finish'' statement
use std.env.ALL;

entity spi_slave_tb is 

end entity;


architecture spi_slave_tb is

component spi_slave is 
port(
reset: in std_logic;
sck: in std_logic;
mosi: in std_logic;
miso: out std_logic;
slave_sel: in std_logic
--Buffer
tx_data: in std_logic_vector(7 downto 0);
rx_data: out std_logic_vector(7 downto 0)
);

end component;

signal half_period: integer := 5ns;
signal reset: std_logic;
signal sck: std_logic;
signal mosi: std_logic;
signal miso: std_logic;
signal slave_sel: std_logic;
signal tx_data: std_logic_vector(7 downto 0);
signal rx_data: std_logic_vector(7 downto 0);

begin

uut: spi_slave port map(	
		reset 		=> 		reset,
		sck   		=> 		sck,
		mosi  		=> 		mosi,
		miso 	 	=> 		miso,
		slave_sel	=> 		slave_sel,
		tx_data		=>		tx_data,
		rx_data		=>		rx_data);

sck_process: process(sck,slave_sel,reset)
begin
if(reset = '1' or slave_sel = '1') then
sck <= '0';

elsif(slave_sel = '0' and reset = '0') then 

sck <= '1'; 
wait for half_period;
sck <= '0';
wait for half_period;

end if;

end process;


stim_proc: process

begin

reset <= '1';
slave_sel <= '1';

wait for 50 ns;

reset <= '0';
slave_sel <= '0';
tx_data <= x'A';

wait for 10 ns;

mosi <= '1';
wait for 10 ns;

mosi <= '0';
wait for 20 ns;

mosi <= '1';
wait for 30 ns;

mosi <= '0';
wait for 10 ns;

mosi <= '1';
wait for 10 ns;

slave_sel <= '1';
wait for 10 ns;

finish(0);

end process;

end architecture;