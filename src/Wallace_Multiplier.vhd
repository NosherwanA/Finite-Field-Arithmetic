library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Wallace_Multiplier is 
	port(
		x		: in std_logic_vector(7 downto 0);
		y		: in std_logic_vector(7 downto 0);
		p		: out	std_logic_vector(15 downto 0)
	);
end Wallace_Multiplier;

architecture internal of Wallace_Multiplier is 
	
	signal ip1			: std_logic_vector(6 downto 0);
	signal ip2,ip3,ip4,ip5,ip6,ip7,ip8,si,iip		: std_logic_vector(7 downto 0);
	signal s1,s2,s3,s4,s5,s6	: std_logic_vector(6 downto 0);
	signal c1,c2,c3,c4,c5,c6,c7		: std_logic_vector(7 downto 0);
	signal c 	: std_logic;
	
	--Components
	
	component HA is 
		port(
			a		: in std_logic;
			b		: in std_logic;
			c_out	: out std_logic;
			sum		: out std_logic
		);
	end component;
	
	component FA is 
		port(
			a		: in std_logic;
			b		: in std_logic;
			c_in	: in std_logic;
			c_out	: out std_logic;
			sum		: out std_logic
		);
	end component;
	
	component FA_2 is 
		port(
			a		: in std_logic;
			b		: in std_logic;
			c_in	: in std_logic;
			c_out	: out std_logic;
			sum		: out std_logic
		);
	end component;
	
	
