library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity float_div is 
port(
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
clk: in std_logic;
exceptions: out std_logic_vector(4 downto 0);
data_out: out std_logic_vector(31 downto 0)
);
end entity;


architecture arch of float_div is

component float_mul is 
port(
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
start: in std_logic;
done: out std_logic;
clk: in std_logic;
C: out std_logic_vector(31 downto 0));
end component;


component floating_add_sub is 
port(
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
clk: in std_logic;
mode: in std_logic;
done: out std_logic;
C: out std_logic_vector(31 downto 0)
);
end component;

signal Exponent:   std_logic_vector(7 downto 0);

signal temp1,temp2,temp3,temp4,temp5,temp6,temp7,debug: std_logic_vector(31 downto 0);
signal reciprocal: std_logic_vector(31 downto 0);
signal y0: std_logic_vector(31 downto 0);
signal y1: std_logic_vector(31 downto 0);
signal y2: std_logic_vector(31 downto 0);
signal y3: std_logic_vector(31 downto 0);
signal temp_b1,temp_b2,temp_b4,temp_b6: std_logic_vector(31 downto 0);
signal reg1: std_logic_vector(31 downto 0);
signal done_m1, done_m2, done_m3, done_m4, done_m5, done_m6, done_m7,done_m8: std_logic;
signal done_a1, done_a2, done_a3, done_a4: std_logic;
signal s1,s2,s3,s4: std_logic;
signal scale: std_logic_vector(31 downto 0);

begin

mul1: float_mul port map(

	A => scale,
	B => x"3FF0F0F1",
	clk => clk,
	start => '1',
	done => done_m1,
	C => temp1);

add1: floating_add_sub port map(

	A 	=> x"4034b4b5",
	B 	=> temp_b1,
	clk => clk,
	mode=> '0',
	done => done_a1,
	C 	=> y0);

--Initial Approximation is Done

mul2: float_mul port map(

	A => scale,
	B => y0,
	clk => clk,
	start => s1,
	done => done_m2,
	C => temp2);

add2: floating_add_sub port map(

	A 	 => x"40000000",
    B 	 => temp_b2,
    clk  => clk,
    mode => '0',
    done => done_a2,
    C 	 => temp3);	
	
mul3: float_mul port map(

	A => y0,
	B => temp3,
	clk => clk,
	start => s2,
	done => done_m3,
	C => y1);

--First Iteration is Done


mul4: float_mul port map(

	A => scale,
	B => y1,
	clk => clk,
	start => done_m3,
	done => done_m4,
	C => temp4);

add3: floating_add_sub port map(

	A 	 => x"40000000",
    B 	 => temp_b4,
    clk  => clk,
    mode => '0',
    done => done_a3,
    C 	 => temp5);	
	
mul5: float_mul port map(

	A => y1,
	B => temp5,
	clk => clk,
	start => s3,
	done => done_m5,
	C => y2);

-- Second Iteration is Done


mul6: float_mul port map(

	A => scale,
	B => y2,
	clk => clk,
	start => done_m5,
	done => done_m6,
	C => temp6);

add4: floating_add_sub port map(

	A 	=> x"40000000",
    B 	=> temp_b6,
    clk => clk,
    mode=> '0',
    done => done_a4,
    C 	=> temp7);	
	
mul7: float_mul port map(

	A => y2,
	B => temp7,
	clk => clk,
	start => s4,
	done => done_m7,
	C => y3);

--Third Iteration is Done

	
Exponent <= y3(30 downto 23) + 126 - B(30 downto 23);	
reciprocal <= B(31) & Exponent & y3(22 downto 0);	
	

last_step: float_mul port map(
	
	A => A,
	B => reciprocal,
	clk => clk,
	start => done_m7,
	done => done_m8,
	C => data_out);	

side_proc1: process(done_m1, done_a1)
begin

s1 <= (done_m1 AND done_a1);

end process;

side_proc2: process(done_m2, done_a2)
begin

s2 <= (done_m2 AND done_a2);

end process;

side_proc3: process(done_m4, done_a3)
begin

s3 <= (done_m4 AND done_a3);

end process;

side_proc4: process(done_m6, done_a4)
begin

s4 <= (done_m6 AND done_a4);

end process;

scaling: process(B)
begin

scale <= '0' & "01111110" & B(22 downto 0);

end process;



    temp_b1 <= ('1' & temp1(30 downto 0));
	
	temp_b2 <= (not(temp2(31))& temp2(30 downto 0));
	
    temp_b4 <= (not(temp4(31))& temp4(30 downto 0));

    temp_b6 <= (not(temp6(31))& temp6(30 downto 0));
    
    
end architecture;