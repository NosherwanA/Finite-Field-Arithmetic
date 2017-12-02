library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Modular_Multiplier is

end tb_Modular_Multiplier;

architecture test of tb_Modular_Multiplier is
    
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
    
    signal in_x             : std_logic_vector(7 downto 0);
    signal in_y             : std_logic_vector(7 downto 0);
    signal in_m             : std_logic_vector(7 downto 0);
    signal out_result       : std_logic_vector(7 downto 0);
    signal in_clk           : std_logic:= '0';
    signal in_start         : std_logic:= '0';
    signal in_reset         : std_logic:= '0';
    signal out_done         : std_logic:= '0';
    signal out_busy         : std_logic:= '0';

    constant TIME_PERIOD    : time := 20 ns;
    constant DELTA_TIME     : time := 10 ns;
    
    begin

        DUT: Modular_Multiplier 
        port map(
            in_x,
            in_y,
            in_m,
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
            in_x <= "01000010";
            in_y <= "11111101";
            in_m <= "01110101";
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 01010100
            wait for DELTA_TIME;

            in_reset <= '0';
            in_x <= "11001101";
            in_y <= "10010000";
            in_m <= "00110000";
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00000000
            wait for DELTA_TIME;

            in_reset <= '0';
            in_x <= "10001100";
            in_y <= "00111011";
            in_m <= "10011000";
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00110100
            wait for DELTA_TIME;

            in_reset <= '0';
            in_x <= "01110100";
            in_y <= "11100101";
            in_m <= "10010100";
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 01001000
            wait for DELTA_TIME;

            in_reset <= '0';
            in_x <= "11110011";
            in_y <= "10010111";
            in_m <= "01000010";
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00111111
            wait for DELTA_TIME;

            in_reset <= '0';
            in_x <= "11111111";
            in_y <= "11111111";
            in_m <= "00001100";
            wait for 15 ns;
            in_reset <= '1';
            in_start <= '1';
            wait for 20 ns;
            in_start <= '0';
            wait until (out_done = '1');
            --result: 00001001
            wait for DELTA_TIME;

         end process simulation;   
        
end architecture;