library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Wallace_Multiplier is
    port(
        a          : in std_logic_vector(7 downto 0);
        b          : in std_logic_vector(7 downto 0);
        product    : out std_logic_vector(15 downto 0)
    );
end Wallace_Multiplier;

architecture internal of Wallace_Multiplier is 

    component HA is 
        port(
            a           : in std_logic;
            b           : in std_logic;
            sum         : out std_logic;
            c_out   	: out std_logic
        );
    end component;

    component FA is 
        port(
            a           : in std_logic;
            b           : in std_logic;
            c_in	    : in std_logic;
            sum         : out std_logic;
            c_out   	: out std_logic
        );
    end component;

    --Signals required

    -- Product 
    signal p1, p2, p3, p4, p5, p6, p7, p8   : std_logic_vector(7 downto 0);

    -- First AND Second layer result
    signal s_l1, c_l1, s_l2, c_l2           : std_logic_vector(7 downto 0);

    -- Thrid and Fourth Layer result
    signal s_l3, c_l3, s_l4, c_l4           : std_logic_vector(7 downto 0);

    -- Fifth Layer Result
    signal s_l5, c_l5                       : std_logic_vector(9 downto 0);

    -- Sixth Layer Result
    signal  s_l6, c_l6                      : std_logic_vector(10 downto 0);

    -- Final layer Seventh layer Result 
    signal c_l7                             : std_logic_vector(10 downto 0);