begin

	-- First AND Array
	p(0) <= y(0) AND x(0);
	ip1(0) <= y(0) AND x(1);
	ip1(1) <= y(0) AND x(2);
	ip1(2) <= y(0) AND x(3);
	ip1(3) <= y(0) AND x(4);
	ip1(4) <= y(0) AND x(5);
	ip1(5) <= y(0) AND x(6);
	ip1(6) <= y(0) AND x(7);
	si(0) <= NOT ip1(6);
	
	-- second AND array
	
	ip2(0) <= y(1) AND x(0);
	ip2(1) <= y(1) AND x(1);
	ip2(2) <= y(1) AND x(2);
	ip2(3) <= y(1) AND x(3);
	ip2(4) <= y(1) AND x(4);
	ip2(5) <= y(1) AND x(5);
	ip2(6) <= y(1) AND x(6);
	ip2(7) <= y(1) AND x(7);
	si(1) <= NOT ip2(7);
	
	-- Third AND array
	
	ip3(0) <= y(2) AND x(0);
	ip3(1) <= y(2) AND x(1);
	ip3(2) <= y(2) AND x(2);
	ip3(3) <= y(2) AND x(3);
	ip3(4) <= y(2) AND x(4);
	ip3(5) <= y(2) AND x(5);
	ip3(6) <= y(2) AND x(6);
	ip3(7) <= y(2) AND x(7);
	si(2) <= NOT ip3(7);
	
	-- Fourth AND array
	
	ip4(0) <= y(3) AND x(0);
	ip4(1) <= y(3) AND x(1);
	ip4(2) <= y(3) AND x(2);
	ip4(3) <= y(3) AND x(3);
	ip4(4) <= y(3) AND x(4);
	ip4(5) <= y(3) AND x(5);
	ip4(6) <= y(3) AND x(6);
	ip4(7) <= y(3) AND x(7);
	si(3) <= NOT ip4(7);
	
	-- Fifth AND array
	
	ip5(0) <= y(4) AND x(0);
	ip5(1) <= y(4) AND x(1);
	ip5(2) <= y(4) AND x(2);
	ip5(3) <= y(4) AND x(3);
	ip5(4) <= y(4) AND x(4);
	ip5(5) <= y(4) AND x(5);
	ip5(6) <= y(4) AND x(6);
	ip5(7) <= y(4) AND x(7);
	si(4) <= NOT ip5(7);
	
	-- Sixth AND array
	
	ip6(0) <= y(5) AND x(0);
	ip6(1) <= y(5) AND x(1);
	ip6(2) <= y(5) AND x(2);
	ip6(3) <= y(5) AND x(3);
	ip6(4) <= y(5) AND x(4);
	ip6(5) <= y(5) AND x(5);
	ip6(6) <= y(5) AND x(6);
	ip6(7) <= y(5) AND x(7);
	si(5) <= NOT ip6(7);
	
	-- Seventh AND array
	
	ip7(0) <= y(6) AND x(0);
	ip7(1) <= y(6) AND x(1);
	ip7(2) <= y(6) AND x(2);
	ip7(3) <= y(6) AND x(3);
	ip7(4) <= y(6) AND x(4);
	ip7(5) <= y(6) AND x(5);
	ip7(6) <= y(6) AND x(6);
	ip7(7) <= y(6) AND x(7);
	si(6) <= NOT ip7(7);
	
	-- Eighth AND array
	
	iip(0) <= y(7) AND x(0);
	iip(1) <= y(7) AND x(1);
	iip(2) <= y(7) AND x(2);
	iip(3) <= y(7) AND x(3);
	iip(4) <= y(7) AND x(4);
	iip(5) <= y(7) AND x(5);
	iip(6) <= y(7) AND x(6);
	iip(7) <= y(7) AND x(7);
	
	ip8(0) <= y(7) XOR iip(0);
	ip8(1) <= y(7) XOR iip(1);
	ip8(2) <= y(7) XOR iip(2);
	ip8(3) <= y(7) XOR iip(3);
	ip8(4) <= y(7) XOR iip(4);
	ip8(5) <= y(7) XOR iip(5);
	ip8(6) <= y(7) XOR iip(6);
	ip8(7) <= y(7) XOR iip(7);
	si(7) <= NOT ip8(7);
	
	-- First adder array
	
	ha1: HA port map(ip1(0), ip2(0), c1(0), p(1));
	fa1: FA port map(ip1(1), ip2(1), ip3(0), c1(1), s1(0));
	fa2: FA port map(ip1(2), ip2(2), ip3(1), c1(2), s1(1));
	fa3: FA port map(ip1(3), ip2(3), ip3(2), c1(3), s1(2));
	fa4: FA port map(ip1(4), ip2(4), ip3(3), c1(4), s1(3));
	fa5: FA port map(ip1(5), ip2(5), ip3(4), c1(5), s1(4));
	fa6: FA port map(ip1(6), ip2(6), ip3(5), c1(6), s1(5));
	fa7: FA port map(si(0), si(1), ip3(6), c1(7), s1(6));
	
	-- Second adder array
	
	ha2: HA port map(s1(0), c1(0), c2(0), p(2));
	sa1: FA port map(s1(1), c1(1), ip4(0), c2(1), s2(0));
	sa2: FA port map(s1(2), c1(2), ip4(1), c2(2), s2(1));
	sa3: FA port map(s1(3), c1(3), ip4(2), c2(3), s2(2));
	sa4: FA port map(s1(4), c1(4), ip4(3), c2(4), s2(3));
	sa5: FA port map(s1(5), c1(5), ip4(4), c2(5), s2(4));
	sa6: FA port map(s1(6), c1(6), ip4(5), c2(6), s2(5));
	sa7: FA port map(si(2), c1(7), ip4(6), c2(7), s2(6));
	
	-- Third adder array
	
	ha3: HA port map(s2(0), c2(0), c3(0), p(3));
	ta1: FA port map(s2(1), ip5(0), c2(1), c3(1), s3(0));
	ta2: FA port map(s2(2), ip5(1), c2(2), c3(2), s3(1));
	ta3: FA port map(s2(3), ip5(2), c2(3), c3(3), s3(2));
	ta4: FA port map(s2(4), ip5(3), c2(4), c3(4), s3(3));
	ta5: FA port map(s2(5), ip5(4), c2(5), c3(5), s3(4));
	ta6: FA port map(s2(6), ip5(5), c2(6), c3(6), s3(5));
	ta7: FA port map(si(3), ip5(6), c2(7), c3(7), s3(6));
	
	-- Fourth adder array
	
	ha4: HA port map(s3(0), c3(0), c4(0), p(4));
	foa1: FA port map(s3(1), ip6(0), c3(1), c4(1), s4(0));
	foa2: FA port map(s3(2), ip6(1), c3(2), c4(2), s4(1));
	foa3: FA port map(s3(3), ip6(2), c3(3), c4(3), s4(2));
	foa4: FA port map(s3(4), ip6(3), c3(4), c4(4), s4(3));
	foa5: FA port map(s3(5), ip6(4), c3(5), c4(5), s4(4));
	foa6: FA port map(s3(6), ip6(5), c3(6), c4(6), s4(5));
	foa7: FA port map(si(4), ip6(6), c3(7), c4(7), s4(6));
	
	-- Fifth adder array
	
	ha5: HA port map(s4(0), c4(0), c5(0), p(5));
	fia1: FA port map(s4(1), ip7(0), c4(1), c5(1), s5(0));
	fia2: FA port map(s4(2), ip7(1), c4(2), c5(2), s5(1));
	fia3: FA port map(s4(3), ip7(2), c4(3), c5(3), s5(2));
	fia4: FA port map(s4(4), ip7(3), c4(4), c5(4), s5(3));
	fia5: FA port map(s4(5), ip7(4), c4(5), c5(5), s5(4));
	fia6: FA port map(s4(6), ip7(5), c4(6), c5(6), s5(5));
	fia7: FA port map(si(5), ip7(6), c4(7), c5(7), s5(6));
	
	-- Sixth adder array
	
	ha6: HA port map(s5(0), c5(0), c6(0), p(6));
	sia1: FA port map(s5(1), ip8(0), c5(1), c6(1), s6(0));
	sia2: FA port map(s5(2), ip8(1), c5(2), c6(2), s6(1));
	sia3: FA port map(s5(3), ip8(2), c5(3), c6(3), s6(2));
	sia4: FA port map(s5(4), ip8(3), c5(4), c6(4), s6(3));
	sia5: FA port map(s5(5), ip8(4), c5(5), c6(5), s6(4));
	sia6: FA port map(s5(6), ip8(5), c5(6), c6(6), s6(5));
	sia7: FA port map(si(6), ip8(6), c5(7), c6(7), s6(6));
	
	-- Seventh adder array
	
	sea0: FA_2 port map(s6(0), c6(0), y(7), c7(0), p(7));
	sea1: FA_2 port map(s6(1), c6(1), c7(0), c7(1), p(8));
	sea2: FA_2 port map(s6(2), c6(2), c7(1), c7(2), p(9));
	sea3: FA_2 port map(s6(3), c6(3), c7(2), c7(3), p(10));
	sea4: FA_2 port map(s6(4), c6(4), c7(3), c7(4), p(11));
	sea5: FA_2 port map(s6(5), c6(5), c7(4), c7(5), p(12));
	sea6: FA_2 port map(s6(6), c6(6), c7(5), c7(6), p(13));
	sea7: FA_2 port map(si(7), c6(7), c7(6), c7(7), p(14));
	ha7: HA port map(c7(7), '1', c, p(15));
	
	
end architecture;