library ieee;
use ieee.std_logic_1164.all;

entity reg32 is
	port(
		clk     : in  std_logic;
		clear  : in  std_logic;
		w_flag : in  std_logic;
		datain  : in  std_logic_vector(31 downto 0);
		reg_out : out std_logic_vector(31 downto 0)
	);
end entity reg32;

architecture RTL of reg32 is

begin
	process(clear, clk)
	begin
		if clear = '0' then
			reg_out <= (others => '0');
		elsif rising_edge(clk) then
			if w_flag = '1' then
				reg_out <= datain;
			end if;
		end if;
	end process;

end architecture RTL;
