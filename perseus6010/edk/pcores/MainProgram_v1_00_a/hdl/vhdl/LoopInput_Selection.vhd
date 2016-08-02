----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    09:36:12 08/23/2014 
-- Design Name: 
-- Module Name:    LoopInput_Selection - Behavioral 
-- Project Name: 	Max-IV LLRF - Loops
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LoopInput_Selection is
    Port ( LoopInputSel : in  STD_LOGIC_VECTOR (2 downto 0);
           ICav : in  STD_LOGIC_VECTOR (15 downto 0);
           QCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           ILoopInput : out  STD_LOGIC_VECTOR (15 downto 0);
           QLoopInput : out  STD_LOGIC_VECTOR (15 downto 0));
end LoopInput_Selection;

architecture Behavioral of LoopInput_Selection is

begin

process(clk)
begin
if(clk'EVENT and clk = '1') then
	case LoopInputSel is
		when "000" => 	ILoopInput <= ICav;
							QLoopInput <= QCav;
		when "001" => 	ILoopInput <= IFwCav;
							QLoopInput <= QFwCav;
		when "010" => 	ILoopInput <= IFwIOT1;
							QLoopInput <= QFwIOT1;
		when "011" => 	ILoopInput <= IFwIOT2;
							QLoopInput <= QFwIOT2;
		when "100" => 	ILoopInput <= IFwIOT3;
							QLoopInput <= QFwIOT3;
		when "101" => 	ILoopInput <= IFwIOT4;
							QLoopInput <= QFwIOT4;
		when "110" => 	ILoopInput <= ICav;
							QLoopInput <= QCav;
		when "111" => 	ILoopInput <= ICav;
							QLoopInput <= QCav;

		when others => null;
	end case;
end if;
end process;


end Behavioral;

