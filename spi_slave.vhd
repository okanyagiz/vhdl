library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity spi_slave is 
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

end entity;


architecture arch of spi_slave is

signal counter: integer range 0 to 7;
signal tx_buffer: std_logic_vector(7 downto 0);
signal rx_buffer: std_logic_vector(7 downto 0);

type states: (


begin

process(reset,sck,slave_sel)

begin

if(slave_sel = '1' or reset = '1') then
counter = 0;
elsif(slave_sel = '0' and sck'event and sck = '1') then

if(counter = 7) then
counter = 0;

else 

counter = counter + 1;

end if;

end if;

-- end if;

end process;

p2: process(reset,sck,slave_sel)

begin

if(slave_sel = '1' or reset = '1') then

rx_buffer <= (others => '0');

elsif(slave_sel = '0' and sck'event and sck = '1') then

rx_buffer(counter) <= mosi;

end if;

end process;

rx_data <= rx_buffer;

p3: process(reset,sck,slave_sel)

begin

if(slave_sel = '1' or reset = '1') then

miso <= '0';

elsif(slave_sel = '0' and sck'event and sck = '1') then

miso <= tx_data(counter);

end if;

end process;



end architecture;