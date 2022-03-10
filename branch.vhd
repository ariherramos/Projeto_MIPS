library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch is
	port(
		pc_data : in  std_logic_vector(31 downto 0);
		address : in  std_logic_vector(15 downto 0);
		b_add   : out std_logic_vector(31 downto 0)
	);
end entity branch;

architecture RTL of branch is
begin
	process(address)
		variable aux : std_logic_vector(31 downto 0);
	begin
		aux       := "0000000000000000" & address;
		branchout <= std_logic_vector(signed(aux) + signed(pc_data) + 1);
	end process;
end architecture RTL;
