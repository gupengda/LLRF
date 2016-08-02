----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    09:25:38 07/04/2016 
-- Design Name: 
-- Module Name:    RampDiag - Behavioral 
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
library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity RampDiag is
    Port ( ICell3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QCell3 : in  STD_LOGIC_VECTOR (15 downto 0);
           ICell2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QCell2 : in  STD_LOGIC_VECTOR (15 downto 0);
           ICell4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QCell4 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IRvIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QRvIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IRvCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QRvCav : in  STD_LOGIC_VECTOR (15 downto 0);
           TuningDephase : in  STD_LOGIC_VECTOR (15 downto 0);
			  IControl	: in std_logic_vector (15 downto 0);
			  QControl	: in std_logic_vector (15 downto 0);
			  IError	: in std_logic_vector (15 downto 0);
			  QError	: in std_logic_vector (15 downto 0);
			  IREf : in std_logic_vector (15 downto 0);
			  QREf : in std_logic_vector (15 downto 0);
           ICell3Top : out  STD_LOGIC_VECTOR (15 downto 0);
           QCell3Top : out  STD_LOGIC_VECTOR (15 downto 0);
           ICell2Top : out  STD_LOGIC_VECTOR (15 downto 0);
           QCell2Top : out  STD_LOGIC_VECTOR (15 downto 0);
           ICell4Top : out  STD_LOGIC_VECTOR (15 downto 0);
           QCell4Top : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1Top : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1Top : out  STD_LOGIC_VECTOR (15 downto 0);
           IRvIOT1Top : out  STD_LOGIC_VECTOR (15 downto 0);
           QRvIOT1Top : out  STD_LOGIC_VECTOR (15 downto 0);
           IRvCavTop : out  STD_LOGIC_VECTOR (15 downto 0);
           QRvCavTop : out  STD_LOGIC_VECTOR (15 downto 0);
           IControlTop : out  STD_LOGIC_VECTOR (15 downto 0);
           QControlTop : out  STD_LOGIC_VECTOR (15 downto 0);
           IErrorTop : out  STD_LOGIC_VECTOR (15 downto 0);
           QErrorTop : out  STD_LOGIC_VECTOR (15 downto 0);
           IRefTop : out  STD_LOGIC_VECTOR (15 downto 0);
           QRefTop : out  STD_LOGIC_VECTOR (15 downto 0);
           ICell3Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QCell3Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           ICell2Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QCell2Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           ICell4Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QCell4Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           IRvIOT1Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QRvIOT1Bottom : out  STD_LOGIC_VECTOR (15 downto 0);
           IRvCavBottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QRvCavBottom : out  STD_LOGIC_VECTOR (15 downto 0);
           IcontrolBottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QcontrolBottom : out  STD_LOGIC_VECTOR (15 downto 0);
           IErrorBottom : out  STD_LOGIC_VECTOR (15 downto 0);
           QErrorBottom : out  STD_LOGIC_VECTOR (15 downto 0);
           TuningDephaseTop : out  STD_LOGIC_VECTOR (15 downto 0);
           TuningDephaseBottom : out  STD_LOGIC_VECTOR (15 downto 0);
			  FFError : in std_logic_vector (15 downto 0);
			  FFErrortop : out std_logic_vector (15 downto 0);
			  FFErrorBottom : out std_logic_vector (15 downto 0);
			  IRefBottom : out std_logic_vector (15 downto 0);
			  QRefBottom : out std_logic_vector (15 downto 0);
           TopRamp : in  STD_LOGIC;
           BottomRamp : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end RampDiag;

architecture Behavioral of RampDiag is

begin

process(clk)
begin
	if(clk'EVENT and clk ='1') then
		if(TopRamp = '1') then			
			ICell3Top <= ICell3;
			QCell3Top <= QCell3; 
			ICell2Top <= ICell2;
			QCell2Top <= QCell2;
			ICell4Top <= ICell4;
			QCell4Top <= QCell4;
			IFwIOT1Top <= IFwIOT1;
			QFwIOT1Top <= QFwIOT1;
			IRvIOT1Top <= IRvIOT1;
			QRvIOT1Top <= QRvIOT1;
			IRvCavTop <= IRvCav;
			QRvCavTop <= QRvCav;
			TuningDephaseTop <= TuningDephase;
			FFErrorTop <= FFError;
			IControlTop <= IControl;
			QControlTop <= QControl;
			IErrorTop <= IError;
			QErrorTop <= QError;
			IRefTop <= IRef;
			QRefTop <= QRef;
		end if;
		
		if(BottomRamp = '1') then		
			ICell3Bottom <= ICell3;
			QCell3Bottom <= QCell3; 
			ICell2Bottom <= ICell2;
			QCell2Bottom <= QCell2;
			ICell4Bottom <= ICell4;
			QCell4Bottom <= QCell4;
			IFwIOT1Bottom <= IFwIOT1;
			QFwIOT1Bottom <= QFwIOT1;
			IRvIOT1Bottom <= IRvIOT1;
			QRvIOT1Bottom <= QRvIOT1;
			IRvCavBottom  <= IRvCav;
			QRvCavBottom  <= QRvCav;
			TuningDephaseBottom <= TuningDephase;
			FFErrorBottom <= FFError;
			IControlBottom <= IControl;
			QControlBottom <= QControl;
			IErrorBottom <= IError;
			QErrorBottom <= QError;
			IRefBottom <= IRef;
			QRefBottom <= QRef;
		end if;
	end if;
end process;

end Behavioral;

