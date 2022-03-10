library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity concat is
	port(
		pc_data    : in  std_logic_vector(31 downto 0);
		pseudo_data : in  std_logic_vector(25 downto 0);
		c_out       : out std_logic_vector(31 downto 0)
	);
end entity concat;

architecture RTL of concat is
begin
	
	c_out<=pc_data(31 downto 26) & pseudo_data;
	
end architecture RTL;
