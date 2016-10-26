----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    10:18:12 06/25/2012 
-- Design Name: 
-- Module Name:    Reference - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reference is
    Port ( AmpRefIn : in std_logic_vector (15 downto 0);
			  PhRefIn : in std_logic_vector (15 downto 0);	
			  AmpRefMin : in std_logic_vector (15 downto 0);
			  PhRefMin : in std_logic_vector (15 downto 0);
			  
			  AmpRefOld_out : out std_logic_vector (15 downto 0);
			  PhRefOld_out : out std_logic_vector (15 downto 0);				  
			  		  
           VoltIncRate : in  STD_LOGIC_VECTOR (2 downto 0);
           PhIncRate : in  STD_LOGIC_VECTOR (2 downto 0);
			  
           clk : in  STD_LOGIC;
			  ConditionDutyCycle : in std_logic_vector (23 downto 0);
			  ConditionDutyCycleDiag : out std_logic_vector (15 downto 0);
			  AutomaticConditioning : in std_logic;
			  Conditioning : in std_logic;
			  PulseUp : out std_logic;
			  RFONState_Delay : in std_logic;
			  Fim_Itck_delay : in std_logic;
			  Vacuum : in std_logic;
			  
			  SquareRefEnable : in std_logic;
			  FreqSquare : in std_logic_vector (15 downto 0);
			  
			  RampEnable : in std_logic;
			  TRG3Hz : in std_logic;
			  TRG3HzDiag : out std_logic;
			  
			  AmpRampInit : in std_logic_vector (15 downto 0);
			  PhRampInit : in std_logic_vector (15 downto 0);			  
			  AmpRampEnd : in std_logic_vector (15 downto 0);
			  PhRampEnd : in std_logic_vector (15 downto 0);		
			  
			  RampingState_out : out std_logic_vector (1 downto 0);		
			  RampReady : out std_logic;
			  
			  t1ramping : in std_logic_vector (15 downto 0);
			  t2ramping : in std_logic_vector (15 downto 0);
			  t3ramping : in std_logic_vector (15 downto 0);
			  t4ramping : in std_logic_vector (15 downto 0);
			  
			  BottomRamp : out std_logic;
			  TopRamp : out std_logic;
			  	  
			  SlopeAmpRampUp : in std_logic_vector (15 downto 0);
			  SlopeAmpRampDw : in std_logic_vector (15 downto 0);
			  SlopePhRampUp : in std_logic_vector (15 downto 0);
			  SlopePhRampDw : in std_logic_vector (15 downto 0);
			  
			  RampIncRate : in std_logic_vector (15 downto 0);
			  TopRampAmp_out : out std_logic_vector (15 downto 0);
			  AmpRamp_out : out std_logic_vector (15 downto 0);
			  PhRamp_out : out std_logic_vector (15 downto 0);
			  
			  PolarLoopsEnable : in std_logic
			  );	
			  
end Reference;

architecture Behavioral of Reference is

-- signals declaration

signal AmpRefOld : std_logic_vector (15 downto 0):= (others => '0');
signal PhRefOld : std_logic_vector (15 downto 0):= (others => '0');
signal AmpRefNew : std_logic_vector (15 downto 0):= (others => '0');
signal PhRefNew : std_logic_vector (15 downto 0):= (others => '0');
signal AmpRampOffset : std_logic_vector (15 downto 0):= (others => '0');
signal PhRampOffset : std_logic_vector (15 downto 0):= (others => '0');
signal ConditionDutyCycleNew : std_logic_vector (23 downto 0):= (others => '0');
signal ConditionDutyCycleOld : std_logic_vector (23 downto 0):= (others => '0');
signal ConditionOffset : std_logic_vector (23 downto 0):= (others => '0');
signal CounterVoltIncRate : std_logic_vector (27 downto 0):= (others => '0');
signal CounterPhIncRate : std_logic_vector (23 downto 0):= (others => '0');
signal CounterAmpRampOffset : std_logic_vector (27 downto 0):= (others => '0');
signal CounterPhRampOffset : std_logic_vector (23 downto 0):= (others => '0');
signal PhDiff : std_logic_vector (15 downto 0):= (others => '0');
signal WaitConditioning : std_logic := '0';
signal CounterConditionOffset : std_logic_vector (12 downto 0):= (others => '0');
signal CounterCondition : std_logic_vector (23 downto 0):= (others => '0');

