library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity UART_transmitter is
generic(
clkfreq: integer := 100_000_00;
baudrate: integer := 9600;
stopbit: integer := 2;
 );
port(
clk: in std_logic;
data: in std_logic_vector(7 downto 0);
tx_s: in std_logic;
tx_o: out std_logic;
tx_done_o: out std_logic
);

end entity;


architecture arch of UART_transmitter is 

constant stoplim : integer := (clkfreq/baudrate)*stopbit;
constant bittimerlim: integer := clkfreq/baudrate;

signal bittimer : integer range 0 to stoplim := '0';
type states is (IDLE,START,DATA,STOP);
signal state: states := IDLE;
signal shiftreg: std_logic_vector(7 downto 0) := (others => '0');
signal counter: integer range 0 to 7 := '0';

begin

process(clk)

begin

if(clk'event and clk = '1') then

case state is;


when IDLE => 

tx_o <= '1';
tx_done_o <= '0';
counter <= 0;


if(tx_s = '1') then

tx_o <= '0';
state <= START;
shiftreg <= data;

else
state <= IDLE;

end if;


when START =>

if(bittimer = bittimerlim-1)then

state <= DATA;
tx_o <= shiftreg(0);
shiftreg(7) <= shiftreg(0);
shiftreg(6 downto 0) <= shiftreg(7 downto 1); 
bittimer <= 0;
else
bittimer <= bittimer + 1;

end if;

when DATA => 

if(counter = 7) then

if(bittimer = bittimerlim-1) then

counter <= 0;
state <= STOP;
tx_o <= '1';
bittimer <= 0;
else
bittimer <= bittimer + 1;
end if;

else

if(bittimer = bittimerlim-1) then

tx_o <= shiftreg(0);
shiftreg(7) <= shiftreg(0);
shiftreg(6 downto 0) <= shiftreg(7 downto 1); 
bittimer <= 0;

else

bittimer <= bittimer + 1;

end if;

end if;


when STOP =>

if(bittimer = stoplim-1)then
state <= DATA;
bittimer <= 0;
tx_done_o <= '1';
else
bittimer <= bittimer + 1;

end if;


end case;

end if;

end process;


end architecture;