library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity operand_modifier is 
generic(
nof_bits: natural := 8
);
port(
A: in std_logic_vector((nof_bits -1) downto 0);
D: out std_logic_vector((nof_bits -1) downto 0)
);
end entity;


architecture arch of operand_modifier is 

signal first_part: std_logic_vector(((nof_bits/2) -1) downto 0);
signal second_part: std_logic_vector(((nof_bits/2) -1) downto 0);

begin

process(A)

begin

second_part <= not(A(((nof_bits/2) -1) downto 0));

end process;

process(second_part)

begin

D <= A((nof_bits -1) downto (nof_bits/2)) & second_part;

end process;

end architecture;