signal counter_pulseup : std_logic_vector (19 downto 0):= (others => '0');
signal PulseUp_sig : std_logic := '0';

signal FreqSquareCounter : std_logic_vector (15 downto 0):= (others => '0');

signal Trg3HzIn : std_logic := '0';
signal Trg3HzInL,Trg3HzInL1,Trg3HzInL2,Trg3HzInL3,Trg3HzInL4,Trg3HzInL5 : std_logic := '0';


signal CounterRamping, counterrampingLatch, counterramping2 : std_logic_vector (25 downto 0):= (others => '0');

signal AmpRefOld_cond : std_logic_vector (15 downto 0):= (others => '0');
signal PhRefOld_cond : std_logic_vector (15 downto 0):= (others => '0');
signal AmpRefOld_ramp : std_logic_vector (15 downto 0):= (others => '0');
signal PhRefOld_ramp : std_logic_vector (15 downto 0):= (others => '0');
signal AmpTopRamp : std_logic_vector (15 downto 0):= (others => '0');

signal counterramp : std_logic_vector (27 downto 0):= (others => '0');
signal OffsetTopRamp : std_logic := '0'; 

signal t1r : std_logic_vector (25 downto 0):= (others => '0');
signal t2r : std_logic_vector (25 downto 0):= (others => '0');
signal t3r : std_logic_vector (25 downto 0):= (others => '0');
signal t4r : std_logic_vector (25 downto 0):= (others => '0');
signal t2r_sig, t3r_sig, t4r_sig : std_logic_vector (15 downto 0):= (others => '0');

signal SlopeAmp1 : std_logic_vector (15 downto 0):= (others => '0');
signal SlopeAmp2 : std_logic_vector (15 downto 0):= (others => '0');
signal SlopePh1 : std_logic_vector (15 downto 0):= (others => '0');
signal SlopePh2 : std_logic_vector (15 downto 0):= (others => '0');

signal AmpRampUpOffset : std_logic := '0';
signal AmpRampUpOffset_sig : std_logic := '0';
signal AmpRampDwOffset : std_logic := '0';
signal AmpRampDwOffset_sig : std_logic := '0';

signal PhRampUpOffset : std_logic := '0';
signal PhRampUpOffset_sig : std_logic := '0';
signal PhRampDwOffset : std_logic := '0';
signal PhRampDwOffset_sig : std_logic := '0';

signal counterAmpSlopeRampUp : std_logic_vector (15 downto 0):= (others => '0');
signal counterAmpSlopeRampDw : std_logic_vector (15 downto 0):= (others => '0');
signal counterPhSlopeRampUp : std_logic_vector (15 downto 0):= (others => '0');
signal counterPhSlopeRampDw : std_logic_vector (15 downto 0):= (others => '0');

signal RampReady_polar : std_logic := '0';
signal EnableTrgCounter : std_logic := '0';

signal VoltIncRate_latch, PhIncRate_latch : std_logic_vector (2 downto 0) := (others => '0');

signal PhDiffOLd_End : std_logic_vector (15 downto 0);
signal PhDiffOLd_Init : std_logic_vector (15 downto 0);


-----

-- components declaration




----
begin

