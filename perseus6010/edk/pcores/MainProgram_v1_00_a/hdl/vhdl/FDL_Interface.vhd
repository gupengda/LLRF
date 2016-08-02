		----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    11:14:04 02/11/2014 
-- Design Name: 
-- Module Name:    FDL_Interface - Behavioral 
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

entity FDL_Interface is
    Port ( Interface_01 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_02 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_03 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_04 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_05 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_06 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_07 : out  STD_LOGIC_VECTOR (15 downto 0);
           Interface_08 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
           clk : in  STD_LOGIC;
			  
           ICav : in  STD_LOGIC_VECTOR (15 downto 0);
           QCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IControl : in  STD_LOGIC_VECTOR (15 downto 0);
           QControl : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IRvIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QRvIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
			  IRvCav : in std_logic_vector (15 downto 0);
			  QRvCav : in std_logic_vector (15 downto 0);
			  TuningDephase : in std_logic_vector (15 downto 0);
			  TuningDephase_filt : in std_logic_vector (15 downto 0);
			  AngCav : in std_logic_vector (15 downto 0);
			  AngFw : in std_logic_vector (15 downto 0);
			  TTL1 : in std_logic;
			  TTL2 : in std_logic;
			  TuningOn : in std_logic;
           
           IRefIn : in  STD_LOGIC_VECTOR (15 downto 0);
           QRefIn : in  STD_LOGIC_VECTOR (15 downto 0);
           IError : in  STD_LOGIC_VECTOR (15 downto 0);
           QError : in  STD_LOGIC_VECTOR (15 downto 0);
           IErrorAccum : in  STD_LOGIC_VECTOR (15 downto 0);
           QErrorAccum : in  STD_LOGIC_VECTOR (15 downto 0);
           IMO : in  STD_LOGIC_VECTOR (15 downto 0);
           QMO : in  STD_LOGIC_VECTOR (15 downto 0);

				IRef_FastPI		: in  STD_LOGIC_VECTOR (15 downto 0);
				QRef_FastPI		: in  STD_LOGIC_VECTOR (15 downto 0);
				IInput_FastPI	: in  STD_LOGIC_VECTOR (15 downto 0);
				QInput_FastPI	: in  STD_LOGIC_VECTOR (15 downto 0);
				IError_FastPI	: in  STD_LOGIC_VECTOR (15 downto 0);
				QError_FastPI	: in  STD_LOGIC_VECTOR (15 downto 0);
				IErrorAccum_FastPI : in  STD_LOGIC_VECTOR (15 downto 0);
				QErrorAccum_FastPI : in  STD_LOGIC_VECTOR (15 downto 0);

			  
			  AmpCav : in std_logic_vector (15 downto 0);			  
			  AngFwCav : in std_logic_vector (15 downto 0);
			  AmpFwCav : in std_logic_vector (15 downto 0);
			  
			  AmpRefIn : in std_logic_vector (15 downto 0);
			  PhRefIn : in std_logic_vector (15 downto 0);
			  Amp_AmpLoopInput : in std_logic_vector (15 downto 0);
			  Ph_PhLoopInput : in std_logic_vector (15 downto 0);
			  AmpError : in std_logic_vector (15 downto 0);
			  PhError : in std_logic_vector (15 downto 0);
			  AmpErrorAccum : in std_logic_vector (15 downto 0);
			  PhErrorAccum : in std_logic_vector (15 downto 0);
			  AmpControlOutput : in std_logic_vector (15 downto 0);
			  PhControlOutput : in std_logic_vector (15 downto 0);
			  IPolarControl : in std_logic_vector (15 downto 0);
			  QPolarControl : in std_logic_vector (15 downto 0);
			  IPolarAmpLoop : in std_logic_vector (15 downto 0);
			  QPolarAmpLoop : in std_logic_vector (15 downto 0);
			  IPolarPhLoop : in std_logic_vector (15 downto 0);
			  QPolarPhLoop : in std_logic_vector (15 downto 0);
			  VCav_16b		: in std_logic_vector (15 downto 0));
			  
end FDL_Interface;

architecture Behavioral of FDL_Interface is

	signal Interface_01_sig : std_logic_vector (15 downto 0);
	signal Interface_02_sig : std_logic_vector (15 downto 0);
	signal Interface_03_sig : std_logic_vector (15 downto 0);
	signal Interface_04_sig : std_logic_vector (15 downto 0);
	signal Interface_05_sig : std_logic_vector (15 downto 0);
	signal Interface_06_sig : std_logic_vector (15 downto 0);
	signal Interface_07_sig : std_logic_vector (15 downto 0);
	signal Interface_08_sig : std_logic_vector (15 downto 0);
	
	signal demux : std_logic_vector (4 downto 0);


