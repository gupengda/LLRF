----------------------------------------------------------------------------------
-- Company: A. Salom
-- Engineer: 
-- 
-- Create Date:    10:55:55 02/15/2014 
-- Design Name: 
-- Module Name:    Tuning - Behavioral 
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


entity Tuning is
    Port ( clk : in  STD_LOGIC;
           TuningEnable : in  STD_LOGIC;
           TunPosEnable : in  STD_LOGIC;
           ForwardMin : in  STD_LOGIC;
           PulseUp : in  STD_LOGIC;
			  Conditioning : in std_logic;
			  
           TuningReset : in  STD_LOGIC;
           MovePLG1 : in  STD_LOGIC;
           MoveUp1 : in  STD_LOGIC;
           MovePLG2 : in  STD_LOGIC;
           MoveUp2 : in  STD_LOGIC;
			  
			  CLKPerPulse : in std_logic_vector (2 downto 0);
			  NumSteps : in std_logic_vector (15 downto 0);
			  
           MarginUp : in  STD_LOGIC_VECTOR (15 downto 0);
           MarginLow : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  Conf : in std_logic_vector (1 downto 0);
			  RampEnableLatch : in std_logic;
			  TopRamp : in std_logic;
			  FFEnable : in std_logic;
			  FFPos : in std_logic;			  
			  AmpCell2 : in std_logic_vector (15 downto 0);
			  AmpCell4 : in std_logic_vector (15 downto 0);
			  AmpCell2Gain : in std_logic_vector (15 downto 0);
			  AmpCell4Gain : in std_logic_vector (15 downto 0);
			  FFPercentage : in std_logic_vector (8 downto 0);
			  FFError_out : out std_logic_vector (15 downto 0);
			  AmpCell2FF_out : out std_logic_vector (15 downto 0);
			  AmpCell4FF_out : out std_logic_vector (15 downto 0);
			  FFOn_out : out std_logic;
			  
           State_out : out  STD_LOGIC_VECTOR (1 downto 0);
			  StateFF_out : out std_logic_vector (1 downto 0);
			  
           TuningOn_out : out  STD_LOGIC;
			  TuningEna_Delay_out : out std_logic;
           PlungerMoving_Auto : out  STD_LOGIC;
           PlungerMoving_Manual1 : out  STD_LOGIC;
           PlungerMoving_Manual2 : out  STD_LOGIC;
			  			  
           TuningDephase : out  STD_LOGIC_VECTOR (15 downto 0);
           TuningDephase_Filt_out : out  STD_LOGIC_VECTOR (15 downto 0);
           AngCavFw_out : out  STD_LOGIC_VECTOR (15 downto 0);			  
           AngCav : in  STD_LOGIC_VECTOR (15 downto 0);
           AngFw : in  STD_LOGIC_VECTOR (15 downto 0);
			  PhaseOffset : in std_logic_vector (15 downto 0);
			  
			  TTL_gpio_output_1 : out std_logic;
			  TTL_gpio_output_2 : out std_logic;
			  TTL_gpio_output_3 : out std_logic;
			  TTL_gpio_output_4 : out std_logic;
			  
			  CounterTuningDelaySetting : in std_logic_vector(15 downto 0);
			  TuningDephase80HzLPFEnable : in std_logic;
			  TuningTrigger_out : out std_logic;
			  TuningTriggerEnable : in std_logic_vector(1 downto 0);
			  TuningInput_out : out std_logic_vector (15 downto 0));
end Tuning;

architecture Behavioral of Tuning is

-- Signals declaration

signal NumCLK1_2 : std_logic_vector (23 downto 0);
signal NumCLK : std_logic_vector (23 downto 0);
signal CounterPulse : std_logic_vector (23 downto 0);
signal CounterPulse2 : std_logic_vector (23 downto 0);
signal CountTTL : std_logic_vector (23 downto 0);
signal State : std_logic_vector (1 downto 0);
signal NumSteps_latch,NumSteps_latch1,NumSteps_latch2 : std_logic_vector (15 downto 0);
signal CounterTuning : std_logic_vector (15 downto 0);
signal CounterTuning2 : std_logic_vector (15 downto 0);

signal TTL1Signal : std_logic;
signal TTL2Signal : std_logic;
signal TTL3Signal : std_logic;
signal TTL4Signal : std_logic;
signal TTL1Signal_sig : std_logic;
signal TTL2Signal_sig : std_logic;
signal TTL3Signal_sig : std_logic;
signal TTL4Signal_sig : std_logic;
signal TuningOn : std_logic;
signal FFOn : std_logic;
signal FFOn_sig : std_logic;
signal TuningOnDelay : std_logic;

