----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    05:18:32 17/06/2012 
-- Design Name: 	
-- Module Name:    Startup - Behavioral 
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

ENTITY StartUp IS

	PORT ( Automatic_StartUp_Enable : in std_logic;
			 CommandStart : in std_logic_vector (4 downto 0);
			 clk : in std_logic;
			 StateStart : out std_logic_vector (4 downto 0);
			 LoopEnable : in std_logic;
			 LoopEnableLatch : out std_logic;
			 TuningEnable : in std_logic;
			 TuningEnableLatch : out std_logic;
			 RFONState_Delay : in std_logic;
			 Fim_Itck_delay : in std_logic;
			 ILoopClosed : out std_logic;
			 QLoopClosed : out std_logic;
			 RampEnable : in std_logic;
			 RampEnableLatch : out std_logic;
			 IntLimit : in std_logic_vector (15 downto 0);
			 IntLimitLatch : out std_logic_vector (15 downto 0);
			 counterIntLimit_out : out std_logic_vector (15 downto 0);
			 IntLimitOffsetAccum_out : out std_logic_vector (15 downto 0);
			 LookRef : in std_logic;
			 LookRefLatch : out std_logic;
			 
			 PolarLoopsEnable : in std_logic;
			 LoopEnable_FastPI : in std_logic;
			 AmpLoopEnable : in std_logic;
			 PhLoopEnable : in std_logic;
			 
			 AmpLoopError : in std_logic_vector (15 downto 0);
			 PhLoopError : in std_logic_vector (15 downto 0);
			 
			 LoopEnable_FastPI_latch : out std_logic;
			 AmpLoopEnable_latch : out std_logic;
			 PhLoopEnable_latch : out std_logic;
			 AnyLoopsEnable_latch : out std_logic;
			 
			 AmpLoopClosed : out std_logic;
			 PhLoopClosed : out std_logic;
			 
			 SpareDI1 : in std_logic;
			 SpareDO1 : out std_logic;			 
			 
			 IRefMin : in std_logic_vector (15 downto 0);
			 QRefMin : in std_logic_vector (15 downto 0);			 
			 AmpRefIn : in std_logic_vector (15 downto 0);
			 PhRefIn : in std_logic_vector (15 downto 0);
			 AmpRefIn_latch : out std_logic_vector (15 downto 0);
			 PhRefIn_latch : out std_logic_vector (15 downto 0);
			 
			 AmpRampInit : in std_logic_vector (15 downto 0);
			 PhRampInit : in std_logic_vector (15 downto 0);
			 AmpRampEnd : in std_logic_vector (15 downto 0);
			 PhRampEnd : in std_logic_vector (15 downto 0);
			 RampingState : in std_logic_vector (1 downto 0);
			 
			 FFEnable : in std_logic;
			 FFEnableLatch : out std_logic;
			 			 
			 AmpRampInit_latch : out std_logic_vector (15 downto 0);
			 PhRampInit_latch : out std_logic_vector (15 downto 0);
			 AmpRampEnd_latch : out std_logic_vector (15 downto 0);
			 PhRampEnd_latch : out std_logic_vector (15 downto 0);
			 
			 ForwardMin : in std_logic;
			 IErrorMean : in std_logic_vector (15 downto 0);
			 QErrorMean : in std_logic_vector (15 downto 0);
			 
			 TuningOn : in std_logic;
			 AmpRefOld : in std_Logic_vector (15 downto 0);
			 AmpRefMin : in std_logic_vector (15 downto 0);
			 PhRefMin : in std_logic_vector (15 downto 0));
	
			 
END Startup;

ARCHITECTURE StartUp_arc OF StartUp is

--Signals declaration
signal IntLimitInit : std_logic_vector (15 downto 0);
signal I_IntLimitInit, Q_IntLimitInit : std_logic_vector (15 downto 0);
signal CounterRef : std_logic_vector (27 downto 0);
signal CounterIntLimit : std_logic_vector (15 downto 0);
signal StateStart_signal : std_logic_vector (4 downto 0);
signal IntLimitOffset : std_logic;
signal IntLimitOffsetAccum : std_logic_vector (15 downto 0);
signal ILoopClosed_signal : std_logic;
signal QLoopClosed_signal : std_logic;
signal RampEnableLatch_signal : std_logic;
signal LoopEnableLatch_signal : std_logic;
signal TuningEnableLatch_signal : std_logic;
signal IntLimitLatch_signal : std_logic_vector (15 downto 0);
signal LoopEnable_FastPI_signal : std_logic;
signal AmpLoopEnable_signal : std_logic;
signal PhLoopEnable_signal : std_logic;

signal FFEnableLatch_signal : std_logic;

