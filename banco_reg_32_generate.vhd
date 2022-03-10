library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_32_generate is
	port(
		clk      : in  std_logic;
		rst      : in  std_logic;
		pa_add   : in  std_logic_vector(4 downto 0);
		pb_add   : in  std_logic_vector(4 downto 0);
		p_w      : in  std_logic;
		p_w_add  : in  std_logic_vector(4 downto 0);
		p_w_data : in  std_logic_vector(31 downto 0);
		outa     : out std_logic_vector(31 downto 0);
		outb     : out std_logic_vector(31 downto 0)
	);
end entity banco_reg_32_generate;

architecture RTL of banco_reg_32_generate is

	component reg_32 is
		port(
			clk     : in  std_logic;
			sclr_n  : in  std_logic;
			clk_ena : in  std_logic;
			datain  : in  std_logic_vector(31 downto 0);
			reg_out : out std_logic_vector(31 downto 0)
		);
	end component reg_32;

	type reg_array is array (integer range 0 to 31) of std_logic_vector(31 downto 0);
	signal reg_out : reg_array;

	type en_array is array (integer range 0 to 31) of std_logic;
	signal en_reg : en_array;

	type in_array is array (integer range 0 to 31) of std_logic_vector(31 downto 0);
	signal reg_in : in_array;

begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			outa <= reg_out(to_integer(unsigned(pa_add)));
		end if;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			outb <= reg_out(to_integer(unsigned(pb_add)));
		end if;
	end process;

	
	en_reg(to_integer(unsigned(p_w_add))) <= p_w;
	reg_in(to_integer(unsigned(p_w_add))) <= p_w_data;

	reg : for i in 0 to 31 generate
		reg : reg_32
			port map(
				clk,
				rst,
				en_reg(i),
				reg_in(i),
				reg_out(i)
			);
	end generate reg;

end architecture RTL;
