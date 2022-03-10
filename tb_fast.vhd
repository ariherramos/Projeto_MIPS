library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_fast is
end entity tb_fast;

architecture RTL of tb_fast is
	component rom is
		port(
			clk      : in  std_logic;
			en       : in  std_logic;
			rd_addr  : in  std_logic_vector(31 downto 0);
			data_out : out std_logic_vector(31 downto 0)
		);
	end component rom;

	component ir is
		port(
			clk            : in  std_logic;
			load           : in  std_logic;
			clear          : in  std_logic;
			data           : in  std_logic_vector(31 downto 0);
			opcode         : out std_logic_vector(5 downto 0);
			rs             : out std_logic_vector(4 downto 0);
			rt             : out std_logic_vector(4 downto 0);
			rd             : out std_logic_vector(4 downto 0);
			shamt          : out std_logic_vector(4 downto 0);
			funct          : out std_logic_vector(5 downto 0);
			address        : out std_logic_vector(15 downto 0);
			pseudo_address : out std_logic_vector(25 downto 0)
		);
	end component ir;

	signal clk      : std_logic;
	signal en       : std_logic;
	signal rd_addr  : std_logic_vector(31 downto 0);
	signal data_out : std_logic_vector(31 downto 0);

	signal load           : std_logic;
	signal clear          : std_logic;
	signal opcode         : std_logic_vector(5 downto 0);
	signal rs             : std_logic_vector(4 downto 0);
	signal rt             : std_logic_vector(4 downto 0);
	signal rd             : std_logic_vector(4 downto 0);
	signal shamt          : std_logic_vector(4 downto 0);
	signal funct          : std_logic_vector(5 downto 0);
	signal address        : std_logic_vector(15 downto 0);
	signal pseudo_address : std_logic_vector(25 downto 0);

begin

	log : rom
		port map(
			clk      => clk,
			en       => en,
			rd_addr  => rd_addr,
			data_out => data_out
		);

	log1 : ir
		port map(
			clk            => clk,
			load           => load,
			clear          => clear,
			data           => data_out,
			opcode         => opcode,
			rs             => rs,
			rt             => rt,
			rd             => rd,
			shamt          => shamt,
			funct          => funct,
			address        => address,
			pseudo_address => pseudo_address
		);

	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;

	en      <= '1';
	rd_addr <= (rd_addr'range => '0'), (rd_addr'range => '0') + '1' after 20 ns, (rd_addr'range => '0') + x"02" after 40 ns;

	--	process
	--	begin
	--		load <= '0';
	--		wait for 10 ns;
	--		load <= '1';
	--		wait for 10 ns;
	--	end process;

	load  <= '0', '1' after 5 ns;
	clear <= '0', '1' after 5 ns;
end architecture RTL;
