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

    type State_Type is (A, B, C, D);
      

    signal curr_state       : State_Type;
    signal next_state       : State_Type;

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

        Register_Section: process (clk, reset)
        begin
            
            if (reset = '0') then
                curr_state <= A;
            elsif (rising_edge(clk)) then
                curr_state <= next_state;
            else
                curr_state <= curr_state;
            end if;

        end process;

        Transition_Section: process (curr_state)
        begin

            case curr_state is
                when A =>
                    If (start = '1') then 
                        next_state <= B;

                    else
                        next_state <= A;
                    end if;
                when B =>



                    next_state <= C;

                when C =>

                when D =>
                    if (reset = '0') then


                        next_state <= A;
                    else
                        next_state <= D;
                    end if;

            end case;
        
        end process;

        Decoder_Section: process (curr_state)
        begin

            case curr_state is
                when A =>
                    busy <= '0';
                    done <= '0';
                when B =>
                    busy <= '1';
                    done <= '0';
                when C =>
                    busy <= '1';
                    done <= '0';
                when D =>
                    busy <= '0';
                    done <= '1';
            end case;            

        end process;
        
end architecture;