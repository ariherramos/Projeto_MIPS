library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_r is
	port(
		mux_in_0 : in  std_logic_vector(4 downto 0);
		mux_in_1 : in  std_logic_vector(4 downto 0);
		mux_sel  : in  std_logic;
		mux_out  : out std_logic_vector(4 downto 0)
	);
end entity mux_r;

architecture RTL of mux_r is
	
begin
	Sel : with mux_sel select 
	mux_out <=	mux_in_0 when '0',
				mux_in_1 when '1',
				(mux_out'range => 'Z') when others;
end architecture RTL;