-- Ramping trigger diagnostics
process( clk)
begin
if(clk'EVENT and clk = '1') then
		Trg3HzIn <= Trg3Hz;
		Trg3HzInL <= Trg3HzIn;
		Trg3HzInL1 <= Trg3HzInL;
		Trg3HzInL2 <= Trg3HzInL1;
		Trg3HzInL3 <= Trg3HzInL2;
		Trg3HzInL4 <= Trg3HzInL3;
		Trg3HzInL5 <= Trg3HzInL4;				
	
		if (EnableTrgCounter = '0') then -- if no trigger has been risen yet
			TRG3HzDiag <= '0';
		elsif (counterrampingLatch > X"2625A00") then -- if time after trigger is bigger than 0.5s and no trigger has been risen yet
			TRG3HzDiag <= '0';
		else
			TRG3HzDiag <= '1';
		end if;		
		
		if(Trg3Hz = '1') then
			EnableTrgCounter <= '1';
		end if;
			
		if(Trg3Hz = '1' and Trg3HzIn = '0') then
			counterrampingLatch <= counterramping2;
			counterramping2 <= (others => '0');
		elsif(counterramping2 < X"7270F00") then
			counterramping2 <= counterramping2 + 1;
		else
			counterrampingLatch <= counterramping2;
		end if;
	end if;
end process;


process(clk)
begin
	if(clk='1' and clk'EVENT) then
		AmpRamp_out <= AmpRefOld_ramp;
		PhRamp_out <= PhRefOld_ramp;
		
		VoltIncRate_latch <= VoltIncRate;
		PhIncRate_latch <= PhIncRate;
	end if;
end process;

process( clk)
begin
if(clk'EVENT and clk = '1') then

		ConditionDutyCycleNew <= ConditionDutyCycle;
		PulseUp <= (PulseUp_sig or (not(Conditioning)));			
		
		if(ConditionDutyCycleOld < ConditionDutyCycleNew) then
			ConditionDutyCycleOld <= ConditionDutyCycleOld + ConditionOffset;
		elsif(ConditionDutyCycleOld > ConditionDutyCycleNew) then
			ConditionDutyCycleOld <= ConditionDutyCycleOld + not(ConditionOffset) + 1;
		else
			ConditionDutyCycleOld <= ConditionDutyCycleOld;
		end if;

		ConditionDutyCycleDiag <= ConditionDutyCycleOld(23 downto 8);	
			
		if(PolarLoopsEnable = '1') then 
			case VoltIncRate is
				when "000" => CounterVoltIncRate <= X"FFFFFFF"; -- 0.015mV per second - minimum achievable speed with 28bits counter
				when "001" => CounterVoltIncRate <= X"7FCEC00"; -- 0.03mV increase per second
				when "010" => CounterVoltIncRate <= X"2657AC8"; -- 0.1mV increase per second
				when "011" => CounterVoltIncRate <= X"0F56450"; -- 0.25mV increase per second
				when "100" => CounterVoltIncRate <= X"07AB228"; -- 0.5mV increase per second
				when "101" => CounterVoltIncRate <= X"03D5720"; -- 1mV increase per second
				when "110" => CounterVoltIncRate <= X"01EAB90"; -- 2mV increase per second
				when "111" => CounterVoltIncRate <= X"0000001"; -- Immediatly apply
				when others => null;
			end case;		
		else
			case VoltIncRate is
				when "000" => CounterVoltIncRate <= X"E8D676B"; -- 0.01mV per second
				when "001" => CounterVoltIncRate <= X"4C4B400"; -- 0.03mV increase per second
				when "010" => CounterVoltIncRate <= X"1748A57"; -- 0.1mV increase per second
				when "011" => CounterVoltIncRate <= X"0950423"; -- 0.25mV increase per second
				when "100" => CounterVoltIncRate <= X"04A8211"; -- 0.5mV increase per second
				when "101" => CounterVoltIncRate <= X"0254108"; -- 1mV increase per second
				when "110" => CounterVoltIncRate <= X"012A084"; -- 2mV increase per second
				when "111" => CounterVoltIncRate <= X"0000001"; -- Immediatly apply
				when others => null;
			end case;
		end if;
		
		
		case PhIncRate is
			when "000" => CounterPhIncRate <= X"430E23"; --0.1 degree per second
			when "001" => CounterPhIncRate <= X"218711"; -- 0.2 degree increase per second
			when "010" => CounterPhIncRate <= X"0D693A"; -- 0.5 degree increase per second
			when "011" => CounterPhIncRate <= X"06B49D"; -- 1 degree increase per second
			when "100" => CounterPhIncRate <= X"035A4E"; -- 2 degree increase per second
			when "101" => CounterPhIncRate <= X"015752"; -- 5 degree increase per second
			when "110" => CounterPhIncRate <= X"00ABA9"; -- 10 degree increase per second
			when "111" => CounterPhIncRate <= X"000001";-- Inmediatly apply
			when others => null;
		end case;
			

		
		if(VoltIncRate /= VoltIncRate_latch) then
			CounterAmpRampOffset <= (others => '0');
		elsif(CounterAmpRampOffset = CounterVoltIncRate) then
			CounterAmpRampOffset <= (others => '0');
			if(AutomaticConditioning = '1') then
				if(Vacuum = '1') then
					AmpRampOffset <= X"0000";
				else
					AmpRampOffset <= X"0001";
				end if;			
			else
			AmpRampOffset <= X"0001";
			end if;
		else
			CounterAmpRampOffset <= CounterAmpRampOffset + 1;
			AmpRampOffset <= X"0000";
		end if;
		
		if(PhIncRate /= PhIncRate_latch) then
			CounterPhRampOffset <= (others => '0');			
		elsif(CounterPhRampOffset = CounterPhIncRate) then
			CounterPhRampOffset <= (others => '0');			
			PhRampOffset <= X"0001";			
		else
			CounterPhRampOffset <= CounterPhRampOffset + 1;
			PhRampOffset <= X"0000";
		end if;
		
		
		if(CounterConditionOffset = X"3E8") then
			CounterConditionOffset <= (others => '0');
			if(AutomaticConditioning = '1') then
				if(Vacuum = '1') then
					ConditionOffset <= X"000000";				
				else
					ConditionOffset <= X"000001";
				end if;			
			else
				ConditionOffset <= X"000001";
			end if;			
		else
		CounterConditionOffset <= CounterConditionOffset + 1;
		ConditionOffset <= X"000000";
		end if;		

end if;
end process;



process(clk)
begin
	if(clk'EVENT and clk = '1') then	
--		AmpRefOld_out <= AmpRefOld;
--		PhRefOld_out <= PhRefOld;
--		
--		AmpRefRamp_out <= AmpRefRamp;
--		PhRefRamp_out <= PhRefRamp;
			
		if(RFONState_Delay = '0' or FIM_Itck_delay = '1') then			
			AmpRefOld <= AmpRefMin;
			PhRefOld <= PhRefMin;
			AmpRefNew <= AmpRefMin;
			PhRefNew <= PhRefMin;
		else
			AmpRefNew <= AmpRefIn;
			PhRefNew <= PhRefIn;		
			if(AmpRefNew > AmpRefOld) then
				AmpRefOld <= AmpRefOld + AmpRampOffset;
			elsif (AmpRefNew < AmpRefOld) then
				AmpRefOld <= AmpRefOld - AmpRampOffset;
			end if;		
			PhDiff <= PhRefOld - PhRefNew;			
			if(PhDiff > X"0000") then
				PhRefOld <= PhRefOld - PhRampOffset;
			elsif (PhDiff < X"0000") then
				PhRefOld <= PhRefOld + PhRampOffset;
			end if;
		end if;
	
	 --Conditioning
		if(Conditioning = '1') then
			if(CounterCondition < ConditionDutyCycleOld) then					
				AmpRefOld_out <= AmpRefOld;
				PhRefOld_out <= PhRefOld;
				CounterCondition <= CounterCondition + 1;
				if(counter_pulseup < X"18333") then
					counter_pulseUp <= counter_pulseup + 1;
				else
					PulseUp_sig <= '1';
				end if;
			
			elsif(CounterCondition < X"7A1200") then
				AmpRefOld_out <= AmpRefMin;
				PhRefOld_out <= PhRefMin;
				CounterCondition <= CounterCondition + 1;
				PulseUp_sig <= '0';
			else
				CounterCondition <= (others => '0');
				counter_pulseup <= (others => '0');
			end if;
		----End conditioning
		
		elsif(RampEnable = '1') then		
			AmpRefOld_out <= AmpRefOld_ramp;
			PhRefOld_out <= PhRefOld_ramp;

		-- Square Reference Enable
		elsif (SquareRefEnable = '1') then
			if(FreqSquareCounter < '0'&FreqSquare(15 downto 1)) then
				AmpRefOld_out <= AmpRefMin;
				PhRefOld_out <= PhRefMin;
				FreqSquareCounter <= FreqSquareCounter + 1;
			elsif(FreqSquareCounter < FreqSquare) then		
				AmpRefOld_out <= AmpRefOld;
				PhRefOld_out <= PhRefOld;
				FreqSquareCounter <= FreqSquareCounter + 1;
			else
				FreqSquareCounter <= (others => '0');
			end if;
			
		else		
			AmpRefOld_out <= AmpRefOld;
			PhRefOld_out <= PhRefOld;
		end if;				
	end if;
	
end process;


ramping : process(clk)
begin
if(clk'EVENT and clk='1') then	
	if(RampEnable = '0' or RFONState_Delay = '0' or FIM_ITCK_Delay = '1') then
			AmpRefOld_ramp <= AmpRampInit;
			PhRefOld_ramp <= PhRampInit;
			AmpTopRamp <= AmpRampInit;
			
			RampReady_Polar <= '0';
			RampingState_out <= "00";
			BottomRamp <= '0';
			TopRamp <= '0';
	else		
			
		if(counterramp = RampIncRate&X"000") then 
			counterramp <= (others => '0');
			OffsetTopRamp <= '1'; 
		else
			counterramp <= counterramp + 1;
			OffsetTopRamp <= '0';
		end if;
		
		if(AmpTopRamp < AmpRampEnd) then
			AmpTopRamp <= AmpTopRamp + OffsetTopRamp;
			RampReady_Polar <= '0';
		else
			RampReady_Polar <= '1';
		end if;		
	
						
		if(Trg3HzIn = '1' and Trg3HzInL5 = '0') then
			t1r <= t1ramping&"00"&X"00";
			t2r <= t2r_sig&"00"&X"00";
			t3r <= t3r_sig&"00"&X"00";
			t4r <= t4r_sig&"00"&X"00";
			
			t2r_sig <= t1ramping + t2ramping;
			t3r_sig <= t1ramping + t2ramping + t3ramping;
			t4r_sig <= t1ramping + t2ramping + t3ramping + t4ramping;
			
			SlopeAmp1 <= SlopeAmpRampUp;
			SlopeAmp2 <= SlopeAmpRampDw;
			SlopePh1 <= SlopePhRampUp;
			SlopePh2 <= SlopePhRampDw;
			counterramping <= (others => '0');
			AmpRefOld_ramp <= AmpRampInit;
			PhRefOld_ramp <= PhRampInit;
			
		elsif(counterramping <t1r) then
			counterramping <= counterramping + 1;
			AmpRefOld_ramp <= AmpRampInit;
			PhRefOld_ramp <= PhRampInit;
			BottomRamp <= '1';
			TopRamp <= '0';
			RampingState_out <= "00";
			
			
		elsif(counterramping <t2r) then
			counterramping <= counterramping + 1;
			AmpRefOld_ramp <= AmpRefOld_ramp + AmpRampUpOffset;
			PhDiffOLd_End <= PhRefOld_ramp - PhRampEnd;
			if(PhDiffOLd_End < X"0000") then
				PhRefOld_ramp <= PhRefOld_ramp + PhRampUpOffset;
			elsif(PhDiffOLd_End > X"0000") then
				PhRefOld_ramp <= PhRefOld_ramp - PhRampUpOffset;
			end if;				
			BottomRamp <= '0';
			TopRamp <= '0';
			RampingState_out <= "01";
			
		elsif(counterramping <t3r) then
			counterramping <= counterramping + 1;
			AmpRefOld_ramp <= AmpRefOld_ramp;
			PhRefOld_ramp <= PhRefOld_ramp;
			BottomRamp <= '0';
			TopRamp <= '1';
			RampingState_out <= "10";
			
		elsif(counterramping <t4r) then
			counterramping <= counterramping + 1;
			AmpRefOld_ramp <= AmpRefOld_ramp - AmpRampDwOffset;
			PhDiffOLd_Init <= PhRefOld_ramp - PhRampInit;
			if(PhDiffOLd_Init < X"0000") then
				PhRefOld_ramp <= PhRefOld_ramp + PhRampDwOffset;
			elsif(PhDiffOLd_Init > X"0000") then
				PhRefOld_ramp <= PhRefOld_ramp - PhRampDwOffset;
			end if;	
			BottomRamp <= '0';
			TopRamp <= '0';
			RampingState_out <= "11";
			
		elsif(counterramping > t4r) then
			AmpRefOld_ramp <= AmpRampInit;
			PhRefOld_ramp <= PhRampInit;
			BottomRamp <= '1';
			TopRamp <= '0';
			RampingState_out <= "00";			
		else
			BottomRamp <= '0';
			TopRamp <= '0';
			RampingState_out <= "00";			
		end if;	
	end if;
end if;
end process ramping;

RampingOffsets : process(clk)
begin
	if(clk'EVENT and clk = '1') then				
		if(counterAmpSlopeRampUp = SlopeAmp1) then
			AmpRampUpOffset_sig <= '1';
			counterAmpSlopeRampUp <= (others => '0');
		else
			counterAmpSlopeRampUp <= counterAmpSlopeRampUp + 1;
			AmpRampUpOffset_sig <= '0';
		end if;	
		if(counterAmpSlopeRampDw = SlopeAmp2) then
			AmpRampDwOffset_sig <= '1';
			counterAmpSlopeRampDw <= (others => '0');
		else
			counterAmpSlopeRampDw <= counterAmpSlopeRampDw + 1;
			AmpRampDwOffset_sig <= '0';
		end if;
				
		if(counterPhSlopeRampUp = SlopePh1) then
			PhRampUpOffset_sig <= '1';
			counterPhSlopeRampUp <= (others => '0');
		else
			counterPhSlopeRampUp <= counterPhSlopeRampUp + 1;
			PhRampUpOffset_sig <= '0';
		end if;	
		if(counterPhSlopeRampDw = SlopePh2) then
			PhRampDwOffset_sig <= '1';
			counterPhSlopeRampDw <= (others => '0');
		else
			counterPhSlopeRampDw <= counterPhSlopeRampDw + 1;
			PhRampDwOffset_sig <= '0';
		end if;
			
		if(AmpRefOld_ramp < AmpTopRamp) then
			AmpRampUpOffset <= AmpRampUpOffset_sig;
		else
			AmpRampUpOffset <= '0';
		end if;
			
		if(AmpRefOld_ramp > AmpRampInit) then
			AmpRampDwOffset <= AmpRampDwOffset_sig;
		else
			AmpRampDwOffset <= '0';
		end if;
		
		if(PhRefOld_ramp = PhRampEnd) then
			PhRampUpOffset <= '0';
		else
			PhRampUpOffset <= PhRampUpOffset_sig;
		end if;
		
		if(PhRefOld_ramp = PhRampInit) then
			PhRampDwOffset <= '0';
		else
			PhRampDwOffset <= PhRampDwOffset_sig;
		end if;	
		
			RampReady <= RampReady_Polar;
			TopRampAmp_out <= AmpTopRamp;
	end if;	
end process RampingOffsets;





end Behavioral;

