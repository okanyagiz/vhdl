library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity MUX_PORT is 
generic(
len: natural := 12
);
port(
A: in std_logic_vector((len-1) downto 0);
B: in std_logic_vector((len-1) downto 0);
--clk: in std_logic;
C: in std_logic_vector((len-1) downto 0);
sel: in std_logic_vector(1 downto 0);
D: out std_logic_vector((len-1) downto 0)
);
end entity;

architecture arch of MUX_PORT is

begin

process(sel,A,B,C)

begin

--if(clk'event and clk = '1') then

if(sel = "00") then

D <= A;

elsif(sel = "01") then

D <= B;

elsif(sel = "10") then

D <= (others => '0');

elsif(sel = "11") then

D <= C;

end if;

--end if;

end process;

end architecture;