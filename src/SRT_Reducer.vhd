----------------------------------------------------------------------------
-- SRT_Reducer 
--
-- Computes the remainder (x mod m) using the  
-- SRT division algorithm
-- Courtersy of www.arithmetic-circuits.org
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity srt_reducer is
port (
    x               : in std_logic_vector (15 downto 0); -- N downto 0
    m               : in std_logic_vector(7 downto 0); -- K-1 downto 0
    clk             : in std_logic; 
    reset           : in std_logic; 
    start           : in std_logic; 
    z               : out std_logic_vector (7 downto 0); -- K-1 downto 0
    done            : out std_logic
);

end srt_reducer;

architecture rtl of srt_reducer is

    constant N: natural := 15;
    constant K: natural := 8;
    constant COUNTER_SIZE: natural := 4;
    constant ZERO: std_logic_vector(counter_size-1 downto 0) := (others => '0');

    signal ss: std_logic_vector(N+1 downto 0);
    signal sc: std_logic_vector(N+1 downto N-K);
    signal rs: std_logic_vector(N downto 0);
    signal rc: std_logic_vector(N downto N-K+1);
    signal r, minus_m, w: std_logic_vector(K downto 0);
    signal not_m: std_logic_vector(K-1 downto 0);
    signal load, update, equal_zero: std_logic;
    signal t: std_logic_vector(2 downto 0);
    signal quotient: std_logic_vector(1 downto 0);
    signal count: std_logic_vector(COUNTER_SIZE -1 downto 0);
    type states is range 0 to 3;
    signal current_state: states;

begin

    csa: for i in N-K to N-1 generate
        rs(i) <= ss(i) xor sc(i) xor w(i-N+K);
        rc(i+1) <= (ss(i) and sc(i)) or (ss(i) and w(i-N+K)) or (sc(i) and w(i-N+K));
    end generate;

    rs(N) <= ss(N) xor sc(N) xor w(K);
    rs(N-K-1 downto 0) <= ss(N-K-1 downto 0);

    r(0) <= rs(N-K);
    r(K downto 1) <= rs(N downto N-K+1) + rc(N downto N-K+1);
    with r(K) select z <= 
        r(K-1 downto 0) when '0',
        r(K-1 downto 0) + m when others;

    registers: process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then 
                ss <= x(n) & x; sc <= (others => '0'); 
            elsif update = '1' then 
                ss(0) <= '0';
                for i in 1 to n+1 loop 
                    ss(i) <= rs(i-1); 
                end loop;
                sc(n-k) <= '0'; sc(n-k+1) <= '0';
                for i in n-k+2 to n+1 loop
                    sc(i) <= rc(i-1); 
                end loop; 
            end if;
        end if;
    end process registers;

    counter: process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then 
                count <= conv_std_logic_vector(N-K-1, COUNTER_SIZE);
            elsif update = '1' then 
                count <= count-1; 
            end if;
        end if;
    end process counter;

    with count select equal_zero <= 
        '1' when zero,
        '0' when others;

    t <= ss(n+1 downto n-1) + sc(n+1 downto n-1);
    quotient(1) <= t(2) xor (t(1) and t(0)); 
    quotient(0) <= not(t(2) and t(1) and t(0));

    not_gates: for i in 0 to k-1 generate 
        not_m(i) <= not(m(i)); 
    end generate;

    minus_m <= ('1'&not_m) +1;

    with quotient select w <= 
        minus_m when "01", 
        ('0' & m) when "11", 
        (others => '0') when others;

    control_unit: process(clk, reset, current_state, equal_zero)
    begin
        case current_state is
            when 0 to 1 => 
                load <= '0'; 
                update <= '0'; 
                done <= '1';
            when 2 => 
                load <= '1'; 
                update <= '0'; 
                done <= '0';
            when 3 => 
                load <= '0'; 
                update <= '1'; 
                done <= '0';
        end case;

        if reset = '1' then 

            current_state <= 0;

        elsif rising_edge(clk) then
        
            case current_state is
                when 0 => 
                    if start = '1' then 
                        current_state <= 1; 
                    end if;
                when 1 => 
                    if start = '0' then 
                        current_state <= 2; 
                    end if;
                when 2 => 
                    current_state <= 3;
                when 3 => 
                    if equal_zero = '1' then 
                        current_state <= 0; 
                    end if;
            end case;

        end if;
    end process;

end rtl;
