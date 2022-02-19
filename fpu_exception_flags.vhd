library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity fpu_expection_flags is 
port
(
A: in std_logic_vector(15 downto 0);
flags: out std_logic_vector(4 downto 0)
);
end entity;


architecture arch of fpu_expection_flags is

begin

process(A)

begin

if(A = (others => '0')) then

-- zeroflag is set

flags(0) <= '1';

elsif(A(15) = '1' and A(14 downto 0) = (others => '0') then

-- negative zero occurs

flags(1) <= '1';

elsif(A(14 downto 10) = "11111" and A(9 downto 0) = "0000000000") then

-- infinitiy occurs

flags(2) <= '1';

elsif(A(14 downto 10) = "11111" and A(9 downto 0) /= "0000000000") then

-- A is not an number, NaN occurs

flags(3) <= '1';

end if;

end process;

end architecture;