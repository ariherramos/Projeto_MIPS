library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extensao_b is
	port(
		shamt    : in  std_logic_vector(4 downto 0);
		ex_out_b : out std_logic_vector(31 downto 0)
	);
end entity extensao_b;

architecture RTL of extensao_b is
	
begin
	ex_out_b <= "000000000000000000000000000" & shamt;
end architecture RTL;
