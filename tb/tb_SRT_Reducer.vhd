LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_signed.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;


ENTITY test_srt_reduction IS
END test_srt_reduction;

ARCHITECTURE behavior OF test_srt_reduction IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT srt_reducer
    PORT(
        x : IN std_logic_vector(15 downto 0);
        m : IN std_logic_vector(7 downto 0);
        clk : IN std_logic;
        reset : IN std_logic;
        start : IN std_logic;          
        z : OUT std_logic_vector(7 downto 0);
        done : OUT std_logic
        );
    END COMPONENT;

    --Inputs
    SIGNAL clk :  std_logic := '0';
    SIGNAL reset :  std_logic := '0';
    SIGNAL start :  std_logic := '0';
    SIGNAL x :  std_logic_vector(15 downto 0) := (others=>'0');
    SIGNAL m :  std_logic_vector(7 downto 0) := (others=>'0');
    --Outputs
    SIGNAL z :  std_logic_vector(7 downto 0);
    SIGNAL done :  std_logic;
    
    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: srt_reducer PORT MAP(
        x => x,
        m => m,
        clk => clk,
        reset => reset,
        start => start,
        z => z,
        done => done
    );


    PROCESS -- clock process for clk
    BEGIN
        WAIT for OFFSET;
        CLOCK_LOOP : LOOP
        clk <= '0';
        WAIT FOR (PERIOD *(1.0 - DUTY_CYCLE));
        clk <= '1';
        WAIT FOR (PERIOD * DUTY_CYCLE);
        END LOOP CLOCK_LOOP;
    END PROCESS;
      

    tb_test : PROCESS	 --test the correctness of data

    BEGIN

        --Randomly selected values for x and m 
        
        reset <= '1';
        WAIT FOR PERIOD;
        reset <= '0';
        x <= "1100010001111011";
        m <= "00010101";
        start <= '1';
        WAIT FOR PERIOD;
        start <= '0';
        WAIT until (done <= '1');
        --Result: 00000100
        WAIT FOR PERIOD;


        reset <= '1';
        WAIT FOR PERIOD;
        reset <= '0';
        x <= "1110110011001100";
        m <= "00100011";
        start <= '1';
        WAIT FOR PERIOD;
        start <= '0';
        WAIT until (done <= '1');
        --Result: 00000000
        WAIT FOR PERIOD;


        reset <= '1';
        WAIT FOR PERIOD;
        reset <= '0';
        x <= "1100011111111111";
        m <= "11010110";
        start <= '1';
        WAIT FOR PERIOD;
        start <= '0';
        WAIT until (done <= '1');
        --Result: 00110101
        WAIT FOR PERIOD;


        reset <= '1';
        WAIT FOR PERIOD;
        reset <= '0';
        x <= "1010110111000111";
        m <= "01001110";
        start <= '1';
        WAIT FOR PERIOD;
        start <= '0';
        WAIT until (done <= '1');
        --Result: 00011011
        WAIT FOR PERIOD;


        reset <= '1';
        WAIT FOR PERIOD;
        reset <= '0';
        x <= "1011111010000111";
        m <= "10101111";
        start <= '1';
        WAIT FOR PERIOD;
        start <= '0';
        WAIT until (done <= '1');
        --Result: 01111101
        WAIT FOR PERIOD;

    END PROCESS;

END ARCHITECTURE;