library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity MUX is 
generic(
len: natural := 54
);
port(
A: in std_logic_vector((len-1) downto 0);
B: in std_logic_vector((len-1) downto 0);
--clk: in std_logic;
sel: in std_logic;
C: out std_logic_vector((len-1) downto 0)
);
end entity;

architecture arch of MUX is

begin

process(sel,A,B)

begin

--if(clk'event and clk = '1') then

if(sel = '0') then

C <= A;

else

C <= B;

end if;

--end if;

end process;

end architecture;