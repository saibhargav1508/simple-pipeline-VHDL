-- Jai Amit Mehta
-- Sai Bhargav Mandavilli
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity datapath is
	generic (
		width  : positive);
	port (
		clk    		: in  std_logic;
		rst    		: in  std_logic;
		input  		: in  std_logic_vector(31 downto 0);
		output 		: out std_logic_vector(16 downto 0);
		valid_in    : in  std_logic;
		valid_out   : out std_logic
	);
end datapath;


architecture str of datapath is	

	signal valid_reg1_out, valid_reg2_out : std_logic_vector(0 downto 0); -- signals in between valid delay registers

	signal reg1_out, reg2_out, reg3_out, reg4_out : std_logic_vector(7 downto 0); -- inputs to multipliers
	signal mul_1_out, mul_2_out : std_logic_vector(15 downto 0); -- outputs from multipliers
	signal add_out : std_logic_vector(16 downto 0); --output from adder
	
begin

	-- valid delay registers datapath
	U_REG_DELAY1 : entity work.reg
		generic map (width  => 1)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input(0)  => valid_in,
		  output => valid_reg1_out);

	U_REG_DELAY2 : entity work.reg
		generic map (
		  width  => 1)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => valid_reg1_out,
		  output => valid_reg2_out);

	U_REG_DELAY3 : entity work.reg
		generic map (
		  width  =>1)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => valid_reg2_out,
		  output(0) => valid_out);
	  
	-- pipeline datapath in structural architecture  
	U_REG1 : entity work.reg
		generic map (
		  width  => 8)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => input(7 downto 0),
		  output => reg1_out);

	U_REG2 : entity work.reg
		generic map (
		  width  => 8)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => input(15 downto 8),
		  output => reg2_out);
	  
	U_REG3 : entity work.reg
		generic map (
		  width  => 8)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => input(23 downto 16),
		  output => reg3_out);

	U_REG4 : entity work.reg
		generic map (
		  width  => 8)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => input(31 downto 24),
		  output => reg4_out);
	  
	U_MUL1 : entity work.mult_pipe
		generic map (
		  width  =>8)
		port map (
		  clk	  => clk,
		  rst	  => rst,
		  in1    => reg1_out,
		  in2    => reg2_out,
		  output => mul_1_out);  

	U_MUL2 : entity work.mult_pipe
		generic map (
		  width  => 8)
		port map (
		  clk    => clk,
		  rst   => rst,
		  in1    => reg3_out,
		  in2    => reg4_out,
		  output => mul_2_out);

	U_VALUE_ADD : entity work.add
		generic map (
		  width  => 16)
		port map (
		  in1    => mul_1_out,
		  in2    => mul_2_out,
		  output => add_out);
	
	U_REG5 : entity work.reg
		generic map (
		  width  => 17)
		port map (
		  clk    => clk,
		  rst    => rst,
		  input  => add_out,
		  output => output);
		  
end str;