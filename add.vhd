-- Jai Amit Mehta
-- Sai Bhargav Mandavilli
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add is
	generic(width  : positive := 16);
	port(
		in1    : in  std_logic_vector(width-1 downto 0);
		in2    : in  std_logic_vector(width-1 downto 0);
		output : out std_logic_vector(width downto 0)
	);
end add;

architecture bhv of add is
begin 
	output <= std_logic_vector(resize(unsigned(in1), width+1)+resize(unsigned(in2), width+1));
end bhv;
