library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
	port(
		clk       : in  std_logic;
		rst       : in  std_logic;
		ir_opcode : in  std_logic_vector(5 downto 0);
		ir_funct  : in  std_logic_vector(5 downto 0);
		ula_equal : in  std_vector;
		ula_less  : in  std_vector;
		pc_load   : out std_logic;
		pc_inc    : out std_logic;
		rom_en    : out std_logic;
		ir_load   : out std_logic;
		br_p_w    : out std_logic;
		ulaop     : out std_logic_vector(5 downto 0);
		mux_d_sel : out std_logic;
		mux_e_sel : out std_logic;
		mux_r_sel : out std_logic;
		mux_c_sel : out std_logic;
		mux_a_sel : out std_logic;
		halt_sig  : out std_logic       --sinal que está tudo suspenso
	);
end entity fsm;

architecture RTL of fsm is
	type state_type is (FETCH, RI, DECODIFICADOR, LI, LI_MEN, FUNC_R, R_MEN, HALT);
	signal state : state_type;
begin

	process(clk, rst)
	begin
		if rst = '1' then
			state <= FETCH;
		elsif rising_edge(clk) then
			case state is
				when FETCH =>
					state <= RI;

				when RI =>
					state <= DECODIFICADOR;

				when DECODIFICADOR =>
					if ir_opcode = "001001" then
						state <= LI;
					elsif ir_opcode = "000000" then
						if ir_funct = "001101" then
							state <= HALT;
						else
							state <= FUNC_R;
						end if;
					end if;

				when LI =>
					state <= LI_MEN;

				when LI_MEN =>
					state <= FETCH;

				when FUNC_R =>
					state <= R_MEN;

				when R_MEN =>
					state <= FETCH;

				when HALT =>
					state <= HALT;

			end case;
		end if;
	end process;

	process(state_fsm)
	begin
		case state_fsm is
			when FETCH =>
				pc_load   <= '0';
				pc_inc    <= '0';
				ir_load   <= '0';
				br_p_w    <= '0';
				ulaop     <= "000000";
				mux_d_sel <= '0';
				mux_e_sel <= '0';
				mux_r_sel <= '0';
				mux_c_sel <= '0';
				mux_a_sel <= '0';

				rom_en <= '1';

			when RI =>
				ir_load <= '1';

			when DECODIFICADOR =>
				mux_d_sel <= '0';
				mux_e_sel <= '0';
				mux_r_sel <= '0';
				mux_c_sel <= '0';
				mux_a_sel <= '0';

			when LI =>
				mux_e_sel <= '1';
				ulaop     <= ir_opcode;

			when LI_MEN =>
				mux_r_sel <= '1';
				br_p_w    <= '1';
				pc_inc    <= '1';

			when FUNC_R =>
				if ir_funct = "000000" or ir_funct = "000010" then
					mux_d_sel <= '1';
				end if;
				ulaop <= ir_funct;

			when R_MEN =>
				mux_r_sel <= '1';
				br_p_w    <= '1';
				pc_inc    <= '1';

			when HALT =>
				halt_sig <= '1';

		end case;
	end process;

end architecture RTL;
