----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    09:42:40 05/13/2016 
-- Design Name: 
-- Module Name:    PhSh_Controls - Behavioral 
-- Project Name:  Diamond Light Source LLRF
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


entity PhSh_Controls is
    Port ( IControl : in  STD_LOGIC_VECTOR (15 downto 0);
           QControl : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_control1 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_control1 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_control2 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_control2 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_control3 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_control3 : in  STD_LOGIC_VECTOR (15 downto 0);
           sin_phsh_control4 : in  STD_LOGIC_VECTOR (15 downto 0);
           cos_phsh_control4 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  IControl1PS : out  STD_LOGIC_VECTOR (15 downto 0);
           QControl1PS : out  STD_LOGIC_VECTOR (15 downto 0);
           IControl2PS : out  STD_LOGIC_VECTOR (15 downto 0);
           QControl2PS : out  STD_LOGIC_VECTOR (15 downto 0);
           IControl3PS : out  STD_LOGIC_VECTOR (15 downto 0);
           QControl3PS : out  STD_LOGIC_VECTOR (15 downto 0);
           IControl4PS : out  STD_LOGIC_VECTOR (15 downto 0);
           QControl4PS : out  STD_LOGIC_VECTOR (15 downto 0)			  
			  );
end PhSh_Controls;

architecture Behavioral of PhSh_Controls is

-- signals declaration

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

PhShControl1 : component PhaseShift
port map(
			Iin => IControl,	
			Qin => QControl,	
			sin => sin_phsh_control1,
			cos => cos_phsh_control1,	
			clk => clk,
			IOut => IControl1PS,	
			QOut => QControl1PS);
			
PhShControl2 : component PhaseShift
port map(
			Iin => IControl,	
			Qin => QControl,	
			sin => sin_phsh_control2,
			cos => cos_phsh_control2,	
			clk => clk,
			IOut => IControl2PS,	
			QOut => QControl2PS);
			
PhShControl3 : component PhaseShift
port map(
			Iin => IControl,	
			Qin => QControl,	
			sin => sin_phsh_control3,
			cos => cos_phsh_control3,	
			clk => clk,
			IOut => IControl3PS,	
			QOut => QControl3PS);
			
PhShControl4 : component PhaseShift
port map(
			Iin => IControl,	
			Qin => QControl,	
			sin => sin_phsh_control4,
			cos => cos_phsh_control4,	
			clk => clk,
			IOut => IControl4PS,	
			QOut => QControl4PS);


end Behavioral;