begin

process(clk)
begin
if(clk'EVENT and clk='1') then

	demux <= demux + 1;

	if(demux(0) ='0') then
		Interface_01 <= ICav(15 downto 1)&'0';
		Interface_02 <= IFwCav(15 downto 1)&'0';
		Interface_03 <= IFwIOT1(15 downto 1)&'0';
		Interface_04 <= IRvIOT1(15 downto 1)&'0';
		Interface_05 <= IRvCav(15 downto 1)&'0';
		Interface_06 <= IControl(15 downto 1)&'0';
	else
		Interface_01 <= QCav(15 downto 1)&'1';
		Interface_02 <= QFwCav(15 downto 1)&'1';
		Interface_03 <= QFwIOT1(15 downto 1)&'1';
		Interface_04 <= QRvIOT1(15 downto 1)&'1';
		Interface_05 <= QRvCav(15 downto 1)&'1';
		Interface_06 <= QControl(15 downto 1)&'1';
	end if;
	
	case demux(2 downto 0) is
		when "000" => Interface_07 <= IRef_FastPI(15 downto 3)&"000";
		when "001" => Interface_07 <= QRef_FastPI(15 downto 3)&"001";
		when "010" => Interface_07 <= IInput_FastPI(15 downto 3)&"010";
		when "011" => Interface_07 <= QInput_FastPI(15 downto 3)&"011";
		when "100" => Interface_07 <= IError_FastPI(15 downto 3)&"100";
		when "101" => Interface_07 <= QError_FastPI(15 downto 3)&"101";
		when "110" => Interface_07 <= IErrorAccum_FastPI(15 downto 3)&"110";
		when "111" => Interface_07 <= QErrorAccum_FastPI(15 downto 3)&"111";
		when others => null;
	end case;		
	
	case demux is
		when '0'&X"0" => Interface_08 <= IRefIn;
		when '0'&X"1" => Interface_08 <= QRefIn;
		when '0'&X"2" => Interface_08 <= IError;
		when '0'&X"3" => Interface_08 <= QError;
		when '0'&X"4" => Interface_08 <= IErrorAccum;
		when '0'&X"5" => Interface_08 <= QErrorAccum;
		when '0'&X"6" => Interface_08 <= IMO;
		when '0'&X"7" => Interface_08 <= QMO;
		when '0'&X"8" => Interface_08 <= AngCav;
		when '0'&X"9" => Interface_08 <= AngFw;
		when '0'&X"A" => Interface_08 <= TuningDephase;
		when '0'&X"B" => Interface_08 <= TuningDephase_Filt;
		when '0'&X"C" => Interface_08 <= AmpFwCav;
		when '0'&X"D" => Interface_08 <= AngFwCav;
		when '0'&X"E" => Interface_08 <= AmpCav;
		when '0'&X"F" => Interface_08 <= X"7FFF";
		
		when '1'&X"0" => Interface_08 <= AmpRefIn;
		when '1'&X"1" => Interface_08 <= PhRefIn;
		when '1'&X"2" => Interface_08 <= Amp_AmpLoopInput;
		when '1'&X"3" => Interface_08 <= Ph_PhLoopInput;
		when '1'&X"4" => Interface_08 <= AmpError;
		when '1'&X"5" => Interface_08 <= PhError;
		when '1'&X"6" => Interface_08 <= AmpErrorAccum;
		when '1'&X"7" => Interface_08 <= PhErrorAccum;
		when '1'&X"8" => Interface_08 <= AmpControlOutput;
		when '1'&X"9" => Interface_08 <= PhControlOutput;
		when '1'&X"A" => Interface_08 <= IPolarControl;
		when '1'&X"B" => Interface_08 <= QPolarControl;
		when '1'&X"C" => Interface_08 <= IPolarAmpLoop;
		when '1'&X"D" => Interface_08 <= QPolarAmpLoop;
		when '1'&X"E" => Interface_08 <= IPolarPhLoop;
		when '1'&X"F" => Interface_08 <= QPolarPhLoop;
		
		when others => null;
	end case;
end if;
end process;



end Behavioral;

