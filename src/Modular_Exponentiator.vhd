library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Modular_Exponentiator is
    port(
        base            : in std_logic_vector(7 downto 0);
        exponent        : in std_logic_vector(7 downto 0);
        modulus         : in std_logic_vector(7 downto 0);
        clk             : in std_logic;
        reset           : in std_logic;
        start           : in std_logic;
        busy            : out std_logic;
        result          : out std_logic_vector(7 downto 0);
        done            : out std_logic
    );
end Modular_Exponentiator;

architecture internal of Modular_Exponentiator is 

    type State_Type is (S_RESET,
                        MULTIPLICATION,
                        INCREMENT_COUNTER,
                        IDLE,
                        COMPARE_COUNTER_ITERATIONS,
                        INITIAL_SETUP);
      

    signal curr_state       : State_Type;
    signal next_state       : State_Type;

    signal ITERATIONS       : integer:= 0;
    signal counter          : integer:= 0;
    signal count_up         : std_logic:= '0';
    signal count_clear      : std_logic:= '0';

    signal num1             : std_logic_vector(7 downto 0);
    signal num2             : std_logic_vector(7 downto 0);
    signal mm_mod           : std_logic_vector(7 downto 0);
    signal mm_result        : std_logic_vector(7 downto 0);
    signal mm_start         : std_logic;
    signal mm_reset         : std_logic;
    signal mm_busy          : std_logic;
    signal mm_done          : std_logic;

    signal temp             : std_logic_vector(7 downto 0);

    -- COMPONENTS
    component Modular_Multiplier is
        port(
            x           : in std_logic_vector(7 downto 0);
            y           : in std_logic_vector(7 downto 0);
            m           : in std_logic_vector(7 downto 0);
            result      : out std_logic_vector(7 downto 0);
            clk         : in std_logic;
            start       : in std_logic;
            reset       : in std_logic;
            done        : out std_logic;
            busy        : out std_logic
        );
    end component;



    begin

        Mod_Mult: Modular_Multiplier
            port map(
                num1,
                num2,
                mm_mod,
                mm_result,
                clk,
                mm_start,
                mm_reset,
                mm_done,
                mm_busy
            );


        Register_Section: process (clk, reset)
        begin

            if rising_edge(clk) then
                if (reset = '0') then
                    curr_state <= S_RESET;
                else
                    curr_state <= next_state;
                end if;
            end if;
        end process;

        Transition_Section: process (clk, curr_state)
        begin

            case curr_state is
                when S_RESET =>
                    mm_reset <= '0';
                    count_up <= '0';
                    num1 <= "00000000";
                    num2 <= "00000000";
                    --temp <= "00000000";
                    count_clear <= '1';

                    If (start = '1') then 
                        next_state <= INITIAL_SETUP;
                    else
                        next_state <= S_RESET;
                    end if;

                when IDLE =>
                    mm_reset <= '0';
                    count_up <= '0';
                    num1 <= "00000000";
                    num2 <= "00000000";
                    count_clear <= '1';

                    If (start = '1') then 
                        next_state <= INITIAL_SETUP;
                    else
                        next_state <= IDLE;
                    end if;

                when INITIAL_SETUP =>
                    num1 <= base;
                    num2 <= base;
                    mm_mod <= modulus;
                    count_clear <= '0';
                    ITERATIONS <= ((to_integer(unsigned(exponent))) - 1);

                    next_state <= MULTIPLICATION;

                when MULTIPLICATION =>
                    mm_reset <= '1';
                    mm_start <= '1';
                    if (mm_done = '0') then 
                        next_state <= MULTIPLICATION;
                    else 
                        temp <= mm_result;
                        next_state <= INCREMENT_COUNTER;
                    end if;

                when INCREMENT_COUNTER =>
                    mm_start <= '0';
                    mm_reset <= '0';
                    count_up <= '1';

                    next_state <= COMPARE_COUNTER_ITERATIONS;
                    
                when COMPARE_COUNTER_ITERATIONS =>
                    count_up <= '0';
                    if(counter = ITERATIONS) then 
                        next_state <= S_START;
                    else
                        num2 <= temp;
                        mm_reset <= '1';
                        next_state <= MULTIPLICATION;
                    end if;

                
                
            end case;
        
        end process;

        Decoder_Section: process (curr_state)
        begin

            case curr_state is
                when S_RESET =>
                    result <= temp;
                    busy <= '0';
                    done <= '1';

                when INITIAL_SETUP =>
                    result <= "00000000";
                    busy <= '1';
                    done <= '0';

                when MULTIPLICATION =>
                    result <= "00000000";
                    busy <= '1';
                    done <= '0';

                when INCREMENT_COUNTER =>
                    result <= "00000000";
                    busy <= '1';
                    done <= '0';
                
                when COMPARE_COUNTER_ITERATIONS =>
                    result <= "00000000";
                    busy <= '1';
                    done <= '0';

                when S_IDLE =>
                    result <= temp;
                    busy <= '0';
                    done <= '1';
                    
            end case;            

        end process;

        Counter_Section: process(clk, reset, count_up, count_clear)
        begin

            if rising_edge(clk) then
                if (reset = '0') then
                    counter <= 0;
                elsif (count_clear = '1') then
                    counter <= 0;
                elsif (count_up = '1') then
                    counter <= counter + 1;
                end if;
            end if;

        end process;
        
end architecture;