signal TTL1 : std_logic;
signal TTL2 : std_logic;
signal TTL3 : std_logic;
signal TTL4 : std_logic;

signal AngCavFw : std_logic_vector (15 downto 0);
signal AngCavFw_latch : std_logic_vector (15 downto 0);

signal NotMarginUp : std_logic_vector (15 downto 0);
signal NotMarginLow : std_logic_vector (15 downto 0);

signal CounterTuningDelay : std_logic_vector (28 downto 0);
signal TuningEna_Delay : std_logic;
signal TuningOnLatch : std_logic;

signal TuningInput : std_logic_vector (15 downto 0);
signal TuningDephase_filt : std_logic_vector (15 downto 0);
signal TuningTrigger : std_logic;

signal TuningOnFAlling : std_logic;
signal TuningOnRising : std_logic;


signal AmpCell2FF : std_logic_vector (15 downto 0);
signal AmpCell4FF : std_logic_vector (15 downto 0);
signal FFMargin : std_logic_vector (15 downto 0);
signal FFError : std_logic_vector (15 downto 0);

signal AmpCell2FF_sig : std_logic_vector (31 downto 0);
signal AmpCell4FF_sig : std_logic_vector (31 downto 0);
signal FFMargin_sig : std_logic_vector (24 downto 0);

signal StateFF : std_logic_vector (1 downto 0);


-- Components declaration


	component MovAverage_20b is
		 Port ( TuningDephase : in  STD_LOGIC_VECTOR (15 downto 0);
				  TuningDephase_Filt : out  STD_LOGIC_VECTOR (15 downto 0);
				  clk : in  STD_LOGIC);
	end component MovAverage_20b;

begin

inst_MovAverage : component MovAverage_20b
port map(TuningDephase => AngCavFw_latch,
			TuningDephase_Filt => TuningDephase_Filt,
			clk => clk);
			

-------------------------------------
---Tuning Loop-----------------------

TuningLoopOutputs : process(clk)