signal AmpLoopClosed_signal : std_logic;
signal PhLoopClosed_signal : std_logic;

signal AmpRampInit_latch_signal : std_logic_vector (15 downto 0);
signal PhRampInit_latch_signal : std_logic_vector (15 downto 0);
signal AmpRampEnd_latch_signal : std_logic_vector (15 downto 0);
signal PhRampEnd_latch_signal : std_logic_vector (15 downto 0);

signal AmpRefIn_Latch_signal : std_logic_vector (15 downto 0);
signal PhRefIn_Latch_signal : std_logic_vector (15 downto 0);
signal LookRefLatch_signal : std_logic;


---

begin
	
	
process(clk)
begin
if(clk'EVENT and clk = '1') then
	StateStart <= StateStart_signal;
	ILoopClosed <= ILoopClosed_signal;
	QLoopClosed <= QLoopClosed_signal;
	AmpLoopClosed <= AmpLoopClosed_signal;
	PhLoopClosed <= PhLoopClosed_signal;
	RampEnableLatch <= RampEnableLatch_signal;
	LoopEnableLatch <= LoopEnableLatch_signal;
	TuningEnableLatch <= TuningEnableLatch_signal;
	FFEnableLatch <= FFEnableLatch_signal;
	IntLimitLatch <= IntLimitLatch_signal;
	AmpLoopEnable_latch <= AmpLoopEnable_signal;
	PhLoopEnable_latch <= PhLoopEnable_signal;
	LoopEnable_FastPI_latch <= LoopEnable_FastPI_signal;
	
	AnyLoopsEnable_latch <= AmpLoopEnable_signal or PhLoopEnable_signal or LoopEnable_FastPI_signal or LoopEnableLatch_signal;
	
	counterIntLimit_out <= counterIntLimit;
	IntLimitOffsetAccum_out <= IntLimitOffsetAccum;
	
	
	AmpRampInit_latch <= AmpRampInit_latch_signal;
	PhRampInit_latch <= PhRampInit_latch_signal;
	AmpRampEnd_latch <= AmpRampEnd_latch_signal;
	PhRampEnd_latch <= PhRampEnd_latch_signal;
	
	AmpRefIN_latch <= AmpRefIn_latch_signal;
	PhRefIN_latch <= PhRefIn_Latch_signal;
	
	lookRefLatch <= LookRefLatch_signal;
	
	  
	if(IRefMin(15)='1') then I_IntLimitInit <= not(IRefMin) + 1;
	else I_IntLimitInit <= IRefMin;
	end if;

	if(QRefMin(15)='1') then Q_IntLimitInit <= not(QRefMin) + 1;
	else Q_IntLimitInit <= QRefMin;
	end if;
	
	if(I_IntLimitInit > Q_IntLimitInit) then IntLimitInit <= Q_IntLimitInit;
	else IntLimitInit <= I_IntLimitInit;
	end if;
	
	if(Automatic_StartUp_Enable = '0') then
		LookRefLatch_signal <= LookRef;
		StateStart_signal <= CommandStart;  
		AmpRampInit_latch_signal <= AmpRampInit;
		PhRampInit_latch_signal <= PhRampInit;
		
		if(RFONState_Delay = '0' or Fim_Itck_delay = '1') then -- or SpareDI1 = '0') then			
			IntLimitLatch_signal <= IntLimitInit;	
			TuningEnableLatch_signal <= '0';
			FFEnableLatch_signal <= '0';
			LoopEnableLatch_signal <= '0';
			AmpLoopEnable_signal <= '0';
			PhLoopEnable_signal <= '0';
			LoopEnable_FastPI_signal <= '0';
			AmpRefIn_latch_signal <= AmpRefMin;
			PhRefIn_Latch_signal <= PhRefMin;
			SpareDO1 <= '0';			
			RampEnableLatch_signal <= '0';
			AmpRampEnd_latch_signal <= AmpRampInit;
			PhRampEnd_latch_signal <= PhRampInit;

		else
			IntLimitLatch_signal <= IntLimit;	
			TuningEnableLatch_signal <= TuningEnable;
			FFEnableLatch_signal <= FFEnable;
			LoopEnableLatch_signal <= LoopEnable;
			AmpLoopEnable_signal <= AmpLoopEnable;
			PhLoopEnable_signal <= PhLoopEnable;
			LoopEnable_FastPI_signal <= LoopEnable_FastPI;
			AmpRefIn_latch_signal <= AmpRefIn;
			PhRefIn_Latch_signal <= PhRefIn;
			RampEnableLatch_signal <= RampEnable;
			AmpRampEnd_latch_signal <= AmpRampEnd;
			PhRampEnd_latch_signal <= PhRampEnd;
		end if;
	
	
	elsif(RFONState_Delay = '0' or Fim_Itck_delay = '1') then
		StateStart_signal <= "00000";
		LoopEnableLatch_signal <= '0';
		TuningEnableLatch_signal <= '0';
		FFEnableLatch_signal <= '0';
		AmpLoopEnable_signal <= '0';
		PhLoopEnable_signal <= '0';
		LoopEnable_FastPI_signal <= '0';
		RampEnableLatch_signal <= '0';
		IntLimitLatch_signal <= IntLimitInit;
		AmpRefIn_latch_signal <= AmpRefMin;
		PhRefIn_Latch_signal <= PhRefMin;
		AmpRampEnd_latch <= AmpRAmpInit;
		PhRampEnd_latch <= PhRampInit;
		counterRef <= (others => '0');
		SpareDO1 <= '0';
		
			
	elsif(StateStart_signal = "00000") then	
		LoopEnableLatch_signal <= '0';
		TuningEnableLatch_signal <= '0';
		FFEnableLatch_signal <= '0';
		RampEnableLatch_signal <= '0';
		IntLimitLatch_signal <= IntLimitInit;
		LookRefLatch_signal <= '0';		
		AmpRefIn_latch_signal <= AmpRefMin;
		PhRefIn_Latch_signal <= PhRefMin;
		ILoopClosed_signal <= '0';
		QLoopClosed_signal <= '0';
		AmpLoopClosed_signal <= '0';
		PhLoopClosed_signal <= '0';
		AmpRampInit_latch_signal <= AmpRampInit;
		PhRAmpInit_latch_signal <= PhRampInit;
		AmpRampEnd_latch_signal <= AmpRAmpInit;
		PhRampEnd_latch_signal <= PhRampInit;
		counterRef <= (others => '0');
		SpareDO1 <= '0';
		
		if( ForwardMin = '1' and StateStart_signal < CommandStart) then
		StateStart_signal <= "00001"; --- RF On and cavity not tuned!!
		end if;
	elsif(StateStart_signal = "00001") then -- Looking for reference	
		if(counterRef < X"2625A00") then
			counterRef <= counterRef + 1;
			LookRefLatch_signal <= LookRef;
		elsif(StateStart_signal < CommandStart) then
			StateStart_signal <= "00010";
			LookRefLatch_signal <= '0';
		end if;
	elsif(StateStart_signal = "00010")   then -- waiting for cavity to be tuned		
		TuningEnableLatch_signal <= TuningEnable;
		FFEnableLatch_signal <= FFEnable;
		if(TuningOn = '0' and StateStart_signal < CommandStart) then
			StateStart_signal <= "00011"; -- Cavity Tuned!!!
		end if;
	
	elsif(StateStart_signal = "00011") then
		if(PolarLoopsEnable = '1') then
			AmpLoopEnable_signal <= AmpLoopEnable;
			PhLoopEnable_signal <= PhLoopEnable;
		else
			LoopEnableLatch_signal <= LoopEnable; 
		end if;
					
			if(IErrorMean < X"00C4" and IErrorMean > X"FF3C") then
				ILoopClosed_signal <= '1';
			else
				ILoopClosed_signal <= '0';
			end if;
			
			if(QErrorMean < X"00C4" and QErrorMean > X"FF3C") then
				QLoopClosed_signal <= '1';
			else
				QLoopClosed_signal <= '0';
			end if;
			
			if(AmpLoopError < X"00C4" and AmpLoopError > X"FF3C") then
				AmpLoopClosed_signal <= '1';
			else
				AmpLoopClosed_signal <= '0';
			end if;
			
			if(PhLoopError < X"00C4" and PhLoopError > X"FF3C") then
				PhLoopClosed_signal <= '1';
			else
				PhLoopClosed_signal <= '0';
			end if;
	
		
		if(LoopEnable = '1') then -- Close loop and Limit Drive increase at 10mV/s.	
			if(ILoopClosed_signal = '1' and QLoopClosed_signal = '1') then
				IntLimitLatch_signal <= IntLimit;
				if(StateStart_signal < CommandStart) then 
					StateStart_signal <= "00100"; -- ready to increase power in close loop controlling rectangular coordinates
				end if;
			elsif(IntLimitLatch_signal < IntLimit) then
				IntLimitLatch_signal <= IntLimitLatch_signal + IntLimitOffset;
			else
				StateStart_signal <= "00111"; --- Loops saturated!!!!
			end if;				
		elsif(AmpLoopEnable = '1') then
			if(AmpLoopClosed_signal = '1') then 
				IntLimitLatch_signal <= IntLimit;
				if(StateStart_signal < CommandStart) then StateStart_signal <= "00100"; -- ready to increase power in close loop controlling polar coordinates
				end if;
			elsif(IntLimitLatch_signal < IntLimit)	then	
				IntLimitLatch_signal <= IntLimitLatch_signal + IntLimitOffset;
			else
				StateStart_signal <= "00111"; --- Loops saturated!!!!
			end if;			
		elsif(StateStart_signal < CommandStart) then
			StateStart_signal <= "00100"; -- ready to increase power in open loop
		end if;
		
		if(counterIntLimit < X"3FF0") then
			counterIntLimit <= CounterIntLimit + 1;
			IntLimitOffset <= '0';
		else
			counterIntLimit <= (others => '0');
			IntLimitOffset <= '1';
		end if;
		
			IntLimitOffsetAccum <= IntLimitOffsetAccum + IntLimitOffset;
		

	elsif(StateStart_signal = "00100") then -- Increasing Voltages

		RampEnableLatch_signal <= RampEnable;
		LoopEnableLatch_signal <= LoopEnable;
		TuningEnableLatch_signal <= TuningEnable;
		FFEnableLatch_signal <= FFEnable;
		AmpLoopEnable_signal <= AmpLoopEnable;
		PhLoopEnable_signal <= PhLoopEnable;
		LoopEnable_FastPI_signal <= LoopEnable_FastPI;	
		IntLimitLatch_signal <= IntLimit;
		LookRefLatch_signal <= LookRef;	
		AmpRampInit_latch_signal <= AmpRampInit;
		PhRampInit_latch_signal <= PhRampInit;	
		
		if(RampEnable = '0') then		
			AmpRefIn_latch_signal <= AmpRefIn;
			PhRefIn_Latch_signal <= PhRefIn;
			AmpRampEnd_latch_signal <= AmpRampInit;
			PhRampEnd_latch_signal <= PhRampInit;		
			if(AmpRefOld = AmpRefIn and StateStart_signal < CommandStart) then		
				StateStart_signal <= "00101"; -- Cavity ready for operation with beam in CW mode
			end if;
		else
			AmpRefIn_latch_signal <= AmpRefMin;
			PhRefIn_Latch_signal <= PhRefMin;
			AmpRampEnd_latch_signal <= AmpRampEnd;
			PhRampEnd_latch_signal <= PhRampEnd;
			if(RampingState = "11" and StateStart_signal < CommandStart) then
				StateStart_signal <= "00110"; -- Cavity ready for operation in ramping mode for Booster
			end if;
		end if;		

	elsif(StateStart_signal = "00110" or StateStart_signal = "00101") then
		LoopEnableLatch_signal <= LoopEnable;		
		RampEnableLatch_signal <= RampEnable;		
		IntLimitLatch_signal <= IntLimit;
		LookRefLatch_signal <= LookRef;
		AmpRefIn_Latch_signal <= AmpRefIn;
		PhRefIN_Latch_signal <= PhRefIn;	
		TuningEnableLatch_signal <= TuningEnable;
		FFEnableLatch_signal <= FFEnable;
		AmpLoopEnable_signal <= AmpLoopEnable;
		PhLoopEnable_signal <= PhLoopEnable;
		LoopEnable_FastPI_signal <= LoopEnable_FastPI;
		StateStart_signal <= CommandStart;
		AmpRampEnd_Latch_signal <= AmpRampEnd;
		PhRampEnd_Latch_signal <= PhRampEnd;
		AmpRampINit_Latch_signal <= AmpRampInit;
		PhRampINit_Latch_signal <= PhRampINit;
		
		
		if(CommandStart = "01000") then
			StateStart_signal <= "01000"; -- command to stop RF plant
		end if;
	elsif(StateStart_signal ="01000") then -- or SpareDI1 = '0') then
		AmpRefIn_Latch_signal <= AmpRefMin;
		PhRefIN_Latch_signal <= PhRefMin;	
		AmpRampEnd_latch_signal <= AmpRefMin;
		PhRampEnd_latch_signal <= PhRefMin;
		AmpRampEnd_latch_signal <= AmpRefMin;
		PhRampEnd_latch_signal <= PhRefMin;
		if(AmpRefOld = AmpRefMin) then -- when power has decreased to minimum, disable all loops and inform transmitter
			StateStart_signal <= "01001";
			LoopEnableLatch_signal <= '0';
			RampEnableLatch_signal <= '0';
			TuningEnableLatch_signal <= '0';
			FFEnableLatch_signal <= '0';
			AmpLoopEnable_signal <= '0';
			PhLoopEnable_signal <= '0';
			LoopEnable_FastPI_signal <= '0';
			SpareDO1 <= '1';
		end if;		
	end if;
end if;
end process;


end StartUp_arc;

