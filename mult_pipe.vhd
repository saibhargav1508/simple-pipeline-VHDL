-- Jai Amit Mehta
-- Sai Bhargav Mandavilli
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_pipe is
  generic (
    width  :     positive := 16);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    output : out std_logic_vector(width*2-1 downto 0));
end mult_pipe;

architecture BHV of mult_pipe is

	-- define signal to store multiplier output
    signal temp : unsigned(width*2-1 downto 0);
	
begin
	
	--multiplier process
	temp <= resize(unsigned(in1),width) * resize(unsigned(in2),width);
	
	-- register process
	process(clk, rst)
	begin
	if (rst = '1') then
	  output   <= (others => '0');
	elsif (rising_edge(clk)) then
		output <= std_logic_vector(temp(width*2-1 downto 0));
	  end if;
	end process;
	
end BHV;

