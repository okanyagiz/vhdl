library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity my_rom is 
generic(

addr_len: natural := 4;
data_len: natural := 8
);
port(
rom_enable: in std_logic;
address: in std_logic_vector((addr_len -1) downto 0);
data_out: out std_logic_vector((data_len -1) downto 0)
);
end entity;


architecture arch of my_rom is

type rom_type is array (0 to (2**(addr_len) -1)) of std_logic_vector((data_len -1) downto 0);

constant mem: rom_type := 
	(

	--ROM ICERIGINI DOLDUR
	"11110000",
	"11010110",
	"10111111",
	"10101100",
	"10011100",
	"10001101",
	"10000001",
	"11101101",
	"11011010",
	"11001001",
	"10111010",
	"10101101",
	"10100001",
	"10010110",
	"10010110",
	"10000100"
	);
	
begin

main_proc: process(rom_enable)

begin


if(rom_enable = '1') then

data_out <= mem(to_integer(unsigned(address)));

end if;

end process;

end architecture;