library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FFA_top is port (
	
	--Clocks
	CLOCK_50			: in std_logic;
	CLOCK2_50			: in std_logic;
	CLOCK3_50			: in std_logic;
	CLOCK4_50			: in std_logic;
	
	--Reset Button
	RESET_N				: in std_logic;
	
	--Keys (Push Buttons) ACTIVE LOW
	KEY					: in std_logic_vector(3 downto 0);
		
	--Switches
	SW					: in std_logic_vector(9 downto 0);
	
	--LEDR (Red LEDs)
	LEDR				: out std_logic_vector(9 downto 0);
	
	--Seven Segment Displays
	HEX0				: out std_logic_vector(6 downto 0);
	HEX1				: out std_logic_vector(6 downto 0);
	HEX2				: out std_logic_vector(6 downto 0);
	HEX3				: out std_logic_vector(6 downto 0);
	HEX4				: out std_logic_vector(6 downto 0);
	HEX5				: out std_logic_vector(6 downto 0);
	
	--DRAM
	DRAM_ADDR			: out std_logic_vector(12 downto 0);
	DRAM_BA				: out std_logic_vector(1 downto 0);
	DRAM_CAS_N			: out std_logic;
	DRAM_CKE			: out std_logic;
	DRAM_CLK			: out std_logic;
	DRAM_CS_N			: out std_logic;
	DRAM_DQ				: inout std_logic_vector(15 downto 0);
	DRAM_LDQM			: out std_logic;
	DRAM_RAS_N			: out std_logic;
	DRAM_UDQM			: out std_logic;
	DRAM_WE_N			: out std_logic;
	
	--GPIOs
	GPIO_0				: inout std_logic_vector(35 downto 0);
	GPIO_1				: inout std_logic_vector(15 downto 0);
	
	--PS2
	PS2_CLK				: inout std_logic;
	PS2_CLK2			: inout std_logic;
	PS2_DAT				: inout std_logic;
	PS2_DAT2			: inout std_logic;
	
	--SD
	SD_CLK				: out std_logic;
	SD_CMD				: inout std_logic;
	SD_DATA				: inout std_logic_vector(3 downto 0);
	
	
	--VGA
	VGA_B				: out std_logic_vector(3 downto 0);
	VGA_G				: out std_logic_vector(3 downto 0);
	VGA_HS				: out std_logic;
	VGA_R				: out std_logic_vector(3 downto 0);
	VGA_VS				: out std_logic
	
);
end FFA_top ;

architecture overall of FFA_top is

	-- COMPONENT DECLARATION
	
	component Wallace_Multiplier is 
		port(
			a		: in std_logic_vector(7 downto 0);
			b		: in std_logic_vector(7 downto 0);
			product		: out	std_logic_vector(15 downto 0)
		);
	end component;
	
	signal in1, in2		: std_logic_vector(7 downto 0);
	signal ou				: std_logic_vector(15 downto 0);
	
	-- INTERNAL SIGNALS 
--	signal x_input		: std_logic_vector(7 downto 0);
--	signal y_input		: std_logic_vector(7 downto 0);
--	signal M_input		: std_logic_vector(7 downto 0);
--	signal b_start		: std_logic;
--	signal output		: std_logic_vector(7 downto 0);
--	signal l_done		: std_logic;
--	
--	signal input_controller 	: std_logic_vector(1 downto 0);

begin

	-- YOUR CODE HERE 
	
--	input_controller <= SW(9 downto 8);
--	
--	LEDR(7 downto 0) <= output;
--	LEDR(8) <= l_done;
--	
--	b_start <= KEY(0);
	
--	with input_controller select x_input <=
--		"00000000" when "00",
--		SW(7 downto 0) when "01",
--		"00000000" when "10",
--		"00000000" when "11";
--	
--	with input_controller select y_input <=
--		"00000000" when "00",
--		SW(7 downto 0) when "10",
--		"00000000" when "01",
--		"00000000" when "11";
--		
--	with input_controller select M_input <=
--		"00000000" when "00",
--		SW(7 downto 0) when "11",
--		"00000000" when "10",
--		"00000000" when "01";
--		
	in1 <= "10100101";
	in2 <= "11011110";
	
	
		mult: Wallace_Multiplier port map(in1,in2,ou);
	
	

end overall;