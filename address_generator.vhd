-- Jai Amit Mehta
-- Sai Bhargav Mandavilli
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity address_generator is
	port(
		clk				:	in  std_logic;
		rst				:	in  std_logic;	
		rd_wr_select	:	in  std_logic; -- control signal to select upper or lower address generator
		wr_en			:	out std_logic;
		in_size_addr	:	in  std_logic_vector(C_MEM_ADDR_WIDTH downto 0);		
		out_write_addr	:	out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
		out_rd_addr		:   out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
		valid_in_addr	:   out std_logic;
		valid_out_addr	:   in  std_logic;
		in_go_addr		:	in  std_logic;
		out_done_addr	:	out std_logic
	);
end address_generator;

architecture bhv of address_generator is

	signal wr_addr_count : std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
	signal rd_addr_count : std_logic_vector(C_MEM_ADDR_WIDTH downto 0);

begin
	process(clk, rst)
	begin
	
		if (rst = '1') then	
		    wr_en          <= '0';
			valid_in_addr  <= '0';
			out_done_addr  <= '0';
			out_write_addr <= (others => '0');
			out_rd_addr    <= (others => '0');			
			wr_addr_count  <= (others => '0');
			rd_addr_count  <= (others => '0');

		elsif(rising_edge(clk)) then
			-- input address generator
			if(rd_wr_select = '1')then
				if (in_go_addr = '1') then
					if (unsigned(rd_addr_count) /= unsigned(in_size_addr)) then
						out_rd_addr <= rd_addr_count(C_MEM_ADDR_WIDTH-1 downto 0);
						rd_addr_count<= std_logic_vector(unsigned(rd_addr_count) + to_unsigned(1,C_MEM_ADDR_WIDTH+1));
						valid_in_addr<='1';
					end if;
				end if;
				
			-- output address generator
			elsif(rd_wr_select = '0') then
					if (valid_out_addr = '1') then
						wr_en <= '1';
						if (unsigned(wr_addr_count) /= unsigned(in_size_addr)) then
							out_write_addr <= wr_addr_count(C_MEM_ADDR_WIDTH-1 downto 0);
							wr_addr_count<= std_logic_vector(unsigned(wr_addr_count) + to_unsigned(1,C_MEM_ADDR_WIDTH+1));  
						end if;
					out_done_addr <= '1';
					end if;			
			end if;		
		end if;		
	end process;
end bhv;