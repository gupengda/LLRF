----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:23:08 04/07/2014 
-- Design Name: 
-- Module Name:    MovAverage_20b - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MovAverage_20b is
    Port ( TuningDephase : in  STD_LOGIC_VECTOR (15 downto 0);
           TuningDephase_Filt : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC);
end MovAverage_20b;

architecture Behavioral of MovAverage_20b is


-- signals declaration
signal accum_32b : std_logic_vector (23 downto 0);
signal accum_32b_out : std_logic_vector (23 downto 0);
signal TD_filt_32b : std_logic_vector (23 downto 0);
signal addr : std_logic_vector (7 downto 0);
signal addra : std_logic_vector (7 downto 0);
signal addrb : std_logic_vector (7 downto 0);
signal TD : std_logic_vector (15 downto 0);
signal wea : std_logic_vector (0 downto 0);

signal decimation_counter : std_logic_vector (11 downto 0);

-- components declaration
--
	component mem
		port (
		clka: IN std_logic;
		ena: IN std_logic;
		wea: IN std_logic_VECTOR(0 downto 0);
		addra: IN std_logic_VECTOR(7 downto 0);
		dina: IN std_logic_VECTOR(23 downto 0);
		clkb: IN std_logic;
		addrb: IN std_logic_VECTOR(7 downto 0);
		doutb: OUT std_logic_VECTOR(23 downto 0));
	end component;
--
begin

inst_mem1 : mem
		port map (
			clka => clk,
			ena => '1',
			wea => wea,
			addra => addra,
			dina => accum_32b,
			clkb => clk,
			addrb => addrb,
			doutb => accum_32b_out);


process(clk)
begin
	if(clk'EVENT and clk = '1') then
		decimation_counter <= decimation_counter + 1;
		TD <= tuningdephase;
		if(decimation_counter = X"FFF") then
			wea <= (others => '1');
			addr <= addr + 1;
			addra <= addr;
			addrb <= addr + 2;
			accum_32b <= accum_32b + TD;
		else
			wea <= (others => '0');	
			TD_filt_32b <= accum_32b - accum_32b_out + TD;
		end if;
			tuningDephase_filt <= TD_filt_32b(23 downto 8);
		
	end if;
end process;


--process(clk)
--begin
--	if(clk'EVENT and clk='1') then
--		TD <= tuningdephase;
--		tuningdephase_accum <= TD + tuningdephase_average*X"7FF";
--		tuningdephase_average <= tuningdephase_accum(26 downto 11) + tuningdephase_accum(10);
--		tuningDephase_filt <= tuningdephase_average;
--		
--	end if;
--end process;	



end Behavioral;

