-- Jai Amit Mehta
-- Sai Bhargav Mandavilli
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity controller is
    port (
		clk   : in  std_logic;
		rst   : in  std_logic;
		go    : in  std_logic;
		done  : out std_logic;
		in_addr_size  : in  std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
		out_addr_size : out std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
		in_done_con   : in  std_logic;
		go_addr  	  : out std_logic	
	);
end controller;

architecture bhv of controller is
begin

	process(clk, rst)
	begin

		if (rst = '1') then
			go_addr <= '0';
			done <= '0';

		elsif(rising_edge(clk)) then    
		
			if(go = '1') then
				go_addr <= '1';
				out_addr_size <= in_addr_size;
			end if;
			
			if(in_done_con = '1') then
				done <= '1';
			end if;
			
		end if;
	end process;
end bhv;
