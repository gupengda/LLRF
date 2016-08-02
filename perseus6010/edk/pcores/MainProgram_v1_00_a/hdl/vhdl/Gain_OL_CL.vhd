----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    16:40:05 12/23/2012 
-- Design Name: 
-- Module Name:    Gain_OL_CL - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Gain_OL_CL is
    Port ( Input_OL_CL : in  STD_LOGIC_VECTOR (15 downto 0);
           Gain : in  STD_LOGIC_VECTOR (7 downto 0);
           Output_OL_CL : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC);
end Gain_OL_CL;

architecture Behavioral of Gain_OL_CL is

-- signals declaration
signal ol_cl_sig : std_logic_vector (23 downto 0);

-- components declaration

begin

process(clk)
begin
	if(clk'EVENT and clk = '1') then
		ol_cl_sig <= input_ol_cl*gain;
		output_ol_cl <= ol_cl_sig(21 downto 6);
	end if;
end process;

end Behavioral;

