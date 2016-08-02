----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    11:00:39 04/06/2016 
-- Design Name: 
-- Module Name:    Plant_Interface - Behavioral 
-- Project Name: Diamond Light Source LLRF 
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
library ieee;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;


entity Plant_Interface is
    Port ( Conf : in  STD_LOGIC_VECTOR (1 downto 0);
           PinDiodeSw_A : in  STD_LOGIC;
           PinDiodeSw_B : in  STD_LOGIC;
           FDL_Trig_Out_A : in  STD_LOGIC;
           FDL_Trig_Out_B : in  STD_LOGIC;
           ControlA1 : in  STD_LOGIC_VECTOR (15 downto 0);
           ControlA2 : in  STD_LOGIC_VECTOR (15 downto 0);
           ControlA3 : in  STD_LOGIC_VECTOR (15 downto 0);
           ControlA4 : in  STD_LOGIC_VECTOR (15 downto 0);
           ControlB1 : in  STD_LOGIC_VECTOR (15 downto 0);
           ControlB2 : in  STD_LOGIC_VECTOR (15 downto 0);
           VCavA : in  STD_LOGIC_VECTOR (15 downto 0);
           VCavB : in  STD_LOGIC_VECTOR (15 downto 0);
			  LLRFItck_A : in std_logic;
			  LLRFItck_B : in std_logic;
           Control1 : out  STD_LOGIC_VECTOR (15 downto 0);
           Control2 : out  STD_LOGIC_VECTOR (15 downto 0);
           Control3 : out  STD_LOGIC_VECTOR (15 downto 0);
           Control4 : out  STD_LOGIC_VECTOR (15 downto 0);
           Control5 : out  STD_LOGIC_VECTOR (15 downto 0);
           Control6 : out  STD_LOGIC_VECTOR (15 downto 0);
           PinDiodeSw : out  STD_LOGIC_VECTOR (3 downto 0);
           FDL_Trig_out : out  STD_LOGIC;
			  LLRFItckOut : out std_logic;
           clk : in  STD_LOGIC);
end Plant_Interface;

architecture Behavioral of Plant_Interface is

begin

process(clk)
begin
	if(clk'EVENT and clk = '1') then
		case conf is
			when "00" => PinDiodeSw <= PinDiodeSw_B&PinDiodeSw_B&PinDiodeSw_A&PinDiodeSw_A; -- NC Cavities
							 FDL_Trig_Out <= FDL_Trig_Out_A or FDL_Trig_Out_B;
							 LLRFItckOut <= LLRFItck_A or LLRFItck_B;
							 Control1 <= ControlA1;
							 Control2 <= ControlA2;
							 Control3 <= ControlB1;
							 Control4 <= ControlB2;
							 Control5 <= VCavA;
							 Control6 <= VCavB;
			when "01" => PinDiodeSw <= PinDiodeSw_B&PinDiodeSw_B&PinDiodeSw_A&PinDiodeSw_A; -- NC Cavities
							 FDL_Trig_Out <= FDL_Trig_Out_A or FDL_Trig_Out_B;
							 LLRFItckOut <= LLRFItck_A or LLRFItck_B;
							 Control1 <= ControlA1;
							 Control2 <= ControlA2;
							 Control3 <= ControlB1;
							 Control4 <= ControlB2;
							 Control5 <= VCavA;
							 Control6 <= VCavB;
			when "10" => PinDiodeSw <= PinDiodeSw_A&PinDiodeSw_A&PinDiodeSw_A&PinDiodeSw_A; -- SC Cavities
							 FDL_Trig_Out <= FDL_Trig_Out_A;
							 LLRFItckOut <= LLRFItck_A;
							 Control1 <= ControlA1;
							 Control2 <= ControlA2;
							 Control3 <= ControlA3;
							 Control4 <= ControlA4;
							 Control5 <= VCavA;
			when "11" => PinDiodeSw <= "111"&PinDiodeSw_A; -- Booster Cavity
							 FDL_Trig_Out <= FDL_Trig_Out_A;
							 LLRFItckOut <= LLRFItck_A;
							 Control1 <= ControlA1;
							 Control2 <= (others => '0');
							 Control3 <= (others => '0');
							 Control4 <= (others => '0');
							 Control5 <= VCavA;
			when others => null;
		end case;
	end if;
end process;
							 
						


end Behavioral;

