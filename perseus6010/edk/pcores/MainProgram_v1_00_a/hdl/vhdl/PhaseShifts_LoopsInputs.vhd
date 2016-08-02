----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    18:26:25 08/22/2014 
-- Design Name: 
-- Module Name:    PhaseShifts_LoopsInputs - Behavioral 
-- Project Name: Max-IV LLRF - Loops Board - Perseus
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

entity PhaseShifts_LoopsInputs is
    Port ( IMuxCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_cav : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_cav : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_fwcav : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_fwcav : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_fwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_fwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_fwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_fwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_fwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_fwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_fwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_fwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           PhaseShiftEnable : in  STD_LOGIC;
           ICav : out  STD_LOGIC_VECTOR (15 downto 0);
           QCav : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwCav : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT3 : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT3 : out  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT4 : out  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT4 : out  STD_LOGIC_VECTOR (15 downto 0));
end PhaseShifts_LoopsInputs;

architecture Behavioral of PhaseShifts_LoopsInputs is

-- Signals declaration

signal IMuxCavPS, QMuxCavPS : std_logic_vector (15 downto 0);
signal IMuxFwCavPS, QMuxFwCavPS : std_logic_vector (15 downto 0);
signal IMuxFwIOT1PS, QMuxFwIOT1PS : std_logic_vector (15 downto 0);
signal IMuxFwIOT2PS, QMuxFwIOT2PS : std_logic_vector (15 downto 0);
signal IMuxFwIOT3PS, QMuxFwIOT3PS : std_logic_vector (15 downto 0);
signal IMuxFwIOT4PS, QMuxFwIOT4PS : std_logic_vector (15 downto 0);


-- components declaration

	component PhaseShift IS
	PORT ( Iin : in std_logic_vector (15 downto 0);	
			 Qin : in std_logic_vector (15 downto 0);	
			 sin : in std_logic_vector (15 downto 0);	
			 cos : in std_logic_vector (15 downto 0);	
			 clk : in std_logic;
			 IOut : out std_logic_vector (15 downto 0);	
			 QOut : out std_logic_vector (15 downto 0));
	end component PhaseShift;

begin

PhShCav : component PhaseShift
port map(
			Iin => IMuxCav,	
			Qin => QMuxCav,	
			sin => sin_phsh_cav,
			cos => cos_phsh_cav,	
			clk => clk,
			IOut => IMuxCavPS,	
			QOut => QMuxCavPS);

PhShFwCav : component PhaseShift
port map(
			Iin => IMuxFwCav,	
			Qin => QMuxFwCav,	
			sin => sin_phsh_Fwcav,
			cos => cos_phsh_Fwcav,	
			clk => clk,
			IOut => IMuxFwCavPS,	
			QOut => QMuxFwCavPS);

PhShFwIOT1 : component PhaseShift
port map(
			Iin => IMuxFwIOT1,	
			Qin => QMuxFwIOT1,	
			sin => sin_phsh_FwIOT1,
			cos => cos_phsh_FwIOT1,	
			clk => clk,
			IOut => IMuxFwIOT1PS,	
			QOut => QMuxFwIOT1PS);

PhShFwIOT2 : component PhaseShift
port map(
			Iin => IMuxFwIOT2,	
			Qin => QMuxFwIOT2,	
			sin => sin_phsh_FwIOT2,
			cos => cos_phsh_FwIOT2,	
			clk => clk,
			IOut => IMuxFwIOT2PS,	
			QOut => QMuxFwIOT2PS);

PhShFwIOT3 : component PhaseShift
port map(
			Iin => IMuxFwIOT3,	
			Qin => QMuxFwIOT3,	
			sin => sin_phsh_FwIOT3,
			cos => cos_phsh_FwIOT3,	
			clk => clk,
			IOut => IMuxFwIOT3PS,	
			QOut => QMuxFwIOT3PS);

PhShFwIOT4 : component PhaseShift
port map(
			Iin => IMuxFwIOT4,	
			Qin => QMuxFwIOT4,	
			sin => sin_phsh_FwIOT4,
			cos => cos_phsh_FwIOT4,	
			clk => clk,
			IOut => IMuxFwIOT4PS,	
			QOut => QMuxFwIOT4PS);




	
ADCsPhaseShiftEnable:process(clk)
begin
	if (clk'EVENT and clk = '1') then
		if(PhaseShiftEnable = '0') then
			ICav <= IMuxCav;
			QCav <= QMuxCav;
			IFwCav <= IMuxFwCav;
			QFwCav <= QMuxFwCav;
			IFwIOT1 <= IMuxFwIOT1;
			QFwIOT1 <= QMuxFwIOT1;
			IFwIOT2 <= IMuxFwIOT2;
			QFwIOT2 <= QMuxFwIOT2;
			IFwIOT3 <= IMuxFwIOT3;
			QFwIOT3 <= QMuxFwIOT3;
			IFwIOT4 <= IMuxFwIOT4;
			QFwIOT4 <= QMuxFwIOT4;
		else
			ICav <= IMuxCavPS;
			QCav <= QMuxCavPS;
			IFwCav <= IMuxFwCavPS;
			QFwCav <= QMuxFwCavPS;
			IFwIOT1 <= IMuxFwIOT1PS;
			QFwIOT1 <= QMuxFwIOT1PS;
			IFwIOT2 <= IMuxFwIOT2PS;
			QFwIOT2 <= QMuxFwIOT2PS;
			IFwIOT3 <= IMuxFwIOT3PS;
			QFwIOT3 <= QMuxFwIOT3PS;
			IFwIOT4 <= IMuxFwIOT4PS;
			QFwIOT4 <= QMuxFwIOT4PS;
		end if;
	end if;
end process ADCsPhaseShiftEnable;




end Behavioral;

