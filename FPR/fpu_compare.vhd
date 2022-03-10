library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity fpu_compare is 
port(
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
result: out std_logic_vector(2 downto 0)
);
end entity;

architecture arch of fpu_compare is

begin


main_proc: process(A,B)

begin

if((A(15) xor B(15)) = '0' and A(15) = '0') then
 
if(A(14 downto 0) > B(14 downto 0) then

result(0) <= '1';

elsif(A(14 downto 0) = B(14 downto 0) then

result(1) <= '1';

elsif(A(14 downto 0) < B(14 downto 0) then

result(2) <= '1';

end if;

elsif((A(15) xor B(15)) = '0' and A(15) = '1') then

if(A(14 downto 0) > B(14 downto 0) then

result(2) <= '1';

elsif(A(14 downto 0) = B(14 downto 0) then

result(1) <= '1';

elsif(A(14 downto 0) < B(14 downto 0) then

result(0) <= '1';

end if;

end if;

if((A(15) xor B(15)) = '1' and A(15) = '0') then

if(A(14 downto 0) = "000000000000000" and B(14 downto 0) = "000000000000000") then

result(1) = '1';

else

result(0) <= '1';

end if;

elsif((A(15) xor B(15)) = '1' and A(15) = '1') then

if(A(14 downto 0) = "000000000000000" and B(14 downto 0) = "000000000000000") then

result(1) = '1';

else

result(2) <= '1';

end if;

end if;

end process;

end architecture;