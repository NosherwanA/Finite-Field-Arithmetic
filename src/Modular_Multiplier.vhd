library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Modular_Multiplier is
    port(
        x           : in std_logic_vector(7 downto 0);
        y           : in std_logic_vector(7 downto 0);
        m           : in std_logic_vector(7 downto 0);
        result      : out std_logic_vector(7 downto 0)

    );
end Modular_Multiplier;

architecture internal of Modular_Multiplier is

    component Wallace_Multiplier is
        port(
            a          : in std_logic_vector(7 downto 0);
            b          : in std_logic_vector(7 downto 0);
            product    : out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal product          : std_logic_vector(15 downto 0);
    signal int_product      : integer;
    signal int_modulus      : integer;
    signal int_remainder    : integer;
    signal remainder        : std_logic_vector(7 downto 0);
    
begin

    Mulitplier: Wallace_Multiplier 
        port map(
            x,
            y,
            product
        );

    int_product <= to_integer(unsigned(product));
    int_modulus <= to_integer(unsigned(m));

    int_remainder <= int_product mod int_modulus;

    remainder <= to_unsigned(int_remainder, 8);

end architecture;