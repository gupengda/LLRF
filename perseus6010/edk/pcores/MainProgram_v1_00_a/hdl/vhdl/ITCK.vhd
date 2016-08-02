----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    18:38:14 08/26/2014 
-- Design Name: 
-- Module Name:    ITCK - Behavioral 
-- Project Name: DLS LLRF - Diagnostics Board
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ITCK is
    Port ( ITCK_In : in  STD_LOGIC;
			  ResetFIM : in std_logic;
           Disable_ITCK : in  STD_LOGIC_VECTOR (5 downto 0);
           ITCK_Out : out  STD_LOGIC_VECTOR (6 downto 0);
           clk : in  STD_LOGIC);
end ITCK;

architecture Behavioral of ITCK is

signal ITCK_In_latch : std_logic;

begin

process(clk)
begin
	if(clk'EVENT and clk = '1') then
	
		if(ResetFIM = '1') then
			ITCK_In_latch <= '0';
		elsif(ITCK_In = '1') then
			ITCK_In_latch <= '1';
		end if;
		
		if(ResetFIM = '1') then
			ITCK_Out <= (others => '0');
		else
			ITCK_Out(0) <= not(Disable_ITCK(0)) and ITCK_In_latch; -- Output to set LLRF in Standby mode - Loops disabled and RF Drive set to minimum
			ITCK_Out(1) <= not(Disable_ITCK(1)) and ITCK_In_latch; -- Pin Diode Switch Output
			ITCK_Out(2) <= not(Disable_ITCK(2)) and ITCK_In_latch; -- Fast Data Logger Trigger Output
			ITCK_Out(3) <= not(Disable_ITCK(3)) and ITCK_In_latch; -- Output to Tx PLC - It sends transmitter to not RFON State
			ITCK_Out(4) <= not(Disable_ITCK(4)) and ITCK_In_latch; -- Output to other LLRF systems
			ITCK_Out(5) <= not(Disable_ITCK(5)) and ITCK_In; 		 -- Diagnostics Output not latched
			ITCK_Out(6) <= not(Disable_ITCK(5)) and ITCK_In_latch; -- Diagnostics Output latched
		end if;
	end if;
end process;


end Behavioral;

