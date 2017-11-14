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

    type State_Type is (S0, S1, S2, S3);
    -- S0 - Start and reset state
    -- S1 - Load in the data to 8 bit registers
    -- S2 - Compute result
    -- S3 - Display result     

    signal curr_state       : State_Type;
    signal next_state       : State_Type;

    signal mult_result_d    : std_logic_vector(7 downto 0);
    signal mult_result_ld   : std_logic;
    signal mult_result_q    : std_logic_vector(7 downto 0);

    signal base_d    : std_logic_vector(7 downto 0);
    signal base_ld   : std_logic;
    signal base_q    : std_logic_vector(7 downto 0);

    signal exponent_d    : std_logic_vector(7 downto 0);
    signal exponent_ld   : std_logic;
    signal exponent_q    : std_logic_vector(7 downto 0);

    signal modulus_d    : std_logic_vector(7 downto 0);
    signal modulus_ld   : std_logic;
    signal modulus_q    : std_logic_vector(7 downto 0);

    signal data_loaded  : std_logic := '0'; 


    -- COMPONENTS
    component register8 IS PORT(
        d   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        ld  : IN STD_LOGIC; -- load/enable.
        clr : IN STD_LOGIC; -- async. clear.
        clk : IN STD_LOGIC; -- clock.
        q   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- output
    );
    END component;

    begin

        mult_result: register8 
            port map(
                mult_result_d,
                mult_result_ld,
                reset,
                clk,
                mult_result_q
            );
        base: register8
            port map(
                base_d,
                base_ld,
                reset,
                clk,
                base_q
            );
        
        exponent: register8
            port map(
                exponent_d,
                exponent_ld,
                reset,
                clk,
                exponent_q
            );

        modulus: register8
            port map(
                modulus_d,
                modulus_ld,
                reset,
                clk,
                modulus_q
            );

        Register_Section: process (clk, reset)
        begin
            
            if (reset = '0') then
                curr_state <= S0;
            elsif (rising_edge(clk)) then
                curr_state <= next_state;
            else
                curr_state <= curr_state;
            end if;

        end process;

        Transition_Section: process (curr_state)
        begin

            case curr_state is
                when S0 =>
                    If (start = '1') then 
                        next_state <= S1;
                        mult_result_ld = '1';
                        base_ld <= '1';
                        exponent_ld <= '1';
                        modulus_ld <= '1';
                    else
                        next_state <= S0;
                    end if;
                when S1 =>
                    mult_result_q <= base;
                    base_q <= base;
                    exponent_q <= exponent;
                    modulus_q <= modulus;

                    mult_result_ld = '0';
                    base_ld <= '0';
                    exponent_ld <= '0';
                    modulus_ld <= '0';

                    next_state <= S2;

                when S2 =>

                when S3 =>
                    if (reset = '0') then

                        mult_result_ld = '1';
                        base_ld <= '1';
                        exponent_ld <= '1';
                        modulus_ld <= '1';

                        mult_result_q <= "00000000";
                        base_q <= "00000000";
                        exponent_q <= "00000000";
                        modulus_q <= "00000000";

                        next_state <= S0;
                    else
                        next_state <= S3;
                    end if;

            end case;
        
        end process;

        Decoder_Section: process (curr_state)
        begin

            case curr_state is
                when S0 =>
                    busy <= '0';
                    done <= '0';
                when S1 =>
                    busy <= '1';
                    done <= '0';
                when S2 =>
                    busy <= '1';
                    done <= '0';
                when S3 =>
                    busy <= '0';
                    done <= '1';
            end case;            

        end process;
        
end architecture;