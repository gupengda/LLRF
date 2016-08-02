----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    18:31:57 08/30/2014 
-- Design Name: 
-- Module Name:    ControlOutputSelection - Behavioral 
-- Project Name: Max-IV LLRF - Perseus Loops Board
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

entity ControlOutputSelection is
    Port ( IControl_Rect : in  STD_LOGIC_vector (15 downto 0);
           QControl_Rect : in  STD_LOGIC_VECTOR (15 downto 0);
           IControl_FastPI : in  STD_LOGIC_VECTOR (15 downto 0);
           QControl_FastPI : in  STD_LOGIC_VECTOR (15 downto 0);
           IControl_Polar : in  STD_LOGIC_VECTOR (15 downto 0);
           QControl_Polar : in  STD_LOGIC_VECTOR (15 downto 0);
           PolarLoopsEnable : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           IControl : out  STD_LOGIC_VECTOR (15 downto 0);
           QControl : out  STD_LOGIC_VECTOR (15 downto 0));
end ControlOutputSelection;

architecture Behavioral of ControlOutputSelection is

-- signals declaration


-- components declaration

begin

process(clk)
begin
	if(PolarLoopsEnable = '1') then
		Icontrol <= IControl_Polar;
		Qcontrol <= QControl_Polar;
	else
		IControl <= IControl_Rect + IControl_FastPI;
		QControl <= QControl_Rect + QControl_FastPI;
	end if;
end process;


end Behavioral;

