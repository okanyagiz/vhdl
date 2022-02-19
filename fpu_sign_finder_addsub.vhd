library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity sign_finder is 
port(
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
clk: in std_logic;
mode: in std_logic;
sign: out std_logic
);
end entity;


architecture arch of sign_finder is 

signal result_xor: std_logic;
signal A_G_B: std_logic;
signal B_G_A: std_logic;
type states is (s0,s1);
signal state: states;

begin


main_proc: process(clk)

begin

if(clk'event and clk = '1') then

if(mode = '0')then

if(result_xor = '0' and A(15) = '0') then 

sign <= '0';

elsif(result_xor = '0' and A(15) = '1') then

if(A_G_B = '1') then

sign <= '1';

else

sign <= '0';

end if;

end if;

if(result_xor = '1' and A(15) = '0') then

if(A_G_B = '1') then

sign <= '0';

else

sign <= '1';

end if;

elsif(result_xor = '1' and A(15) = '1') then

if(A_G_B = '1') then

sign <= '1';

else 

sign <= '0';

end if;

end if;

else

--------------------------------------------
-- From here subtraction case is on the hand

if(result_xor = '0' and A(15) = '0') then 

if(A_G_B = '1') then

sign <= '0';

else

sign <= '1';

end if;

elsif(result_xor = '0' and A(15) = '1') then

if(A_G_B = '1') then

sign <= '1';

else

sign <= '0';

end if;

end if;

if(result_xor = '1' and A(15) = '0') then

sign <= '0';

elsif(result_xor = '1' and A(15) = '1') then

sign <= '1';

end if;

end if;


end if;

end process;


side_proc: process(A,B)

begin

result_xor <= (A(15) xor B(15));

if(A(14 downto 0) >= B(14 downto 0)) then

A_G_B <= '1';
B_G_A <= '0';

else

A_G_B <= '0';
B_G_A <= '1';

end if;

end process;

end architecture;