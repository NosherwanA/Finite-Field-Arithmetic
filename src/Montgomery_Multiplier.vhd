----------------------------------------------------------------------------
-- Montgomery Multiplier (Montgomery_multiplier.vhd)
--
-- Implements x.y/R mod M
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
--package Montgomery_multiplier_parameters is
  --constant K: integer := 8;
  --constant logK: integer := 3;
  --constant int_M: integer := 239;
  --constant M: std_logic_vector(K-1 downto 0) := conv_std_logic_vector(int_m, K);
  --constant minus_M: std_logic_vector(K downto 0) := conv_std_logic_vector(2**K - int_M, K+1);
  --constant ZERO: std_logic_vector(logK-1 downto 0) := (others => '0');
--end Montgomery_multiplier_parameters;


--library ieee; 
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
--use work.Montgomery_multiplier_parameters.all;
entity Montgomery_multiplier is

	generic(
		K   				: integer;
		logK				: integer
	);
	port (
		x					: in std_logic_vector(K-1 downto 0);
		y					: in std_logic_vector(K-1 downto 0);
		M					: in std_logic_vector(K-1 downto 0);
		clk				: in std_logic;
		reset				: in std_logic;
		start				: in std_logic;
		z					: out std_logic_vector(K-1 downto 0);
		done				: out std_logic
	);
	
end Montgomery_multiplier;

architecture rtl of Montgomery_multiplier is
	
	signal p, pc, ps, y_by_xi, next_pc, next_ps, 
         half_ac, half_as, half_bc, half_bs, p_minus_m: std_logic_vector(K downto 0);
	signal ac, as, bc, bs, long_m: std_logic_vector(K+1 downto 0);
	signal int_x: std_logic_vector(K-1 downto 0);
	signal xi, load, ce_p, equal_zero: std_logic;
	type states is range 0 to 3;
	signal current_state: states;
	signal count: std_logic_vector(logK-1 downto 0);
	signal minus_M: std_logic_vector(K+1 downto 0);
	signal ZERO: std_logic_vector(logK-1 downto 0) := (others => '0');
	
	signal int_M: integer;
	signal temp: integer;
	signal kplus1: integer;
	signal kminus1: integer;
	signal countminus1: integer;
	
begin
	
	int_M <= to_integer(unsigned(M));
	temp <= ((2**K) - int_M);
	kplus1 <= (K+1);
	kminus1 <= (K-1);
	
	minus_M <= std_logic_vector(to_unsigned(temp,kplus1));
	--minus_M <= std_logic_vector((2**K - (to_integer(unsigned(M)))), K+1);
	--ZERO std_logic_vector(logK-1 downto 0) := (others => '0');

	and_gates: for i in 0 to K-1 generate y_by_xi(i) <= y(i) and xi; end generate;
	y_by_xi(K) <= '0';

	first_csa: for i in 0 to K generate
		as(i) <= pc(i) xor ps(i) xor y_by_xi(i);
		ac(i+1) <= (pc(i) and ps(i)) or (pc(i) and y_by_xi(i)) or (ps(i) and y_by_xi(i));
	end generate;
	
	ac(0) <= '0';
	as(K+1) <= '0';
	long_m <= "00"&M;
	
	second_csa: for i in 0 to K generate
		bs(i) <= ac(i) xor as(i) xor long_m(i);
		bc(i+1) <= (ac(i) and as(i)) or (ac(i) and long_m(i)) or (as(i) and long_m(i));
	end generate;
	
	bc(0) <= '0';
	bs(K+1) <= ac(K+1);
	half_as <= as(K+1 downto 1); half_ac <= ac(K+1 downto 1);
	half_bs <= bs(K+1 downto 1); half_bc <= bc(K+1 downto 1);

	with as(0) select next_pc <= half_ac when '0', half_bc when others;
	with as(0) select next_ps <= half_as when '0', half_bs when others;

	parallel_register: process(clk)
	begin
	if clk'event and clk = '1' then
		if load = '1' then 
			pc <= (others => '0'); ps <= (others => '0');
		elsif ce_p = '1' then 
			pc <= next_pc; ps <= next_ps; 
		end if;
	end if;
	end process parallel_register;

	equal_zero <= '1' when count = zero else '0';

	p <= std_logic_vector(unsigned(ps) + unsigned(pc));
	p_minus_m <= std_logic_vector(unsigned(p) + unsigned(minus_m));
	with p_minus_m(K) select z <= p(K-1 downto 0) when '0', p_minus_m(K-1 downto 0) when others;

	shift_register: process(clk)
	begin
	if clk'event and clk = '1' then
		if load = '1' then 
			int_x <= x;
		elsif ce_p = '1' then
			for i in 0 to K-2 loop int_x(i) <= int_x(i+1); end loop;
			int_x(K-1) <= '0';
		end if;
	end if;
	end process shift_register;

	xi <= int_x(0);

	counter: process(clk)
	begin
	if clk'event and clk = '1' then
		if load = '1' then 
			count <= std_logic_vector(to_unsigned(kminus1, logK));
		elsif ce_p= '1' then 
			countminus1 <= (to_integer(unsigned(count)) - 1);
			count <= std_logic_vector(to_unsigned(countminus1, logK));
		end if;
	end if;
	end process;

	control_unit: process(clk, reset, current_state)
	begin
	case current_state is
		when 0 to 1 => ce_p <= '0'; load <= '0'; done <= '1';
		when 2 => ce_p <= '0'; load <= '1'; done <= '0';
		when 3 => ce_p <= '1'; load <= '0'; done <= '0';
	end case;

	if reset = '1' then
		current_state <= 0;
	elsif clk'event and clk = '1' then
		case current_state is
			when 0 => if start = '0' then current_state <= 1; end if;
			when 1 => if start = '1' then current_state <= 2; end if;
			when 2 => current_state <= 3;
			when 3 => if equal_zero = '1' then current_state <= 0; end if;
		end case;
	end if;
	end process;

end rtl;
