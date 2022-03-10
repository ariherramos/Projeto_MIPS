library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port(
		clk     : in  std_logic;
		rst     : in  std_logic;
		dataa   : in  std_logic_vector(31 downto 0);
		datab   : in  std_logic_vector(31 downto 0);
		ulaop   : in  std_logic_vector(5 downto 0);
		equal   : out std_logic;
		less    : out std_logic;
		out_lsb : out std_logic_vector(31 downto 0)
	);
end entity ula;

architecture RTL of ula is
	signal lo : std_logic_vector(31 downto 0);
	signal hi : std_logic_vector(31 downto 0);
begin
	
	process(clk, rst)
		variable product : std_logic_vector(63 downto 0);
	begin
		if rst = '0' then
			lo    <= (lo'range => '0');
			hi    <= (hi'range => '0');
			equal <= '0';
			less  <= '0';
		elsif rising_edge(clk) then
			case ulaop is
				when "100000" =>        --add
					lo <= std_logic_vector(signed(dataa) + signed(datab));

				when "011000" =>        --mult
					product := std_logic_vector(signed(dataa) * signed(datab));
					lo      <= product(31 downto 0);
					hi      <= product(63 downto 32);

				when "100100" =>        --and
					lo <= dataa and datab;

				when "100101" =>        --or
					lo <= dataa or datab;

				when "100110" =>        --xor
					lo <= dataa xor datab;

				when "100111" =>        --nor
					lo <= NOT dataa;

				when "000000" =>        --sll
					lo <= std_logic_vector(shift_left(unsigned(datab), to_integer(unsigned(dataa))));

				when "000010" =>        --srl
					lo <= std_logic_vector(shift_right(unsigned(datab), to_integer(unsigned(dataa))));

				when "001001" =>        --li
					lo <= datab;

				when "000111" =>          --bgtz_blez
					if dataa < datab then
						less <= '1';
					else
						less <= '0';
					end if;

				when "000100" =>          --bne_beq
					if dataa = datab then
						equal <= '1';
					else
						equal <= '0';
					end if;

				when "001101" =>          --break
					lo    <= (lo'range => '0');
					hi    <= (hi'range => '0');
					equal <= '0';
					less  <= '0';

				when others =>
					null;
			end case;
		end if;
	end process;
	
	out_lsb <= lo;
	
end architecture RTL;
