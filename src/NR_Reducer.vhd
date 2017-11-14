library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nr_reducer is
    port (
        x: in std_logic_vector (15 downto 0);
        m: in std_logic_vector(7 downto 0);
        clk, reset, start: in std_logic; 
        z: out std_logic_vector (7 downto 0);
        done: out std_logic
    );
end nr_reducer;

architecture rtl of nr_reducer is

    constant N: natural := 15; --number of bits of x
    constant K: natural := 8;  --number of bits of m
    constant COUNTER_SIZE: natural := 4; -- bigger than log2(N-K-1)
    constant ZERO: std_logic_vector(counter_size-1 downto 0) := (others => '0');
    
    signal s: std_logic_vector(N+1 downto 0);
    signal r: std_logic_vector(N downto 0);
    signal minus_m, w: std_logic_vector(K downto 0);
    signal not_m, z_i: std_logic_vector(K-1 downto 0);
    signal load, update, equal_zero: std_logic;
    signal count: std_logic_vector(counter_size -1 downto 0);
    type states is range 0 to 3;
    signal current_state: states;

begin

    r(N downto N-K) <= s(N downto N-K) + w;
    r(N-K-1 downto 0) <= s(N-K-1 downto 0) ;

    with r(N) select z <= 
        r(N-1 downto N-K) when '0',
        r(N-1 downto N-K)+ m when others;

    registers: process(clk)
    begin
        if clk'event and clk = '1' then
            if load = '1' then 
                s <= x(n) & x; --sign extension 
            elsif update = '1' then 
                s <= r(N downto 0) & '0';
            end if;
        end if;
    end process registers;

    counter: process(clk)
    begin
        if clk'event and clk = '1' then
            if load = '1' then 
                count <= conv_std_logic_vector(N-K-1, counter_size);
            elsif update = '1' then 
                count <= count-1; 
            end if;
        end if;
    end process counter;

    with count select equal_zero <= 
        '1' when ZERO, 
        '0' when others;

    minus_m <= ('1'&not(m)) + 1; --Two´s complement of m
    with s(N+1) select w <= 
        minus_m when '0', 
        ('0'&m) when others;

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
        elsif clk'event and clk = '1' then
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
