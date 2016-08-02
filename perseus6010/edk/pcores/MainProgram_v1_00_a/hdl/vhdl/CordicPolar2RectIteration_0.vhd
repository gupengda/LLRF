----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    21:23:34 06/24/2012 
-- Design Name: 
-- Module Name:    CordicPolar2RectIteration - Behavioral 
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

entity CordicPolar2RectIteration_0 is
    Port ( Ph_ref : in  STD_LOGIC_VECTOR (15 downto 0);
           Ph_in : in  STD_LOGIC_VECTOR (15 downto 0);
           I_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (15 downto 0);
           I_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Q_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Ph_out : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  phase_cordic : in std_logic_vector (15 downto 0));
end CordicPolar2RectIteration_0;

architecture Behavioral of CordicPolar2RectIteration_0 is

begin

process (clk)
variable Ph_ref_in : std_logic_vector (15 downto 0);
begin
	if(clk='1' and clk'EVENT) then
		ph_ref_in := ph_ref - ph_in;
		if((Ph_ref_in) > X"0000") then
			ph_out <= ph_in + phase_cordic;
			I_out <= I_in - Q_in;
			Q_out <= Q_in + I_In;
		else
			ph_out <= ph_in - phase_cordic;
			I_out <= I_in + Q_in;
			Q_out <= Q_in - I_In;
		end if;
	end if;
end process;


end Behavioral;

