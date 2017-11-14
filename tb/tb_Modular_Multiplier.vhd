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
            result      : out std_logic_vector(7 downto 0)
    
        );
    end component;
    
        signal in_x             : std_logic_vector(7 downto 0);
        signal in_y             : std_logic_vector(7 downto 0);
        signal in_m             : std_logic_vector(7 downto 0);
        signal out_result       : std_logic_vector(7 downto 0);
    
        constant DELTA_TIME     : time := 10 ns;
    
    begin

        DUT: Modular_Multiplier 
        port map(
            in_x,
            in_y,
            in_m,
            out_p
        );
        
        simulation : process
        begin

            in_x <= "01000010";
            in_y <= "11111101";
            in_m <= "01110101";
            --result: 01010100
            wait for DELTA_TIME;

            in_x <= "10001100";
            in_y <= "00111011";
            in_m <= "10011000";
            --result: 00110100
            wait for DELTA_TIME;

            in_x <= "01110100";
            in_y <= "11100101";
            in_m <= "10010100";
            --result: 01001000
            wait for DELTA_TIME;

            in_x <= "11110011";
            in_y <= "10010111";
            in_m <= "01000010";
            --result: 01000000
            wait for DELTA_TIME;

            in_x <= "11111111";
            in_y <= "11111111";
            in_m <= "00001100";
            --result: 00001001
            wait for DELTA_TIME;

         end process simulation;   
        
end architecture;