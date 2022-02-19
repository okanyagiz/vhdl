library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity decider is 
port(
A: in std_logic;
B: in std_logic;
mode: in std_logic;
decide: out std_logic
);
end entity;

architecture arch of decider is

begin

process(A,B,mode)

begin

if((A xor B) = '0' and mode = '0') then

decide <= '0';

elsif((A xor B) = '1' and mode = '0') then

decide <= '1';

elsif((A xor B) = '0' and mode = '1') then

decide <= '1';

elsif((A xor B) = '1' and mode = '1') then

decide <= '0';

end if;

end process;


end architecture;