begin

    -- Calculating project

    p1(0) <= a(0) AND b(0);
    p1(1) <= a(1) AND b(0);
    p1(2) <= a(2) AND b(0);
    p1(3) <= a(3) AND b(0);
    p1(4) <= a(4) AND b(0);
    p1(5) <= a(5) AND b(0);
    p1(6) <= a(6) AND b(0);
    p1(7) <= a(7) AND b(0);

    p2(0) <= a(0) AND b(1);
    p2(1) <= a(1) AND b(1);
    p2(2) <= a(2) AND b(1);
    p2(3) <= a(3) AND b(1);
    p2(4) <= a(4) AND b(1);
    p2(5) <= a(5) AND b(1);
    p2(6) <= a(6) AND b(1);
    p2(7) <= a(7) AND b(1);

    p3(0) <= a(0) AND b(2);
    p3(1) <= a(1) AND b(2);
    p3(2) <= a(2) AND b(2);
    p3(3) <= a(3) AND b(2);
    p3(4) <= a(4) AND b(2);
    p3(5) <= a(5) AND b(2);
    p3(6) <= a(6) AND b(2);
    p3(7) <= a(7) AND b(2);

    p4(0) <= a(0) AND b(3);
    p4(1) <= a(1) AND b(3);
    p4(2) <= a(2) AND b(3);
    p4(3) <= a(3) AND b(3);
    p4(4) <= a(4) AND b(3);
    p4(5) <= a(5) AND b(3);
    p4(6) <= a(6) AND b(3);
    p4(7) <= a(7) AND b(3);

    p5(0) <= a(0) AND b(4);
    p5(1) <= a(1) AND b(4);
    p5(2) <= a(2) AND b(4);
    p5(3) <= a(3) AND b(4);
    p5(4) <= a(4) AND b(4);
    p5(5) <= a(5) AND b(4);
    p5(6) <= a(6) AND b(4);
    p5(7) <= a(7) AND b(4);

    p6(0) <= a(0) AND b(5);
    p6(1) <= a(1) AND b(5);
    p6(2) <= a(2) AND b(5);
    p6(3) <= a(3) AND b(5);
    p6(4) <= a(4) AND b(5);
    p6(5) <= a(5) AND b(5);
    p6(6) <= a(6) AND b(5);
    p6(7) <= a(7) AND b(5);

    p7(0) <= a(0) AND b(6);
    p7(1) <= a(1) AND b(6);
    p7(2) <= a(2) AND b(6);
    p7(3) <= a(3) AND b(6);
    p7(4) <= a(4) AND b(6);
    p7(5) <= a(5) AND b(6);
    p7(6) <= a(6) AND b(6);
    p7(7) <= a(7) AND b(6);

    p8(0) <= a(0) AND b(7);
    p8(1) <= a(1) AND b(7);
    p8(2) <= a(2) AND b(7);
    p8(3) <= a(3) AND b(7);
    p8(4) <= a(4) AND b(7);
    p8(5) <= a(5) AND b(7);
    p8(6) <= a(6) AND b(7);
    p8(7) <= a(7) AND b(7);

    -- Layer 1
    -- Config
    -- HA - FA - FA - FA - FA - FA - FA - HA

    L1_HA1: HA port map (p1(1), p2(0), s_l1(0), c_l1(0));
    L1_FA1: FA port map (p1(2), p2(1), p3(0), s_l1(1), c_l1(1));
    L1_FA2: FA port map (p1(3), p2(2), p3(1), s_l1(2), c_l1(2));
    L1_FA3: FA port map (p1(4), p2(3), p3(2), s_l1(3), c_l1(3));
    L1_FA4: FA port map (p1(5), p2(4), p3(3), s_l1(4), c_l1(4));
    L1_FA5: FA port map (p1(6), p2(5), p3(4), s_l1(5), c_l1(5));
    L1_FA6: FA port map (p1(7), p2(6), p3(5), s_l1(6), c_l1(6));
    L1_HA2: HA port map (p2(7), p3(6), s_l1(7), c_l1(7));

    -- Layer 2
    -- Config
    -- HA - FA - FA - FA - FA - FA - FA - HA

    L2_HA1: HA port map (p4(1), p5(0), s_l2(0), c_l2(0));
    L2_FA1: FA port map (p4(2), p5(1), p6(0), s_l2(1), c_l2(1));
    L2_FA2: FA port map (p4(3), p5(2), p6(1), s_l2(2), c_l2(2));
    L2_FA3: FA port map (p4(4), p5(3), p6(2), s_l2(3), c_l2(3));
    L2_FA4: FA port map (p4(5), p5(4), p6(3), s_l2(4), c_l2(4));
    L2_FA5: FA port map (p4(6), p5(5), p6(4), s_l2(5), c_l2(5));
    L2_FA6: FA port map (p4(7), p5(6), p6(5), s_l2(6), c_l2(6));
    L2_HA2: HA port map (p5(7), p6(6), s_l2(7), c_l2(7));

    -- Filling up the product vector
    product(0) <= p1(0);

    --Layer 3

    L3_HA1: HA port map (c_l1(0), s_l1(1), s_l3(0), c_l3(0));
    L3_FA1: FA port map (c_l1(1), s_l1(2), p4(0), s_l3(1), c_l3(1));
    L3_FA2: FA port map (c_l1(2), s_l1(3), s_l2(0), s_l3(2), c_l3(2));
    L3_FA3: FA port map (c_l1(3), s_l1(4), c_l2(0), s_l3(3), c_l3(3));
    L3_FA4: FA port map (c_l1(4), s_l1(5), c_l2(1), s_l3(4), c_l3(4));
    L3_FA5: FA port map (c_l1(5), s_l1(6), c_l2(2), s_l3(5), c_l3(5));
    L3_FA6: FA port map (c_l1(6), s_l1(7), c_l2(3), s_l3(6), c_l3(6));
    L3_FA7: FA port map (c_l1(7), p3(7), c_l2(4), s_l3(7), c_l3(7));


    --Layer 4

    L4_HA1: HA port map (s_l2(2), p7(0), s_l4(0), c_l4(0));
    L4_FA1: FA port map (s_l2(3), p7(1), p8(0), s_l4(1), c_l4(1));
    L4_FA2: FA port map (s_l2(4), p7(2), p8(1), s_l4(2), c_l4(2));
    L4_FA3: FA port map (s_l2(5), p7(3), p8(2), s_l4(3), c_l4(3));
    L4_FA4: FA port map (s_l2(6), p7(4), p8(3), s_l4(4), c_l4(4));
    L4_FA5: FA port map (s_l2(7), p7(5), p8(4), s_l4(5), c_l4(5));
    L4_FA6: FA port map (p6(7), p7(6), p8(5), s_l4(6), c_l4(6));
    L4_HA2: HA port map (p7(7), p8(6), s_l4(7), c_l4(7));   

    -- Filling up product vector
    product(1) <= s_l1(0);
    
    --Layer 5

    L5_HA1: HA port map (c_l3(0), s_l3(1), s_l5(0), c_l5(0));
    L5_HA2: HA port map (c_l3(1), s_l3(2), s_l5(1), c_l5(1));
    L5_FA1: FA port map (c_l3(2), s_l3(3), s_l2(1), s_l5(2), c_l5(2));
    L5_FA2: FA port map (c_l3(3), s_l3(4), s_l4(0), s_l5(3), c_l5(3));
    L5_FA3: FA port map (c_l3(4), s_l3(5), c_l4(0), s_l5(4), c_l5(4));
    L5_FA4: FA port map (c_l3(5), s_l3(6), c_l4(1), s_l5(5), c_l5(5));
    L5_FA5: FA port map (c_l3(6), s_l3(7), c_l4(2), s_l5(6), c_l5(6));
    L5_FA6: FA port map (c_l3(7), c_l2(5), c_l4(3), s_l5(7), c_l5(7));
    L5_HA3: HA port map (c_l2(6), c_l4(4), s_l5(8), c_l5(8));
    L5_HA4: HA port map (c_l2(7), c_l4(5), s_l5(9), c_l5(9));

    --Filling up product vector
    product(2) <= s_l3(0);

    --Layer 6

    L6_HA1: HA port map (c_l5(0), s_l5(1), s_l6(0), c_l6(0));
    L6_HA2: HA port map (c_l5(1), s_l5(2), s_l6(1), c_l6(1));
    L6_HA3: HA port map (c_l5(2), s_l5(3), s_l6(2), c_l6(2));
    L6_FA1: FA port map (c_l5(3), s_l5(4), s_l4(1), s_l6(3), c_l6(3));
    L6_FA2: FA port map (c_l5(4), s_l5(5), s_l4(2), s_l6(4), c_l6(4));
    L6_FA3: FA port map (c_l5(5), s_l5(6), s_l4(3), s_l6(5), c_l6(5));
    L6_FA4: FA port map (c_l5(6), s_l5(7), s_l4(4), s_l6(6), c_l6(6));
    L6_FA5: FA port map (c_l5(7), s_l5(8), s_l4(5), s_l6(7), c_l6(7));
    L6_FA6: FA port map (c_l5(8), s_l5(9), s_l4(6), s_l6(8), c_l6(8));
    L6_FA7: FA port map (c_l5(9), c_l4(6), s_l4(7), s_l6(9), c_l6(9));
    L6_HA4: HA port map (c_l4(7), p8(7), s_l6(10), c_l6(10));

    --Filling up product vector
    product(3) <= s_l5(0);

    product(4) <= s_l6(0);
    --Final layer Layer 7 

    L7_HA1: HA port map (c_l6(0), s_l6(1), product(5), c_l7(0));
    L7_FA1: FA port map (c_l6(1), s_l6(2), c_l7(0), product(6), c_l7(1));
    L7_FA2: FA port map (c_l6(2), s_l6(3), c_l7(1), product(7), c_l7(2));
    L7_FA3: FA port map (c_l6(3), s_l6(4), c_l7(2), product(8), c_l7(3));
    L7_FA4: FA port map (c_l6(4), s_l6(5), c_l7(3), product(9), c_l7(4));
    L7_FA5: FA port map (c_l6(5), s_l6(6), c_l7(4), product(10), c_l7(5));
    L7_FA6: FA port map (c_l6(6), s_l6(7), c_l7(5), product(11), c_l7(6));
    L7_FA7: FA port map (c_l6(7), s_l6(8), c_l7(6), product(12), c_l7(7));
    L7_FA8: FA port map (c_l6(8), s_l6(9), c_l7(7), product(13), c_l7(8));
    L7_FA9: FA port map (c_l6(9), s_l6(10), c_l7(8), product(14), c_l7(9));
    L7_HA2: HA port map (c_l6(10), c_l7(9), product(15), c_l7(10));

end architecture;