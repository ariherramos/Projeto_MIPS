library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extensao_a is
	port(
		shamt    : in  std_logic_vector(4 downto 0);
		funct    : in  std_logic_vector(5 downto 0);
		ex_out_a : out std_logic_vector(31 downto 0)
	);
end entity extensao_a;

architecture RTL of extensao_a is

begin
	extend <= "000000000000000000000" & shamt & funct when shamt(4) = '0'else        --positivo
			  "111111111111111111111" & shamt & funct when shamt(4) = '1';           --negativo

end architecture RTL;