begin
if(clk'EVENT and clk = '1') then
	
	NumCLK1_2 <= NumCLK(23)&NumCLK(23 downto 1);
	
	if(CountTTL < NumCLK) then
		CountTTL <= CountTTL + 1;
	else CountTTL <= (others => '0');
	end if;
		 
	if(CountTTL<NumCLK1_2) then
	 TTL2Signal_sig <= '1';
	else
	 TTL2Signal_sig <= '0';
	end if;	 

	 if(TunPosEnable = '1') then
		TTL1Signal_sig <= State(1);
	 else
		TTL1Signal_sig <= not(State(1));
	 end if;
			 
	
	if(ForwardMin = '0') then
		TTL1Signal <= '0';
		TTL2Signal <= '0';
		TTL3Signal <= '0';
		TTL4Signal <= '0';
		
	elsif(TuningOnDelay = '1' and PulseUp = '1') then -- In case tuning dephase out of deadband, both plunger are moved simultaneouly and in the same sense
	
		TTL1Signal <= TTL1Signal_sig;
		TTL2Signal <= TTL2Signal_sig;
		TTL3Signal <= TTL1Signal_sig;
		TTL4Signal <= TTL2Signal_sig;
				
	elsif(FFOn = '1' and TuningOn = '0' and FFEnable = '1') then
		if(FFPos = '1') then
			TTL1Signal <= StateFF(1);
			TTL2Signal <= TTL2Signal_sig;
			TTL3Signal <= not(StateFF(1));
			TTL4Signal <= TTL2Signal_sig;
		else
			TTL1Signal <= not(StateFF(1));
			TTL2Signal <= TTL2Signal_sig;
			TTL3Signal <= StateFF(1);
			TTL4Signal <= TTL2Signal_sig;
		end if;
	else
		TTL1Signal <= '0';
		TTL2Signal <= '0';
		TTL3Signal <= '0';
		TTL4Signal <= '0';
	end if;

		

end if;
end process TuningLoopOutputs;

TuningLoopFreq : process(clk)
begin
	if(clk'EVENT and clk =  '1') then
		case CLKperPulse is
			when "010" => NumCLK <= X"061A80"; --Pulse period = 5ms (200 Hz)
			when "011" => NumCLK <= X"030D40"; --Pulse period = 2.5ms (400Hz)
			when "100" => NumCLK <= X"0208D5"; --Pulse period = 1.667ms (600Hz)
			when "101" => NumCLK <= X"0186A0"; --Pulse period = 1.25ms (800Hz)
			when "110" => NumCLK <= X"00C350"; --Pulse period = 1 ms (1000Hz)
			when "111" => NumCLK <= X"0061A8"; --Pulse period = 0.5ms (2000Hz)
			when "001" => NumCLK <= X"0C3500"; -- Pulse period = 10ms (100Hz)
			when others => NumCLK <= X"186A00"; --Pulse period = 1 ms (50Hz)
	end case;
end if;
end process TuningLoopFreq;



ManualTuning : process(clk)
begin
	if (clk'EVENT and clk = '1') then		
		if(TuningReset = '1') then 
		
			if(MovePLG1 = '1') then
				NumSteps_latch1 <= NumSteps;
			else			
				NumSteps_latch1 <= (others => '0');
			end if;
			
			if(MovePLG2 = '1') then
				NumSteps_latch2 <= NumSteps;
			else
				NumSteps_latch2 <= (others => '0');				
			end if;
			
			CounterTuning <= (others => '0');
			CounterTuning2 <= (others => '0');
			CounterPulse <= (others => '0');
			CounterPulse2 <= (others => '0');
			PlungerMoving_Auto <= '0';
			PlungerMoving_Manual1 <= '0';
			PlungerMoving_Manual2 <= '0';
		elsif(TuningEnable = '1') then		
			TTL1 <= TTL1Signal;
			TTL2 <= TTL2Signal;			
			TTL3 <= TTL3Signal;
			TTL4 <= TTL4Signal;		
			PlungerMoving_Auto <= (ForwardMin and TuningOnDelay and TuningEnable) or (ForwardMin and FFOn and FFEnable and (not(TuningOnDelay)));
			PlungerMoving_Manual1 <= '0';
			PlungerMoving_Manual2 <= '0';
		elsif(CounterTuning < NumSteps_latch1 or CounterTuning2 < NumSteps_latch2) then -- X"B2D05E00" = 50e6*60 --> number of clocks per minute; X"2FAF080" = 50e6 --> number of clocks per second (50MHz)			
			PlungerMoving_Auto <= '0'; 
			if(CounterTuning < NumSteps_latch1 and MovePLG1 = '1') then
				PlungerMoving_Manual1 <= '1';
				if(CounterPulse < NumCLK1_2) then
					TTL2 <= '1';
					TTL1 <= MoveUp1; 
					CounterPulse <= CounterPulse + 1;
				elsif(CounterPulse < NumCLK) then
					TTL2 <= '0';
					TTL1 <= MoveUp1; 
					CounterPulse <= CounterPulse + 1;
				else
					CounterPulse <= (others => '0');
					CounterTuning <= CounterTuning + 1;
				end if;
			else			
				PlungerMoving_Manual1 <= '0';
				TTL1 <= '0';
				TTL2 <= '0';
			end if;
			
			if(CounterTuning2 < NumSteps_latch2 and MovePLG2 = '1') then
				PlungerMoving_Manual2 <= '1';
				if(CounterPulse2 < NumCLK1_2) then
					TTL4 <= '1';
					TTL3 <= MoveUp2; 
					CounterPulse2 <= CounterPulse2 + 1;
				elsif(CounterPulse2 < NumCLK) then
					TTL4 <= '0';
					TTL3 <= MoveUp2; 
					CounterPulse2 <= CounterPulse2 + 1;
				else
					CounterPulse2 <= (others => '0');
					CounterTuning2 <= CounterTuning2 + 1;
				end if;
			else			
				PlungerMoving_Manual2 <= '0';
				TTL3 <= '0';
				TTL4 <= '0';
			end if;
			
		
		else
		TTL1 <= '0';
		TTL2 <= '0';
		TTL3 <= '0';
		TTL4 <= '0';
		PlungerMoving_Auto <= '0';
		PlungerMoving_Manual1 <= '0';
		PlungerMoving_Manual2 <= '0';

		end if;
		
		-- Signals to DB9 for tuning
		TTL_gpio_output_1 <= TTL1; --direction plunger
		TTL_gpio_output_2 <= TTL2; --pulse plunger
		
		if (conf = "11") then -- in booster configuration, second plunger controlled by Cavity A. In other configuration, second plunger should be controlled by cavity B
			TTL_gpio_output_3 <= TTL3; --direction plunger
			TTL_gpio_output_4 <= TTL4; --pulse plunger
		else
			TTL_gpio_output_3 <= '0'; --direction plunger
			TTL_gpio_output_4 <= '0'; --pulse plunger
		end if;
		

		
	end if;
end process ManualTuning;



TuningDep : process (clk)
begin
if (clk'EVENT and clk = '1') then
	AngCavFw <= AngCav + not(AngFw) + 1 + not(PhaseOffset) + 1;		
	AngCavFw_out <= AngCavFw;
	if(PulseUP ='1' or Conditioning ='0') then
		AngCavFw_latch <= AngCavFw;
	end if;
		TuningDephase <= AngCavFw_latch;
		TuningDephase_Filt_out <= TuningDephase_Filt;
end if;
end process TuningDep;




-----------------------------------------------
---Tuning on/off. Deadband implementation------
process( clk)
begin
if (clk'EVENT and clk =  '1')then

	NotMarginUp <= not(MarginUp) + 1;
	NotMarginLow <= not(MarginLow) + 1;
	
	TuningOnLatch <= TuningOn;
	TuningEna_Delay_out <= TuningOnDelay;
	State_out <= State;
	
	if(TuningOnLatch = '0' and TuningOn = '1') then
		TuningOnRising <= '1';
	elsif (tuningOnLatch = '1' and TuningOn = '0') then
		TuningOnFalling <= '1';
	else
		TuningOnRising <= '0';
		TuningOnFalling <= '0';
	end if;
	
	TuningInput_out <= TuningInput;
	
	if(TuningDephase80HzLPFEnable = '0') then
		TuningInput <= AngCavFw_latch;
	else
		TuningInput <= TuningDephase_Filt;
	end if;
	
	if((TuningOnFalling = '1' and TuningEnable= '1')) then -- when tuning has reached stable position, loop gets disable during X seconds to disregard possible oscillations of the plunger when it gets stopped
		CounterTuningDelay <= (others => '0');
		TuningEna_Delay <= '0';
		TuningTrigger <= '1' and not(TuningTriggerEnable(1));
	elsif (CounterTuningDelay <= '0'&CounterTuningDelaySetting&X"000") then
		CounterTuningDelay <= CounterTuningDelay + '1';
		TuningEna_Delay <= '0';
		TuningTrigger <= '0';
	else
		TuningEna_Delay <= '1';
		if(TuningOnRising = '1') then
			TuningTrigger <= '1' and tuningTriggerEnable(1);
		else
			TuningTrigger <= '0';
		end if;
	end if;	
	
	tuningOnDelay <= TuningOn and TuningEna_Delay;
	
	
	
	if(TuningTriggerEnable(0) = '1') then
		TuningTrigger_out <= TuningTrigger;
	else
		TuningTrigger_out <= '0';
	end if;
	
	
	if(TuningInput > MarginUp ) then 
		State <= "00";
		TuningOn <= '1';
	elsif(TuningInput < NotMarginUp) then 
		State <= "11";
		TuningOn <= '1';
	elsif(State = "00" and TuningInput < NotMarginLow) then
		State <= "01";
		TuningOn <= '0';
	elsif(State = "11" and TuningInput > MarginLow) then 
		State <= "10";
		TuningOn <= '0';
	end if;
		TuningOn_out <= TuningOn;

end if;
end process;



---------------------------------------------
--FieldFlatness on/off deadband-------------
process(clk)
begin
if (clk'EVENT and clk =  '1')then
	AmpCell2FF_sig <= AmpCell2*AmpCell2Gain;
	AmpCell4FF_sig <= AmpCell4*AmpCell4Gain;
	
	AmpCell2FF <= AmpCell2FF_sig (29 downto 14);
	AmpCell4FF <= AmpCell4FF_sig (29 downto 14);
	
	FFError <= AmpCell2FF + not(AmpCell4FF) + 1;
	
	FFMargin_sig <= AmpCell2*FFPercentage;
	FFMargin <= FFMargin_sig (23 downto 8);
	
	
	AmpCell2FF_Out <= AmpCell2FF;
	AmpCell4FF_Out <= AmpCell4FF;
	FFError_Out <= FFError;
	
	if(FFError(15) = '0' and FFError > FFMargin) then
		StateFF <= "00";
		FFOn_sig <= '1';
	elsif (FFError(15) = '1' and FFError < (not(FFMargin)+1)) then
		StateFF <= "11";
		FFOn_sig <= '1';
	elsif (StateFF = "00" and FFError(15) = '1') then
		StateFF <= "01";
		FFOn_sig <= '0';
	elsif (StateFF = "11" and FFError(15) = '0') then
		StateFF <= "10";
		FFOn_sig <= '0';
	end if;
	
	StateFF_out  <= StateFF;
	
	if(RampEnableLatch = '0') then -- if ramping not enable, FF loop active always
		FFOn <= FFOn_sig;		
	elsif (TopRamp ='1') then -- if ramping enable, FF loop only active at top of the ramp
		FFOn <= FFOn_sig;
	else
		FFOn <= '0';
	end if;
	
	FFOn_out <= FFOn;
	
	
end if;
end process;





end Behavioral;

