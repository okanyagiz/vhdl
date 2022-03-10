library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity reciprocal is 
port(
D: in std_logic_vector(63 downto 0);
clk: in std_logic;
data_out: out std_logic_vector(63 downto 0)
);
end entity;

architecture arch of reciprocal is 

	-- SIGNAL DECLARATIONS 

	signal enable: std_logic;
	signal sel1: std_logic_vector(1 downto 0);
	signal sel2: std_logic;
	signal sel3: std_logic;
	
	signal out_rom: std_logic_vector(19 downto 0);
	signal out_om: std_logic_vector(19 downto 0);
	signal out_rom2: std_logic_vector(53 downto 0);
	signal out_om2: std_logic_vector(53 downto 0);
	signal out_mux1: std_logic_vector(53 downto 0);
	signal out_mux2: std_logic_vector(53 downto 0);
	signal out_mux3: std_logic_vector(53 downto 0);
	signal out_mult: std_logic_vector(107 downto 0);
	
	signal reg1: std_logic_vector(53 downto 0);
	signal reg2: std_logic_vector(53 downto 0);
	signal reg3: std_logic_vector(53 downto 0);
	
	signal final_man: std_logic_vector(51 downto 0);
	
	signal exponent: std_logic_vector(10 downto 0);
	signal temp: std_logic_vector(53 downto 0);
	
	signal done1: std_logic;
	signal done2: std_logic;
	
	signal counter: integer := 0;
	
	type states is (s0,s1,s2,s3,s4,s5,s6,s7);
	signal state: states;

	-- COMPONENT DECLARATIONS

	component my_rom_dp_v2 is
	generic(

	addr_len: natural := 10;
	data_len: natural := 20
	);
	port(
	rom_enable: in std_logic;
	address: in std_logic_vector((addr_len -1) downto 0);
	data_out: out std_logic_vector((data_len -1) downto 0)
	);
	end component;

	component my_rom_dp is
	generic(

	addr_len: natural := 10;
	data_len: natural := 20
	);
	port(
	rom_enable: in std_logic;
	address: in std_logic_vector((addr_len -1) downto 0);
	data_out: out std_logic_vector((data_len -1) downto 0)
	);
	end component;


	component operand_modifier is 
	generic(
    nof_bits: natural := 20
    );
    port(
    A: in std_logic_vector((nof_bits -1) downto 0);
    D: out std_logic_vector((nof_bits -1) downto 0)
    );
	end component;

	component MUX is
	generic(
	len: natural := 54
	);
	port(
	A: in std_logic_vector((len-1) downto 0);
	B: in std_logic_vector((len-1) downto 0);
	sel: in std_logic;
--	clk: in std_logic;
	C: out std_logic_vector((len-1) downto 0)
	);
	end component;

	component MUX_PORT is 
	generic(
	len: natural := 54
	);
	port(
	A: in std_logic_vector((len-1) downto 0);
	B: in std_logic_vector((len-1) downto 0);
	C: in std_logic_vector((len-1) downto 0);
--	clk: in std_logic;
	sel: in std_logic_vector(1 downto 0);
	D: out std_logic_vector((len-1) downto 0)
	);
	end component;

begin

rom_map: my_rom_dp_v2 port map(
	
		rom_enable => enable,
		address => D(51 downto 42),
		data_out => out_rom);		

--rom_map: my_rom_dp port map(
	
--		rom_enable => enable,
--		address => D(51 downto 42),
--		data_out => out_rom);		


om_map: operand_modifier port map(

		A => D(51 downto 32),
		D => out_om);

first_mux: MUX_PORT port map(

		A => reg1,
		B => reg3,
--		clk => clk,
		C => out_rom2,
		sel => sel1,	
		D => out_mux1);

second_mux: MUX port map(
	
		A => out_om2,
		B => out_mux3,
--		clk => clk,
		sel => sel2,
		C => out_mux2);

third_mux: MUX port map(

		A => reg2,
		B => temp,
--		clk => clk,
		sel => sel3,
		C => out_mux3);


deneme2: process(D)

begin

reg3 <= D(51 downto 0) & "00";
enable <= '1';

end process;

main_proc: process(clk)

begin

if(clk'event and clk = '1') then

case state is 

when s0 =>
exponent <= 2046 - D(62 downto 52);
out_rom2 <= out_rom & x"00000000" & "00"   ;
out_om2 <=  out_om & x"00000000" & "00"  ;
--out_om2 <=  x"00000000" & "00" & out_om   ;
sel1 <= "11";
sel2 <= '0';
state <= s1;

when s1 =>

out_mult <= out_mux1*out_mux2;
state <= s2;

when s2 =>

reg1 <= out_mult(107 downto 54);
reg2 <= out_mult(107 downto 54);
sel1 <= "01";
sel2 <= '1';
sel3 <= '0';
state <= s3;

when s3 =>

out_mult <= out_mux1*out_mux2;
state <= s4;

when s4 =>
temp <= 2 - out_mult(107 downto 54);
--temp <= 2 + std_logic_vector(unsigned(not(out_mult(107 downto 54))) + 1);
sel3 <= '1';
sel2 <= '1';
sel1 <= "00";
state <= s5;


when s5 =>

out_mult <= out_mux1*out_mux2;
counter <= counter + 1;

state <= s6;

when s6 =>

if(counter < 2) then
reg1 <= out_mult(107 downto 54);
reg2 <= out_mult(107 downto 54);
sel1 <= "01";
sel2 <= '1';
sel3 <= '0';
state <= s3;

elsif(out_mult(107) = '0' and out_mult(106) = '1') then
final_man <= out_mult(105 downto 54);
state <= s7;

elsif(out_mult(107) = '1') then

final_man <= out_mult(106 downto 55);
exponent <= exponent -1;
state <= s7;

elsif(out_mult(107) = '0' and out_mult(106) = '0') then

out_mult <= out_mult(106 downto 0) & '0';
exponent <= exponent -1;
state <= s6;

end if;


when s7 =>

data_out(63) <= D(63);
data_out(62 downto 52) <= exponent;
data_out(51 downto 0) <= final_man;

end case;

end if;

end process;

end architecture;