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
    constant DELTA_TIME     : time := 10 ns;
    
    begin

        DUT: Modular_Exponentiator 
        port map(
            in_base,
            in_exponent,
            in_modulus,
            out_result,
            in_clk,
            in_start,
            in_reset,
            out_done,
            out_busy
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
            in_reset <= '0';
            in_base <= "01011001"; -- (89)10
            in_exponent <= "10111010"; -- (186)10
            in_modulus <= "01110100"; -- (116)10
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00001101  (13)10
            wait for DELTA_TIME;

            

         end process simulation;   
        
end architecture;