library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Modular_Exponentiator is

end tb_Modular_Exponentiator;

architecture test of tb_Modular_Exponentiator is
    
    component Modular_Exponentiator is
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
    end component;
    
    signal in_base          : std_logic_vector(7 downto 0);
    signal in_exponent      : std_logic_vector(7 downto 0);
    signal in_modulus       : std_logic_vector(7 downto 0);
    signal out_result       : std_logic_vector(7 downto 0);
    signal in_clk           : std_logic:= '0';
    signal in_start         : std_logic:= '0';
    signal in_reset         : std_logic:= '0';
    signal out_done         : std_logic:= '0';
    signal out_busy         : std_logic:= '0';

    constant TIME_PERIOD    : time := 20 ns;
    constant DELTA_TIME     : time := 20 ns;
    
    begin

        DUT: Modular_Exponentiator 
        port map(
            in_base,
            in_exponent,
            in_modulus,
            in_clk,
            in_reset,
            in_start,
            out_busy,
            out_result,
            out_done
        );

        clock_process: process
        begin
            in_clk <= '0';
            wait for (TIME_PERIOD/2);
            in_clk <= '1';
            wait for (TIME_PERIOD/2);
        end process;
        
        simulation : process
        begin
            -- rising edge of clock firs one at 10 ns then every 20ns
            
            -- INITIAL RESET
            in_reset <= '0';
            wait for 15 ns;
            in_reset <= '1';

            wait for 5 ns;
            in_start <= '1';
            in_base <= "01011001"; -- (89)10
            in_exponent <= "10111010"; -- (186)10
            in_modulus <= "01110100"; -- (116)10
            wait for 15 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00001101  (13)10
            wait for DELTA_TIME;


            in_start <= '1';
            in_base <= "11101010"; -- (234)10
            in_exponent <= "11000101"; -- (197)10
            in_modulus <= "11011000"; -- (216)10
            wait for 10 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00000000  (0)10
            wait for DELTA_TIME;

            in_start <= '1';
            in_base <= "00000011"; -- (3)10
            in_exponent <= "11101000"; -- (232)10
            in_modulus <= "00000100"; -- (4)10
            wait for 10 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00000001  (1)10 runtime: 37000 ns;
            wait for DELTA_TIME;

            in_start <= '1';
            in_base <= "10010011"; -- (147)10
            in_exponent <= "11000110"; -- (198)10
            in_modulus <= "10110111"; -- (183)10
            wait for 10 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00001001  (9)10 runtime: 37000 ns
            wait for DELTA_TIME;

            in_start <= '1';
            in_base <= "11110110"; -- (246)10
            in_exponent <= "00111001"; -- (57)10
            in_modulus <= "01101000"; -- (104)10
            wait for 10 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 01000000  (64)10 runtime: 9000 ns
            wait for DELTA_TIME;
            

         end process simulation;   
        
end architecture;