----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    05:18:32 06/21/2016 
-- Design Name: 	
-- Module Name:    FwMinLoopsEnable - Behavioral 
-- Project Name: 	Diamond LLRF
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

entity FwMinLoopsEnable is
    Port ( FwMin : in  STD_LOGIC_VECTOR (15 downto 0);
			  FwMin_AmpPh : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           LoopsIn_SlowI : in  STD_LOGIC_VECTOR (15 downto 0);
           LoopsIn_SlowQ : in  STD_LOGIC_VECTOR (15 downto 0);
           LoopsIn_FastI : in  STD_LOGIC_VECTOR (15 downto 0);
           LoopsIn_FastQ : in  STD_LOGIC_VECTOR (15 downto 0);
           LoopsIn_Amp : in  STD_LOGIC_VECTOR (15 downto 0);
           LoopsIn_Ph : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpFwCav : in  STD_LOGIC_VECTOR (16 downto 0);
           ForwardMin_Tuning : out  STD_LOGIC;
           ForwardMin_Amp : out  STD_LOGIC;
           ForwardMin_SlowIQ : out  STD_LOGIC;
           ForwardMin_FastIQ : out  STD_LOGIC;
           ForwardMin_Ph : out  STD_LOGIC);
end FwMinLoopsEnable;

architecture Behavioral of FwMinLoopsEnable is

-- signals declaration

signal counter_FwMin_Tuning : std_logic_vector (11 downto 0);
signal counter_FwMin_Amp : std_logic_vector (11 downto 0);
signal counter_FwMin_Ph : std_logic_vector (11 downto 0);
signal counter_FwMin_SlowIQ : std_logic_vector (11 downto 0);
signal counter_FwMin_FastIQ : std_logic_vector (11 downto 0);

signal LoopsIn_SlowI_sig, LoopsIn_SlowQ_sig : std_logic_vector (15 downto 0);
signal LoopsIn_FastI_sig, LoopsIn_FastQ_sig : std_logic_vector (15 downto 0);

-- components declaration

begin

ForwardMin_Process : process ( clk)
begin
if (clk'EVENT and clk ='1') then
	
	if(AmpFwCav > '0'&FwMin) then
		ForwardMin_Tuning <= '1';
		counter_FwMin_Tuning <= (others => '0');
	elsif(counter_FwMin_Tuning < X"320") then -- wait 10us before disabling tuning loop
		counter_FwMin_tuning <= counter_FwMin_Tuning + 1;
	else
		ForwardMin_Tuning <= '0';
	end if;	
	
	if(LoopsIn_Amp > FwMin_AmpPh) then
		ForwardMin_Amp <= '1';
		counter_FwMin_Amp <= (others => '0');
	elsif(counter_FwMin_Amp < X"320") then -- wait 10us before disabling amplitude loop
		counter_FwMin_Amp <= counter_FwMin_Amp + 1;
	else
		ForwardMin_Amp <= '0';
	end if;	
		
	if(LoopsIn_Ph > FwMin_AmpPh) then
		ForwardMin_Ph <= '1';
		counter_FwMin_Ph <= (others => '0');
	elsif(counter_FwMin_Ph < X"320") then -- wait 10us before disabling phase loop
		counter_FwMin_Ph <= counter_FwMin_Ph + 1;
	else
		ForwardMin_Ph <= '0';
	end if;		
	
	-------
	-------
	
	if(LoopsIn_SlowI(15) = '1') then
		LoopsIn_SlowI_sig <= not(LoopsIn_SlowI) + 1;
	else
		LoopsIn_SlowI_sig <= LoopsIn_SlowI;
	end if;
	
	if(LoopsIn_SlowQ(15) = '1') then
		LoopsIn_SlowQ_sig <= not(LoopsIn_SlowQ) + 1;
	else
		LoopsIn_SlowQ_sig <= LoopsIn_SlowQ;
	end if;
	
	if(LoopsIn_FastI(15) = '1') then
		LoopsIn_FastI_sig <= not(LoopsIn_FastI) + 1;
	else
		LoopsIn_FastI_sig <= LoopsIn_FastI;
	end if;
	
	if(LoopsIn_FastQ(15) = '1') then
		LoopsIn_FastQ_sig <= not(LoopsIn_FastQ) + 1;
	else
		LoopsIn_FastQ_sig <= LoopsIn_FastQ;
	end if;
		
	
	if(LoopsIn_SlowI_sig > FwMin_AmpPh or LoopsIn_SlowQ_sig > FwMin_AmpPh) then
		ForwardMin_SlowIQ <= '1';
		counter_FwMin_SlowIQ <= (others => '0');
	elsif(counter_FwMin_SlowIQ < X"320") then -- wait 10us before disabling Slow IQ loop
		counter_FwMin_SlowIQ <= counter_FwMin_SlowIQ + 1;
	else
		ForwardMin_SlowIQ <= '0';
	end if;
	
	if(LoopsIn_FastI_sig > FwMin_AmpPh or LoopsIn_FastQ_sig > FwMin_AmpPh) then
		ForwardMin_FastIQ <= '1';
		counter_FwMin_FastIQ <= (others => '0');
	elsif(counter_FwMin_FastIQ < X"320") then -- wait 10us before disabling Fast IQ loop
		counter_FwMin_FastIQ <= counter_FwMin_FastIQ + 1;
	else
		ForwardMin_FastIQ <= '0';
	end if;		
	
end if;
end process ForwardMin_Process;




end Behavioral;

