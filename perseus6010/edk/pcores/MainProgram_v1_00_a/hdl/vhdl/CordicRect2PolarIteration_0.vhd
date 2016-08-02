----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    12:57:21 06/30/2012 
-- Design Name: 
-- Module Name:    CordicRect2PolarIteration - Behavioral 
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
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CordicRect2PolarIteration_0 is
    Port ( I_in : in  STD_LOGIC_VECTOR (17 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (17 downto 0);
           Ph_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  ph_cordic : in std_logic_vector (15 downto 0);
           clk : in  STD_LOGIC;
           I_out : out  STD_LOGIC_VECTOR (17 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (17 downto 0);
           ph_out : out  STD_LOGIC_VECTOR (15 downto 0));
end CordicRect2PolarIteration_0;

architecture Behavioral of CordicRect2PolarIteration_0 is

begin

process(clk)
begin
if(clk='1' and clk'EVENT) then
	if(Q_in(17) = '0') then
		I_out <= I_in + Q_in;
		Q_out <= Q_in - I_in;
		ph_out <= ph_in + ph_cordic;
	else
		I_out <= I_in - Q_in;
		Q_out <= Q_in + I_in;
		ph_out <= ph_in - ph_cordic;		
	end if;
	
	
end if;
end process;


end Behavioral;

