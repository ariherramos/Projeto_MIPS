library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(
		clk     : in  std_logic;
		rst     : in  std_logic;
		load    : in  std_logic;
		inc     : in  std_logic;
		data_in : in  std_logic_vector(31 downto 0);
		data    : out std_logic_vector(31 downto 0)
	);
end entity pc;

architecture RTL of pc is

begin

	process (clk, rst)
		variable count : std_logic_vector(31 downto 0) := (others => '0');
	begin
		if rst = '0' then
			data <= (data'range => '0');
			count := (count'range => '0');
		elsif rising_edge(clk) then
			if load = '1' then
				data <= data_in;
				count := data_in;
			elsif load = '0' AND inc = '1' then
				count := std_logic_vector(signed(count) + 1);
				data <= count;
			end if;
		end if;
	end process;

end architecture RTL;
