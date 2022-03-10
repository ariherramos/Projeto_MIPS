library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
	port(
		clk : in std_logic;
		rst : in std_logic
	);
end entity mips;

architecture RTL of mips is
	component pc is
		port(
			clk     : in  std_logic;
			rst     : in  std_logic;
			load    : in  std_logic;
			inc     : in  std_logic;
			data_in : in  std_logic_vector(31 downto 0);
			data    : out std_logic_vector(31 downto 0)
		);
	end component pc;

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

	component banco_reg_32_generate is
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
	end component banco_reg_32_generate;

	component ula is
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
	end component ula;

	component mux is
		port(
			mux_in_0 : in  std_logic_vector(31 downto 0);
			mux_in_1 : in  std_logic_vector(31 downto 0);
			mux_sel  : in  std_logic;
			mux_out  : out std_logic_vector(31 downto 0)
		);
	end component mux;

	component mux_r is
		port(
			mux_in_0 : in  std_logic_vector(4 downto 0);
			mux_in_1 : in  std_logic_vector(4 downto 0);
			mux_sel  : in  std_logic;
			mux_out  : out std_logic_vector(4 downto 0)
		);
	end component mux_r;

	component extensao_a is
		port(
			shamt    : in  std_logic_vector(4 downto 0);
			funct    : in  std_logic_vector(5 downto 0);
			ex_out_a : out std_logic_vector(31 downto 0)
		);
	end component extensao_a;

	component extensao_b is
		port(
			shamt    : in  std_logic_vector(4 downto 0);
			ex_out_b : out std_logic_vector(31 downto 0)
		);
	end component extensao_b;

	component concat is
		port(
			pc_data     : in  std_logic_vector(31 downto 0);
			pseudo_data : in  std_logic_vector(25 downto 0);
			c_out       : out std_logic_vector(31 downto 0)
		);
	end component concat;

	component branch is
		port(
			pc_data : in  std_logic_vector(31 downto 0);
			address : in  std_logic_vector(15 downto 0);
			b_add   : out std_logic_vector(31 downto 0)
		);
	end component branch;

	--Sinais de controle

	signal pc_load   : std_logic;
	signal pc_inc    : std_logic;
	signal rom_en    : std_logic;
	signal ir_load   : std_logic;
	signal ir_opcode : std_logic_vector(5 downto 0);
	signal ir_funct  : std_logic_vector(5 downto 0);
	signal br_p_w    : std_logic;
	signal ulaop     : std_logic_vector(5 downto 0);
	signal ula_equal : std_vector;
	signal ula_less  : std_vector;
	signal mux_d_sel : std_logic;
	signal mux_e_sel : std_logic;
	signal mux_r_sel : std_logic;
	signal mux_c_sel : std_logic;
	signal mux_a_sel : std_logic;
	signal halt_sig  : std_logic;

	--Sinais de entrada e saida
	signal pc_data           : std_logic_vector(31 downto 0);
	signal rom_data_out      : std_logic_vector(31 downto 0);
	signal ir_rs             : std_logic_vector(4 downto 0);
	signal ir_rt             : std_logic_vector(4 downto 0);
	signal ir_rd             : std_logic_vector(4 downto 0);
	signal ir_shamt          : std_logic_vector(4 downto 0);
	--signal ir_funct  : std_logic_vector(5 downto 0);
	signal ir_address        : std_logic_vector(15 downto 0);
	signal ir_pseudo_address : std_logic_vector(25 downto 0);
	signal ex_out_a          : std_logic_vector(31 downto 0);
	signal ex_out_b          : std_logic_vector(31 downto 0);
	signal br_outa           : std_logic_vector(31 downto 0);
	signal br_outb           : std_logic_vector(31 downto 0);
	signal out_lsb           : std_logic_vector(31 downto 0);
	signal mux_d_out         : std_logic_vector(31 downto 0);
	signal mux_e_out         : std_logic_vector(31 downto 0);
	signal mux_r_out         : std_logic_vector(4 downto 0);
	signal mux_c_out         : std_logic_vector(31 downto 0);
	signal mux_a_out         : std_logic_vector(31 downto 0);
	signal out_io            : std_logic_vector(31 downto 0);
	signal c_out             : std_logic_vector(31 downto 0);
	signal b_add             : std_logic_vector(31 downto 0);
begin

	pc_0 : pc
		port map(
			clk     => clk,
			rst     => rst,
			load    => pc_load,
			inc     => pc_inc,
			data_in => mux_a_out,
			data    => pc_data
		);

	rom_0 : rom
		port map(
			clk      => clk,
			en       => rom_en,
			rd_addr  => pc_data,
			data_out => rom_data_out
		);

	ir_0 : ir
		port map(
			clk            => clk,
			load           => ir_load,
			clear          => rst,
			data           => rom_data_out,
			opcode         => ir_opcode,
			rs             => ir_rs,
			rt             => ir_rt,
			rd             => ir_rd,
			shamt          => ir_shamt,
			funct          => ir_funct,
			address        => ir_address,
			pseudo_address => ir_pseudo_address
		);

	br_0 : banco_reg_32_generate
		port map(
			clk      => clk,
			rst      => rst,
			pa_add   => ir_rs,
			pb_add   => ir_rt,
			p_w      => br_p_w,
			p_w_add  => mux_r_out,
			p_w_data => mux_c_out,
			outa     => br_outa,
			outb     => br_outb
		);

	ula_0 : ula
		port map(
			clk     => clk,
			rst     => rst,
			dataa   => mux_d_out,
			datab   => mux_e_out,
			ulaop   => ulaop,
			equal   => ula_equal,
			less    => ula_less,
			out_lsb => out_lsb
		);

	mux_d : mux
		port map(
			mux_in_0 => br_outa,
			mux_in_1 => ex_out_b,
			mux_sel  => mux_d_sel,
			mux_out  => mux_d_out
		);

	mux_e : mux
		port map(
			mux_in_0 => br_outb,
			mux_in_1 => ex_out_a,
			mux_sel  => mux_e_sel,
			mux_out  => mux_e_out
		);

	mux_c : mux
		port map(
			mux_in_0 => out_lsb,
			mux_in_1 => out_io,
			mux_sel  => mux_c_sel,
			mux_out  => mux_c_out
		);

	mux_a : mux
		port map(
			mux_in_0 => c_out,
			mux_in_1 => b_add,
			mux_sel  => mux_a_sel,
			mux_out  => mux_a_out
		);

	r_mux : mux_r
		port map(
			mux_in_0 => ir_rt,
			mux_in_1 => ir_rd,
			mux_sel  => mux_r_sel,
			mux_out  => mux_r_out
		);

	ex_a : extensao_a
		port map(
			shamt    => ir_shamt,
			funct    => ir_funct,
			ex_out_a => ex_out_a
		);

	ex_b : extensao_b
		port map(
			shamt    => ir_shamt,
			ex_out_b => ex_out_b
		);

	con : concat
		port map(
			pc_data     => pc_data,
			pseudo_data => ir_pseudo_address,
			c_out       => c_out
		);

	bc : branch
		port map(
			pc_data => pc_data,
			address => ir_address,
			b_add   => b_add
		);
end architecture RTL;
