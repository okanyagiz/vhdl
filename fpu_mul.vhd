library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity float_mul is 
port(
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
clk: in std_logic;
C: out std_logic_vector(15 downto 0));
end entity;

architecture arch of float_mul is 

signal sign: std_logic;
signal done: std_logic;
signal zero_flag: std_logic;
signal nan_flag: std_logic;
signal inf_flag: std_logic;
signal shift_binary: std_logic;
signal final_exponent: std_logic_vector(4 downto 0);
signal A_man: std_logic_vector(10 downto 0);
signal B_man: std_logic_vector(10 downto 0);
signal result_man: std_logic_vector(21 downto 0);
type states is (s0,s1,s2,s3,s4);
signal state: states;

begin

main_proc: process(clk)

begin

if(clk'event and clk = '1') then

case state is 

when s0 =>

if(A = x"0000" or B = x"0000") then

zero_flag <= '1';
C <= x"0000";
state <= s0;

else

sign <= A(15) xor B(15);
A_man <= '1' & A(9 downto 0);
B_man <= '1' & B(9 downto 0);
shift_binary <= '0';
state <= s1;

end if;

when s1 =>

result_man <= A_man * B_man;
state <= s2;

when s2 =>

if(result_man(21) = '1') then

result_man(21 downto 1) <= result_man(20 downto 0);
result_man(0) <= '0';
shift_binary <= '1';
state <= s3;

else

shift_binary <= '0';
state <= s3;

end if;

when s3 =>

final_exponent <= A(14 downto 10) + B(14 downto 10) -15 + shift_binary;
state <= s4;

when s4 =>

if( (final_exponent - 15) > 15 or (final_exponent -15) < -16) then

inf_flag <= '1';
C <= (others => 'Z');
done <= '1';

else

C(15) <= sign;
C(14 downto 10) <= final_exponent;
C(9 downto 0) <= result_man(21 downto 12);
done <= '1';
state <= s0;

end if;

end case;

end if;

end process;

end architecture;
