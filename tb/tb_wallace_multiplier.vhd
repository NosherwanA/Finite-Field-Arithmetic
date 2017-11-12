library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_wallace_multiplier is

end tb_wallace_multiplier;

architecture test of tb_wallace_multiplier is

    component Wallace_Multiplier is 
        port(
            a       : in std_logic_vector(7 downto 0);
            b       : in std_logic_vector(7 downto 0);
            product : out std_logic_vector(15 downto 0)
        );
    end component;

    signal in_x     : std_logic_vector(7 downto 0);
    signal in_y     : std_logic_vector(7 downto 0);
    signal out_p    : std_logic_vector(15 downto 0);

    constant DELTA_TIME     : time := 5 ns;

begin

    DUT: Wallace_Multiplier 
        port map(
            in_x,
            in_y,
            out_p
        );    
        

    simulation : process
    begin

    in_x <= "11111111";
    in_y <= "11111111";
    -- Result: 1111111000000001
    wait for DELTA_TIME;

    in_x <= "11111111";
    in_y <= "00000000";
    -- Result: 0000000000000000
    wait for DELTA_TIME;

    in_x <= "00000000";
    in_y <= "11111111";
    -- Result: 0000000000000000
    wait for DELTA_TIME;

    in_x <= "00000000";
    in_y <= "00000000";
    -- Result: 0000000000000000
    wait for DELTA_TIME;

    in_x <= "11000011";
    in_y <= "11100000";
    -- Result: 1010101010100000
    wait for DELTA_TIME;

    in_x <= "10101110";
    in_y <= "10010011";
    -- Result: 0110001111101010
    wait for DELTA_TIME;

    in_x <= "10010000";
    in_y <= "00010101";
    --Result: 0000101111010000
    wait for DELTA_TIME;

    end process simulation;
end architecture; --tb_wallace_multiplieresttb_wallace_multiplier