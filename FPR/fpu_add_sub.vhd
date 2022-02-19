library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity floating_add_sub is 
port(
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
clk: in std_logic;
mode: in std_logic;
C: out std_logic_vector(15 downto 0)
);
end entity;

architecture arch of floating_add_sub is

type states is (s0,s1,s2,s3,s4,s5);
signal state: states;

signal A_exp: std_logic_vector(4 downto 0);
signal B_exp: std_logic_vector(4 downto 0);

signal A_man: std_logic_vector(10 downto 0);
signal B_man: std_logic_vector(10 downto 0);

signal shift: std_logic_vector(4 downto 0);
signal select_mantissa: std_logic;

signal counter: std_logic_vector(4 downto 0) := '0' & x"0";

signal temp: std_logic_vector(10 downto 0);
signal temp1: std_logic_vector(11 downto 0);
signal done: std_logic;

signal sign: std_logic;
signal last_exp: std_logic_vector(4 downto 0);

signal add_flag: std_logic;
signal sub_flag: std_logic;
signal decide_flag: std_logic;


-- Component Declarations

component sign_finder is
port(
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
mode: in std_logic;
clk: in std_logic;
sign: out std_logic
);
end component;

component decider is 
port(
A: in std_logic;
B: in std_logic;
mode: in std_logic;
decide: out std_logic);
end component;

begin
main_process: process(clk)

begin

if(clk'event and clk = '1') then

case state is

when s0 =>

A_exp <= A(14 downto 10);
A_man <= '1' & A(9 downto 0);
B_exp <= B(14 downto 10);
B_man <= '1' & B(9 downto 0);
done <= '0';
add_flag <= '0';
sub_flag <= '0';
counter <= '0' & x"0";
state <= s1;

when s1 =>

if(A(14 downto 0) > B(14 downto 0)) then

shift <= A(14 downto 10) - B(14 downto 10);
last_exp <= A_exp;
select_mantissa <= '1';
temp <= B_man;
state <= s2;

elsif(A(14 downto 0) <= B(14 downto 0))then

shift <= B(14 downto 10) - A(14 downto 10);
last_exp <= B_exp;
select_mantissa <= '0';
temp <= A_man;
state <= s2;

end if;

when s2 =>

if(counter < shift) then

temp(9 downto 0) <= temp(10 downto 1);
temp(10) <= '0';
counter <= counter + 1;
state <= s2;

else

state <= s3;

end if;

when s3 =>

if(select_mantissa = '0' and decide_flag = '0') then

temp1 <=  ('0' & temp) + ('0' & B_man);
add_flag <= '1';
state <= s4;

elsif(select_mantissa = '0' and decide_flag = '1') then

temp1(10 downto 0) <=  std_logic_Vector(abs(signed(temp) - signed( B_man)));
sub_flag <= '1';
state <= s4;

elsif(select_mantissa = '1' and decide_flag = '0') then

temp1 <=  ('0' & temp) + ('0' & A_man);
add_flag <= '1';
state <= s4;

elsif(select_mantissa = '1' and decide_flag = '1') then

temp1(10 downto 0) <=  std_logic_Vector(abs(signed(A_man) - signed(temp)));
sub_flag <= '1';
state <= s4;

end if;

when s4 =>

if(add_flag <= '1' and temp1(11) = '1') then

last_exp <= last_exp + 1;
temp1 <= temp1 + 1;
state <= s5;

elsif(add_flag <= '1' and temp1(11) = '0') then

temp1(11 downto 1) <= temp1(10 downto 0); 
temp1(0) <= '0';
state <= s4;


end if;

if(sub_flag = '1' and temp1(10) = '0') then

temp1(10 downto 1) <= temp1(9 downto 0); 
temp1(0) <= '0';
last_exp <= last_exp -1;
state <= s4;

else

state <= s5;

end if;


when s5 =>

if(add_flag = '1') then

C(15) <= sign;
C(14 downto 10) <= last_exp;
C(9 downto 0) <= temp1(10 downto 1);
done <= '1';
state <= s0;

else

C(15) <= sign;
C(14 downto 10) <= last_exp;
C(9 downto 0) <= temp1(9 downto 0);
done <= '1';
state <= s0;


end if;

end case;

end if;

end process;


pmap1: sign_finder port map(
    
        A => A,
        B => B,
        mode => mode,
        clk => clk,
        sign => sign);


pmap2: decider port map(
        
        A => A(15),
        B => B(15),
        mode => mode,
        decide => decide_flag);


end architecture;