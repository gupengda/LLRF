---File average.vhd;----

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY average IS

	PORT ( 	a : in std_logic_vector (15 downto 0);
				clk : in std_logic;
				average_update : in std_logic;
				accum_enable : in std_logic;
				averageout : out std_logic_vector (15 downto 0));
			 
END average;

ARCHITECTURE average_arc OF average is
	signal accum1 : std_logic_vector (15 downto 0);
	signal accum2 : std_logic_vector (31 downto 0);
	signal a_latch : std_logic_vector (15 downto 0);
	
BEGIN
	process (clk)
	begin
	if (clk'EVENT and clk = '1') then
		a_latch <= a;		
		if(average_update = '1') then
			accum1 <= accum2(31 downto 16);
			accum2 <= (others => '0');
		elsif(accum_enable = '1') then
			accum2 <= accum2 + a_latch;			
		end if;
		averageout <= accum1;

	end if;
	end process;
end  average_arc;
	