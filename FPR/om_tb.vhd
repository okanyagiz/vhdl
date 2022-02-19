library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity om_tb is 

end entity;

architecture arch of om_tb is

component operand_modifier is
generic(
nof_bits: natural := 6
);
port(
A: in std_logic_vector((nof_bits -1) downto 0);
D: out std_logic_vector((nof_bits -1) downto 0)
);
end component;

signal A: std_logic_vector(5 downto 0);
signal D: std_logic_vector(5 downto 0);

begin

uut: operand_modifier port map(

		A => A,
		D => D);

stim_proc: process

begin
		A <= "001101";
		wait for 20 ns;
		A <= "111000";
		wait for 20 ns;
		wait;

end process;

end architecture;