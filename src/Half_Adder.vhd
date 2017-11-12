library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HA is 
	port(
		a		: in std_logic;
		b		: in std_logic;
		sum		: out std_logic;
		c_out	: out std_logic
	);
end HA;

architecture internal of HA is 

begin
	sum <= a XOR b;
	c_out <= a AND b;

end architecture;