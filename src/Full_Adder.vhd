library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FA is 
	port(
		a		: in std_logic;
		b		: in std_logic;
		c_in	: in std_logic;
		c_out	: out std_logic;
		sum		: out std_logic
	);
end FA;

architecture internal of FA is 
	
	signal x : std_logic;
	signal y : std_logic;
	
begin

	x <= a XOR b;
	y <= a XNOR b;
	
	sum <= ((c_in AND y) OR ((NOT c_in) AND x));
	c_out <= ((c_in AND x) OR ((NOT x) AND a)); 


end architecture;