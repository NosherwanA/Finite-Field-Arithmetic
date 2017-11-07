library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FA_2 is 
	port(
		a		: in std_logic;
		b		: in std_logic;
		c_in	: in std_logic;
		sum	: out std_logic;
		c_out	: out std_logic
	);
end FA_2;


architecture internal of FA_2 is 

begin 
	
	sum <= (c_in XOR a XOR b);
	c_out <= ((a AND b) OR (c_in AND (a XOR b)));
	
end architecture;