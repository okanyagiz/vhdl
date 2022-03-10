library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity float_mul is 
port(
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
clk: in std_logic;
start: in std_logic;
done: out std_logic;
C: out std_logic_vector(31 downto 0));
end entity;

architecture arch of float_mul is 

signal sign: std_logic;
signal zero_flag: std_logic;
signal nan_flag: std_logic;
signal inf_flag: std_logic;
signal shift_binary: integer := 0;
signal final_exponent: std_logic_vector(7 downto 0);
signal temp_exponent: std_logic_vector(7 downto 0);
signal A_man: std_logic_vector(23 downto 0);
signal B_man: std_logic_vector(23 downto 0);
signal result_man: std_logic_vector(47 downto 0);
signal final_man: std_logic_vector(22 downto 0);
signal A_temp: std_logic_vector(31 downto 0);
signal B_temp: std_logic_vector(31 downto 0);
signal C_temp: std_logic_vector(31 downto 0);
type states is (s0,s1,s2,s3,s4);
signal state: states;

begin

main_proc: process(clk)

begin
if(start = '0') then

state <= s0;

elsif(clk'event and clk = '1') then

case state is 

when s0 =>

A_temp <= A;
B_temp <= B;

if(A = x"00000000" or B = x"00000000") then

zero_flag <= '1';
C <= x"00000000";
state <= s0;

elsif(A = A_temp and B = B_temp) then

state <= s0;
done <= '1';
else

sign <= A(31) xor B(31);
A_man <= '1' & A(22 downto 0);
B_man <= '1' & B(22 downto 0);
temp_exponent <=  A(30 downto 23) + B(30 downto 23) -127;
shift_binary <= 0;
state <= s1;
done <= '0';

end if;

when s1 =>

result_man <= A_man * B_man;
state <= s2;

when s2 =>

if(result_man(46) = '1' and result_man(47) = '0') then
final_man <= result_man(45 downto 23);

state <= s3;

--elsif(result_man(47) = '1' and result_man(46) = '0') then
elsif(result_man(47) = '1') then

final_man <= result_man(46 downto 24);
shift_binary <= shift_binary + 1;
state <= s3;

elsif(result_man(47) = '0' and result_man(46) = '0') then

result_man <= result_man(46 downto 0) & '0';
state <= s2;

end if;

when s3 =>

final_exponent <= temp_exponent + shift_binary;
state <= s4;

when s4 =>

--if( (final_exponent - 127) > 127 or (final_exponent -127) < -128) then

--inf_flag <= '1';
--C <= (others => 'Z');
--done <= '1';
--state <= s0;

--else

C <= sign & final_exponent & final_man;
done <= '1';
state <= s0;

--end if;

end case;

end if;

end process;

end architecture;
