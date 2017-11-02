----------------------------------------------------------------------------
-- Montgomery Exponenciator (Montgomery_esponenciator_msb.vhd)
--
-- Implements x.y/R mod M
-- adds a timeout signal when result is available
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package Montgomery_exponentiator_parameters is
  --constant K: integer := 8;
  --constant logK: integer := 3;
  --constant M: std_logic_vector(K-1 downto 0) := X"ef"; --239d
  --minus_m = 2**k - m
  --constant minus_M: std_logic_vector(K downto 0) := '0' & X"F1";
  --constant one: std_logic_vector(K-1 downto 0) := conv_std_logic_vector(1, K);
  --exp_k = 2**k mod m
  --constant exp_K: std_logic_vector(K-1 downto 0) := X"11"; --17d
  --exp_2k = 2**(2*k) mod m
  --constant exp_2K: std_logic_vector(K-1 downto 0) := X"32"; --50d

--  constant k: integer := 192;
--  constant logk: integer := 8;
--  constant m: std_logic_vector(k-1 downto 0) := X"fffffffffffffffffffffffffffffffeffffffffffffffff"; 
--  --minus_m = 2**k - m
--  constant minus_m: std_logic_vector(k downto 0) := '0'&X"000000000000000000000000000000010000000000000001";
--  constant one: std_logic_vector(k-1 downto 0) := conv_std_logic_vector(1, k);
--  --exp_k = 2**k mod m
--  constant exp_k: std_logic_vector(k-1 downto 0) := X"000000000000000000000000000000010000000000000001";
--  --exp_2k = 2**(2*k) mod m
--  constant exp_2k: std_logic_vector(k-1 downto 0) := X"000000000000000100000000000000020000000000000001";
end Montgomery_exponentiator_parameters;


library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.Montgomery_exponentiator_parameters.all;
entity Montgomery_exponentiator_lsb is
generic(
    k   : integer;
    logk: integer
);
port (
  x, y, M: in std_logic_vector(k-1 downto 0);
  clk, reset, start: in std_logic;
  z: out std_logic_vector(k-1 downto 0);  
  done: out std_logic
);
end Montgomery_exponentiator_lsb;

architecture rtl of Montgomery_exponentiator_lsb is

signal second, operand1, operand2, next_e, next_y, e, ty, int_x: std_logic_vector(k-1 downto 0);
signal start_mp1, start_mp2, mp1_done, mp2_done, mp_done, ce_e, ce_ty, load, update, xi, equal_zero, first, last: std_logic;


type states is range 0 to 15;
signal current_state: states;
signal count: std_logic_vector(logk-1 downto 0);

component Montgomery_multiplier_modif is
port (
  x, y: in std_logic_vector(k-1 downto 0);
  clk, reset, start: in std_logic;
  z: out std_logic_vector(k-1 downto 0);
  done: out std_logic
);
end component;


begin

  with last select second <= ty when '0', one when others;
  with first select operand1 <= y when '1', ty when others;
  with first select operand2 <= exp_2k when '1', ty when others;

  main_component1: Montgomery_multiplier_modif port map(x => e, y => second, clk => clk, 
  reset=> reset, start => start_mp1, z => next_e, done => mp1_done);

  main_component2: Montgomery_multiplier_modif port map(x => operand1, y => operand2, clk => clk, 
  reset=> reset, start => start_mp2, z => next_y, done => mp2_done);

  mp_done <= mp1_done and mp2_done;
  z <= next_e;

  register_e: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' then 
      e <= (2**k mod m); 
    elsif ce_e = '1' then 
      e <= next_e; 
    end if;
  end if;
  end process register_e;

  register_ty: process(clk)
  begin
  if clk'event and clk = '1' then
  if ce_ty = '1' then ty <= next_y; 
  end if;
  end if;
  end process register_ty;


  shift_register: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' then 
      int_x <= x;
    elsif update = '1' then
      int_x <= '0'&int_x(K-1 downto 1);
    end if;
  end if;
  end process shift_register;

  xi <= int_x(0);

  counter: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' then 
      count <= conv_std_logic_vector(K, logK);
    elsif update= '1' then 
      count <= count - 1;
    end if;
    end if;
  end process;
  equal_zero <= '1' when count = 0 else '0';

  control_unit: process(clk, reset, current_state)
  begin
  case current_state is
    when 0 to 1 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '1';
    when 2 => ce_e <= '0'; ce_ty <= '0'; load <= '1'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '1';
    when 3 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '1'; first <= '1'; last <= '0'; done <= '0';
    when 4 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '1'; last <= '0'; done <= '0';
    when 5 => ce_e <= '0'; ce_ty <= '1'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '1'; last <= '0'; done <= '0';
    when 6 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '1'; first <= '0'; last <= '0'; done <= '0';
    when 7 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
    when 8 => ce_e <= '0'; ce_ty <= '1'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
    when 9 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '1'; start_mp2 <= '1'; first <= '0'; last <= '0'; done <= '0';
    when 10 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
    when 11 => ce_e <= '1'; ce_ty <= '1'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
    when 12 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '1'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
    when 13 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
    when 14 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '1'; start_mp2 <= '0'; first <= '0'; last <= '1'; done <= '0';
    when 15 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '1'; done <= '0';
    --when 16 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp1 <= '0'; start_mp2 <= '0'; first <= '0'; last <= '0'; done <= '0';
  end case;

  if reset = '1' then 
    current_state <= 0;
  elsif clk'event and clk = '1' then
    case current_state is
      when 0 => if start = '0' then current_state <= 1; end if;
      when 1 => if start = '1' then current_state <= 2; end if;
      when 2 => current_state <= 3;
      when 3 => current_state <= 4;
      when 4 => if mp2_done= '1' then current_state <= 5; end if;
      when 5 => if xi = '0' then current_state <= 6; else current_state <= 9; end if;
      when 6 => current_state <= 7;
      when 7 => if mp2_done = '1' then current_state <= 8; end if;
      when 8 => current_state <= 12;
      when 9 => current_state <= 10;
      when 10 => if mp_done= '1' then current_state <= 11; end if;
      when 11 => current_state <= 12;
      when 12 => current_state <= 13;
      when 13 => if equal_zero = '1' then current_state <= 14; 
                 elsif xi = '0' then current_state <= 6; 
                 else current_state <= 9; 
                 end if;
      when 14 => current_state <= 15;
      when 15 => if mp_done= '1' then current_state <= 0; end if;
      --when 16 => current_state <= 0;
    end case;
  end if;
  end process;

end rtl;
