library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir is
	port(
		clk			   : in  std_logic;
		load           : in  std_logic;
		clear          : in  std_logic;
		data           : in  std_logic_vector(31 downto 0);
		opcode         : out std_logic_vector(5 downto 0);
		rs             : out std_logic_vector(4 downto 0);
		rt             : out std_logic_vector(4 downto 0);
		--Intrução R
		rd             : out std_logic_vector(4 downto 0);
		shamt          : out std_logic_vector(4 downto 0);
		funct          : out std_logic_vector(5 downto 0);
		--Instrução I
		address        : out std_logic_vector(15 downto 0);
		--Instrução J
		pseudo_address : out std_logic_vector(25 downto 0)
	);
end entity ir;

architecture RTL of ir is

begin

	process(clk, clear, load)
		variable op_data : std_logic_vector(5 downto 0);
	begin
		if clear = '0' then
			opcode         <= (others => '0');
			rs             <= (others => '0');
			rt             <= (others => '0');
			rd             <= (others => '0');
			shamt          <= (others => '0');
			funct          <= (others => '0');
			address        <= (others => '0');
			pseudo_address <= (others => '0');
			
		elsif load = '1' then
			op_data := data(31 downto 26);
			
			if op_data = "000000" then
				opcode <= data(31 downto 26);
				rs     <= data(25 downto 21);
				rt     <= data(20 downto 16);
				rd     <= data(15 downto 11);
				shamt  <= data(10 downto 6);
				funct  <= data(5 downto 0);
			elsif op_data = "100011" or op_data = "101011" or op_data = "000100" or op_data = "000111" or op_data = "000101" then
				opcode  <= data(31 downto 26);
				rs      <= data(25 downto 21);
				rt      <= data(20 downto 16);
				address <= data(15 downto 0);
			elsif op_data = "000010" then
				opcode         <= data(31 downto 26);
				pseudo_address <= data(25 downto 0);
			end if;

		end if;
	end process;

end architecture RTL;
