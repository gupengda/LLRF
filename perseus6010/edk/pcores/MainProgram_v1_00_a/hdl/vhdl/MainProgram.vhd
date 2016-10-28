	---File MainProgram.vhd;----

library ieee;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY MainProgram IS

	PORT ( VCav : in std_logic_vector (15 downto 0);
			 FwCav : in std_logic_vector (15 downto 0);
			 RvCav : in std_logic_vector (15 downto 0);
			 MO : in std_logic_vector (15 downto 0);
			 FwIOT1 : in std_logic_vector (15 downto 0);
			 RvIOT1 : in std_logic_vector (15 downto 0);
			 
			 DACsIF : in std_logic_vector (15 downto 0);
			 
			 RFIn7 : in std_logic_vector (15 downto 0);
			 RFIn8 : in std_logic_vector (15 downto 0);
			 RFIn9 : in std_logic_vector (15 downto 0);
			 RFIn10 : in std_logic_vector (15 downto 0);
			 RFIn11 : in std_logic_vector (15 downto 0);
			 RFIn12 : in std_logic_vector (15 downto 0);
			 RFIn13 : in std_logic_vector (15 downto 0);
			 RFIn14 : in std_logic_vector (15 downto 0);
			 RFIn15 : in std_logic_vector (15 downto 0);
			 
			 reg_data1_input : in std_logic_vector(31 downto 0);
			 reg_data2_input : in std_logic_vector (15 downto 0);
			 reg_data2_output : out std_logic_vector (15 downto 0);
			 reg_data3_input : in std_logic_vector (16 downto 0);
			 reg_data3_output : out std_logic_vector (31 downto 0);
			 
			 Interface_01 : out std_logic_vector (15 downto 0);
			 Interface_02 : out std_logic_vector (15 downto 0);
			 Interface_03 : out std_logic_vector (15 downto 0);
			 Interface_04 : out std_logic_vector (15 downto 0);
			 Interface_05 : out std_logic_vector (15 downto 0);
			 Interface_06 : out std_logic_vector (15 downto 0);
			 Interface_07 : out std_logic_vector (15 downto 0);
			 Interface_08 : out std_logic_vector (15 downto 0);		 
			 			 
			 Control1 : out std_logic_vector (15 downto 0);
			 Control2 : out std_logic_vector (15 downto 0);
			 Control3 : out std_logic_vector (15 downto 0);
			 Control4 : out std_logic_vector (15 downto 0);
			 Control5_VCav : out std_logic_vector (15 downto 0);
			 Control8_IFDACs : out std_logic_vector (15 downto 0);
			 
			 gpio_input : in std_logic_vector (12 downto 0);
			 gpio_output : out std_logic_vector(10 downto 0);
			 
			 clk : in std_logic;
			 FDL_Trig_out : out std_logic;
			 PinDiodeSw : out std_logic;
			 LLRFItckOut : out std_logic;
			 LLRFItckIn : in std_logic;
			 TRG3Hz	: in std_logic;
			 Conf : in std_logic_vector (1 downto 0));
			 
end MainProgram;

ARCHITECTURE MainProgram_arc OF MainProgram is

  
 ------------------------------------------------------------------------------
  ----LLRF Signals definition----------------------------------------------------
  
	-- common RF signals to 3 cavities configuration: NC (conf 0 or 1), SC (conf 2), Bo (conf 3)					
	signal VCav_16b		: std_logic_vector (15 downto 0);
	signal FwCav_16b		: std_logic_vector (15 downto 0);
	signal RvCav_16b		: std_logic_vector (15 downto 0);
	signal MO_16b			: std_logic_vector (15 downto 0);
	signal FwIOT1_16b		: std_logic_vector (15 downto 0);
	signal RvIOT1_16b		: std_logic_vector (15 downto 0);
	signal FwIOT2_VCell2_16b		: std_logic_vector (15 downto 0);
	signal RvIOT2_VCell4_16b		: std_logic_vector (15 downto 0);
	
	signal DACsIF_16b			: std_logic_vector (15 downto 0);	
	
	-- Spare RF Signals - to be used or not depending on cavity configuration
	signal RFIn7_16b		: std_logic_vector (15 downto 0);
	signal RFIn8_16b		: std_logic_vector (15 downto 0);
	signal RFIn9_16b		: std_logic_vector (15 downto 0);
	signal RFIn10_16b		: std_logic_vector (15 downto 0);
	signal RFIn11_16b		: std_logic_vector (15 downto 0);
	signal RFIn12_16b		: std_logic_vector (15 downto 0);
	signal RFIn13_16b		: std_logic_vector (15 downto 0);
	signal RFIn14_16b		: std_logic_vector (15 downto 0);
	signal RFIn15_16b		: std_logic_vector (15 downto 0);
  
	-- control signals
   signal IControl, IControl1PS, IControl2PS, IControl3PS, IControl4PS  : std_logic_vector (15 downto 0);
	signal QControl, QControl1PS, QControl2PS, QControl3PS, QControl4PS : std_logic_vector (15 downto 0);
	signal Control1Out_sig, Control2Out_sig, Control3Out_sig, Control4Out_sig : std_logic_vector (15 downto 0);
	signal IControl1Gain, QControl1Gain : std_logic_vector (15 downto 0);
	signal IControl2Gain, QControl2Gain : std_logic_vector (15 downto 0);
	signal IControl3Gain, QControl3Gain : std_logic_vector (15 downto 0);
	signal IControl4Gain, QControl4Gain : std_logic_vector (15 downto 0);
	signal IControl1, QControl1 : std_logic_vector (15 downto 0);
	signal IControl2, QControl2 : std_logic_vector (15 downto 0);	
	signal IControl3, QControl3 : std_logic_vector (15 downto 0);	
	signal IControl4, QControl4 : std_logic_vector (15 downto 0);	
	signal IControl1L, QControl1L : std_logic_vector (15 downto 0);
	signal IControl2L, QControl2L : std_logic_vector (15 downto 0);
	signal IControl3L, QControl3L : std_logic_vector (15 downto 0);
	signal IControl4L, QControl4L : std_logic_vector (15 downto 0);
	signal IControl1LC, QControl1LC : std_logic_vector (15 downto 0);
	signal IControl2LC, QControl2LC : std_logic_vector (15 downto 0);
	signal IControl3LC, QControl3LC : std_logic_vector (15 downto 0);
	signal IControl4LC, QControl4LC : std_logic_vector (15 downto 0);
	signal IControl1Mean, QControl1Mean : std_logic_vector (15 downto 0);
	signal IControl2Mean, QControl2Mean : std_logic_vector (15 downto 0);		
	signal IControl3Mean, QControl3Mean : std_logic_vector (15 downto 0);		
	signal IControl4Mean, QControl4Mean : std_logic_vector (15 downto 0);		
	
	signal IControl1Out_sig : std_logic_vector (15 downto 0);
	signal QControl1Out_sig : std_logic_vector (15 downto 0);
	signal IControl2Out_sig : std_logic_vector (15 downto 0);
	signal QControl2Out_sig : std_logic_vector (15 downto 0);
	signal IControl3Out_sig : std_logic_vector (15 downto 0);
	signal QControl3Out_sig : std_logic_vector (15 downto 0);
	signal IControl4Out_sig : std_logic_vector (15 downto 0);
	signal QControl4Out_sig : std_logic_vector (15 downto 0);
  
   ---IQ Demux signals
	signal IMO, QMO : std_logic_vector (15 downto 0);
	--signal IMOFilter, QMOFilter : std_logic_vector (15 downto 0);
	
	signal ICav : std_logic_vector (15 downto 0);
	signal QCav : std_logic_vector (15 downto 0);
	signal IFw : std_logic_vector (15 downto 0);
	signal QFw : std_logic_vector (15 downto 0);
	signal IMuxCav : std_logic_vector (15 downto 0);
	signal QMuxCav : std_logic_vector (15 downto 0);
			
	signal IFwIOT1, IFwIOT2, IFwIOT3, IFwIOT4 : std_logic_vector (15 downto 0);
	signal QFwIOT1, QFwIOT2, QFwIOT3, QFwIOT4 : std_logic_vector (15 downto 0);	
	signal IFwIOT1Mean, IFwIOT2Mean, IFwIOT3Mean, IFwIOT4Mean : std_logic_vector (15 downto 0);
	signal QFwIOT1Mean, QFwIOT2Mean, QFwIOT3Mean, QFwIOT4Mean : std_logic_vector (15 downto 0);	
	signal IFwIOT1L, IFwIOT2L, IFwIOT3L, IFwIOT4L : std_logic_vector (15 downto 0);
	signal QFwIOT1L, QFwIOT2L, QFwIOT3L, QFwIOT4L : std_logic_vector (15 downto 0);	
	signal ICell2, QCell2, ICell4, QCell4 : std_logic_vector (15 downto 0);
	
	signal ICell2L, QCell2L, ICell4L, QCell4L : std_logic_vector (15 downto 0);	
	signal ICell2Mean, QCell2Mean, ICell4Mean, QCell4Mean : std_logic_vector (15 downto 0);
		
	signal IRFIn7 , QRFIn7  : std_logic_vector (15 downto 0);
	signal IRFIn8 , QRFIn8  : std_logic_vector (15 downto 0);
	signal IRFIn9 , QRFIn9  : std_logic_vector (15 downto 0);
	signal IRFIn10, QRFIn10 : std_logic_vector (15 downto 0);
	signal IRFIn11, QRFIn11 : std_logic_vector (15 downto 0);
	signal IRFIn12, QRFIn12 : std_logic_vector (15 downto 0);
	signal IRFIn13, QRFIn13 : std_logic_vector (15 downto 0);
	signal IRFIn14, QRFIn14 : std_logic_vector (15 downto 0);
	signal IRFIn15, QRFIn15 : std_logic_vector (15 downto 0);
	
	signal IRFIn7Mean, QRFIn7Mean : std_logic_vector (15 downto 0);
	signal IRFIn8Mean, QRFIn8Mean : std_logic_vector (15 downto 0);
	signal IRFIn9Mean, QRFIn9Mean : std_logic_vector (15 downto 0);
	signal IRFIn10Mean, QRFIn10Mean : std_logic_vector (15 downto 0);
	signal IRFIn11Mean, QRFIn11Mean : std_logic_vector (15 downto 0);
	signal IRFIn12Mean, QRFIn12Mean : std_logic_vector (15 downto 0);
	signal IRFIn13Mean, QRFIn13Mean : std_logic_vector (15 downto 0);
	signal IRFIn14Mean, QRFIn14Mean : std_logic_vector (15 downto 0);
	signal IRFIn15Mean, QRFIn15Mean : std_logic_vector (15 downto 0);
	
	signal IRFIn7L, QRFIn7L : std_logic_vector (15 downto 0);
	signal IRFIn8L, QRFIn8L : std_logic_vector (15 downto 0);
	signal IRFIn9L, QRFIn9L : std_logic_vector (15 downto 0);
	signal IRFIn10L, QRFIn10L : std_logic_vector (15 downto 0);
	signal IRFIn11L, QRFIn11L : std_logic_vector (15 downto 0);
	signal IRFIn12L, QRFIn12L : std_logic_vector (15 downto 0);
	signal IRFIn13L, QRFIn13L : std_logic_vector (15 downto 0);
	signal IRFIn14L, QRFIn14L : std_logic_vector (15 downto 0);
	signal IRFIn15L, QRFIn15L : std_logic_vector (15 downto 0);
	
	signal IDACsIF, QDACsIF : std_logic_vector (15 downto 0);
	signal IDACsIFL, QDACsIFL : std_logic_vector (15 downto 0);
	signal IDACsIFMean, QDACsIFMean : std_logic_vector (15 downto 0);
	
	signal IMOMean, QMOMean : std_logic_vector (15 downto 0);
	signal IMOL, QMOL : std_logic_vector (15 downto 0);
		
	signal quad : std_logic_vector (1 downto 0);
	
	
	-- Slave loops
	signal IControl_Rect : std_logic_vector (15 downto 0);
	signal QControl_Rect : std_logic_vector (15 downto 0);
	signal IControl_FastPI : std_logic_vector (15 downto 0);
	signal QControl_FastPI : std_logic_vector (15 downto 0);
	signal IError_FastPI : std_logic_vector (15 downto 0);
	signal QError_FastPI : std_logic_vector (15 downto 0);
	signal IErrorAccum_FastPI : std_logic_vector (15 downto 0);
	signal QErrorAccum_FastPI : std_logic_vector (15 downto 0);
	signal Kp_FastPi : std_logic_vector (15 downto 0);
	signal Ki_FastPi : std_logic_vector (15 downto 0);
	
	signal IControl_PIDMean, IControl_PIDL : std_logic_vector (15 downto 0);
	signal QControl_PIDMean, QControl_PIDL : std_logic_vector (15 downto 0);
	signal IControl_FastPIMean, IControl_FastPIL: std_logic_vector (15 downto 0);
	signal QControl_FastPIMean, QControl_FastPIL : std_logic_vector (15 downto 0);
	signal ILoopInputMean, QLoopInputMean : std_logic_vector (15 downto 0);
	signal ILoopInputL, QLoopInputL : std_logic_vector (15 downto 0);
	signal IInput_FastPIMean, QInput_FastPIMean : std_logic_vector (15 downto 0);
	signal IInput_FastPIL, QInput_FastPIL : std_logic_vector (15 downto 0);
	
	signal IInput_FastPI : std_logic_vector (15 downto 0);
	signal QInput_FastPI : std_logic_vector (15 downto 0);
	signal IRef_FastPI : std_logic_vector (15 downto 0);
	signal QRef_FastPI : std_logic_vector (15 downto 0);
	signal LoopEnable_FastPI : std_logic;
	signal LoopEnable_FastPI_latch : std_logic;
	
	signal IControl_Polar : std_logic_vector (15 downto 0);
	signal QControl_Polar : std_logic_vector (15 downto 0);
	signal Amp_AmpLoopInput : std_logic_vector (16 downto 0);
	signal Ph_AmpLoopInput : std_logic_vector (15 downto 0);
	signal Amp_PhLoopInput : std_logic_vector (16 downto 0);
	signal Ph_PhLoopInput : std_logic_vector (15 downto 0);
	signal IAmpLoop : std_logic_vector (15 downto 0);
	signal QAmpLoop : std_logic_vector (15 downto 0);
	signal IPhLoop : std_logic_vector (15 downto 0);
	signal QPhLoop : std_logic_vector (15 downto 0);
	signal PolarLoopInputSelection_amp : std_logic_vector (2 downto 0);
	signal PolarLoopInputSelection_ph : std_logic_vector (2 downto 0);
	
	--Enables and external parameters
	signal	kp 				 	 : std_logic_vector (15 downto 0);		
	signal	ki						 : std_logic_vector (15 downto 0);
	signal	sin					 : std_logic_vector (15 downto 0);	
	signal	cos					 : std_logic_vector (15 downto 0);	
	signal	LoopEnable			 : std_logic;	
	signal	LoopEnableLatch	 : std_logic;				
	signal	PhaseShiftEnable	 : std_logic;					
	signal	ExtRefEnable		 : std_logic;					
	signal	ResetKi				 : std_logic;		
	signal	IntLimit				 : std_logic_vector (15 downto 0);	
	signal	IntLimit1			 : std_logic_vector (15 downto 0);	
	signal	IntLimitLatch		 : std_logic_vector (15 downto 0);		
	signal	SquareRefEnable    : std_logic;						
	signal	FreqSquare		    : std_logic_vector (15 downto 0);				
	signal	TuningEnable		 : std_logic;					
	signal	TuningEnableLatch	 : std_logic;				
	signal	NumSteps				 : std_logic_vector (15 downto 0);	
	signal	MoveUp1				 : std_logic;	
	signal	MovePLG1					 : std_logic;
	signal	MoveUp2				 : std_logic;	
	signal	MovePLG2					 : std_logic;
	signal	TunFFOnTopEnable		 : std_logic;
	signal	CLKperPulse			 : std_logic_vector (2 downto 0);	
	signal	DACsPhaseShiftEnable  : std_logic;					
	signal	TunPosEnable		 : std_logic;			
	signal	PhaseOffset			 : std_logic_vector (15 downto 0);	
	
	
	signal	sin_phsh_control1			 : std_logic_vector (15 downto 0);	
	signal	cos_phsh_control1			 : std_logic_vector (15 downto 0);
	signal	sin_phsh_control2			 : std_logic_vector (15 downto 0);
	signal	cos_phsh_control2			 : std_logic_vector (15 downto 0);
	signal	sin_phsh_control3			 : std_logic_vector (15 downto 0);
	signal	cos_phsh_control3			 : std_logic_vector (15 downto 0);
	signal	sin_phsh_control4			 : std_logic_vector (15 downto 0);
	signal	cos_phsh_control4			 : std_logic_vector (15 downto 0);
	
	signal	GainControl1 : std_logic_vector (15 downto 0);
	signal	GainControl2 : std_logic_vector (15 downto 0);
	signal	GainControl3 : std_logic_vector (15 downto 0);
	signal	GainControl4 : std_logic_vector (15 downto 0);
	signal 	GainOL, GainOL1 : std_logic_vector (7 downto 0);
		
	-- Ramping
	signal	RampEnable : std_logic;	
	signal	RampEnableLatch : std_logic;	
	signal	AmpRampInit: std_logic_vector (15 downto 0);
	signal 	AmpRampEnd: std_logic_vector (15 downto 0);
	signal	PhRampInit: std_logic_vector (15 downto 0);
	signal	PhRampEnd: std_logic_vector (15 downto 0);
	signal 	AmpRampUpSlope : std_logic_vector (15 downto 0);
	signal 	AmpRampDownSlope : std_logic_vector (15 downto 0);
	signal 	PhRampUpSlope : std_logic_vector (15 downto 0);
	signal 	PhRampDownSlope : std_logic_vector (15 downto 0);	
	signal 	RampingState : std_logic_vector (1 downto 0);
	signal 	t1ramping : std_logic_vector (15 downto 0);
	signal 	t2ramping : std_logic_vector (15 downto 0);
	signal 	t3ramping : std_logic_vector (15 downto 0);
	signal 	t4ramping : std_logic_vector (15 downto 0);
	signal 	RampIncRate : std_logic_vector (15 downto 0);
	
	signal 	AmpRampInit_latch : std_logic_vector (15 downto 0);
	signal 	PhRampINit_latch : std_logic_vector (15 downto 0);
	signal 	AmpRampEnd_latch : std_logic_vector (15 downto 0);
	signal 	PhRampEnd_latch : std_logic_vector (15 downto 0);
		
	signal 	AmpRefIn : std_logic_vector (15 downto 0);
	signal 	PhRefIn : std_logic_vector (15 downto 0);
	signal	AmpRefMin : std_logic_vector (15 downto 0);
	signal 	PhRefMin : std_logic_vector (15 downto 0);
	signal 	PhIncRate : std_logic_vector (2 downto 0);	
	
	signal 	TopRampAmp : std_logic_vector (15 downto 0);
	signal	AmpRamp : std_logic_vector (15 downto 0);
	signal 	PhRamp : std_logic_vector (15 downto 0);	
	
	signal ICell3Top : std_logic_vector (15 downto 0);
	signal QCell3Top : std_logic_vector (15 downto 0);
	signal ICell2Top : std_logic_vector (15 downto 0);
	signal QCell2Top : std_logic_vector (15 downto 0);
	signal ICell4Top : std_logic_vector (15 downto 0);
	signal QCell4Top : std_logic_vector (15 downto 0);
	signal IFwIOT1Top : std_logic_vector (15 downto 0);
	signal QFwIOT1Top : std_logic_vector (15 downto 0);
	signal IRvIOT1Top : std_logic_vector (15 downto 0);
	signal QRvIOT1Top : std_logic_vector (15 downto 0);
	signal IRvCavTop : std_logic_vector (15 downto 0);
	signal QRvCavTop : std_logic_vector (15 downto 0);
	signal TuningDephaseTop : std_logic_vector (15 downto 0);
	signal FFErrorTop : std_logic_vector (15 downto 0);
	signal IRefTop : std_logic_vector (15 downto 0);
	signal QRefTop : std_logic_vector (15 downto 0);
	signal IcontrolTop : std_logic_vector (15 downto 0);
	signal QControlTop : std_logic_vector (15 downto 0);
	signal IErrorTop : std_logic_vector (15 downto 0);
	signal QErrorTop : std_logic_vector (15 downto 0);	
	signal ICell3Bottom : std_logic_vector (15 downto 0);
	signal QCell3Bottom : std_logic_vector (15 downto 0);
	signal ICell2Bottom : std_logic_vector (15 downto 0);
	signal QCell2Bottom : std_logic_vector (15 downto 0);
	signal ICell4Bottom : std_logic_vector (15 downto 0);
	signal QCell4Bottom : std_logic_vector (15 downto 0);
	signal IFwIOT1Bottom : std_logic_vector (15 downto 0);
	signal QFwIOT1Bottom : std_logic_vector (15 downto 0);
	signal IRvIOT1Bottom : std_logic_vector (15 downto 0);
	signal QRvIOT1Bottom : std_logic_vector (15 downto 0);
	signal IRvCavBottom : std_logic_vector (15 downto 0);
	signal QRvCavBottom : std_logic_vector (15 downto 0);
	signal TuningDephaseBottom : std_logic_vector (15 downto 0);
	signal FFErrorBottom : std_logic_vector (15 downto 0);
	signal IRefBottom : std_logic_vector (15 downto 0);
	signal QRefBottom : std_logic_vector (15 downto 0);
	signal IcontrolBottom : std_logic_vector (15 downto 0);
	signal QControlBottom : std_logic_vector (15 downto 0);
	signal IErrorBottom : std_logic_vector (15 downto 0);
	signal QErrorBottom : std_logic_vector (15 downto 0);
	signal IFwCavTop : std_logic_vector (15 downto 0);
	signal QFwCavTop : std_logic_vector (15 downto 0);
	signal IFwCavBottom : std_logic_vector (15 downto 0);
	signal QFwCavBottom : std_logic_vector (15 downto 0);
	
	
	signal ICell3TopL : std_logic_vector (15 downto 0);
	signal QCell3TopL : std_logic_vector (15 downto 0);
	signal ICell2TopL : std_logic_vector (15 downto 0);
	signal QCell2TopL : std_logic_vector (15 downto 0);
	signal ICell4TopL : std_logic_vector (15 downto 0);
	signal QCell4TopL : std_logic_vector (15 downto 0);
	signal IFwIOT1TopL : std_logic_vector (15 downto 0);
	signal QFwIOT1TopL : std_logic_vector (15 downto 0);
	signal IRvIOT1TopL : std_logic_vector (15 downto 0);
	signal QRvIOT1TopL : std_logic_vector (15 downto 0);
	signal IRvCavTopL : std_logic_vector (15 downto 0);
	signal QRvCavTopL : std_logic_vector (15 downto 0);
	signal TuningDephaseTopL : std_logic_vector (15 downto 0);
	signal FFErrorTopL : std_logic_vector (15 downto 0);
	signal IRefTopL : std_logic_vector (15 downto 0);
	signal QRefTopL : std_logic_vector (15 downto 0);
	signal IcontrolTopL : std_logic_vector (15 downto 0);
	signal QControlTopL : std_logic_vector (15 downto 0);
	signal IErrorTopL : std_logic_vector (15 downto 0);
	signal QErrorTopL : std_logic_vector (15 downto 0);	
	signal ICell3BottomL : std_logic_vector (15 downto 0);
	signal QCell3BottomL : std_logic_vector (15 downto 0);
	signal ICell2BottomL : std_logic_vector (15 downto 0);
	signal QCell2BottomL : std_logic_vector (15 downto 0);
	signal ICell4BottomL : std_logic_vector (15 downto 0);
	signal QCell4BottomL : std_logic_vector (15 downto 0);
	signal IFwIOT1BottomL : std_logic_vector (15 downto 0);
	signal QFwIOT1BottomL : std_logic_vector (15 downto 0);
	signal IRvIOT1BottomL : std_logic_vector (15 downto 0);
	signal QRvIOT1BottomL : std_logic_vector (15 downto 0);
	signal IRvCavBottomL : std_logic_vector (15 downto 0);
	signal QRvCavBottomL : std_logic_vector (15 downto 0);
	signal TuningDephaseBottomL : std_logic_vector (15 downto 0);
	signal FFErrorBottomL : std_logic_vector (15 downto 0);
	signal IRefBottomL : std_logic_vector (15 downto 0);
	signal QRefBottomL : std_logic_vector (15 downto 0);
	signal IcontrolBottomL : std_logic_vector (15 downto 0);
	signal QControlBottomL : std_logic_vector (15 downto 0);
	signal IErrorBottomL : std_logic_vector (15 downto 0);
	signal QErrorBottomL : std_logic_vector (15 downto 0);
	signal IFwCavTopL : std_logic_vector (15 downto 0);
	signal QFwCavTopL : std_logic_vector (15 downto 0);
	signal IFwCavBottomL : std_logic_vector (15 downto 0);
	signal QFwCavBottomL : std_logic_vector (15 downto 0);
	signal average_update_ramping : std_logic;
				
	

	-- Polar Loops Signals
	signal LoopInputSel	: std_logic_vector (2 downto 0);
	signal PolarLoopsEnable	: std_logic;
	signal LoopInputSel_FastPI	: std_logic_vector (2 downto 0);
	signal IntLimit_FastPI : std_logic_vector (15 downto 0);
	
	signal AmpLoopenable : std_logic;
	signal AmpLoopenable_latch : std_logic;
	signal AmpLoop_kp : std_logic_vector (15 downto 0);
	signal AmpLoop_ki : std_logic_vector (15 downto 0);
	signal PhLoopenable : std_logic;
	signal PhLoopenable_latch : std_logic;
	signal AnyLoopsEnable_latch : std_logic;
	signal PhLoop_kp : std_logic_vector (15 downto 0);
	signal PhLoop_ki : std_logic_vector (15 downto 0);
	signal PhCorrectionControl_Enable : std_logic;
	signal PhCorrectionControl_reset : std_logic;
	
	signal IPolarAmpLoop : std_logic_vector (15 downto 0);
	signal QPolarAmpLoop : std_logic_vector (15 downto 0);
	signal IPolarPhLoop : std_logic_vector (15 downto 0);
	signal QPolarPhLoop : std_logic_vector (15 downto 0);
	
	signal AmpLoop_ControlOutput : std_logic_vector (15 downto 0);
	signal AmpLoop_Error : std_logic_vector (15 downto 0);
	signal AmpLoop_ErrorAccum : std_logic_vector (15 downto 0);
	
	signal PhLoop_ControlOutput : std_logic_vector (15 downto 0);
	signal PhLoop_Error : std_logic_vector (15 downto 0);
	signal PhLoop_ErrorAccum : std_logic_vector (15 downto 0);
	
	signal PhCorrectionControl, PhCorrectionControlMean, PhCorrectionControlL : std_logic_vector (15 downto 0);
	signal PhCorrectionControl_32b : std_logic_vector (31 downto 0);
	signal Q_DACsIF_Out, I_DACsIF_Out : std_logic_vector (15 downto 0);
	signal PhCorrection_Error, PhCorrection_ErrorMean, PhCorrection_ErrorL : std_logic_vector (15 downto 0);
	signal PhaseCorrection_sig : std_logic_vector (15 downto 0);
	signal AmpSpare1 : std_logic_vector (16 downto 0);
	signal PhSpare1 : std_logic_vector (15 downto 0);
	signal AmpMO : std_logic_vector (16 downto 0);
	signal PhMO : std_logic_vector (15 downto 0);
	
		
	signal IPolarAmpLoopL			: std_logic_vector (15 downto 0);
	signal QPolarAmpLoopL           : std_logic_vector (15 downto 0);
	signal IPolarPhLoopL            : std_logic_vector (15 downto 0);
	signal QPolarPhLoopL            : std_logic_vector (15 downto 0);
	signal Amp_AmpLoopInputL        : std_logic_vector (15 downto 0);
	signal Ph_AmpLoopInputL         : std_logic_vector (15 downto 0);
	signal Amp_PhLoopInputL         : std_logic_vector (15 downto 0);
	signal Ph_PhLoopInputL          : std_logic_vector (15 downto 0);
	signal AmpLoop_ControlOutputL   : std_logic_vector (15 downto 0);
	signal AmpLoop_ErrorL           : std_logic_vector (15 downto 0);
	signal AmpLoop_ErrorAccumL      : std_logic_vector (15 downto 0);
	signal PhLoop_controlOutputL    : std_logic_vector (15 downto 0);
	signal PhLoop_ErrorL            : std_logic_vector (15 downto 0);
	signal PhLoop_ErrorAccumL 	     : std_logic_vector (15 downto 0);
	signal IControl_RectL          : std_logic_vector (15 downto 0);
	signal QControl_RectL          : std_logic_vector (15 downto 0);
	signal IControl_PolarL          : std_logic_vector (15 downto 0);
	signal QControl_PolarL          : std_logic_vector (15 downto 0);
		
		
	signal IPolarAmpLoopMean	       : std_logic_vector (15 downto 0);
	signal QPolarAmpLoopMean          : std_logic_vector (15 downto 0);
	signal IPolarPhLoopMean           : std_logic_vector (15 downto 0);
	signal QPolarPhLoopMean           : std_logic_vector (15 downto 0);
	signal Amp_AmpLoopInputMean       : std_logic_vector (15 downto 0);
	signal Ph_AmpLoopInputMean        : std_logic_vector (15 downto 0);
	signal Amp_PhLoopInputMean        : std_logic_vector (15 downto 0);
	signal Ph_PhLoopInputMean         : std_logic_vector (15 downto 0);
	signal AmpLoop_ControlOutputMean  : std_logic_vector (15 downto 0);
	signal AmpLoop_ErrorMean          : std_logic_vector (15 downto 0);
	signal AmpLoop_ErrorAccumMean     : std_logic_vector (15 downto 0);
	signal PhLoop_controlOutputMean   : std_logic_vector (15 downto 0);
	signal PhLoop_ErrorMean           : std_logic_vector (15 downto 0);
	signal PhLoop_ErrorAccumMean	    : std_logic_vector (15 downto 0);
	signal IControl_RectMean         : std_logic_vector (15 downto 0);
	signal QControl_RectMean         : std_logic_vector (15 downto 0);
	signal IControl_PolarMean         : std_logic_vector (15 downto 0);
	signal QControl_PolarMean         : std_logic_vector (15 downto 0);
	
	signal i_in_r2p_polarloops : std_logic_vector (15 downto 0);
	signal q_in_r2p_polarloops : std_logic_vector (15 downto 0);	
	signal Amp_out_r2p_PolarLoops : std_logic_vector (16 downto 0);	
	signal ph_out_r2p_polarloops : std_logic_vector (15 downto 0);	
	signal id_in_r2p_PolarLoops : std_logic_vector (3 downto 0);	
	signal id_out_r2p_PolarLoops : std_logic_vector (3 downto 0);	
	
		
    --PID Parameters
	signal Counter : std_logic_vector (3 downto 0);
	signal CounterRef : std_logic_vector (16 downto 0);

	signal IError : std_logic_vector (15 downto 0);
	signal IErrorAccum : std_logic_vector (15 downto 0);
	signal QError : std_logic_vector (15 downto 0);
	signal QErrorAccum : std_logic_vector (15 downto 0);
	signal IRefIn : std_logic_vector (15 downto 0);
	signal QRefIn : std_logic_vector (15 downto 0);
	
	-- Cordic Algorithm Signals  
	signal AngCavFw : std_logic_vector (15 downto 0);
	signal AngCavFw_latch : std_logic_vector (15 downto 0);
	signal AngCav : std_logic_vector (15 downto 0);
	signal AngFw : std_logic_vector (15 downto 0);
	
	signal State : std_logic_vector (1 downto 0);
	signal TuningOn : std_logic;
	signal TuningOnDelay : std_logic;
	signal TuningTrigger : std_logic;
	signal Tuninginput : std_logic_vector (15 downto 0);
	 
	signal AngCavFwFilt : std_logic_vector (15 downto 0);
	
	--Tuning and field flatness signals
	signal TTL1Signal : std_logic;
	signal TTL2Signal : std_logic;
	signal TTL3Signal : std_logic;
	signal TTL4Signal : std_logic;
	signal CountTTL : std_logic_vector (23 downto 0);
	signal NumCLK1_2 : std_logic_vector (23 downto 0);
	
	signal TTL1 : std_logic;
	signal TTL2 : std_logic;
	signal TTL3 : std_logic;
	signal TTL4 : std_logic;
	
	signal FwMin_Tuning : std_logic_vector (15 downto 0);
	signal FwMin_AmpPh : std_logic_vector (15 downto 0);
	
	signal MarginUp : std_logic_vector (15 downto 0);
	signal MarginLow : std_logic_vector (15 downto 0);
	signal NotMarginUp : std_logic_vector (15 downto 0);
	signal NotMarginLow : std_logic_vector (15 downto 0);
		
	signal TuningReset : std_logic;
	
	signal ForwardMin_Tuning : std_logic;
	signal ForwardMin_Amp : std_logic;
	signal ForwardMin_Ph : std_logic;
	signal ForwardMin_FastIQ : std_logic;
	signal ForwardMin_SlowIQ : std_logic;
	
	signal AmpCav : std_logic_vector (16 downto 0);
	signal AmpCavMean : std_logic_vector (15 downto 0);
	signal AmpFw : std_logic_vector (16 downto 0);	
	signal AmpFwMean : std_logic_vector (15 downto 0);	
	signal AmpCavL, AmpFwL : std_logic_vector (15 downto 0);
	
	signal PlungerMovingAuto : std_logic;
	signal PlungerMovingManual1 : std_logic;
	signal PlungerMoving_diag1 : std_logic;
	signal PlungerMovingUp_diag1 : std_logic;
	
	signal PlungerMovingAuto2 : std_logic;
	signal PlungerMovingManual2 : std_logic;
	signal PlungerMoving_diag2 : std_logic;
	signal PlungerMovingUp_diag2 : std_logic;
	
	signal FFOn : std_logic;
	signal FFError,FFErrorMean,FFErrorL : std_logic_vector (15 downto 0);
	signal FFPercentage : std_logic_vector (8 downto 0);
	signal AmpCell2Gain, AmpCell2Gain_sig : std_logic_vector (15 downto 0);
	signal AmpCell4Gain, AmpCell4Gain_sig : std_logic_vector (15 downto 0);
	signal AmpCell2 : std_logic_vector (16 downto 0);
	signal AmpCell4 : std_logic_vector (16 downto 0);
	signal PhCell2, PhCell4 : std_logic_vector (15 downto 0);
	signal AmpCell2FF : std_logic_vector (15 downto 0);
	signal AmpCell4FF : std_logic_vector (15 downto 0);
	signal AmpCell2Mean : std_logic_vector (15 downto 0);
	signal AmpCell4Mean : std_logic_vector (15 downto 0);
	signal FFEnable : std_logic;
	signal FFEnablelatch : std_logic;
	signal FFPos : std_logic;
	
	signal CounterTuningDelaySetting : std_logic_vector (15 downto 0);
	signal TuningDephase_Filt : std_logic_vector (15 downto 0);
	signal TuningDephase : std_logic_vector (15 downto 0);
	signal TuningDephase80HzLPFEnable : std_logic;
	signal TuningTriggerEnable : std_logic_vector (1 downto 0);
	
	--Conditioning
	signal Conditioning : std_logic;
	signal CounterCondition : std_logic_vector (23 downto 0);
	signal VoltIncRate : std_logic_vector (2 downto 0);
	signal PulseUp, PulseUp_sig : std_logic;

	--Diagnostics Signals
	
	signal ConditionDutyCycle : std_logic_vector (23 downto 0);
	signal ConditionDutyCycleDiag : std_logic_vector (15 downto 0);

	
	--Averaging Signals for diagnostics
	signal reg_data3_inL : std_logic;
	signal ICavMean : std_logic_vector (15 downto 0);
	signal ICavL : std_logic_vector (15 downto 0);
	signal QCavMean : std_logic_vector (15 downto 0);
	signal QCavL : std_logic_vector (15 downto 0);
	signal IControlMean : std_logic_vector (15 downto 0);
	signal IControlL : std_logic_vector (15 downto 0);
	
	signal QControlMean : std_logic_vector (15 downto 0);
	signal QControlL : std_logic_vector (15 downto 0);
	
	signal IErrorMean : std_logic_vector (15 downto 0);
	signal IErrorL : std_logic_vector (15 downto 0);
	signal QErrorMean : std_logic_vector (15 downto 0);
	signal QErrorL : std_logic_vector (15 downto 0);
	signal IErrorAccumMean : std_logic_vector (15 downto 0);
	signal IErrorAccumL : std_logic_vector (15 downto 0);
	signal QErrorAccumMean : std_logic_vector (15 downto 0);
	signal QErrorAccumL : std_logic_vector (15 downto 0);
	
	signal IFwMean : std_logic_vector (15 downto 0);
	signal IFwL : std_logic_vector (15 downto 0);
	signal QFwMean : std_logic_vector (15 downto 0);
	signal QFwL : std_logic_vector (15 downto 0);
	
	signal AngCavMean : std_logic_vector (15 downto 0);
	signal AngCavL : std_logic_vector (15 downto 0);
	signal AngFwMean : std_logic_vector (15 downto 0);
	signal AngFwL : std_logic_vector (15 downto 0);
	signal AngCavFwMean : std_logic_vector (15 downto 0);
	signal AngCavFwL : std_logic_vector (15 downto 0);
		
	signal IRefL : std_logic_vector (15 downto 0);
	signal QRefL : std_logic_vector (15 downto 0);

	
	--Demultiplexing by quadrants
	signal clkdemux: std_logic_vector (1 downto 0);
	signal WordQuad : std_logic_vector (3 downto 0);
	signal lookref: std_logic;
	signal LookRefLatch : std_logic;	
	signal LookRefManual : std_logic;	
	signal ManualOffset : std_logic_vector (1 downto 0);	
	
	signal FilterCav : std_logic;		
	
	--Automatic Conditioning	
	signal AutomaticConditioning : std_logic;
	signal Vacuum : std_logic;
	
	-- Interlock inputs and outputs
	signal ITCKOut_SetLLRF2STBY_sig : std_logic;
	signal LLRFItckOut2PLC_sig : std_logic;
	signal PinDiodeSw_sig : std_logic;
	signal LLRFItckOut2LLRF_sig : std_logic;
	
		
	-- RFOnState Enable
	signal RFONState, RFONState_Delay : std_logic;
	signal RFONState_Counter : std_logic_vector (27 downto 0);
	signal RFONState_Disable : std_logic;
	
	-- DACs Disable signal
	signal FIM_ITCK, FIM_ITCK_Delay	: std_logic;
	signal FIM_ITCK_counter 	: std_logic_vector (3 downto 0);
	signal FIM_ITCK_Disable : std_logic;	
	
	--VCXO Programming signals
	signal MDivider : std_logic_vector (9 downto 0);
	signal NDivider : std_logic_vector (9 downto 0);
	signal MuxSel : std_logic_vector (2 downto 0);
	signal Mux0 : std_logic_vector (2 downto 0);
	signal Mux1 : std_logic_vector (2 downto 0);
	signal Mux2 : std_logic_vector (2 downto 0);
	signal Mux3 : std_logic_vector (2 downto 0);
	signal Mux4 : std_logic_vector (2 downto 0);
	signal VCXO_Powered, VCXO_Ref, VCXO_Locked : std_logic;
	signal SendWordVCXO : std_logic;
	signal CP_Dir : std_logic;
	signal gpio_out_inversion : std_logic;
	signal VCXO_Enable : std_logic;
	signal VCXO_word : std_logic;
	signal VCXO_clk : std_logic;			
			
	-- Automatic Startup
	signal Automatic_StartUp_Enable : std_logic;
	signal CommandStart: std_logic_vector (4 downto 0);
	signal StateStart : std_logic_vector (4 downto 0);
	signal IRefMin : std_logic_vector (15 downto 0);
	signal QRefMin : std_logic_vector (15 downto 0);
	signal counterIntLimit : std_logic_vector (15 downto 0);
	signal IntLimitOffsetAccum : std_logic_vector (15 downto 0);
	
	signal ILoopClosed, QLoopClosed : std_logic;
	signal AmpLoopClosed, PhLoopClosed : std_logic;
	
	
	signal AmpRefIn_latch : std_logic_vector (15 downto 0);
	signal PhRefIn_latch : std_logic_vector (15 downto 0);
	
	signal AmpRefOld : std_logic_vector (15 downto 0);
	signal PhRefOld : std_logic_vector (15 downto 0);
	
	
	-- Fast Data Logger Signals

	
	-- Decoding of settings addresses
	signal reg_data1_in_add				: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_loops 	: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_startup : std_logic_vector (15 downto 0);
	signal reg_data1_in_data_enables	: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_cond		: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_tuning	: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_ramping	: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_vcxo		: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_FDL		: std_logic_vector (15 downto 0);
	signal reg_data1_in_data_FIM		: std_logic_vector (15 downto 0);
	
	signal reg_data3_out_LSB 			: std_logic_vector (15 downto 0);
	signal reg_data3_out_MSB 			: std_logic_vector (15 downto 0);
	
	-- cordic signals
	signal I_in_r2p : std_logic_vector (15 downto 0);
	signal Q_in_r2p : std_logic_vector (15 downto 0);
	signal id_in_r2p : std_logic_vector (3 downto 0);
	signal Amp_out_r2p : std_logic_vector (16 downto 0);
	signal Ph_out_r2p : std_logic_vector (15 downto 0);
	signal mux_r2p : std_logic_vector (3 downto 0);
	signal id_out_r2p : std_logic_vector (3 downto 0);
	
	-- FDL
	signal FDL_trig_HW_input : std_logic; 
	signal FDL_trig_SW_input : std_logic; 	
	signal FDL_trig_out_sig : std_logic; 	
	
	-- GPIO  Spares	
	signal SpareDI1, SpareDO1 : std_logic;
	
	-- Phase Shifters to be applied to Loop Inputs signals
	signal CavPhSh : std_logic_vector (15 downto 0);
	signal sin_phsh_cav, cos_phsh_cav : std_logic_vector (15 downto 0);
	signal FwCavPhSh, FwCavGain : std_logic_vector (15 downto 0);
	signal sin_phsh_Fwcav, cos_phsh_Fwcav : std_logic_vector (15 downto 0);
	signal FwIOT1PhSh, FwIOT1Gain : std_logic_vector (15 downto 0);
	signal FwIOT2PhSh, FwIOT2Gain : std_logic_vector (15 downto 0);
	signal FwIOT3PhSh, FwIOT3Gain : std_logic_vector (15 downto 0);
	signal FwIOT4PhSh, FwIOT4Gain : std_logic_vector (15 downto 0);
	signal sin_phsh_FwIOT1, cos_phsh_FwIOT1 : std_logic_vector (15 downto 0);
	signal sin_phsh_FwIOT2, cos_phsh_FwIOT2 : std_logic_vector (15 downto 0);
	signal sin_phsh_FwIOT3, cos_phsh_FwIOT3 : std_logic_vector (15 downto 0);
	signal sin_phsh_FwIOT4, cos_phsh_FwIOT4 : std_logic_vector (15 downto 0);
	
	-- demux outputs
	signal IMuxFwCav, QMuxFwCav : std_logic_vector (15 downto 0);
	signal IRvCav, QRvCav : std_logic_vector (15 downto 0);
	signal IRvIOT1, QRvIOT1 : std_logic_vector (15 downto 0);
	signal IRvIOT2, QRvIOT2 : std_logic_vector (15 downto 0);
	signal IRvIOT3, QRvIOT3 : std_logic_vector (15 downto 0);
	signal IRvIOT4, QRvIOT4 : std_logic_vector (15 downto 0);
	signal IRvIOT3_ICell2, QRvIOT3_QCell2 : std_logic_vector (15 downto 0);
	signal IRvIOT4_ICell4, QRvIOT4_QCell4 : std_logic_vector (15 downto 0);
	signal AmpRvIOT3_Cell2_sig : std_logic_vector (16 downto 0);
	signal PhRvIOT3_Cell2_sig : std_logic_vector (15 downto 0);
	signal AmpRvIOT4_Cell4_sig : std_logic_vector (16 downto 0);
	signal PhRvIOT4_Cell4_sig : std_logic_vector (15 downto 0);
	signal IMuxFwIOT1, QMuxFwIOT1 : std_logic_vector (15 downto 0);
	signal IMuxFwIOT2, QMuxFwIOT2 : std_logic_vector (15 downto 0);
	signal IMuxFwIOT3, QMuxFwIOT3 : std_logic_vector (15 downto 0);
	signal IMuxFwIOT4, QMuxFwIOT4 : std_logic_vector (15 downto 0);
	
	signal IMuxDACsIF, QMuxDACsIF : std_logic_vector (15 downto 0);
	signal AmpDACsIF, PhDACsIF : std_logic_vector (15 downto 0);
	
	signal IFwCavMean, QFwCavMean : std_logic_vector (15 downto 0);
	signal IFwCavL, QFwCavL : std_logic_vector (15 downto 0);
	signal IRvCavMean, QRvCavMean : std_logic_vector (15 downto 0);
	signal IRvCavL, QRvCavL : std_logic_vector (15 downto 0);
	
	signal IRvIOT1L, IRvIOT1Mean : std_logic_vector (15 downto 0);
	signal QRvIOT1L, QRvIOT1Mean : std_logic_vector (15 downto 0);
	signal IRvIOT2L, IRvIOT2Mean : std_logic_vector (15 downto 0);
	signal QRvIOT2L, QRvIOT2Mean : std_logic_vector (15 downto 0);
	
	signal IMuxCavMean, QMuxCavMean : std_logic_vector (15 downto 0);
	signal IMuxCavL, QMuxCavL : std_logic_vector (15 downto 0);
	
	-- Loop Inputs Selection
	signal ILoopInput, QLoopInput : std_logic_vector (15 downto 0);
	
	signal PhShDACsIOT1 : std_logic_vector (15 downto 0);
	signal PhShDACsIOT2 : std_logic_vector (15 downto 0);
	signal PhShDACsIOT3 : std_logic_vector (15 downto 0);
	signal PhShDACsIOT4 : std_logic_vector (15 downto 0);
	
	-- Fast Interlock signals		
	signal ResetFIM : std_logic;
	signal AmpRvIOT1 : std_logic_vector (16 downto 0);
	signal PhRvIOT1 : std_logic_vector (15 downto 0);
	signal AmpRvIOT2_sig, AmpRvIOT2 : std_logic_vector (16 downto 0);
	signal PhRvIOT2 : std_logic_vector (15 downto 0);
	signal PhRvIOT2_sig : std_logic_vector (15 downto 0);
	signal AmpRvIOT3 : std_logic_vector (16 downto 0);
	signal PhRvIOT3 : std_logic_vector (15 downto 0);
	signal AmpRvIOT4 : std_logic_vector (16 downto 0);
	signal PhRvIOT4 : std_logic_vector (15 downto 0);
	signal AmpRvCav :  STD_LOGIC_VECTOR (16 downto 0);
	signal PhRvCav :  STD_LOGIC_VECTOR (15 downto 0);
	signal Manual_itck_in:  std_logic;

	signal RvIOT1Limit :  STD_LOGIC_VECTOR (15 downto 0);
	signal RvIOT2Limit :  STD_LOGIC_VECTOR (15 downto 0);
	signal RvIOT3Limit :  STD_LOGIC_VECTOR (15 downto 0);
	signal RvIOT4Limit :  STD_LOGIC_VECTOR (15 downto 0);
	signal RvCavLimit :  STD_LOGIC_VECTOR (15 downto 0);

	signal DisableITCK_RvIOT1 : std_logic_vector (5 downto 0);
	signal DisableITCK_RvIOT2 : std_logic_vector (5 downto 0);
	signal DisableITCK_RvIOT3 : std_logic_vector (5 downto 0);
	signal DisableITCK_RvIOT4 : std_logic_vector (5 downto 0);
	signal DisableITCK_RvCav: std_logic_vector (5 downto 0);
	signal DisableITCK_Manual: std_logic_vector (5 downto 0);
	signal DisableITCK_PLC: std_logic_vector (5 downto 0);
	signal DisableITCK_LLRF1: std_logic_vector (5 downto 0);
	signal DisableITCK_LLRF2: std_logic_vector (5 downto 0);
	signal DisableITCK_LLRF3: std_logic_vector (5 downto 0);
	signal DisableITCK_ESwUp1: std_logic_vector (5 downto 0);
	signal DisableITCK_ESwDw1: std_logic_vector (5 downto 0);
	signal DisableITCK_ESwUp2: std_logic_vector (5 downto 0);
	signal DisableITCK_ESwDw2: std_logic_vector (5 downto 0);
	
	signal EndSwitchNO: std_logic;
	
	signal gpio_out_itck :  STD_LOGIC_VECTOR (4 downto 0);
	signal gpio_output_sig :  STD_LOGIC_VECTOR (10 downto 0);
	
	signal ITCK_Detected: std_logic_vector (13 downto 0);
	signal InterlocksDisplay0 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay1 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay2 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay3 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay4 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay5 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay6 : std_logic_vector (13 downto 0);
	signal InterlocksDisplay7 : std_logic_vector (13 downto 0);
	
	signal timestamp1_out : std_logic_vector (15 downto 0);
	signal timestamp2_out : std_logic_vector (15 downto 0);
	signal timestamp3_out : std_logic_vector (15 downto 0);
	signal timestamp4_out : std_logic_vector (15 downto 0);
	signal timestamp5_out : std_logic_vector (15 downto 0);
	signal timestamp6_out : std_logic_vector (15 downto 0);
	signal timestamp7_out : std_logic_vector (15 downto 0);
	
	signal delay_interlocks: std_logic_vector (15 downto 0);
	
	signal llrfinitckfromllrf1, llrfinitckfromllrf2 : std_logic;
	
	-- Ramping signals
	signal TopRamp : std_logic;
	signal BottomRamp : std_logic;
	signal TRG3HzDiag : std_logic;
	signal RampReady : std_logic;
	signal SlopeAmpRampUp : std_logic_vector (15 downto 0);
	signal SlopeAmpRampDw : std_logic_vector (15 downto 0);
	signal SlopePhRampUp : std_logic_vector (15 downto 0);
	signal SlopePhRampDw : std_logic_vector (15 downto 0);
	
	-- FDL ADCs Raw Data
	signal Interface_01_sig : std_logic_vector (15 downto 0);
	signal Interface_02_sig : std_logic_vector (15 downto 0);
	signal Interface_03_sig : std_logic_vector (15 downto 0);
	signal Interface_04_sig : std_logic_vector (15 downto 0);
	signal Interface_05_sig : std_logic_vector (15 downto 0);
	signal Interface_06_sig : std_logic_vector (15 downto 0);
	signal Interface_07_sig : std_logic_vector (15 downto 0);
	signal Interface_08_sig : std_logic_vector (15 downto 0);	
	
	signal FDL_ADCsRawData : std_logic;

	
  ---Components Declaration
   --- Averaging Component
  
  component Averages is
     Port ( In1 : in  STD_LOGIC_VECTOR (15 downto 0);
           In2 : in  STD_LOGIC_VECTOR (15 downto 0);
           In3 : in  STD_LOGIC_VECTOR (15 downto 0);
           In4 : in  STD_LOGIC_VECTOR (15 downto 0);
           In5 : in  STD_LOGIC_VECTOR (15 downto 0);
           In6 : in  STD_LOGIC_VECTOR (15 downto 0);
           In7 : in  STD_LOGIC_VECTOR (15 downto 0);
           In8 : in  STD_LOGIC_VECTOR (15 downto 0);
           In9 : in  STD_LOGIC_VECTOR (15 downto 0);
           In10 : in  STD_LOGIC_VECTOR (15 downto 0);
           In11 : in  STD_LOGIC_VECTOR (15 downto 0);
           In12 : in  STD_LOGIC_VECTOR (15 downto 0);
           In13 : in  STD_LOGIC_VECTOR (15 downto 0);
           In14 : in  STD_LOGIC_VECTOR (15 downto 0);
           In15 : in  STD_LOGIC_VECTOR (15 downto 0);
           In16 : in  STD_LOGIC_VECTOR (15 downto 0);
           In17 : in  STD_LOGIC_VECTOR (15 downto 0);
           In18 : in  STD_LOGIC_VECTOR (15 downto 0);
           In19 : in  STD_LOGIC_VECTOR (15 downto 0);
           In20 : in  STD_LOGIC_VECTOR (15 downto 0);
           In21 : in  STD_LOGIC_VECTOR (15 downto 0);
           In22 : in  STD_LOGIC_VECTOR (15 downto 0);
           In23 : in  STD_LOGIC_VECTOR (15 downto 0);
           In24 : in  STD_LOGIC_VECTOR (15 downto 0);
           In25 : in  STD_LOGIC_VECTOR (15 downto 0);
           In26 : in  STD_LOGIC_VECTOR (15 downto 0);
           In27 : in  STD_LOGIC_VECTOR (15 downto 0);
           In28 : in  STD_LOGIC_VECTOR (15 downto 0);
           In29 : in  STD_LOGIC_VECTOR (15 downto 0);
           In30 : in  STD_LOGIC_VECTOR (15 downto 0);
           In31 : in  STD_LOGIC_VECTOR (15 downto 0);
           In32 : in  STD_LOGIC_VECTOR (15 downto 0);
           In33 : in  STD_LOGIC_VECTOR (15 downto 0);
           In34 : in  STD_LOGIC_VECTOR (15 downto 0);
           In35 : in  STD_LOGIC_VECTOR (15 downto 0);
           In36 : in  STD_LOGIC_VECTOR (15 downto 0);
           In37 : in  STD_LOGIC_VECTOR (15 downto 0);
           In38 : in  STD_LOGIC_VECTOR (15 downto 0);
           In39 : in  STD_LOGIC_VECTOR (15 downto 0);
           In40 : in  STD_LOGIC_VECTOR (15 downto 0);
           In41 : in  STD_LOGIC_VECTOR (15 downto 0);
           In42 : in  STD_LOGIC_VECTOR (15 downto 0);
           In43 : in  STD_LOGIC_VECTOR (15 downto 0);
           In44 : in  STD_LOGIC_VECTOR (15 downto 0);
           In45 : in  STD_LOGIC_VECTOR (15 downto 0);
           In46 : in  STD_LOGIC_VECTOR (15 downto 0);
           In47 : in  STD_LOGIC_VECTOR (15 downto 0);
           In48 : in  STD_LOGIC_VECTOR (15 downto 0);
           In49 : in  STD_LOGIC_VECTOR (15 downto 0);
           In50 : in  STD_LOGIC_VECTOR (15 downto 0);
           In51 : in  STD_LOGIC_VECTOR (15 downto 0);
           In52 : in  STD_LOGIC_VECTOR (15 downto 0);
           In53 : in  STD_LOGIC_VECTOR (15 downto 0);
           In54 : in  STD_LOGIC_VECTOR (15 downto 0);
           In55 : in  STD_LOGIC_VECTOR (15 downto 0);
           In56 : in  STD_LOGIC_VECTOR (15 downto 0);
           In57 : in  STD_LOGIC_VECTOR (15 downto 0);
           In58 : in  STD_LOGIC_VECTOR (15 downto 0);
           In59 : in  STD_LOGIC_VECTOR (15 downto 0);
           In60 : in  STD_LOGIC_VECTOR (15 downto 0);
           In61 : in  STD_LOGIC_VECTOR (15 downto 0);
           In62 : in  STD_LOGIC_VECTOR (15 downto 0);
           In63 : in  STD_LOGIC_VECTOR (15 downto 0);
           In64 : in  STD_LOGIC_VECTOR (15 downto 0);
           In65 : in  STD_LOGIC_VECTOR (15 downto 0);
           In66 : in  STD_LOGIC_VECTOR (15 downto 0);
           In67 : in  STD_LOGIC_VECTOR (15 downto 0);
           In68 : in  STD_LOGIC_VECTOR (15 downto 0);
           In69 : in  STD_LOGIC_VECTOR (15 downto 0);
           In70 : in  STD_LOGIC_VECTOR (15 downto 0);
           In71 : in  STD_LOGIC_VECTOR (15 downto 0);
           In72 : in  STD_LOGIC_VECTOR (15 downto 0);
           In73 : in  STD_LOGIC_VECTOR (15 downto 0);
           In74 : in  STD_LOGIC_VECTOR (15 downto 0);
           In75 : in  STD_LOGIC_VECTOR (15 downto 0);
           In76 : in  STD_LOGIC_VECTOR (15 downto 0);
           In77 : in  STD_LOGIC_VECTOR (15 downto 0);
           In78 : in  STD_LOGIC_VECTOR (15 downto 0);
           In79 : in  STD_LOGIC_VECTOR (15 downto 0);
           In80 : in  STD_LOGIC_VECTOR (15 downto 0);
           In81 : in  STD_LOGIC_VECTOR (15 downto 0);
           In82 : in  STD_LOGIC_VECTOR (15 downto 0);
           In83 : in  STD_LOGIC_VECTOR (15 downto 0);
           In84 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  PulseUp : in std_logic;
			  Conditioning : in std_logic;
           Out1 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out2 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out3 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out4 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out5 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out6 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out7 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out8 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out9 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out10 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out11 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out12 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out13 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out14 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out15 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out16 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out17 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out18 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out19 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out20 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out21 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out22 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out23 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out24 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out25 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out26 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out27 : out  STD_LOGIC_VECTOR (15 downto 0);			  
           Out28 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out29 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out30 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out31 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out32 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out33 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out34 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out35 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out36 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out37 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out38 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out39 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out40 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out41 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out42 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out43 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out44 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out45 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out46 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out47 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out48 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out49 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out50 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out51 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out52 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out53 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out54 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out55 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out56 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out57 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out58 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out59 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out60 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out61 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out62 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out63 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out64 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out65 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out66 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out67 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out68 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out69 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out70 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out71 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out72 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out73 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out74 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out75 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out76 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out77 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out78 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out79 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out80 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out81 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out82 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out83 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out84 : Out  STD_LOGIC_VECTOR (15 downto 0);
			  average_update_out : out std_logic
			  );
	end component averages;	
	
	component RampDiag is
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
	end component RampDiag;
	
	
	component Polar2Rect is
    Port ( AmpRefOld : in  STD_LOGIC_VECTOR (15 downto 0);
           PhRefOld: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRefMin : in  STD_LOGIC_VECTOR (15 downto 0);
           PhRefMin : in  STD_LOGIC_VECTOR (15 downto 0);
			  CavPhSh : in std_logic_vector (15 downto 0);
			  FwCavPhSh : in std_logic_vector (15 downto 0);
			  FwIOT1PhSh : in std_logic_vector (15 downto 0);
			  FwIOT2PhSh : in std_logic_vector (15 downto 0);
			  FwIOT3PhSh : in std_logic_vector (15 downto 0);
			  FwIOT4PhSh : in std_logic_vector (15 downto 0);
			  
			  FwCavGain : in std_logic_vector (15 downto 0);
			  FwIOT1Gain : in std_logic_vector (15 downto 0);
			  FwIOT2Gain : in std_logic_vector (15 downto 0);
			  FwIOT3Gain : in std_logic_vector (15 downto 0);
			  FwIOT4Gain : in std_logic_vector (15 downto 0);
			  
			  GainControl1 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT1 : in std_logic_vector (15 downto 0);
			  GainControl2 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT2 : in std_logic_vector (15 downto 0);
			  GainControl3 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT3 : in std_logic_vector (15 downto 0);
			  GainControl4 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT4 : in std_logic_vector (15 downto 0);
			  
			  AmpLoop_ControlOutput : in std_logic_vector (15 downto 0);
			  PhLoop_ControlOutput : in std_logic_vector (15 downto 0);
			  PhCorrectionControl : in std_logic_vector (15 downto 0);
			  
			  PhCorrectionControl_enable : in std_logic;
			  
           clk : in  STD_LOGIC;
           IRefOld : out  STD_LOGIC_VECTOR (15 downto 0);
           QRefOld : out  STD_LOGIC_VECTOR (15 downto 0);
           IRefMin : out  STD_LOGIC_VECTOR (15 downto 0);
           QRefMin : out  STD_LOGIC_VECTOR (15 downto 0);
			  sin_phsh_cav : out std_logic_vector (15 downto 0);
			  cos_phsh_cav : out std_logic_vector (15 downto 0);
			  sin_phsh_fwcav : out std_logic_vector (15 downto 0);
			  cos_phsh_fwcav : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT1 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT1 : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT2 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT2 : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT3 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT3 : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT4 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT4 : out std_logic_vector (15 downto 0);
			  sin_phsh_control1 : out std_logic_vector (15 downto 0);
			  cos_phsh_control1 : out std_logic_vector (15 downto 0);
			  sin_phsh_control2 : out std_logic_vector (15 downto 0);
			  cos_phsh_control2 : out std_logic_vector (15 downto 0);
			  sin_phsh_control3 : out std_logic_vector (15 downto 0);
			  cos_phsh_control3 : out std_logic_vector (15 downto 0);
			  sin_phsh_control4 : out std_logic_vector (15 downto 0);
			  cos_phsh_control4 : out std_logic_vector (15 downto 0);
			  I_DACsIF_out : out std_logic_vector (15 downto 0);
			  Q_DACsIF_out : out std_logic_vector (15 downto 0);
			  IControl_Polar : out std_logic_vector (15 downto 0);
			  QControl_Polar : out std_logic_vector (15 downto 0)
			  );
	end component Polar2Rect;

	
	
	--Demultiplexing
	component Demux is
		PORT ( 
			 SignalIn : in std_logic_vector (15 downto 0);	
			 clk : in std_logic;
			 ClkDemux : in std_logic_vector (1 downto 0);
			 IOut,QOut : out std_logic_vector (15 downto 0));
	end component Demux;
	

	
	-- PID loop
	component PID is
		PORT (Input : in std_logic_vector (15 downto 0);
			 Gain_OL : in std_logic_vector (7 downto 0);
			 LoopEnable : in std_logic;
			 Ref : in std_logic_vector (15 downto 0);
			 Kp : in std_logic_vector (15 downto 0);
			 Ki : in std_logic_vector (15 downto 0);
			 Error : out std_logic_vector(15 downto 0);
			 ErrorAccumOut : out std_logic_vector (15 downto 0);
			 ResetKi : in std_logic;
			 IntLimit : in std_logic_vector (15 downto 0);
			 Control : out std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 ForwardMin : in std_logic);
	end component PID;
	
	
	component Fast_PI IS
	PORT ( Input : in std_logic_vector (15 downto 0);
			 LoopEnable : in std_logic;
			 Ref : in std_logic_vector (15 downto 0);
			 Kp : in std_logic_vector(15 downto 0);
			 Ki : in std_logic_vector(15 downto 0);
			 IntLimit : in std_logic_vector(15 downto 0);
			 Error : out std_logic_vector(15 downto 0);
			 ErrorAccumOut : out std_logic_vector (15 downto 0);
			 Control : out std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 ForwardMin : in std_logic);			 
	end component Fast_PI;
	
	component FastLoopInput_Selection is
    Port ( LoopInputSel : in  STD_LOGIC_VECTOR (2 downto 0);
           IFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           IRef_FastPI : out  STD_LOGIC_VECTOR (15 downto 0);
           QRef_FastPI : out  STD_LOGIC_VECTOR (15 downto 0);
           IInput_FastPI : out  STD_LOGIC_VECTOR (15 downto 0);
           QInput_FastPI : out  STD_LOGIC_VECTOR (15 downto 0));
	end component FastLoopInput_Selection;
	
	component PolarLoops is
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
			  clk : in std_logic;
			  ForwardMin_Amp : in std_logic;
			  ForwardMin_Ph : in std_logic;
			  IPolarAmpLoop : out std_logic_vector (15 downto 0);
			  QPolarAmpLoop : out std_logic_vector (15 downto 0);
			  IPolarPhLoop : out std_logic_vector (15 downto 0);
			  QPolarPhLoop : out std_logic_vector (15 downto 0);
           PolarLoopInputSelection_amp : in  STD_LOGIC_VECTOR (2 downto 0);
           PolarLoopInputSelection_ph : in  STD_LOGIC_VECTOR (2 downto 0);
           Amp_AmpLoopInput : in  STD_LOGIC_VECTOR (15 downto 0);
			  Gain_OL : in std_logic_vector (7 downto 0);
			  IntLimit : in std_logic_vector (15 downto 0);
           Ph_PhLoopInput : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_ControlOutput : out  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_Error : out  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_ErrorAccum : out  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_kp : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_ki : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRefIn : in  STD_LOGIC_VECTOR (15 downto 0);
           PhRefIn : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpPolarLoopEnable : in  STD_LOGIC;
           PhPolarLoopEnable : in  STD_LOGIC;
           PhLoop_controlOutput : out  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_Error : out  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_ErrorAccum : out  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_kp : in  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_ki : in  STD_LOGIC_VECTOR (15 downto 0));
	end component PolarLoops;
	
	component ControlOutputSelection is
    Port ( IControl_Rect : in  STD_LOGIC_vector (15 downto 0);
           QControl_Rect : in  STD_LOGIC_VECTOR (15 downto 0);
           IControl_FastPI : in  STD_LOGIC_VECTOR (15 downto 0);
           QControl_FastPI : in  STD_LOGIC_VECTOR (15 downto 0);
           IControl_Polar : in  STD_LOGIC_VECTOR (15 downto 0);
           QControl_Polar : in  STD_LOGIC_VECTOR (15 downto 0);
           PolarLoopsEnable : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           IControl : out  STD_LOGIC_VECTOR (15 downto 0);
           QControl : out  STD_LOGIC_VECTOR (15 downto 0));
	end component ControlOutputSelection;
	
	--Phase shift
	component PhaseShift is
		PORT ( Iin : in std_logic_vector (15 downto 0);	
			 Qin : in std_logic_vector (15 downto 0);	
			 sin : in std_logic_vector (15 downto 0);	
			 cos : in std_logic_vector (15 downto 0);	
			 clk : in std_logic;
			 IOut : out std_logic_vector (15 downto 0);	
			 QOut : out std_logic_vector (15 downto 0));
	end component PhaseShift;
	
	
	-- Automatic Startup	
	component StartUp IS
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
	end component Startup;
	
	-- Reference for Loops, Booster Ramping and Automatic Startup
	component Reference is
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
			  
end component Reference;
	
	-- cordic for tuning
	component CordicRect2Polar is
    Port ( I_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           Amp_out : out  STD_LOGIC_VECTOR (16 downto 0);
           Ph_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  id_in : in std_logic_vector (3 downto 0);
			  id_out : out std_logic_vector (3 downto 0));
	end component CordicRect2Polar;
	
	-- Fast Data Logger Interface
	component FDL_Interface is
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
	end component FDL_Interface;
	
	
	component VCXO_Programming IS
		port( LE_VCXO: out std_logic;
			Data_VCXO : out std_logic;
			CLK_VCXO : out std_logic;
			clk : in std_logic;
			MDivider : in std_logic_vector (9 downto 0);
			NDivider : in std_logic_vector (9 downto 0);
			MuxSel : in std_logic_vector (2 downto 0);
			Mux0 : in std_logic_vector (2 downto 0);
			Mux1 : in std_logic_vector (2 downto 0);
			Mux2 : in std_logic_vector (2 downto 0);
			Mux3 : in std_logic_vector (2 downto 0);
			Mux4 : in std_logic_vector (2 downto 0);
			CP_Dir: in std_logic;
			SendWordVCXO : in std_logic;
			VCXO_out_inversion : in std_logic);
	end component VCXO_Programming;
  
  
	component Demuxes is
    Port ( VCav : in  STD_LOGIC_VECTOR (15 downto 0); --RFIN1
           FwCav : in  STD_LOGIC_VECTOR (15 downto 0); -- RFIn2
           RvCav : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn3
           MO : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn4;
           FwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn5
           RvIOT1 : in  STD_LOGIC_VECTOR (15 downto 0); --RFIN6
           DACsIF : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn16
			  
           RFIn7 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn8 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn9 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn10 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn11 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn12 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn13 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn14 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn15 : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           LookRefLatch : in  STD_LOGIC;
			  LookRefManual : in std_logic;
			  ManualOffset : in std_logic_vector (1 downto 0);
			  AnyLoopsEnable_latch : in std_logic;
           Quad : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
			  
           IMuxCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxCav : out  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwCav : out  STD_LOGIC_VECTOR (15 downto 0);
           IMuxRvCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxRvCav : out  STD_LOGIC_VECTOR (15 downto 0);
			  IMO : out std_logic_vector (15 downto 0);
			  QMO : out std_logic_vector (15 downto 0);			  
           IMuxFwIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);			  
           IMuxRvIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxRvIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  IMuxDACsIF : out std_logic_vector (15 downto 0);
			  QMuxDACsIF : out std_logic_vector (15 downto 0);
			  
           IRFIn7 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn7 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn8 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn8 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn9 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn9 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn10 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn10 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn11 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn11 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn12 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn12 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn13 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn13 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn14 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn14 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn15 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn15 : out  STD_LOGIC_VECTOR (15 downto 0);			  
           
			  ClkDemux_out : out  STD_LOGIC_VECTOR (1 downto 0);
			  WordQuad_out : out std_logic_vector (3 downto 0)
			  );
	end component Demuxes;
	
	
	component PhaseShifts_LoopsInputs is
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
	end component PhaseShifts_LoopsInputs;
	
	component LoopInput_Selection is
    Port ( LoopInputSel : in  STD_LOGIC_VECTOR (2 downto 0);
           ICav : in  STD_LOGIC_VECTOR (15 downto 0);
           QCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           ILoopInput : out  STD_LOGIC_VECTOR (15 downto 0);
           QLoopInput : out  STD_LOGIC_VECTOR (15 downto 0));
	end component LoopInput_Selection;
	
	
	component Tuning is
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
			  TuningInput_out : out std_logic_vector (15 downto 0);			  
			  TunFFOnTopEnable : in std_logic);
	end component Tuning;
	
	component PhSh_Controls is
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
	end component PhSh_Controls;
	
	component FwMinLoopsEnable is
    Port ( FwMin_Tuning : in  STD_LOGIC_VECTOR (15 downto 0);
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
	end component FwMinLoopsEnable;
	
	
	component FIM is
    Port ( clk 					: in  STD_LOGIC;
			  ResetFIM 				: in std_logic;
           AmpRvIOT1 			: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvIOT2				: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvIOT3 			: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvIOT4 			: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvCav 				: in  STD_LOGIC_VECTOR (15 downto 0);
			  Manual_itck_in		: in 	std_logic;
			  ExtLLRF3ITCK_In		: in 	std_logic;
           gpio_in_itck 		: in  STD_LOGIC_VECTOR (12 downto 0); -- PLC interlock and external LLRF interlocks 
           RvIOT1Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvIOT2Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvIOT3Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvIOT4Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvCavLimit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           Conf 					: in  STD_LOGIC_VECTOR (1 downto 0);
			  DisableITCK_RvIOT1 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvIOT2 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvIOT3 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvIOT4 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvCav			: in std_logic_vector (5 downto 0);
			  DisableITCK_Manual			: in std_logic_vector (5 downto 0);
			  DisableITCK_PLC				: in std_logic_vector (5 downto 0);
			  DisableITCK_LLRF1			: in std_logic_vector (5 downto 0);
			  DisableITCK_LLRF2			: in std_logic_vector (5 downto 0);
			  DisableITCK_LLRF3			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwUp1			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwDw1			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwUp2			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwDw2			: in std_logic_vector (5 downto 0);
			  EndSwitchNO			: in std_logic;
           gpio_out_itck 		: out  STD_LOGIC_VECTOR (4 downto 0);
			  ITCK_Detected		: out std_logic_vector (13 downto 0);
			  InterlocksDisplay0 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay1 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay2 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay3 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay4 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay5 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay6 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay7 : out std_logic_vector (13 downto 0);
			  timestamp1_out 		: out std_logic_vector (15 downto 0);
			  timestamp2_out 		: out std_logic_vector (15 downto 0);
			  timestamp3_out 		: out std_logic_vector (15 downto 0);
			  timestamp4_out 		: out std_logic_vector (15 downto 0);
			  timestamp5_out 		: out std_logic_vector (15 downto 0);
			  timestamp6_out 		: out std_logic_vector (15 downto 0);
			  timestamp7_out 		: out std_logic_vector (15 downto 0);
			  delay_interlocks	: in std_logic_vector (15 downto 0)
			  );
	end component FIM;

  
	
BEGIN


-----------------------------------------------------------
  ---DLLRF Parameters and Enables----------------------------
  Parameters:process(clk)
  begin
	if(clk'EVENT and clk = '1') then
	
--	if(gpio_out_inversion ='1') then
--		PulseUP_sig <= pulseup;
--	else		
--		PulseUP_sig <= not(pulseup);
--	end if;
	
	
	reg_data1_in_add 				<= reg_data1_input(31 downto 16);
	reg_data1_in_data_loops 	<= reg_data1_input(15 downto 0);
	reg_data1_in_data_startup 	<= reg_data1_input(15 downto 0);
	reg_data1_in_data_ramping 	<= reg_data1_input(15 downto 0);
	reg_data1_in_data_enables	<= reg_data1_input(15 downto 0);
	reg_data1_in_data_cond		<= reg_data1_input(15 downto 0);
	reg_data1_in_data_tuning	<= reg_data1_input(15 downto 0);
	reg_data1_in_data_vcxo		<= reg_data1_input(15 downto 0);
	reg_data1_in_data_FDL		<= reg_data1_input(15 downto 0);
	reg_data1_in_data_FIM		<= reg_data1_input(15 downto 0);
	
	--Parameters assignment
	case reg_data1_in_add is
	
	
		--Amplitude and Phase loop parameters
		when X"0000" => kp <= reg_data1_in_data_loops; -- Gain of parameter (P) of PID
		when X"0002" => ki <= reg_data1_in_data_loops; -- Gain of integral (I) of PID
--		
		when X"0004" => CavPhSh <= reg_data1_in_data_loops; -- Phase Shift to be applied to IQCav
		when X"0006" => FwCavPhSh <= reg_data1_in_data_loops; -- Phase Shift to be applied to IQFwCav
--		
		when X"0008" => FwIOT1PhSh <= reg_data1_in_data_loops; -- Phase Shift to be applied to FwIOT1
		when X"000A" => FwIOT2PhSh <= reg_data1_in_data_loops; -- Phase Shift to be applied to FwIOT2
		when X"000C" => FwIOT3PhSh <= reg_data1_in_data_loops; -- Phase Shift to be applied to FwIOT3
		when X"000E" => FwIOT4PhSh <= reg_data1_in_data_loops; -- Phase Shift to be applied to FwIOT4
		
		when X"0010" => FwCavGain <= reg_data1_in_data_loops; -- Gain to be applied to IQFwCav--		
		when X"0012" => FwIOT1Gain <= reg_data1_in_data_loops; -- Gain to be applied to FwIOT1
		when X"0014" => FwIOT2Gain <= reg_data1_in_data_loops; -- Gain to be applied to FwIOT2
		when X"0016" => FwIOT3Gain <= reg_data1_in_data_loops; -- Gain to be applied to FwIOT3
		when X"0018" => FwIOT4Gain <= reg_data1_in_data_loops; -- Gain to be applied to FwIOT4
		when X"001A" => IntLimit1 <= reg_data1_in_data_loops; -- Integral limit of PID
		when X"001C" => PhShDACsIOT1 <= reg_data1_in_data_loops; -- Phase Shift to be applied to control signal of IOT1		
		when X"001E" => PhShDACsIOT2 <= reg_data1_in_data_loops; -- Phase Shift to be applied to control signal of IOT2
		when X"0020" => PhShDACsIOT3 <= reg_data1_in_data_loops; -- Phase Shift to be applied to control signal of IOT3
		when X"0022" => PhShDACsIOT4 <= reg_data1_in_data_loops; -- Phase Shift to be applied to control signal of IOT4

		when X"0024" => GainControl1 <= reg_data1_in_data_loops; -- Gain to be applied to control signal of IOT1
		when X"0026" => GainControl2 <= reg_data1_in_data_loops; -- Gain to be applied to control signal of IOT2
		when X"0028" => GainControl3 <= reg_data1_in_data_loops; -- Gain to be applied to control signal of IOT3
		when X"002A" => GainControl4 <= reg_data1_in_data_loops; -- Gain to be applied to control signal of IOT4
		
		-- Automatic Startup		
		when X"002C" => Automatic_StartUp_Enable <= reg_data1_in_data_startup(0); -- Automatic Startup Enable
		when X"002E" => CommandStart <= reg_data1_in_data_startup(4 downto 0); -- command start
		when X"0030" => AmpRefIn <= reg_data1_in_data_startup; -- Loops Amplitude reference 
		when X"0032" => PhRefIn <= reg_data1_in_data_startup; -- Loops Phase reference
		when X"0034" => AmpRefMin <= reg_data1_in_data_startup; -- Amplitude reference at beginning of startup - Minimum RF Drive
		when X"0036" => PhRefMin <= reg_data1_in_data_startup; -- Phase reference at beginning of startup
		when X"0038" => PhIncRate <= reg_data1_in_data_startup(2 downto 0); -- Phase increase rate
		when X"003A" => VoltIncRate <= reg_data1_in_data_enables(2 downto 0); -- Voltage Increase Rate
		
		when X"003C" => GainOL1 <= reg_data1_in_data_startup(7 downto 0); -- 
		when X"003E" => PhCorrectionControl_Enable <= reg_data1_in_data_startup(0); -- 
		
		-- FDL SW Trigger
		when X"0040" => FDL_Trig_SW_input <= reg_data1_in_data_loops(0); -- Fast Data Logger Software Trigger Input
		when X"0042" => FDL_ADCsRawData <= reg_data1_in_data_loops(0); -- Fast Data Logger ADCs Raw Data enable
		
		--Enables
		
		when X"00C8" => LoopEnable <= reg_data1_in_data_enables(0); -- Amplitude and Phase close loop
		when X"00CA" => PhaseShiftEnable <= reg_data1_in_data_enables(0); -- Cavity voltage and other loop inputs phase shifter enable
		when X"00CC" => DACsPhaseShiftEnable <= reg_data1_in_data_enables(0); -- Control outputs phase shift enable
		when X"00CE" => SquareRefEnable <= reg_data1_in_data_enables(0); -- Square reference enable for testing purposes
		
		when X"00D0" => FreqSquare <= reg_data1_in_data_enables(15 downto 0); -- Frequency of a square reference for test purposes
		
		when X"00D2" => ResetKi <= reg_data1_in_data_enables(0); -- Reset Integral Action
		when X"00D4" => LookRef <= reg_data1_in_data_enables(0); -- Look Reference for quadrant selection in IQ Demodulation
		when X"00D6" => Quad <= reg_data1_in_data_enables(1 downto 0); -- Quadrant Selection
		when X"00D8" => LookRefManual <= reg_data1_in_data_enables(0); --
		when X"00DA" => ManualOffset <= reg_data1_in_data_enables(1 downto 0); --
		
--		when X"00D8" =>  <= reg_data1_in_data_enables; --  
--		when X"00DA" =>  <= reg_data1_in_data_enables; -- 

		-- Settings of ancillary loops
		when X"00DC" => LoopInputSel <= reg_data1_in_data_enables(2 downto 0); -- Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4	
		when X"00DE" => LoopInputSel_FastPI <= reg_data1_in_data_enables(2 downto 0); -- Fast IQ Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4	
		when X"00E0" => PolarLoopInputSelection_amp <= reg_data1_in_data_enables(2 downto 0); -- Amp Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4			
		when X"00E2" => PolarLoopInputSelection_ph <= reg_data1_in_data_enables(2 downto 0); -- Phase Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4				
		when X"00E4" => PolarLoopsEnable <= reg_data1_in_data_enables(0); -- Enable of Polar Loops (Amplitude and Phase versus IQ Loops)		
		when X"00E6" => LoopEnable_FastPI <= reg_data1_in_data_enables(0); -- Fast IQ Loop Enable
		when X"00E8" => AmpLoopEnable <= reg_data1_in_data_enables(0); -- Amplitude Loop Enable
		when X"00EA" => PhLoopEnable <= reg_data1_in_data_enables(0); -- Phase Loop Enable
		when X"00EC" => Kp_FastPI <= reg_data1_in_data_enables; -- Kp constant of Fast PI loop
		when X"00EE" => Ki_FastPI <= reg_data1_in_data_enables; -- Ki constant of Fast PI loop
		when X"00F0" => AmpLoop_kp <= reg_data1_in_data_enables; -- Kp constant of Amplitude loop
		when X"00F2" => AmpLoop_ki <= reg_data1_in_data_enables; -- Ki constant of Amplitude loop
		when X"00F4" => PhLoop_kp <= reg_data1_in_data_enables; -- Ki constant of Phase loop
		when X"00F6" => PhLoop_ki <= reg_data1_in_data_enables; -- Ki constant of Phase loop
		when X"00F8" => IntLimit_FastPI <= reg_data1_in_data_enables; -- Ki constant of Phase loop
		when X"00FA" => FwMin_AmpPh <= reg_data1_in_data_enables; -- Threshold to enable amplitude and phase loops (polar and/or rect)
		
		--Conditioning (pulse mode)
		when X"0190" => Conditioning <= reg_data1_in_data_cond(0); -- Pulse Mode Enable 
		when X"0192" => AutomaticConditioning <= reg_data1_in_data_cond(0); -- Vacuum interlocks taken into account
		when X"0194" => ConditionDutyCycle <= reg_data1_in_data_cond&X"00"; -- Pulse mode duty cycle
					
		--Tuning
		when X"0258" => TuningEnable <= reg_data1_in_data_tuning(0); -- Tuning Enable
		when X"025A" => TunPosEnable <= reg_data1_in_data_tuning(0); -- Tuning loop direction
		when X"025C" => NumSteps <= reg_data1_in_data_tuning; -- Number of steps to move the plunger in manual tuning
		when X"025E" => CLKPerPulse <= reg_data1_in_data_tuning(2 downto 0); -- Frequency of pulses to move plungers
		when X"0260" => PhaseOffset <= reg_data1_in_data_tuning; -- Phase offset of tuning loop
		when X"0262" => MovePLG1 <= reg_data1_in_data_tuning(0); -- Manual tuning enable (PLG1)
		when X"0264" => MoveUp1 <= reg_data1_in_data_tuning(0); -- Manual tuning direction
		when X"0266" => TuningReset <= reg_data1_in_data_tuning(0); -- Counter pulses of manual tuning reset
		when X"0268" => FwMin_Tuning <= reg_data1_in_data_tuning; -- Minimum forward power to enable the tuning
		when X"026A" => MarginUp <= reg_data1_in_data_tuning; -- High margin of tuning loop deadband
		when X"026C" => MarginLow <= reg_data1_in_data_tuning; -- Low margin of tuning loop deadband
		when X"026E" => CounterTuningDelaySetting <= reg_data1_in_data_tuning; -- Period of time to disable the tuning loops after they have reached equilibrium to avoid ringing
		when X"0270" => TuningDephase80HzLPFEnable <= reg_data1_in_data_tuning(0); -- 80Hz Low Pass filter enabled to be applied on Tuning Dephase signal		
		when X"0272" => tuningTriggerEnable <= reg_data1_in_data_tuning(1 downto 0); -- FDL Tuning trigger:  [bit 0: 0 --> TuningOn trigger disabled; 1 --> tuningOn trigger Enabled. Bit 1: 0 --> TriggerOn on FALLING Edge; 1 --> TriggerOn on RISING EDGE]
		when X"0274" => MovePLG2 <= reg_data1_in_data_tuning(0); -- Manual tuning enable (PLG2)
		when X"0276" => MoveUp2 <= reg_data1_in_data_tuning(0); -- Manual tuning direction (PLG2)
		when X"0278" => TunFFOnTopEnable <= reg_data1_in_data_tuning(0); -- Tuning and FF pulses only on top of the ramp
		
		--Field Flatness -- Only for Booster Configuration
		when X"02BC" => FFEnable <= reg_data1_in_data_tuning(0); -- Field Flatness Enable
		when X"02BE" => FFPos <= reg_data1_in_data_tuning(0); -- Field Flatness Loop Direction
		when X"02C0" => FFPercentage <= reg_data1_in_data_tuning(8 downto 0); -- Field Flatness Loop Direction
		when X"02C2" => AmpCell2Gain_sig <= reg_data1_in_data_tuning; -- Gain for amplitude of Cell2 Voltage for Field Flatness Loops
		when X"02C4" => AmpCell4Gain_sig <= reg_data1_in_data_tuning; -- Gain for amplitude of Cell4 Voltage for Field Flatness Loops
		
		-- Ramping parameters -- only for Booster Configuration
		when X"02C6" => RampEnable <= reg_data1_in_data_ramping(0); -- Ramping Enable 
		when X"02C8" => t1ramping 		<= reg_data1_in_data_ramping; -- delay t1 to start ramping after trigger detection
		when X"02CA" => t2ramping 		<= reg_data1_in_data_ramping; -- delay t2 to ramp up RF of Booster
		when X"02CC" => t3ramping 		<= reg_data1_in_data_ramping; -- t3 - time of the ramp top
		when X"02CE" => t4ramping 		<= reg_data1_in_data_ramping; -- t4 - time to ramp down RF of Booster before next trigger
		when X"02D0" => RampIncRate	<= reg_data1_in_data_ramping; -- ramp increase rate. Defines how much fast the ramp will increase from low values to nominal values
		when X"02D2" => AmpRampInit 			<= reg_data1_in_data_ramping; -- amplitude at the beginning of the ramp
		when X"02D4" => AmpRampEnd 			<= reg_data1_in_data_ramping; -- amplitude at the end of the ramp
		when X"02D6" => PhRampInit 			<= reg_data1_in_data_ramping; -- phase at the beginning of the ramp
		when X"02D8" => PhRampEnd 			<= reg_data1_in_data_ramping; -- phase at the end of the ramp
		when X"02DA" => SlopeAmpRampUp 		<= reg_data1_in_data_ramping; -- amplitude slope to ramp up
		when X"02DC" => SlopeAmpRampDw 	<= reg_data1_in_data_ramping; -- amplitude slope to ramp down
		when X"02DE" => SlopePhRampUp 		<= reg_data1_in_data_ramping; -- phase slope to ramp up
		when X"02E0" => SlopePhRampDw 	<= reg_data1_in_data_ramping; -- phase slope to ramp down
		
	
	

		
		--Interlocks Disable for Loops: Amp&Ph, tuning and RF Drive
		when X"0320" => RFONState_Disable <= reg_data1_in_data_enables(0); -- RFOnState disable
		when X"0322" => FIM_ITCK_Disable <= reg_data1_in_data_enables(0); -- FIM Interlock disable
		
		
		--VCXO Programming Parameters
		when X"03E8" => MDivider <= reg_data1_in_data_vcxo(9 downto 0); -- M divider for Reference input of VCXO
		when X"03EA" => NDivider <= reg_data1_in_data_vcxo(9 downto 0); -- N divider for VCXO frequency
		when X"03EC" => MuxSel <= reg_data1_in_data_vcxo(2 downto 0); -- MuxSel to lock the VCXO PLL
		when X"03EE" => Mux0 <= reg_data1_in_data_vcxo(2 downto 0); -- Frequency divider of first PLL output
		when X"03F0" => Mux1 <= reg_data1_in_data_vcxo(2 downto 0); -- Frequency divider of second PLL output
		when X"03F2" => Mux2 <= reg_data1_in_data_vcxo(2 downto 0); -- Frequency divider of third PLL output
		when X"03F4" => Mux3 <= reg_data1_in_data_vcxo(2 downto 0); -- Frequency divider of fourth PLL output
		when X"03F6" => Mux4 <= reg_data1_in_data_vcxo(2 downto 0); -- Frequency divider of fifth PLL output
		when X"03F8" => sendwordVCXO <= reg_data1_in_data_vcxo(0); -- Send words to program VCXO
		when X"03FA" => CP_Dir <= reg_data1_in_data_vcxo(0); -- PLL Loop direction
		when X"03FC" => gpio_out_inversion <= reg_data1_in_data_vcxo(0); -- PLL Loop direction
		
		-- FIM Interlocks
		when X"0640" =>  RvIOT1Limit <= reg_data1_in_data_FIM;
		when X"0642" =>  RvIOT2Limit <= reg_data1_in_data_FIM;
		when X"0644" =>  RvIOT3Limit <= reg_data1_in_data_FIM;
		when X"0646" =>  RvIOT4Limit <= reg_data1_in_data_FIM;
		when X"0648" =>  RvCavLimit <= reg_data1_in_data_FIM;
		when X"064A" =>  Manual_itck_in <= reg_data1_in_data_FIM(0);
		when X"064C" =>  DisableITCK_RvIOT1 <= reg_data1_in_data_FIM(5 downto 0);
		when X"064E" =>  DisableITCK_RvIOT2 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0650" =>  DisableITCK_RvIOT3 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0652" =>  DisableITCK_RvIOT4 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0654" =>  DisableITCK_RvCav	<= reg_data1_in_data_FIM(5 downto 0);
		when X"0656" =>  DisableITCK_Manual <= reg_data1_in_data_FIM(5 downto 0);
		when X"0658" =>  DisableITCK_PLC 	<= reg_data1_in_data_FIM(5 downto 0);
		when X"065A" =>  DisableITCK_LLRF1 	<= reg_data1_in_data_FIM(5 downto 0);
		when X"065C" =>  DisableITCK_LLRF2 	<= reg_data1_in_data_FIM(5 downto 0);
		when X"065E" =>  DisableITCK_LLRF3 	<= reg_data1_in_data_FIM(5 downto 0);
		when X"0660" =>  DisableITCK_ESwUp1 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0662" =>  DisableITCK_ESwDw1 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0664" =>  DisableITCK_ESwUp2 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0666" =>  DisableITCK_ESwDw2 <= reg_data1_in_data_FIM(5 downto 0);
		when X"0668" =>  EndSwitchNO <= reg_data1_in_data_FIM(0);
		when X"066A" =>  ResetFIM <= reg_data1_in_data_FIM(0);
		when X"066C" =>  delay_interlocks <= reg_data1_in_data_FIM;		
		
		
		when others => null;
	end case;
	
	-- Default values for gains and PI Limit settings
		if(IntLimit1 = X"000") then
			IntLimit <= X"3FFF";
		else
			IntLimit <= IntLimit1;
		end if;
		
		if(GainOL1 <= X"00") then
			GainOL <= X"40";
		else
			GainOL <= GainOL1;
		end if;
		
		if(AmpCell4Gain_sig = X"0000") then
			AmpCell4Gain <= X"4000";
		else
			AmpCell4Gain <= AmpCell4Gain_sig;
		end if;
		
		if(AmpCell2Gain_sig = X"0000") then
			AmpCell2Gain <= X"4000";
		else
			AmpCell2Gain <= AmpCell2Gain_sig;
		end if;
		

	--Parameters readback
	case reg_data2_input(15 downto 0) is
		--Amp and Phase Loop Parameters
		when X"0000" => reg_data2_output(15 downto 0) <= kp;
		when X"0001" => reg_data2_output(15 downto 0) <= ki;
		when X"0002" => reg_data2_output(15 downto 0) <= CavPhSh;
		when X"0003" => reg_data2_output(15 downto 0) <= FwCavPhSh;
		when X"0004" => reg_data2_output(15 downto 0) <= FwIOT1PhSh;
		when X"0005" => reg_data2_output(15 downto 0) <= FwIOT2PhSh;
		when X"0006" => reg_data2_output(15 downto 0) <= FwIOT3PhSh;
		when X"0007" => reg_data2_output(15 downto 0) <= FwIOT4PhSh;
		when X"0008" => reg_data2_output(15 downto 0) <= FwCavGain;
		when X"0009" => reg_data2_output(15 downto 0) <= FwIOT1Gain;
		when X"000A" => reg_data2_output(15 downto 0) <= FwIOT2Gain;
		when X"000B" => reg_data2_output(15 downto 0) <= FwIOT3Gain;
		when X"000C" => reg_data2_output(15 downto 0) <= FwIOT4Gain;
		when X"000D" => reg_data2_output(15 downto 0) <= IntLimit;
		when X"000E" => reg_data2_output(15 downto 0) <= PhShDACsIOT1;
		when X"000F" => reg_data2_output(15 downto 0) <= PhShDACsIOT2;
		when X"0010" => reg_data2_output(15 downto 0) <= PhShDACsIOT3;
		when X"0011" => reg_data2_output(15 downto 0) <= PhShDACsIOT4;
		when X"0012" => reg_data2_output(15 downto 0) <= GainControl1;
		when X"0013" => reg_data2_output(15 downto 0) <= GainControl2;
		when X"0014" => reg_data2_output(15 downto 0) <= GainControl3;
		when X"0015" => reg_data2_output(15 downto 0) <= GainControl4;
		
		--Automatic Startup		
		when X"0016" => reg_data2_output(15 downto 0) <= X"000"&"000"&Automatic_StartUp_Enable;
		when X"0017" => reg_data2_output(15 downto 0) <= X"00"&"000"&CommandStart;
		when X"0018" => reg_data2_output(15 downto 0) <= AmpRefIn;
		when X"0019" => reg_data2_output(15 downto 0) <= PhRefIn;
		when X"001A" => reg_data2_output(15 downto 0) <= AmpRefMIn;
		when X"001B" => reg_data2_output(15 downto 0) <= PhRefMIn;
		when X"001C" => reg_data2_output(15 downto 0) <= X"000"&'0'&PhIncRate;
		when X"001D" => reg_data2_output(15 downto 0) <= X"000"&'0'&VoltIncRate;
		when X"001E" => reg_data2_output(15 downto 0) <= X"00"&GainOL;
		when X"001F" => reg_data2_output(15 downto 0) <= X"000"&"000"&PhCorrectionControl_Enable;
		
		--  FDL Sw Trigger		
		when X"0020" => reg_data2_output(15 downto 0) <= X"000"&"000"&FDL_Trig_Sw_Input;
		when X"0021" => reg_data2_output(15 downto 0) <= X"000"&"000"&FDL_ADCsRawData;
		
		
			
		--Enables
		when X"0064" => reg_data2_output(15 downto 0) <= X"000"&"000"&LoopEnable;
		when X"0065" => reg_data2_output(15 downto 0) <= X"000"&"000"&PhaseShiftEnable;	
		when X"0066" => reg_data2_output(15 downto 0) <= X"000"&"000"&DACsPhaseShiftEnable;
		when X"0067" => reg_data2_output(15 downto 0) <= X"000"&"000"&SquareRefEnable;		
		when X"0068" => reg_data2_output(15 downto 0) <= FreqSquare;				
		when X"0069" => reg_data2_output(15 downto 0) <= X"000"&"000"&ResetKi;
		when X"006A" => reg_data2_output(15 downto 0) <= X"000"&"000"&LookRef;
		when X"006B" => reg_data2_output(15 downto 0) <= X"000"&"00"&Quad;
		--when X"006C" => reg_data2_output(15 downto 0) <= 
--		when X"006D" => reg_data2_output(15 downto 0) <= ;
				
		-- Readback of Settings of ancillary loops
		when X"006E" => reg_data2_output <= X"000"&'0'&LoopInputSel; -- Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4	
		when X"006F" => reg_data2_output <= X"000"&'0'&LoopInputSel_FastPI; -- Fast IQ Loop Input Selection --> '0' Cavity Forward Power, '1' IOT 1 Output; '2' IOT 2 Output, '3' FwIOT3, '4' FwIOT4	
		when X"0070" => reg_data2_output <= X"000"&'0'&PolarLoopInputSelection_amp;-- Amp Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4		
		when X"0071" => reg_data2_output <= X"000"&'0'&PolarLoopInputSelection_ph;-- Phase Loop Input Selection --> '0' Cavity Voltage; '1' Cavity Forward Power;'2' FwIOT1; '3' FwIOT2, '4'	FwIOT3, '5' FwIOT4				
		when X"0072" => reg_data2_output <= X"000"&"000"&PolarLoopsEnable;-- Enable of Polar Loops (Amplitude and Phase versus IQ Loops)		
		when X"0073" => reg_data2_output <= X"000"&"000"&LoopEnable_FastPI;-- Fast IQ Loop Enable
		when X"0074" => reg_data2_output <= X"000"&"000"&AmpLoopEnable;-- Amplitude Loop Enable
		when X"0075" => reg_data2_output <= X"000"&"000"&PhLoopEnable;-- Phase Loop Enable
		when X"0076" => reg_data2_output <= Kp_FastPI;-- Kp constant of Fast PI loop
		when X"0077" => reg_data2_output <= Ki_FastPI;-- Ki constant of Fast PI loop
		when X"0078" => reg_data2_output <= AmpLoop_kp;-- Kp constant of Amplitude loop
		when X"0079" => reg_data2_output <= AmpLoop_ki;-- Ki constant of Amplitude loop
		when X"007A" => reg_data2_output <= PhLoop_kp;-- Kp constant of Phase loop
		when X"007B" => reg_data2_output <= PhLoop_ki;-- Ki constant of Phase loop
		when X"007C" => reg_data2_output <= IntLimit_FastPI;-- Integral Limit of Fast PI - IQ
		when X"007D" => reg_data2_output <= FwMin_AmpPh;-- Threshold to enable amp & ph loops (polar and/or rect)
	
		--Conditioning
		when X"00C8" => reg_data2_output(15 downto 0) <= X"000"&"000"&Conditioning;
		when X"00C9" => reg_data2_output(15 downto 0) <= X"000"&"000"&AutomaticConditioning;
		when X"00CA" => reg_data2_output(15 downto 0) <= ConditionDutyCycle(23 downto 8);
			
			
		--Tuning		
		when X"012C" => reg_data2_output(15 downto 0) <= X"000"&"000"&TuningEnable;
		when X"012D" => reg_data2_output(15 downto 0) <= X"000"&"000"&TunPosEnable;
		when X"012E" => reg_data2_output(15 downto 0) <= NumSteps;
		when X"012F" => reg_data2_output(15 downto 0) <= X"000"&"0"&CLKPerPulse;
		when X"0130" => reg_data2_output(15 downto 0) <= PhaseOffset;
		when X"0131" => reg_data2_output(15 downto 0) <= X"000"&"000"&MovePLG1;
		when X"0132" => reg_data2_output(15 downto 0) <= X"000"&"000"&MoveUp1;
		when X"0133" => reg_data2_output(15 downto 0) <= X"000"&"000"&TuningReset;
		when X"0134" => reg_data2_output(15 downto 0) <= FwMin_Tuning;
		when X"0135" => reg_data2_output(15 downto 0) <= MarginUp;
		when X"0136" => reg_data2_output(15 downto 0) <= MarginLow;
		when X"0137" => reg_data2_output(15 downto 0) <= CounterTuningDelaySetting;  -- Period of time to disable the tuning loops after they have reached equilibrium to avoid ringing
		when X"0138" => reg_data2_output(15 downto 0) <= X"000"&"000"&TuningDephase80HzLPFEnable; -- 80Hz Low Pass filter enabled to be applied on Tuning Dephase signal		
		when X"0139" => reg_data2_output(15 downto 0) <= X"000"&"00"&tuningTriggerEnable; -- FDL Tuning trigger:  [bit 0: 0 --> TuningOn trigger disabled; 1 --> tuningOn trigger Enabled. Bit 1: 0 --> TriggerOn on FALLING Edge; 1 --> TriggerOn on RISING EDGE]
		when X"013A" => reg_data2_output(15 downto 0) <= X"000"&"000"&MovePLG2;-- Manual tuning enable (PLG2)
		when X"013B" => reg_data2_output(15 downto 0) <= X"000"&"000"&MoveUp2; -- manul tuning direction (PLG2)
		when X"013C" => reg_data2_output(15 downto 0) <= X"000"&"000"&TunFFOnTopEnable; -- Tuning and FF Pulses only on top of Ramp
		
		--Field Flatness -- Only for Booster Configuration
		when X"015E" => reg_data2_output(15 downto 0) <= X"000"&"000"&FFEnable;
		when X"015F" => reg_data2_output(15 downto 0) <= X"000"&"000"&FFPos;
		when X"0160" => reg_data2_output(15 downto 0) <= X"0"&"000"&FFPercentage;
		when X"0161" => reg_data2_output(15 downto 0) <= AmpCell2Gain;			
		when X"0162" => reg_data2_output(15 downto 0) <= AmpCell4Gain;			
		
		-- Ramping parameters -- Only for Booster Configuration
		when X"0163" => reg_data2_output(15 downto 0) <= X"000"&"000"&RampEnable;	
		when X"0164" => reg_data2_output(15 downto 0) <= t1ramping; 						
		when X"0165" => reg_data2_output(15 downto 0) <= t2ramping; 						
		when X"0166" => reg_data2_output(15 downto 0) <= t3ramping; 						
		when X"0167" => reg_data2_output(15 downto 0) <= t4ramping; 						
		when X"0168" => reg_data2_output(15 downto 0) <= RampIncRate;					
		when X"0169" => reg_data2_output(15 downto 0) <= AmpRampInit; 					
		when X"016A" => reg_data2_output(15 downto 0) <= AmpRampEnd;					
		when X"016B" => reg_data2_output(15 downto 0) <= PhRampInit;					
		when X"016C" => reg_data2_output(15 downto 0) <= PhRampEnd;						
		when X"016D" => reg_data2_output(15 downto 0) <= SlopeAmpRampUp;					
		when X"016E" => reg_data2_output(15 downto 0) <= SlopeAmpRampDw; 				
		when X"016F" => reg_data2_output(15 downto 0) <= SlopePhRampUp; 					
		when X"0170" => reg_data2_output(15 downto 0) <= SlopePhRampDw; 	

		
		--EPS Interlock Disable
		when X"0190" => reg_data2_output(15 downto 0) <= X"000"&"000"&RFONState_Disable;
		when X"0191" => reg_data2_output(15 downto 0) <= X"000"&"000"&FIM_ITCK_Disable;
		
		
		--VCXO
		when X"01F4" => reg_data2_output(15 downto 0) <= X"0"&"00"&MDivider;
		when X"01F5" => reg_data2_output(15 downto 0) <= X"0"&"00"&NDivider;
		when X"01F6" => reg_data2_output(15 downto 0) <= X"000"&"0"&MuxSel;
		when X"01F7" => reg_data2_output(15 downto 0) <= X"000"&"0"&Mux0;
		when X"01F8" => reg_data2_output(15 downto 0) <= X"000"&"0"&Mux1;
		when X"01F9" => reg_data2_output(15 downto 0) <= X"000"&"0"&Mux2;
		when X"01FA" => reg_data2_output(15 downto 0) <= X"000"&"0"&Mux3;
		when X"01FB" => reg_data2_output(15 downto 0) <= X"000"&"0"&Mux4;
		when X"01FC" => reg_data2_output(15 downto 0) <= X"000"&"000"&SendWordVCXO;
		when X"01FD" => reg_data2_output(15 downto 0) <= X"000"&"000"&CP_Dir;
		when X"01FE" => reg_data2_output(15 downto 0) <= X"000"&"000"&gpio_out_inversion;
		
		
		--FIM			
		when X"0320" =>  reg_data2_output(15 downto 0) <= RvIOT1Limit;
		when X"0321" =>  reg_data2_output(15 downto 0) <= RvIOT2Limit;
		when X"0322" =>  reg_data2_output(15 downto 0) <= RvIOT3Limit;
		when X"0323" =>  reg_data2_output(15 downto 0) <= RvIOT4Limit;
		when X"0324" =>  reg_data2_output(15 downto 0) <= RvCavLimit;
		when X"0325" =>  reg_data2_output(15 downto 0) <= X"000"&"000"&Manual_itck_in;	 	
		when X"0326" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_RvIOT1; 	
		when X"0327" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_RvIOT2; 	
		when X"0328" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_RvIOT3; 	
		when X"0329" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_RvIOT4; 	
		when X"032A" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_RvCav;		
		when X"032B" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_Manual; 	
		when X"032C" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_PLC; 		
		when X"032D" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_LLRF1; 		
		when X"032E" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_LLRF2; 		
		when X"032F" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_LLRF3; 		
		when X"0330" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_ESwUp1; 	
		when X"0331" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_ESwDw1;	
		when X"0332" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_ESwUp2; 	
		when X"0333" =>  reg_data2_output(15 downto 0) <= X"00"&"00"&DisableITCK_ESwDw2; 	
		when X"0334" =>  reg_data2_output(15 downto 0) <= X"000"&"000"&EndSwitchNO; 			
		when X"0335" =>  reg_data2_output(15 downto 0) <= X"000"&"000"&ResetFIM; 			
		when X"0336" =>  reg_data2_output(15 downto 0) <= delay_interlocks;
	
		when others => null;
		end case;
		
		
		
	
	---Read Diagnostics signals
	reg_data3_inL <= reg_data3_input(16);
	
	if(reg_data3_inL = '0' and reg_data3_input(16) = '1') then
			ICavL					<= ICavMean;
			QCavL					<= QCavMean;
			IFwCavL					<= IFwCavMean;
			QFwCavL					<= QFwCavMean;
			IControlL				<= IControlMean;
			QControlL				<= QControlMean;
			IControl1L				<= IControl1Mean;
			Qcontrol1L				<= Qcontrol1Mean;
			IControl2L				<= IControl2Mean;
			Qcontrol2L				<= Qcontrol2Mean;
			IControl3L				<= IControl3Mean;
			Qcontrol3L				<= Qcontrol3Mean;
			IControl4L				<= IControl4Mean;
			Qcontrol4L				<= Qcontrol4Mean;
			IErrorL					<= IErrorMean;
			QErrorL					<= QErrorMean;
			IErrorAccumL			<= IErrorAccumMean;
			QErrorAccumL			<= QErrorAccumMean;
			AngCavL					<= AngCavMean;
			AngFwL					<= AngFwMean;
			IFwIOT1L				<= IFwIOT1Mean;
			QFwIOT1L				<= QFwIOT1Mean;
			IRvIOT1L				<= IRvIOT1Mean;
			QRvIOT1L				<= QRvIOT1Mean;
			IRvCavL				<= IRvCavMean;
			QRvCavL				<= QRvCavMean;
			IFwIOT2L				<= IFwIOT2Mean;
			QFwIOT2L				<= QFwIOT2Mean;
			ICell2L					<= ICell2Mean;
			QCell2L					<= QCell2Mean;
			ICell4L					<= ICell4Mean;
			QCell4L					<= QCell4Mean;
					
			AngCavFwL				<= AngCavFwMean;
			AmpCavL					<= AmpCavMean;
			AmpFwL					<= AmpFwMean;
					
			IMOL					<= IMOMean;
			QMOL					<= QMOMean;
			IRFIn7L					<= IRFIn7Mean;
			QRFIn7L					<= QRFIn7Mean;
			IRFIn8L					<= IRFIn8Mean;
			QRFIn8L					<= QRFIn8Mean;
			IRFIn9L					<= IRFIn9Mean;
			QRFIn9L					<= QRFIn9Mean;
			IRFIn10L				<= IRFIn10Mean;
			QRFIn10L				<= QRFIn10Mean;
			IRFIn11L				<= IRFIn11Mean;
			QRFIn11L				<= QRFIn11Mean;
			IRFIn12L				<= IRFIn12Mean;
			QRFIn12L				<= QRFIn12Mean;
			IRFIn13L				<= IRFIn13Mean;
			QRFIn13L				<= QRFIn13Mean;
			IRFIn14L				<= IRFIn14Mean;
			QRFIn14L				<= QRFIn14Mean;
			IRFIn15L				<= IRFIn15Mean;
			QRFIn15L				<= QRFIn15Mean;
			IPolarAmpLoopL			<= IPolarAmpLoopMean;	
			QPolarAmpLoopL			<= QPolarAmpLoopMean;	
			IPolarPhLoopL 			<= IPolarPhLoopMean; 	
			QPolarPhLoopL 			<= QPolarPhLoopMean; 
			Amp_AmpLoopInputL		<= Amp_AmpLoopInputMean;
			Ph_AmpLoopInputL		<= Ph_AmpLoopInputMean;
			Amp_PhLoopInputL		<= Amp_PhLoopInputMean;
			Ph_PhLoopInputL			<= Ph_PhLoopInputMean;
			AmpLoop_ControlOutputL	<= AmpLoop_ControlOutputMean;
			AmpLoop_ErrorL 			<= AmpLoop_ErrorMean; 		
			AmpLoop_ErrorAccumL		<= AmpLoop_ErrorAccumMean;
			PhLoop_controlOutputL	<= PhLoop_controlOutputMean;
			PhLoop_ErrorL 			<= PhLoop_ErrorMean; 		
			PhLoop_ErrorAccumL 		<= PhLoop_ErrorAccumMean; 	
			IControl_PolarL			<= IControl_PolarMean;
			QControl_PolarL			<= QControl_PolarMean;			
			IControl_RectL			<= IControl_RectMean;
			QControl_RectL			<= QControl_RectMean;
			IControl_FastPIL		<= IControl_FastPIMean;
			QControl_FastPIL		<= QControl_FastPIMean;
			
			IloopInputL				<= IloopInputMean;
			QloopInputL				<= QloopInputMean;
			IInput_FastPIL			<= IInput_FastPIMean;
			QInput_FastPIL			<= QInput_FastPIMean;		
			PhCorrection_ErrorL	<= PhCorrection_ErrorMean;		
			PhCorrectionControlL	<= PhCorrectionControlMean;		
			FFErrorL	<= FFErrorMean;		

			IRefL <= IRefIn;
			QRefL <= QRefIn;
			
			ICell3TopL 			<= ICell3Top;			
			QCell3TopL 			<= QCell3Top; 			
			ICell2TopL 			<= ICell2Top; 			
			QCell2TopL 			<= QCell2Top; 			
			ICell4TopL 			<= ICell4Top; 			
			QCell4TopL 			<= QCell4Top; 			
			IFwIOT1TopL			<= IFwIOT1Top;			
			QFwIOT1TopL			<= QFwIOT1Top;			
			IRvIOT1TopL			<= IRvIOT1Top;			
			QRvIOT1TopL			<= QRvIOT1Top;			
			IRvCavTopL 			<= IRvCavTop;			
			QRvCavTopL 			<= QRvCavTop; 			
			TuningDephaseTopL 	<= TuningDephaseTop;
			FFErrorTopL 		<= FFErrorTop;
			IControlTopL 		<= IControlTop; 		
			QControlTopL 		<= QControlTop; 		
			IErrorTopL 			<= IErrorTop; 			
			QErrorTopL 			<= QErrorTop; 			
			IRefTopL 			<= IRefTop;			
			QRefTopL 			<= QRefTop; 			
			IFwCavTopL 			<= IFwCavTop; 			
			QFwCavTopL 			<= QFwCavTop; 			
					
			ICell3BottomL 			<= ICell3Bottom; 		
			QCell3BottomL 			<= QCell3Bottom; 		
			ICell2BottomL 			<= ICell2Bottom; 		
			QCell2BottomL 			<= QCell2Bottom; 		
			ICell4BottomL 			<= ICell4Bottom; 		
			QCell4BottomL 			<= QCell4Bottom; 		
			IFwIOT1BottomL 			<= IFwIOT1Bottom; 		
			QFwIOT1BottomL 			<= QFwIOT1Bottom; 		
			IRvIOT1BottomL 			<= IRvIOT1Bottom; 		
			QRvIOT1BottomL 			<= QRvIOT1Bottom; 		
			IRvCavBottomL  			<= IRvCavBottom;  		
			QRvCavBottomL  			<= QRvCavBottom;  		
			TuningDephaseBottomL 	<= TuningDephaseBottom;
			FFErrorBottomL 			<= FFErrorBottom; 		
			IControlBottomL 		<= IControlBottom; 	
			QControlBottomL 		<= QControlBottom; 	
			IErrorBottomL 			<= IErrorBottom; 		
			QErrorBottomL 			<= QErrorBottom; 		
			IRefBottomL 			<= IRefBottom; 		
			QRefBottomL 			<= QRefBottom; 		
			IFwCavBottomL 			<= IFwCavBottom; 		
			QFwCavBottomL 			<= QFwCavBottom;
			
			
	end if;
	

	
	case reg_data3_input(15 downto 0) is
		when X"0000"  => reg_data3_out_LSB <= ICavL;				
		when X"0001"  => reg_data3_out_LSB <= QCavL;					
		when X"0002"  => reg_data3_out_LSB <= IFwCavL;					
		when X"0003"  => reg_data3_out_LSB <= QFwCavL;					
		when X"0004"  => reg_data3_out_LSB <= IControlL;				
		when X"0005"  => reg_data3_out_LSB <= QControlL;			
		when X"0006"  => reg_data3_out_LSB <= IControl1L;				
		when X"0007"  => reg_data3_out_LSB <= Qcontrol1L;				
		when X"0008"  => reg_data3_out_LSB <= IControl2L;				
		when X"0009"  => reg_data3_out_LSB <= Qcontrol2L;				
		when X"000A"  => reg_data3_out_LSB <= IControl3L;				
		when X"000B"  => reg_data3_out_LSB <= Qcontrol3L;				
		when X"000C"  => reg_data3_out_LSB <= IControl4L;				
		when X"000D"  => reg_data3_out_LSB <= Qcontrol4L;				
		when X"000E"  => reg_data3_out_LSB <= IErrorL;					
		when X"000F"  => reg_data3_out_LSB <= QErrorL;					
		when X"0010"  => reg_data3_out_LSB <= IErrorAccumL;				
		when X"0011"  => reg_data3_out_LSB <= QErrorAccumL;				
		when X"0012"  => reg_data3_out_LSB <= AngCavL;					
		when X"0013"  => reg_data3_out_LSB <= AngFwL;					
		when X"0014"  => reg_data3_out_LSB <= IFwIOT1L;					
		when X"0015"  => reg_data3_out_LSB <= QFwIOT1L;					
		when X"0016"  => reg_data3_out_LSB <= IRvIOT1L;					
		when X"0017"  => reg_data3_out_LSB <= QRvIOT1L;					
		when X"0018"  => reg_data3_out_LSB <= IRvCavL;					
		when X"0019"  => reg_data3_out_LSB <= QRvCavL;					
		when X"001A"  => reg_data3_out_LSB <= ICell2L;					
		when X"001B"  => reg_data3_out_LSB <= QCell2L;					
		when X"001C"  => reg_data3_out_LSB <= ICell4L;					
		when X"001D"  => reg_data3_out_LSB <= QCell4L;					
		when X"001E"  => reg_data3_out_LSB <= IFwIOT2L;					
		when X"001F"  => reg_data3_out_LSB <= QFwIOT2L;		

		when X"0020"  => reg_data3_out_LSB <= AngCavFwL;			
		when X"0021"  => reg_data3_out_LSB <= AmpCavL;					
		when X"0022"  => reg_data3_out_LSB <= AmpFwL;	

		when X"0023"  => reg_data3_out_LSB <= IMOL;						
		when X"0024"  => reg_data3_out_LSB <= QMOL;						
		when X"0025"  => reg_data3_out_LSB <= IRFIn7L;					
		when X"0026"  => reg_data3_out_LSB <= QRFIn7L;					
		when X"0027"  => reg_data3_out_LSB <= IRFIn8L;					
		when X"0028"  => reg_data3_out_LSB <= QRFIn8L;					
		when X"0029"  => reg_data3_out_LSB <= IRFIn9L;					
		when X"002A"  => reg_data3_out_LSB <= QRFIn9L;					
		when X"002B"  => reg_data3_out_LSB <= IRFIn10L;					
		when X"002C"  => reg_data3_out_LSB <= QRFIn10L;					
		when X"002D"  => reg_data3_out_LSB <= IRFIn11L;					
		when X"002E"  => reg_data3_out_LSB <= QRFIn11L;					
		when X"002F"  => reg_data3_out_LSB <= IRFIn12L;					
		when X"0030"  => reg_data3_out_LSB <= QRFIn12L;					
		when X"0031"  => reg_data3_out_LSB <= IRFIn13L;					
		when X"0032"  => reg_data3_out_LSB <= QRFIn13L;					
		when X"0033"  => reg_data3_out_LSB <= IRFIn14L;					
		when X"0034"  => reg_data3_out_LSB <= QRFIn14L;					
		when X"0035"  => reg_data3_out_LSB <= IRFIn15L;					
		when X"0036"  => reg_data3_out_LSB <= QRFIn15L;					
		when X"0037"  => reg_data3_out_LSB <= IPolarAmpLoopL;			
		when X"0038"  => reg_data3_out_LSB <= QPolarAmpLoopL;			
		when X"0039"  => reg_data3_out_LSB <= IPolarPhLoopL;			
		when X"003A"  => reg_data3_out_LSB <= QPolarPhLoopL;			
		when X"003B"  => reg_data3_out_LSB <= Amp_AmpLoopInputL;	
		when X"003C"  => reg_data3_out_LSB <= Ph_AmpLoopInputL;			
		when X"003D"  => reg_data3_out_LSB <= Amp_PhLoopInputL;			
		when X"003E"  => reg_data3_out_LSB <= Ph_PhLoopInputL;			
		when X"003F"  => reg_data3_out_LSB <= AmpLoop_ControlOutputL;
		when X"0040"  => reg_data3_out_LSB <= AmpLoop_ErrorL; 			
		when X"0041"  => reg_data3_out_LSB <= AmpLoop_ErrorAccumL;		
		when X"0042"  => reg_data3_out_LSB <= PhLoop_controlOutputL;	
		when X"0043"  => reg_data3_out_LSB <= PhLoop_ErrorL; 			
		when X"0044"  => reg_data3_out_LSB <= PhLoop_ErrorAccumL; 		
		when X"0045"  => reg_data3_out_LSB <= IControl_PolarL;			
		when X"0046"  => reg_data3_out_LSB <= QControl_PolarL;			
		when X"0047"  => reg_data3_out_LSB <= IControl_RectL;			
		when X"0048"  => reg_data3_out_LSB <= QControl_RectL;			
		when X"0049"  => reg_data3_out_LSB <= IControl_FastPIL;			
		when X"004A"  => reg_data3_out_LSB <= QControl_FastPIL;			

		when X"004B"  => reg_data3_out_LSB <= IloopInputL;				
		when X"004C"  => reg_data3_out_LSB <= QloopInputL;				
		when X"004D"  => reg_data3_out_LSB <= IInput_FastPIL;			
		when X"004E"  => reg_data3_out_LSB <= QInput_FastPIL;		
						
		when X"004F"	=> reg_data3_out_LSB <= X"000"&"000"&Vacuum;
		
		when X"0050"  => reg_data3_out_LSB <= PhCorrection_ErrorL;				
		when X"0051"  => reg_data3_out_LSB <= PhCorrectionControlL;		
		
		when X"0052"  => reg_data3_out_LSB <= AmpRvIOT1(15 downto 0);		
		when X"0053"  => reg_data3_out_LSB <= PhRvIOT1;		
		when X"0054"  => reg_data3_out_LSB <= AmpRvIOT2(15 downto 0);		
		when X"0055"  => reg_data3_out_LSB <= PhRvIOT2;		
		when X"0056"  => reg_data3_out_LSB <= AmpRvIOT3(15 downto 0);		
		when X"0057"  => reg_data3_out_LSB <= PhRvIOT3;		
		when X"0058"  => reg_data3_out_LSB <= AmpRvIOT4(15 downto 0);		
		when X"0059"  => reg_data3_out_LSB <= PhRvIOT4;			
		when X"005A"  => reg_data3_out_LSB <= FFErrorL;		
		
		when X"005B"  => reg_data3_out_LSB <= IMuxDACsIF;			
		when X"005C"  => reg_data3_out_LSB <= QMuxDACsIF;			
		when X"005D"  => reg_data3_out_LSB <= AmpDACsIF;			
		when X"005E"  => reg_data3_out_LSB <= PhDACsIF;		
		
		when X"005F"  => reg_data3_out_LSB <= I_DACsIF_out;			
		when X"0060"  => reg_data3_out_LSB <= Q_DACsIF_out;		
		
		                                
		when X"0061"	=> reg_data3_out_LSB <= X"000"&"000"&VCXO_Powered;
		when X"0062"	=> reg_data3_out_LSB <= X"000"&"000"&VCXO_Ref;
		when X"0063"	=> reg_data3_out_LSB <= X"000"&"000"&VCXO_Locked;
		
		-- Polar Loops diagnostics		
		when X"0064"	=> reg_data3_out_LSB <= IPolarAmpLoopL;							
		when X"0065"	=> reg_data3_out_LSB <= QPolarAmpLoopL;
		when X"0066"	=> reg_data3_out_LSB <= IPolarPhLoopL;
		when X"0067"	=> reg_data3_out_LSB <= QPolarPhLoopL; 
		when X"0068"	=> reg_data3_out_LSB <= Amp_AmpLoopInputL;
		when X"0069"	=> reg_data3_out_LSB <= Ph_AmpLoopInputL; 
		when X"006A"	=> reg_data3_out_LSB <= Amp_PhLoopInputL; 
		when X"006B"	=> reg_data3_out_LSB <= Ph_PhLoopInputL; 
		when X"006C"	=> reg_data3_out_LSB <= AmpLoop_ControlOutputL;
		when X"006D"	=> reg_data3_out_LSB <= AmpLoop_ErrorL; 
		when X"006E"	=> reg_data3_out_LSB <= AmpLoop_ErrorAccumL; 
		when X"006F"	=> reg_data3_out_LSB <= PhLoop_controlOutputL;
		when X"0070"	=> reg_data3_out_LSB <= PhLoop_ErrorL; 
		when X"0071"	=> reg_data3_out_LSB <= PhLoop_ErrorAccumL; 	
		when X"0072"	=> reg_data3_out_LSB <= IControl_PolarL; 
		when X"0073"	=> reg_data3_out_LSB <= QControl_PolarL; 
		
		when X"0074"	=> reg_data3_out_LSB <= IControlL; 
		when X"0075"	=> reg_data3_out_LSB <= QControlL; 
		when X"0076"	=> reg_data3_out_LSB <= IControl_FastPIL; 
		when X"0077"	=> reg_data3_out_LSB <= QControl_FastPIL; 
		when X"0078"	=> reg_data3_out_LSB <= ILoopInputL; 
		when X"0079"	=> reg_data3_out_LSB <= QLoopInputL; 
		when X"007A"	=> reg_data3_out_LSB <= IInput_FastPIL; 
		when X"007B"	=> reg_data3_out_LSB <= QInput_FastPIL; 
		when X"007C"	=> reg_data3_out_LSB <= IRef_FastPI; 
		when X"007D"	=> reg_data3_out_LSB <= QRef_FastPI; 
		
		-- Ramping Diagnostics Signals - only for Booster			
		when X"0096" =>	reg_data3_out_LSB <= ICell3TopL;
		when X"0097" =>	reg_data3_out_LSB <= QCell3TopL;
		when X"0098" =>	reg_data3_out_LSB <= ICell2TopL;
		when X"0099" =>	reg_data3_out_LSB <= QCell2TopL;
		when X"009A" =>	reg_data3_out_LSB <= ICell4TopL;
		when X"009B" =>	reg_data3_out_LSB <= QCell4TopL;
		when X"009C" =>	reg_data3_out_LSB <= IFwIOT1TopL;
		when X"009D" =>	reg_data3_out_LSB <= QFwIOT1TopL;
		when X"009E" =>	reg_data3_out_LSB <= IRvIOT1TopL;
		when X"009F" =>	reg_data3_out_LSB <= QRvIOT1TopL;
		when X"00A0" =>	reg_data3_out_LSB <= IRvCavTopL;
		when X"00A1" =>	reg_data3_out_LSB <= QRvCavTopL;
		when X"00A2" =>	reg_data3_out_LSB <= TuningDephaseTopL;
		when X"00A3" =>	reg_data3_out_LSB <= FFErrorTopL;
		when X"00A4" =>	reg_data3_out_LSB <= IRefTopL;
		when X"00A5" =>	reg_data3_out_LSB <= QRefTopL;
		when X"00A6" =>	reg_data3_out_LSB <= IcontrolTopL;
		when X"00A7" =>	reg_data3_out_LSB <= QControlTopL;
		when X"00A8" =>	reg_data3_out_LSB <= IErrorTopL;
		when X"00A9" =>	reg_data3_out_LSB <= QErrorTopL;	
		when X"00AA" =>	reg_data3_out_LSB <= ICell3BottomL;
		when X"00AB" =>	reg_data3_out_LSB <= QCell3BottomL;
		when X"00AC" =>	reg_data3_out_LSB <= ICell2BottomL;
		when X"00AD" =>	reg_data3_out_LSB <= QCell2BottomL;
		when X"00AE" =>	reg_data3_out_LSB <= ICell4BottomL;
		when X"00AF" =>	reg_data3_out_LSB <= QCell4BottomL;
		when X"00B0" =>	reg_data3_out_LSB <= IFwIOT1BottomL;
		when X"00B1" =>	reg_data3_out_LSB <= QFwIOT1BottomL;
		when X"00B2" =>	reg_data3_out_LSB <= IRvIOT1BottomL;
		when X"00B3" =>	reg_data3_out_LSB <= QRvIOT1BottomL;
		when X"00B4" =>	reg_data3_out_LSB <= IRvCavBottomL;
		when X"00B5" =>	reg_data3_out_LSB <= QRvCavBottomL;
		when X"00B6" =>	reg_data3_out_LSB <= TuningDephaseBottomL;
		when X"00B7" =>	reg_data3_out_LSB <= FFErrorBottomL;
		when X"00B8" =>	reg_data3_out_LSB <= IRefBottomL;
		when X"00B9" =>	reg_data3_out_LSB <= QRefBottomL;
		when X"00BA" =>	reg_data3_out_LSB <= IcontrolBottomL;
		when X"00BB" =>	reg_data3_out_LSB <= QControlBottomL;
		when X"00BC" =>	reg_data3_out_LSB <= IErrorBottomL;
		when X"00BD" =>	reg_data3_out_LSB <= QErrorBottomL;	
		when X"00BE" =>	reg_data3_out_LSB <= IFwCavTopL;	
		when X"00BF" =>	reg_data3_out_LSB <= QFwCavTopL;	
		when X"00C0" =>	reg_data3_out_LSB <= IFwCavBottomL;	
		when X"00C1" =>	reg_data3_out_LSB <= QFwCavBottomL;	

		-- Polar to Rect Diagnostics for phase shifters
--		when X"00C8"	=> reg_data3_out_LSB <= sin_phsh_cav;
--		when X"00C9"	=> reg_data3_out_LSB <= cos_phsh_cav;
--		when X"00CA"	=> reg_data3_out_LSB <= sin_phsh_fwcav;
--		when X"00CB"	=> reg_data3_out_LSB <= cos_phsh_fwcav;
--      when X"00CC"	=> reg_data3_out_LSB <= sin_phsh_FwIOT1;
--      when X"00CD"	=> reg_data3_out_LSB <= cos_phsh_FwIOT1;
--      when X"00CE"	=> reg_data3_out_LSB <= sin_phsh_FwIOT2;
--		when X"00CF"	=> reg_data3_out_LSB <= cos_phsh_FwIOT2;	
--      when X"00D0"	=> reg_data3_out_LSB <= sin_phsh_FwIOT3;
--      when X"00D1"	=> reg_data3_out_LSB <= cos_phsh_FwIOT3;
--      when X"00D2"	=> reg_data3_out_LSB <= sin_phsh_FwIOT4;
--		when X"00D3"	=> reg_data3_out_LSB <= cos_phsh_FwIOT4;	
--		when X"00D4"	=> reg_data3_out_LSB <= sin_phsh_control1;
--		when X"00D5"	=> reg_data3_out_LSB <= cos_phsh_control1;
--		when X"00D6"	=> reg_data3_out_LSB <= sin_phsh_control2;
--		when X"00D7"	=> reg_data3_out_LSB <= cos_phsh_control2;
--		when X"00D8"	=> reg_data3_out_LSB <= sin_phsh_control3;
--		when X"00D9"	=> reg_data3_out_LSB <= cos_phsh_control3;
--		when X"00DA"	=> reg_data3_out_LSB <= sin_phsh_control4;
--		when X"00DB"	=> reg_data3_out_LSB <= cos_phsh_control4;
--		 IQ demodulators output (before phase shifters)
--		when X"00DC"	=> reg_data3_out_LSB <= IMuxCav;
--		when X"00DD"	=> reg_data3_out_LSB <= QMuxCav;
--		when X"00DE"	=> reg_data3_out_LSB <= IMuxFwCav;
--		when X"00DF"	=> reg_data3_out_LSB <= QMuxFwCav;
--		when X"00E0"	=> reg_data3_out_LSB <= IMuxFwIOT1;
--		when X"00E1"	=> reg_data3_out_LSB <= QMuxFwIOT1;
--		when X"00E2"	=> reg_data3_out_LSB <= IMuxFwIOT2;
--		when X"00E3"	=> reg_data3_out_LSB <= QMuxFwIOT2;
--		when X"00E4"	=> reg_data3_out_LSB <= IMuxFwIOT3;
--		when X"00E5"	=> reg_data3_out_LSB <= QMuxFwIOT3;
--		when X"00E6"	=> reg_data3_out_LSB <= IMuxFwIOT4;
--		when X"00E7"	=> reg_data3_out_LSB <= QMuxFwIOT4;
		
		
                                        
		
		-- Tuning Loops Signals		
		when X"012B"	=> reg_data3_out_LSB <= X"000"&"000"&TuningOn; 													-- TuningDephase out of tuning deadband margins
		when X"012C"	=> reg_data3_out_LSB <= X"000"&"000"&(not(TTL1) and PlungerMovingAuto); 				-- Cavity out of tune
		when X"012D"	=> reg_data3_out_LSB <= X"000"&"000"&(TTL1 and PlungerMovingAuto);						-- Cavity resonance frequency increasing due to automatic tuning
		when X"012E"	=> reg_data3_out_LSB <= X"000"&"000"&(not(MoveUp1) and PlungerMovingManual1);			-- Plunger being moved manually
		when X"012F"	=> reg_data3_out_LSB <= X"000"&"000"&(MoveUp1 and PlungerMovingManual1);					-- Plunger being moved manually in up direction
		when X"0130"	=> reg_data3_out_LSB <= X"000"&"00"&State;					-- Tuning State: 00 - TuningOn and TuningDephase > Margin Up, 
																														--   11 - TuningOn and TuningDephase < -MarginUp, 
																														--   01 - TuningOff and TuningDephase coming from positive values
																														--   10 - TuningOff and TuningDephase coming from negatvie values
		when X"0131"	=> reg_data3_out_LSB <= X"000"&"000"&TuningOnDelay;			-- TuningOn Delay - Tuning Loop disabled during a period of time after having reached stability
		when X"0132"	=> reg_data3_out_LSB <= TuningInput;								-- Tuning dephase used for tuning loop
		when X"0133"	=> reg_data3_out_LSB <= X"000"&"000"&ForwardMin_Tuning;				-- Detected minimum forward power to activate loops
		when X"0134"	=> reg_data3_out_LSB <= X"000"&"000"&ForwardMin_SlowIQ;				-- Detected minimum forward power to activate loops
		when X"0135"	=> reg_data3_out_LSB <= X"000"&"000"&ForwardMin_FastIQ;				-- Detected minimum forward power to activate loops
		when X"0136"	=> reg_data3_out_LSB <= X"000"&"000"&ForwardMin_Amp;				-- Detected minimum forward power to activate loops
		when X"0137"	=> reg_data3_out_LSB <= X"000"&"000"&ForwardMin_Ph;				-- Detected minimum forward power to activate loops
		
		when X"0138"	=> reg_data3_out_LSB <= X"000"&"000"&FFOn;								-- Field Flatness loop out of deadband
		when X"0139"	=> reg_data3_out_LSB <= X"000"&"000"&(not(TTL3) and PlungerMovingAuto2);		-- Cavity out of tune or out of field flatness - moving down PLG2
		when X"013A"	=> reg_data3_out_LSB <= X"000"&"000"&(TTL3 and PlungerMovingAuto2);				-- Cavity out of tune or out of field flatness - moving up PLG2
		when X"013B"	=> reg_data3_out_LSB <= X"000"&"000"&(not(MoveUp2) and PlungerMovingManual2);		-- Plunger 2 being manually moved down
		when X"013C"	=> reg_data3_out_LSB <= X"000"&"000"&(MoveUp2 and PlungerMovingManual2);			-- Plunger being manually moved up
		when X"013D"	=> reg_data3_out_LSB <= FFErrorMean;							
		 when X"013E"	=> reg_data3_out_LSB <= AmpCell2Mean;						
		 when X"013F"	=> reg_data3_out_LSB <= AmpCell4Mean;							
		 when X"0140"	=> reg_data3_out_LSB <= AmpCell2FF;							
		 when X"0141"	=> reg_data3_out_LSB <= AmpCell4FF;							
		
		-- Interlock and digital inputs diagnostics
		when X"0190" => reg_data3_out_LSB <= X"000"&"000"&RFONState_Delay;
		when X"0191" => reg_data3_out_LSB <= X"000"&"000"&FIM_ITCK_Delay;
		when X"0192" => reg_data3_out_LSB <= X"000"&"000"&FDL_trig_HW_input;
		when X"0193" => reg_data3_out_LSB <= X"000"&"000"&FDL_trig_SW_input;
		when X"0194" => reg_data3_out_LSB <= X"000"&"000"&RFONState;
		when X"0195" => reg_data3_out_LSB <= X"000"&"000"&FIM_ITCK;
		when X"0196" => reg_data3_out_LSB <= X"000"&"000"&PulseUp;
--		when X"0197" => reg_data3_out_LSB <= X"000"&"000"&PulseUp_sig;
		when X"0198" => reg_data3_out_LSB <= X"000"&"000"&SpareDI1;
--		when X"0199" => reg_data3_out_LSB <= X"000"&"000"&SpareDI2;
--		when X"019A" => reg_data3_out_LSB <= X"000"&"000"&SpareDI3;

		-- Fast Interlocks diagnostics
		when X"01C2" => reg_data3_out_LSB <= "00"&InterlocksDisplay0;
		when X"01C3" => reg_data3_out_LSB <= "00"&InterlocksDisplay1;
		when X"01C4" => reg_data3_out_LSB <= "00"&InterlocksDisplay2;
		when X"01C5" => reg_data3_out_LSB <= "00"&InterlocksDisplay3;
		when X"01C6" => reg_data3_out_LSB <= "00"&InterlocksDisplay4;
		when X"01C7" => reg_data3_out_LSB <= "00"&InterlocksDisplay5;
		when X"01C8" => reg_data3_out_LSB <= "00"&InterlocksDisplay6;
		when X"01C9" => reg_data3_out_LSB <= "00"&InterlocksDisplay7;
		
		when X"01CA" => reg_data3_out_LSB <= timestamp1_out;
		when X"01CB" => reg_data3_out_LSB <= timestamp2_out;
		when X"01CC" => reg_data3_out_LSB <= timestamp3_out;
		when X"01CD" => reg_data3_out_LSB <= timestamp4_out;
		when X"01CE" => reg_data3_out_LSB <= timestamp5_out;
		when X"01CF" => reg_data3_out_LSB <= timestamp6_out;
		when X"01D0" => reg_data3_out_LSB <= timestamp7_out;
		
		when X"01D1" => reg_data3_out_LSB <= "00"&ITCK_Detected;
		
		when X"01D2" => reg_data3_out_LSB <= X"0"&"0"&gpio_output_sig;
		when X"01D3" => reg_data3_out_LSB <= X"00"&"000"&gpio_out_itck;
		when X"01D4" => reg_data3_out_LSB <= "000"&gpio_input;
		
		
		-- Automatic StartUp Diagnostics
		
		when X"01F4" => reg_data3_out_LSB <= X"00"&"000"&StateStart;
		when X"01F5" => reg_data3_out_LSB <= X"000"&"000"&LoopEnableLatch;
		when X"01F6" => reg_data3_out_LSB <= X"000"&"000"&ILoopClosed;
		when X"01F7" => reg_data3_out_LSB <= X"000"&"000"&QLoopClosed;
		when X"01F8" => reg_data3_out_LSB <= X"000"&"000"&RampEnableLatch;
		when X"01F9" => reg_data3_out_LSB <= IntLimitLatch;
		when X"01FA" => reg_data3_out_LSB <= AmpRefIn_latch;
		when X"01FB" => reg_data3_out_LSB <= PhRefIn_latch;
		when X"01FC" => reg_data3_out_LSB <= AmpRampInit;
		when X"01FD" => reg_data3_out_LSB <= PhRampInit;
		when X"01FE" => reg_data3_out_LSB <= AmpRampEnd_latch;
		when X"01FF" => reg_data3_out_LSB <= PhRampEnd_latch;
		when X"0200" => reg_data3_out_LSB <= IRefIn;
		when X"0201" => reg_data3_out_LSB <= QRefIn;
		when X"0202" => reg_data3_out_LSB <= X"000"&"000"&LookRefLatch;
		when X"0203" => reg_data3_out_LSB <= X"000"&"000"&TuningEnableLatch;
		when X"0204" => reg_data3_out_LSB <= counterIntLimit;
		when X"0205" => reg_data3_out_LSB <= IntLimitOffsetAccum;
		when X"0206" => reg_data3_out_LSB <= x"000"&"000"&LoopEnable_FastPI_latch;
		when X"0207" => reg_data3_out_LSB <= x"000"&"000"&AmpLoopEnable_latch;
		when X"0208" => reg_data3_out_LSB <= x"000"&"000"&PhLoopEnable_latch;
		when X"0209" => reg_data3_out_LSB <= x"000"&"000"&AmpLoopClosed;
		when X"020A" => reg_data3_out_LSB <= x"000"&"000"&PhLoopClosed;
		when X"020B" => reg_data3_out_LSB <= x"000"&"000"&SpareDI1;
		when X"020C" => reg_data3_out_LSB <= x"000"&"000"&SpareDO1;
		when X"020D" => reg_data3_out_LSB <= x"000"&"000"&AnyLoopsEnable_latch;
		when X"020E" => reg_data3_out_LSB <= x"000"&WordQuad;
		when X"020F" => reg_data3_out_LSB <= AmpRefOld;
		when X"0210" => reg_data3_out_LSB <= X"000"&"000"&FFEnableLatch;
		when X"0212" => reg_data3_out_LSB <= ConditionDutyCycleDiag;
		when X"0213" => reg_data3_out_LSB <= X"000"&"000"&TRG3HzDiag;
		when X"0214" => reg_data3_out_LSB <= X"000"&"00"&RampingState;
		when X"0215" => reg_data3_out_LSB <= X"000"&"000"&RampReady;
		when X"0216" => reg_data3_out_LSB <= X"000"&"000"&BottomRamp;
		when X"0217" => reg_data3_out_LSB <= X"000"&"000"&TopRamp;
		when X"0218" => reg_data3_out_LSB <= TopRampAmp;
		when X"0219" => reg_data3_out_LSB <= AmpRamp;
		when X"021A" => reg_data3_out_LSB <= PhRamp;
		when X"021B" => reg_data3_out_LSB <= X"000"&"000"&TRG3Hz;
		

		
		-- signals not latched and filtered		
		when X"03E8"  => reg_data3_out_LSB <= ICavMean;				
		when X"03E9"  => reg_data3_out_LSB <= QCavMean;					
		when X"03EA"  => reg_data3_out_LSB <= IFwCavMean;					
		when X"03EB"  => reg_data3_out_LSB <= QFwCavMean;					
		when X"03EC"  => reg_data3_out_LSB <= IControlMean;				
		when X"03ED"  => reg_data3_out_LSB <= QControlMean;			
		when X"03EE"  => reg_data3_out_LSB <= IControl1Mean;				
		when X"03EF"  => reg_data3_out_LSB <= Qcontrol1Mean;				
		when X"03F0"  => reg_data3_out_LSB <= IControl2Mean;				
		when X"03F1"  => reg_data3_out_LSB <= Qcontrol2Mean;				
		when X"03F2"  => reg_data3_out_LSB <= IControl3Mean;				
		when X"03F3"  => reg_data3_out_LSB <= Qcontrol3Mean;				
		when X"03F4"  => reg_data3_out_LSB <= IControl4Mean;				
		when X"03F5"  => reg_data3_out_LSB <= Qcontrol4Mean;				
		when X"03F6"  => reg_data3_out_LSB <= IErrorMean;					
		when X"03F7"  => reg_data3_out_LSB <= QErrorMean;					
		when X"03F8"  => reg_data3_out_LSB <= IErrorAccumMean;				
		when X"03F9"  => reg_data3_out_LSB <= QErrorAccumMean;				
		when X"03FA"  => reg_data3_out_LSB <= AngCavMean;					
		when X"03FB"  => reg_data3_out_LSB <= AngFwMean;					
		when X"03FC"  => reg_data3_out_LSB <= IFwIOT1Mean;					
		when X"03FD"  => reg_data3_out_LSB <= QFwIOT1Mean;					
		when X"03FE"  => reg_data3_out_LSB <= IRvIOT1Mean;					
		when X"03FF"  => reg_data3_out_LSB <= QRvIOT1Mean;					
		when X"0400"  => reg_data3_out_LSB <= IRvCavMean;					
		when X"0401"  => reg_data3_out_LSB <= QRvCavMean;					
		when X"0402"  => reg_data3_out_LSB <= IFwIOT2Mean;					
		when X"0403"  => reg_data3_out_LSB <= QFwIOT2Mean;					
		when X"0404"  => reg_data3_out_LSB <= ICell2Mean;					
		when X"0405"  => reg_data3_out_LSB <= QCell2Mean;					
		when X"0406"  => reg_data3_out_LSB <= ICell4Mean;					
		when X"0407"  => reg_data3_out_LSB <= QCell4Mean;		
		when X"0408"  => reg_data3_out_LSB <= AngCavFwMean;			
		when X"0409"  => reg_data3_out_LSB <= AmpCavMean;					
		when X"040A"  => reg_data3_out_LSB <= AmpFwMean;	
		when X"040B"  => reg_data3_out_LSB <= IMOMean;						
		when X"040C"  => reg_data3_out_LSB <= QMOMean;						
		when X"040D"  => reg_data3_out_LSB <= IRFIn7Mean;					
		when X"040E"  => reg_data3_out_LSB <= QRFIn7Mean;					
		when X"040F"  => reg_data3_out_LSB <= IRFIn8Mean;					
		when X"0410"  => reg_data3_out_LSB <= QRFIn8Mean;					
		when X"0411"  => reg_data3_out_LSB <= IRFIn9Mean;					
		when X"0412"  => reg_data3_out_LSB <= QRFIn9Mean;					
		when X"0413"  => reg_data3_out_LSB <= IRFIn10Mean;					
		when X"0414"  => reg_data3_out_LSB <= QRFIn10Mean;					
		when X"0415"  => reg_data3_out_LSB <= IRFIn11Mean;					
		when X"0416"  => reg_data3_out_LSB <= QRFIn11Mean;					
		when X"0417"  => reg_data3_out_LSB <= IRFIn12Mean;					
		when X"0418"  => reg_data3_out_LSB <= QRFIn12Mean;					
		when X"0419"  => reg_data3_out_LSB <= IRFIn13Mean;					
		when X"041A"  => reg_data3_out_LSB <= QRFIn13Mean;					
		when X"041B"  => reg_data3_out_LSB <= IRFIn14Mean;					
		when X"041C"  => reg_data3_out_LSB <= QRFIn14Mean;					
		when X"041D"  => reg_data3_out_LSB <= IRFIn15Mean;					
		when X"041E"  => reg_data3_out_LSB <= QRFIn15Mean;					
		when X"041F"  => reg_data3_out_LSB <= IPolarAmpLoopMean;			
		when X"0420"  => reg_data3_out_LSB <= QPolarAmpLoopMean;			
		when X"0421"  => reg_data3_out_LSB <= IPolarPhLoopMean;			
		when X"0422"  => reg_data3_out_LSB <= QPolarPhLoopMean;			
		when X"0423"  => reg_data3_out_LSB <= Amp_AmpLoopInputMean;	
		when X"0424"  => reg_data3_out_LSB <= Ph_AmpLoopInputMean;			
		when X"0425"  => reg_data3_out_LSB <= Amp_PhLoopInputMean;			
		when X"0426"  => reg_data3_out_LSB <= Ph_PhLoopInputMean;			
		when X"0427"  => reg_data3_out_LSB <= AmpLoop_ControlOutputMean;
		when X"0428"  => reg_data3_out_LSB <= AmpLoop_ErrorMean; 			
		when X"0429"  => reg_data3_out_LSB <= AmpLoop_ErrorAccumMean;		
		when X"042A"  => reg_data3_out_LSB <= PhLoop_controlOutputMean;	
		when X"042B"  => reg_data3_out_LSB <= PhLoop_ErrorMean; 			
		when X"042C"  => reg_data3_out_LSB <= PhLoop_ErrorAccumMean; 		
		when X"042D"  => reg_data3_out_LSB <= IControl_PolarMean;			
		when X"042E"  => reg_data3_out_LSB <= QControl_PolarMean;			
		when X"042F"  => reg_data3_out_LSB <= IControl_RectMean;			
		when X"0430"  => reg_data3_out_LSB <= QControl_RectMean;			
		when X"0431"  => reg_data3_out_LSB <= IControl_FastPIMean;			
		when X"0432"  => reg_data3_out_LSB <= QControl_FastPIMean;	
		when X"0433"  => reg_data3_out_LSB <= IloopInputMean;				
		when X"0434"  => reg_data3_out_LSB <= QloopInputMean;				
		when X"0435"  => reg_data3_out_LSB <= IInput_FastPIMean;			
		when X"0436"  => reg_data3_out_LSB <= QInput_FastPIMean;		
								
		when X"0437"  => reg_data3_out_LSB <= PhCorrection_ErrorMean;				
		when X"0438"  => reg_data3_out_LSB <= PhCorrectionControlMean;			
		                                
		
		-- Polar Loops diagnostics		
		when X"044C"	=> reg_data3_out_LSB <= IPolarAmpLoopMean;							
		when X"044D"	=> reg_data3_out_LSB <= QPolarAmpLoopMean;
		when X"044E"	=> reg_data3_out_LSB <= IPolarPhLoopMean;
		when X"044F"	=> reg_data3_out_LSB <= QPolarPhLoopMean; 
		when X"0450"	=> reg_data3_out_LSB <= Amp_AmpLoopInputMean;
		when X"0451"	=> reg_data3_out_LSB <= Ph_AmpLoopInputMean; 
		when X"0452"	=> reg_data3_out_LSB <= Amp_PhLoopInputMean; 
		when X"0453"	=> reg_data3_out_LSB <= Ph_PhLoopInputMean; 
		when X"0454"	=> reg_data3_out_LSB <= AmpLoop_ControlOutputMean;
		when X"0455"	=> reg_data3_out_LSB <= AmpLoop_ErrorMean; 
		when X"0456"	=> reg_data3_out_LSB <= AmpLoop_ErrorAccumMean; 
		when X"0457"	=> reg_data3_out_LSB <= PhLoop_controlOutputMean;
		when X"0458"	=> reg_data3_out_LSB <= PhLoop_ErrorMean; 
		when X"0459"	=> reg_data3_out_LSB <= PhLoop_ErrorAccumMean; 	
		when X"045A"	=> reg_data3_out_LSB <= IControl_PolarMean; 
		when X"045B"	=> reg_data3_out_LSB <= QControl_PolarMean; 		
		when X"045C"	=> reg_data3_out_LSB <= IControlMean; 
		when X"045D"	=> reg_data3_out_LSB <= QControlMean; 
		when X"045E"	=> reg_data3_out_LSB <= IControl_FastPIMean; 
		when X"045F"	=> reg_data3_out_LSB <= QControl_FastPIMean; 
		when X"0460"	=> reg_data3_out_LSB <= ILoopInputMean; 
		when X"0461"	=> reg_data3_out_LSB <= QLoopInputMean; 
		when X"0462"	=> reg_data3_out_LSB <= IInput_FastPIMean; 
		when X"0463"	=> reg_data3_out_LSB <= QInput_FastPIMean; 
		
		
		-- Ramping Diagnostics Signals - only for Booster			
--		when X"0492" =>	reg_data3_out_LSB <= ICell3Top;
--		when X"0493" =>	reg_data3_out_LSB <= QCell3Top;
--		when X"0494" =>	reg_data3_out_LSB <= ICell2Top;
--		when X"0495" =>	reg_data3_out_LSB <= QCell2Top;
--		when X"0496" =>	reg_data3_out_LSB <= ICell4Top;
--		when X"0497" =>	reg_data3_out_LSB <= QCell4Top;
--		when X"0498" =>	reg_data3_out_LSB <= IFwIOT1Top;
--		when X"0499" =>	reg_data3_out_LSB <= QFwIOT1Top;
--		when X"049A" =>	reg_data3_out_LSB <= IRvIOT1Top;
--		when X"049B" =>	reg_data3_out_LSB <= QRvIOT1Top;
--		when X"049C" =>	reg_data3_out_LSB <= IRvCavTop;
--		when X"049D" =>	reg_data3_out_LSB <= QRvCavTop;
--		when X"049E" =>	reg_data3_out_LSB <= TuningDephaseTop;
--		when X"049F" =>	reg_data3_out_LSB <= FFErrorTop;
--		when X"04A0" =>	reg_data3_out_LSB <= IRefTop;
--		when X"04A1" =>	reg_data3_out_LSB <= QRefTop;
--		when X"04A2" =>	reg_data3_out_LSB <= IcontrolTop;
--		when X"04A3" =>	reg_data3_out_LSB <= QControlTop;
--		when X"04A4" =>	reg_data3_out_LSB <= IErrorTop;
--		when X"04A5" =>	reg_data3_out_LSB <= QErrorTop;	
--		when X"04A6" =>	reg_data3_out_LSB <= ICell3Bottom;
--		when X"04A7" =>	reg_data3_out_LSB <= QCell3Bottom;
--		when X"04A8" =>	reg_data3_out_LSB <= ICell2Bottom;
--		when X"04A9" =>	reg_data3_out_LSB <= QCell2Bottom;
--		when X"04AA" =>	reg_data3_out_LSB <= ICell4Bottom;
--		when X"04AB" =>	reg_data3_out_LSB <= QCell4Bottom;
--		when X"04AC" =>	reg_data3_out_LSB <= IFwIOT1Bottom;
--		when X"04AD" =>	reg_data3_out_LSB <= QFwIOT1Bottom;
--		when X"04AE" =>	reg_data3_out_LSB <= IRvIOT1Bottom;
--		when X"04AF" =>	reg_data3_out_LSB <= QRvIOT1Bottom;
--		when X"04B0" =>	reg_data3_out_LSB <= IRvCavBottom;
--		when X"04B1" =>	reg_data3_out_LSB <= QRvCavBottom;
--		when X"04B2" =>	reg_data3_out_LSB <= TuningDephaseBottom;
--		when X"04B3" =>	reg_data3_out_LSB <= FFErrorBottom;
--		when X"04B4" =>	reg_data3_out_LSB <= IRefBottom;
--		when X"04B5" =>	reg_data3_out_LSB <= QRefBottom;
--		when X"04B6" =>	reg_data3_out_LSB <= IcontrolBottom;
--		when X"04B7" =>	reg_data3_out_LSB <= QControlBottom;
--		when X"04B8" =>	reg_data3_out_LSB <= IErrorBottom;
--		when X"04B9" =>	reg_data3_out_LSB <= QErrorBottom;	
--		when X"04BA" =>	reg_data3_out_LSB <= IFwCavTop;	
--		when X"04BB" =>	reg_data3_out_LSB <= QFwCavTop;	
--		when X"04BC" =>	reg_data3_out_LSB <= IFwCavBottom;	
--		when X"04BD" =>	reg_data3_out_LSB <= QFwCavBottom;	 		
		
		
		--Signals not latched and not filtered		
		when X"07D0"  => reg_data3_out_LSB <= ICav;				
		when X"07D1"  => reg_data3_out_LSB <= QCav;					
		when X"07D2"  => reg_data3_out_LSB <= IFw;					
		when X"07D3"  => reg_data3_out_LSB <= QFw;					
		when X"07D4"  => reg_data3_out_LSB <= IControl;				
		when X"07D5"  => reg_data3_out_LSB <= QControl;			
--		when X"07D6"  => reg_data3_out_LSB <= IControl1;				
--		when X"07D7"  => reg_data3_out_LSB <= Qcontrol1;				
--		when X"07D8"  => reg_data3_out_LSB <= IControl2;				
--		when X"07D9"  => reg_data3_out_LSB <= Qcontrol2;				
--		when X"07DA"  => reg_data3_out_LSB <= IControl3;				
--		when X"07DB"  => reg_data3_out_LSB <= Qcontrol3;				
--		when X"07DC"  => reg_data3_out_LSB <= IControl4;				
--		when X"07DD"  => reg_data3_out_LSB <= Qcontrol4;				
--		when X"07DE"  => reg_data3_out_LSB <= IError;					
--		when X"07DF"  => reg_data3_out_LSB <= QError;					
--		when X"07E0"  => reg_data3_out_LSB <= IErrorAccum;				
--		when X"07E1"  => reg_data3_out_LSB <= QErrorAccum;				
--		when X"07E2"  => reg_data3_out_LSB <= AngCav;					
--		when X"07E3"  => reg_data3_out_LSB <= AngFw;					
		when X"07E4"  => reg_data3_out_LSB <= IFwIOT1;					
		when X"07E5"  => reg_data3_out_LSB <= QFwIOT1;					
--		when X"07E6"  => reg_data3_out_LSB <= IFwIOT2;					
--		when X"07E7"  => reg_data3_out_LSB <= QFwIOT2;					
--		when X"07E8"  => reg_data3_out_LSB <= IFwIOT3;					
--		when X"07E9"  => reg_data3_out_LSB <= QFwIOT3;					
--		when X"07EA"  => reg_data3_out_LSB <= IFwIOT4;					
--		when X"07EB"  => reg_data3_out_LSB <= QFwIOT4;					
--		when X"07EC"  => reg_data3_out_LSB <= ICell2;					
--		when X"07ED"  => reg_data3_out_LSB <= QCell2;					
--		when X"07EE"  => reg_data3_out_LSB <= ICell4;					
--		when X"07EF"  => reg_data3_out_LSB <= QCell4;		
--		when X"07F0"  => reg_data3_out_LSB <= AngCavFw;			
--		when X"07F1"  => reg_data3_out_LSB <= AmpCav(15 downto 0);					
--		when X"07F2"  => reg_data3_out_LSB <= AmpFw(15 downto 0);	
--		when X"07F3"  => reg_data3_out_LSB <= IMO;						
--		when X"07F4"  => reg_data3_out_LSB <= QMO;						
		when X"07F5"  => reg_data3_out_LSB <= IRFIn7;					
		when X"07F6"  => reg_data3_out_LSB <= QRFIn7;					
		when X"07F7"  => reg_data3_out_LSB <= IRFIn8;					
		when X"07F8"  => reg_data3_out_LSB <= QRFIn8;					
		when X"07F9"  => reg_data3_out_LSB <= IRFIn9;					
		when X"07FA"  => reg_data3_out_LSB <= QRFIn9;					
		when X"07FB"  => reg_data3_out_LSB <= IRFIn10;					
		when X"07FC"  => reg_data3_out_LSB <= QRFIn10;					
		when X"07FD"  => reg_data3_out_LSB <= IRFIn11;					
		when X"07FE"  => reg_data3_out_LSB <= QRFIn11;					
		when X"07FF"  => reg_data3_out_LSB <= IRFIn12;					
		when X"0800"  => reg_data3_out_LSB <= QRFIn12;					
		when X"0801"  => reg_data3_out_LSB <= IRFIn13;					
		when X"0802"  => reg_data3_out_LSB <= QRFIn13;					
		when X"0803"  => reg_data3_out_LSB <= IRFIn14;					
		when X"0804"  => reg_data3_out_LSB <= QRFIn14;					
		when X"0805"  => reg_data3_out_LSB <= IRFIn15;					
		when X"0806"  => reg_data3_out_LSB <= QRFIn15;					
--		when X"0807"  => reg_data3_out_LSB <= IPolarAmpLoop;			
--		when X"0808"  => reg_data3_out_LSB <= QPolarAmpLoop;			
--		when X"0809"  => reg_data3_out_LSB <= IPolarPhLoop;			
--		when X"080A"  => reg_data3_out_LSB <= QPolarPhLoop;			
--		when X"080B"  => reg_data3_out_LSB <= Amp_AmpLoopInput(15 downto 0);	
--		when X"080C"  => reg_data3_out_LSB <= Ph_AmpLoopInput;			
--		when X"080D"  => reg_data3_out_LSB <= Amp_PhLoopInput(15 downto 0);			
--		when X"080E"  => reg_data3_out_LSB <= Ph_PhLoopInput;			
--		when X"080F"  => reg_data3_out_LSB <= AmpLoop_ControlOutput;
--		when X"0810"  => reg_data3_out_LSB <= AmpLoop_Error; 			
--		when X"0811"  => reg_data3_out_LSB <= AmpLoop_ErrorAccum;		
--		when X"0812"  => reg_data3_out_LSB <= PhLoop_controlOutput;	
--		when X"0813"  => reg_data3_out_LSB <= PhLoop_Error; 			
--		when X"0814"  => reg_data3_out_LSB <= PhLoop_ErrorAccum; 		
--		when X"0815"  => reg_data3_out_LSB <= IControl_Polar;			
--		when X"0816"  => reg_data3_out_LSB <= QControl_Polar;			
--		when X"0817"  => reg_data3_out_LSB <= IControl_Rect;			
--		when X"0818"  => reg_data3_out_LSB <= QControl_Rect;			
--		when X"0819"  => reg_data3_out_LSB <= IControl_FastPI;			
--		when X"081A"  => reg_data3_out_LSB <= QControl_FastPI;	
--		when X"081B"  => reg_data3_out_LSB <= IloopInput;				
--		when X"081C"  => reg_data3_out_LSB <= QloopInput;				
--		when X"081D"  => reg_data3_out_LSB <= IInput_FastPI;			
--		when X"081E"  => reg_data3_out_LSB <= QInput_FastPI;		
--								
		when X"0820"  => reg_data3_out_LSB <= PhCorrection_Error;				
		when X"0821"  => reg_data3_out_LSB <= PhCorrectionControl;			
--		
--		                                
		
		-- Polar Loops diagnostics		
--		when X"0834"	=> reg_data3_out_LSB <= IPolarAmpLoop;							
--		when X"0835"	=> reg_data3_out_LSB <= QPolarAmpLoop;
--		when X"0836"	=> reg_data3_out_LSB <= IPolarPhLoop;
--		when X"0837"	=> reg_data3_out_LSB <= QPolarPhLoop; 
--		when X"0838"	=> reg_data3_out_LSB <= Amp_AmpLoopInput(15 downto 0);
--		when X"0839"	=> reg_data3_out_LSB <= Ph_AmpLoopInput; 
--		when X"083A"	=> reg_data3_out_LSB <= Amp_PhLoopInput(15 downto 0); 
--		when X"083B"	=> reg_data3_out_LSB <= Ph_PhLoopInput; 
--		when X"083C"	=> reg_data3_out_LSB <= AmpLoop_ControlOutput;
--		when X"083D"	=> reg_data3_out_LSB <= AmpLoop_Error; 
--		when X"083E"	=> reg_data3_out_LSB <= AmpLoop_ErrorAccum; 
--		when X"083F"	=> reg_data3_out_LSB <= PhLoop_controlOutput;
--		when X"0840"	=> reg_data3_out_LSB <= PhLoop_Error; 
--		when X"0841"	=> reg_data3_out_LSB <= PhLoop_ErrorAccum; 	
--		when X"0842"	=> reg_data3_out_LSB <= IControl_Polar; 
--		when X"0843"	=> reg_data3_out_LSB <= QControl_Polar; 		
--		when X"0844"	=> reg_data3_out_LSB <= IControl_Rect; 
--		when X"0845"	=> reg_data3_out_LSB <= QControl_Rect; 
--		when X"0846"	=> reg_data3_out_LSB <= IControl_FastPI; 
--		when X"0847"	=> reg_data3_out_LSB <= QControl_FastPI; 
--		when X"0848"	=> reg_data3_out_LSB <= ILoopInput; 
--		when X"0849"	=> reg_data3_out_LSB <= QLoopInput; 
--		when X"084A"	=> reg_data3_out_LSB <= IInput_FastPI; 
--		when X"084B"	=> reg_data3_out_LSB <= QInput_FastPI; 
				
		when others => null;
		
	end case;
	
	
	reg_data3_output <= X"0000" & reg_data3_out_LSB;
	
	end if;
	end process Parameters;	
	
	
	---Diagnostic Signals Means
	
		
	average_diag : component averages
	port map(
			In1 => ICav,
			In2 => QCav,
			In3 => IFw,
			In4 => QFw,
			In5 => IControl,
			In6 => QControl,
			In7 => IControl1,
			In8 => Qcontrol1,
			In9 => IControl2,
			In10 => Qcontrol2,
			In11 => IControl3,
			In12 => Qcontrol3,
			In13 => IControl4,
			In14 => Qcontrol4,
			In15 => IError,
			In16 => QError,
			In17 => IErrorAccum,
			In18 => QErrorAccum,
			In19 => AngCav,
			In20 => AngFw,
			In21 => IFwIOT1,
			In22 => QFwIOT1,
			In23 => IRvIOT1,
			In24 => QRvIOT1,
			In25 => IRvCav,
			In26 => QRvCav,
			In27 => IFwIOT4,
			In28 => QFwIOT4,
			In29 => ICell2,
			In30 => QCell2,
			In31 => ICell4,
			In32 => QCell4,
			
			In33 => AngCavFw,
			In34 => AmpCav(15 downto 0),
			In35 => AmpFw(15 downto 0),
			
			In36 => IMO,
			In37 => QMO,
			In38 => IRFIn7,
			In39 => QRFIn7,
			In40 => IRFIn8,
			In41 => QRFIn8,
			In42 => IRFIn9,
			In43 => QRFIn9,
			In44 => IRFIn10,
			In45 => QRFIn10,
			In46 => IRFIn11,
			In47 => QRFIn11,
			In48 => IRFIn12,
			In49 => QRFIn12,
			In50 => IRFIn13,
			In51 => QRFIn13,
			In52 => IRFIn14,
			In53 => QRFIn14,
			In54 => IRFIn15,
			In55 => QRFIn15,
			In56 => IPolarAmpLoop,	
			In57 => QPolarAmpLoop,	
			In58 => IPolarPhLoop, 	
			In59 => QPolarPhLoop, 
			In60 => Amp_AmpLoopInput(15 downto 0),
			In61 => Ph_AmpLoopInput,
			In62 => Amp_PhLoopInput(15 downto 0),
			In63 => Ph_PhLoopInput,
			In64 => AmpLoop_ControlOutput,
			In65 => AmpLoop_Error, 		
			In66 => AmpLoop_ErrorAccum,
			In67 => PhLoop_controlOutput,
			In68 => PhLoop_Error, 		
			In69 => PhLoop_ErrorAccum, 	
			In70 => IControl_Polar,
			In71 => QControl_Polar,			
			In72 => IControl_Rect,
			In73 => QControl_Rect,
			In74 => IControl_FastPI,
			In75 => QControl_FastPI,
			
			In76 => IloopInput,
			In77 => QloopInput,
			In78 => IInput_FastPI,
			In79 => QInput_FastPI,				
			In80 => PhCorrection_Error,				
			In81 => PhCorrectionControl,				
			In82 => AmpCell2(15 downto 0),				
			In83 => AmpCell4(15 downto 0),				
			In84 => FFError,				
			
			clk => clk,
			PulseUp => PulseUP,
			Conditioning => Conditioning,
			
			Out1 => ICavMean,
			Out2 => QCavMean,
			Out3 => IFwCavMean,
			Out4 => QFwCavMean,
			Out5 => IControlMean,
			Out6 => QControlMean,
			Out7 => IControl1Mean,
			Out8 => Qcontrol1Mean,
			Out9 => IControl2Mean,
			Out10 => Qcontrol2Mean,
			Out11 => IControl3Mean,
			Out12 => Qcontrol3Mean,
			Out13 => IControl4Mean,
			Out14 => Qcontrol4Mean,
			Out15 => IErrorMean,
			Out16 => QErrorMean,
			Out17 => IErrorAccumMean,
			Out18 => QErrorAccumMean,
			Out19 => AngCavMean,
			Out20 => AngFwMean,
			Out21 => IFwIOT1Mean,
			Out22 => QFwIOT1Mean,
			Out23 => IRvIOT1Mean,
			Out24 => QRvIOT1Mean,
			Out25 => IRvCavMean,
			Out26 => QRvCavMean,
			Out27 => IFwIOT2Mean,
			Out28 => QFwIOT2Mean,
			Out29 => ICell2Mean,
			Out30 => QCell2Mean,
			Out31 => ICell4Mean,
			Out32 => QCell4Mean,
			
			Out33 => AngCavFwMean,
			Out34 => AmpCavMean,
			Out35 => AmpFwMean,
			
			Out36 => IMOMean,
			Out37 => QMOMean,
			Out38 => IRFIn7Mean,
			Out39 => QRFIn7Mean,
			Out40 => IRFIn8Mean,
			Out41 => QRFIn8Mean,
			Out42 => IRFIn9Mean,
			Out43 => QRFIn9Mean,
			Out44 => IRFIn10Mean,
			Out45 => QRFIn10Mean,
			Out46 => IRFIn11Mean,
			Out47 => QRFIn11Mean,
			Out48 => IRFIn12Mean,
			Out49 => QRFIn12Mean,
			Out50 => IRFIn13Mean,
			Out51 => QRFIn13Mean,
			Out52 => IRFIn14Mean,
			Out53 => QRFIn14Mean,
			Out54 => IRFIn15Mean,
			Out55 => QRFIn15Mean,
			Out56 => IPolarAmpLoopMean,	
			Out57 => QPolarAmpLoopMean,	
			Out58 => IPolarPhLoopMean, 	
			Out59 => QPolarPhLoopMean, 
			Out60 => Amp_AmpLoopInputMean,
			Out61 => Ph_AmpLoopInputMean,
			Out62 => Amp_PhLoopInputMean,
			Out63 => Ph_PhLoopInputMean,
			Out64 => AmpLoop_ControlOutputMean,
			Out65 => AmpLoop_ErrorMean, 		
			Out66 => AmpLoop_ErrorAccumMean,
			Out67 => PhLoop_controlOutputMean,
			Out68 => PhLoop_ErrorMean, 		
			Out69 => PhLoop_ErrorAccumMean, 	
			Out70 => IControl_PolarMean,
			Out71 => QControl_PolarMean,			
			Out72 => IControl_RectMean,
			Out73 => QControl_RectMean,
			Out74 => IControl_FastPIMean,
			Out75 => QControl_FastPIMean,
			
			Out76 => IloopInputMean,
			Out77 => QloopInputMean,
			Out78 => IInput_FastPIMean,
			Out79 => QInput_FastPIMean,			
			Out80 => PhCorrection_ErrorMean,			
			Out81 => PhCorrectionControlMean,		
			Out82 => AmpCell2Mean,	
			Out83 => AmpCell4Mean,		
			Out84 => FFErrorMean,
			average_update_out => average_update_ramping
			);
--
--inst_RampDiag : component RampDiag
--    Port map(
--			ICell3 => ICavMean, 
--			QCell3 => QCavMean, 
--			ICell2 => ICell2Mean, 
--			QCell2 => QCell2Mean, 
--			ICell4 => ICell4Mean, 
--			QCell4 => QCell4Mean, 
--			IFwIOT1 => IFwIOT1Mean,
--			QFwIOT1 => QFwIOT1Mean,
--			IRvIOT1 => IRvIOT1Mean,
--			QRvIOT1 => QRvIOT1Mean,
--			IRvCav => IRvCavMean, 
--			QRvCav => QRvCavMean, 
--			TuningDephase => TuningDephase_Filt,
--			IControl => IControlMean,
--			QControl => QControlMean,
--			IError => IErrorMean,
--			QError => QErrorMean,
--			IRef => IRefIn,
--			QRef => QRefIn,
--			ICell3Top => ICell3Top,
--			QCell3Top => QCell3Top, 
--			ICell2Top => ICell2Top, 
--			QCell2Top => QCell2Top, 
--			ICell4Top => ICell4Top, 
--			QCell4Top => QCell4Top, 
--			IFwIOT1Top => IFwIOT1Top,
--			QFwIOT1Top => QFwIOT1Top,
--			IRvIOT1Top => IRvIOT1Top,
--			QRvIOT1Top => QRvIOT1Top,
--			IRvCavTop => IRvCavTop, 
--			QRvCavTop => QRvCavTop, 
--			IcontrolTop => IControlTop,
--			QControlTop => QcontrolTop,
--			IErrorTop => IErrorTop,
--			QErrorTop => QErrorTop,
--			IRefTop => IRefTop,
--			QRefTop => QRefTop,
--			ICell3Bottom => ICell3Bottom, 
--			QCell3Bottom => QCell3Bottom, 
--			ICell2Bottom => ICell2Bottom, 
--			QCell2Bottom => QCell2Bottom, 
--			ICell4Bottom => ICell4Bottom, 
--			QCell4Bottom => QCell4Bottom, 
--			IFwIOT1Bottom => IFwIOT1Bottom,
--			QFwIOT1Bottom => QFwIOT1Bottom,
--			IRvIOT1Bottom => IRvIOT1Bottom,
--			QRvIOT1Bottom => QRvIOT1Bottom,
--			IRvCavBottom => IRvCavBottom, 
--			QRvCavBottom => QRvCavBottom, 
--			IcontrolBottom => IControlBottom,
--			QControlBottom => QcontrolBottom,
--			IErrorBottom => IErrorBottom,
--			QErrorBottom => QErrorBottom,
--			TuningDephaseTop => TuningDephaseTop,
--			TuningDephaseBottom => TuningDephaseBottom,
--			FFError => FFError,
--			FFErrortop => FFErrortop,
--			FFErrorBottom => FFErrorBottom,
--			IRefBottom => IRefBottom,
--			QRefBottom => QRefBottom,
--			TopRamp => TopRamp,
--			BottomRamp => BottomRamp,
--			clk => clk);



process(clk)
begin
	if(clk'EVENT and clk ='1') then
		if(TopRamp = '1' and average_update_ramping = '1') then			
			ICell3Top <= ICavMean;
			QCell3Top <= QCavMean; 
			ICell2Top <= ICell2Mean;
			QCell2Top <= QCell2Mean;
			ICell4Top <= ICell4Mean;
			QCell4Top <= QCell4Mean;
			IFwIOT1Top <= IFwIOT1Mean;
			QFwIOT1Top <= QFwIOT1Mean;
			IRvIOT1Top <= IRvIOT1Mean;
			QRvIOT1Top <= QRvIOT1Mean;
			IRvCavTop <= IRvCavMean;
			QRvCavTop <= QRvCavMean;
			TuningDephaseTop <= TuningDephase_Filt;
			FFErrorTop <= FFErrorMean;
			IControlTop <= IControlMean;
			QControlTop <= QControlMean;
			IErrorTop <= IErrorMean;
			QErrorTop <= QErrorMean;
			IRefTop <= IRefIn;
			QRefTop <= QRefIn;
			IFwCavTop <= IFwCavMean;
			QFwCavTop <= QFwCavMean;
		end if;
		
		if(BottomRamp = '1' and average_update_ramping = '1') then		
			ICell3Bottom <= ICavMean;
			QCell3Bottom <= QCavMean; 
			ICell2Bottom <= ICell2Mean;
			QCell2Bottom <= QCell2Mean;
			ICell4Bottom <= ICell4Mean;
			QCell4Bottom <= QCell4Mean;
			IFwIOT1Bottom <= IFwIOT1Mean;
			QFwIOT1Bottom <= QFwIOT1Mean;
			IRvIOT1Bottom <= IRvIOT1Mean;
			QRvIOT1Bottom <= QRvIOT1Mean;
			IRvCavBottom  <= IRvCavMean;
			QRvCavBottom  <= QRvCavMean;
			TuningDephaseBottom <= TuningDephase_Filt;
			FFErrorBottom <= FFErrorMean;
			IControlBottom <= IControlMean;
			QControlBottom <= QControlMean;
			IErrorBottom <= IErrorMean;
			QErrorBottom <= QErrorMean;
			IRefBottom <= IRefIn;
			QRefBottom <= QRefIn;
			IFwCavBottom <= IFwCavMean;
			QFwCavBottom <= QFwCavMean;
		end if;
	end if;
end process;
  
  
  --IQ Demodulation---------
  
	
	
---------------------------------------------------------------------------------------
-- Demultiplexing and positive conversion of the I and Q signals of RF Cavity ---------
-- and Forward  Signals ----------------------------------------------------------------
---------------------------------------------------------------------------------------

-- ADCs data: Extension from 14b to 16b
process(clk)
begin
	if(clk'EVENT and clk = '1') then	
		VCav_16b	 	 <= VCav;	
		FwCav_16b	 <= FwCav;	
		RvCav_16b	 <= RvCav;	
      MO_16b		 <= MO;
		FwIOT1_16b	 <= FwIOT1;	
		RvIOT1_16b	 <= RvIOT1;	
		DACsIF_16b 	 <= DACsIF;
		
		RFIn7_16b <= RFIn7;
		RFIn8_16b <= RFIn8;
		RFIn9_16b <= RFIn9;
		RFIn10_16b <= RFIn10;
		RFIn11_16b <= RFIn11;
		RFIn12_16b <= RFIn12;
		RFIn13_16b <= RFIn13;
		RFIn14_16b <= RFIn14;
		RFIn15_16b <= RFIn15;
	end if;
end process;


inst_demuxes : component Demuxes 
    Port map ( VCav => VCav,
					FwCav => FwCav,
					RvCav => RvCav,
					MO => MO,
					FwIOT1 => FwIOT1,
					RvIOT1 => RvIOT1,
					DACsIF => DACsIF,

					RFIn7 => RFIn7,
					RFIn8 => RFIn8,
					RFIn9 => RFIn9,
					RFIn10 => RFIn10,
					RFIn11 => RFIn11,
					RFIn12 => RFIn12,
					RFIn13 => RFIn13,
					RFIn14 => RFIn14,
					RFIn15 => RFIn15,
					
					LookRefLatch 	=> LookRefLatch,
					LookRefManual 	=> LookRefManual,
					ManualOffset 	=> ManualOffset,				
					AnyLoopsEnable_latch => AnyLoopsEnable_latch,
					Quad 				=> Quad,
					clk 				=> clk,				

					IMuxCav => IMuxCav,
					QMuxCav => QMuxCav,
					IMuxFwCav => IMuxFwCav,
					QMuxFwCav => QMuxFwCav,
					IMuxRvCav => IRvCav,
					QMuxRvCav => QRvCav,
					IMO => IMO,
					QMO => QMO,
					IMuxFwIOT1 => IMuxFwIOT1,
					QMuxFwIOT1 => QMuxFwIOT1,
					IMuxRvIOT1 => IRvIOT1,
					QMuxRvIOT1 => QRvIOT1,
					IMuxDACsIF => IMuxDACsIF,
					QMuxDACsIF => QMuxDACsIF,

					IRFIn7 => IRFIn7,
					QRFIn7 => QRFIn7,
					IRFIn8 => IRFIn8,
					QRFIn8 => QRFIn8,
					IRFIn9 => IRFIn9,
					QRFIn9 => QRFIn9,
					IRFIn10 => IRFIn10,
					QRFIn10 => QRFIn10,
					IRFIn11 => IRFIn11,
					QRFIn11 => QRFIn11,
					IRFIn12 => IRFIn12,
					QRFIn12 => QRFIn12,
					IRFIn13 => IRFIn13,
					QRFIn13 => QRFIn13,
					IRFIn14 => IRFIn14,
					QRFIn14 => QRFIn14,
					IRFIn15 => IRFIn15,
					QRFIn15 => QRFIn15,

					ClkDemux_out 	=> ClkDemux,
					WordQuad_out	=> WordQuad
					);
					


inst_PhShLoops : component PhaseShifts_LoopsInputs 
    Port map ( IMuxCav			 => IMuxCav,
			   QMuxCav           => QMuxCav,
			   IMuxFwCav         => IMuxFwCav,
			   QMuxFwCav         => QMuxFwCav,
			   IMuxFwIOT1        => IMuxFwIOT1,
			   QMuxFwIOT1        => QMuxFwIOT1,
			   IMuxFwIOT2        => IMuxFwIOT2,
			   QMuxFwIOT2        => QMuxFwIOT2,
			   IMuxFwIOT3        => IMuxFwIOT3,
			   QMuxFwIOT3        => QMuxFwIOT3,
			   IMuxFwIOT4        => IMuxFwIOT4,
			   QMuxFwIOT4        => QMuxFwIOT4,
			   sin_phsh_cav      => sin_phsh_cav,
			   cos_phsh_cav      => cos_phsh_cav,
			   sin_phsh_fwcav    => sin_phsh_fwcav,
			   cos_phsh_fwcav    => cos_phsh_fwcav,
			   sin_phsh_FwIOT1   => sin_phsh_FwIOT1,
			   cos_phsh_FwIOT1   => cos_phsh_FwIOT1,
			   sin_phsh_FwIOT2   => sin_phsh_FwIOT2,
			   cos_phsh_FwIOT2   => cos_phsh_FwIOT2,
			   sin_phsh_FwIOT3   => sin_phsh_FwIOT3,
			   cos_phsh_FwIOT3   => cos_phsh_FwIOT3,
			   sin_phsh_FwIOT4   => sin_phsh_FwIOT4,
			   cos_phsh_FwIOT4   => cos_phsh_FwIOT4,
			   clk               => clk,
			   PhaseShiftEnable  => PhaseShiftEnable,
			   ICav              => ICav,
			   QCav              => QCav,
			   IFwCav            => IFw,
			   QFwCav            => QFw,
			   IFwIOT1           => IFwIOT1,
			   QFwIOT1           => QFwIOT1,
			   IFwIOT2           => IFwIOT2,
			   QFwIOT2           => QFwIOT2,
			   IFwIOT3           => IFwIOT3,
			   QFwIOT3           => QFwIOT3,
			   IFwIOT4           => IFwIOT4,
			   QFwIOT4           => QFwIOT4);
				
--inst_PhShControls : component PhSh_Controls
--    Port map( 
--		     IControl 		  		=> IControl,
--           QControl         	=> QControl,
--           sin_phsh_control1 => sin_phsh_control1,
--           cos_phsh_control1 => cos_phsh_control1,
--           sin_phsh_control2 => sin_phsh_control2,
--           cos_phsh_control2 => cos_phsh_control2,
--           sin_phsh_control3 => sin_phsh_control3,
--           cos_phsh_control3 => cos_phsh_control3,
--           sin_phsh_control4 => sin_phsh_control4,
--           cos_phsh_control4 => cos_phsh_control4,
--           clk               => clk,
--		     IControl1PS       => IControl1PS, 
--           QControl1PS       => QControl1PS, 
--           IControl2PS       => IControl2PS, 
--           QControl2PS       => QControl2PS, 
--           IControl3PS       => IControl3PS, 
--           QControl3PS       => QControl3PS, 
--           IControl4PS       => IControl4PS, 
--           QControl4PS 		  => QControl4PS 
--			  );


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


---------------------------------------
-- Control Loop - PID -----------------


process(clk)
variable CounterVble : std_logic_vector (16 downto 0);
begin
	if(clk'EVENT and clk = '1') then
		CounterRef <= CounterRef + 1;
		counter <= counter + 1;
	end if;
end process;

process(clk)
begin
	if(clk'EVENT and clk = '1') then
		
		LLRFInITCKfromLLRF1 <= gpio_input(0);
		LLRFInITCKfromLLRF2 <= gpio_input(1);
		
		
		RFONState <= gpio_input(3);	 -- gpio_4 cavity A, gpio_5 cavity B
		FIM_ITCK <= gpio_out_itck(0); -- ITCKOut_SetLLRF2STBY_sig
		if(FIM_ITCK_Disable ='1' or FIM_ITCK='0') then 
			FIM_ITCK_Delay <= '0';
			FIM_ITCK_counter <= (others => '0');
		elsif(FIM_ITCK_counter < "1111") then
			FIM_ITCK_counter <= FIM_ITCK_counter + 1;
		else
			FIM_ITCK_delay <= '1';-- DACs Disable signal coming from FIM component
		end if;
		
		if(RFONState = '1') then
			RFONState_counter <= (others => '0');
			RFONState_Delay <= '1';
		elsif (RFONState = '1' and RFONState_counter < X"E4E1C00") then -- wait for 3 seconds before disabling loops
			RFONState_counter <= RFONState_counter + 1;
			RFONState_Delay <= '1';
		else
			RFONState_counter <= RFONState_counter;
			if(RFONState_Disable = '1') then
				RFONState_Delay <= '1';
			else
				RFONState_Delay <= '0';
			end if;		
		end if;
	end if;
end process;


process(clk)
begin
	if(clk'EVENT and clk = '1') then
	
		FDL_trig_out_sig <= FDL_trig_HW_input or FDL_trig_SW_input or TuningTrigger;
		FDL_trig_out <= FDL_Trig_out_sig; 
		
		if(gpio_out_inversion = '1') then
			VCXO_Powered <= gpio_input(7); -- connected to gpio 12 in Cav A & B
			VCXO_Ref <= gpio_input(8); -- connected to gpio 13 in Cav A & B
			VCXO_Locked <= gpio_input(9); -- connected to gpio 14 in Cav A & B
		else			
			VCXO_Powered <= not(gpio_input(7)); -- connected to gpio 12 in Cav A & B
			VCXO_Ref <= not(gpio_input(8)); -- connected to gpio 13 in Cav A & B
			VCXO_Locked <= not(gpio_input(9)); -- connected to gpio 14 in Cav A & B
		end if;
			
		Vacuum <= gpio_input(4); -- Vacuum switch -- connected to gpio_6 in Cavity A and gpio_7 in cavity B
		
		SpareDI1 <= gpio_input(10); -- connected to gpio_15 in cavity A&B
	end if;
end process;		



inst_startup : component StartUp
	port map ( Automatic_StartUp_Enable => automatic_startup_enable, 
			 CommandStart => commandStart,
			 clk => clk,
			 StateStart => StateStart,
			 LoopEnable => LoopEnable,
			 LoopEnableLatch => LoopEnableLatch,
			 TuningEnable => TuningEnable,
			 TuningEnableLatch => TuningEnableLatch,
			 RFONState_Delay => RFONState_Delay,
			 Fim_Itck_delay => Fim_Itck_delay,
			 ILoopClosed => ILoopClosed,
			 QLoopClosed => QLoopClosed,
			 RampEnable => RampEnable,
			 RampEnableLatch => RampEnableLatch,
			 IntLimit => IntLimit,
			 IntLimitLatch => IntLimitLatch,
			 counterIntLimit_out => counterIntLimit,
			 IntLimitOffsetAccum_out => IntLimitOffsetAccum,
			 LookRef => LookRef,
			 LookRefLatch => LookRefLatch,
			 
			 PolarLoopsEnable => PolarLoopsEnable,		
			 LoopEnable_FastPI => LoopEnable_FastPI, 		
			 AmpLoopEnable => AmpLoopEnable, 			
			 PhLoopEnable => PhLoopEnable, 		
			 
			 AmpLoopError => AmpLoop_Error, 			
			 PhLoopError => PhLoop_Error, 		
			 
			 LoopEnable_FastPI_latch => LoopEnable_FastPI_latch,
			 AmpLoopEnable_latch => AmpLoopEnable_latch, 	
			 PhLoopEnable_latch => PhLoopEnable_latch, 	
			 AnyLoopsEnable_latch => AnyLoopsEnable_latch,
			 
			 AmpLoopClosed => AmpLoopClosed, 			
			 PhLoopClosed => PhLoopClosed, 		
			 
			 SpareDI1 => SpareDI1, 				
			 SpareDO1 => SpareDO1, 				
			 
			 IRefMin => IRefMin,
			 QRefMin=> QRefMin,
			 AmpRefIn => AmpRefIn,
			 PhRefIn => PhRefIn,
			 AmpRefIn_latch => AmpRefIn_Latch,
			 PhRefIn_latch => PhRefIn_Latch,
			 AmpRampInit => AmpRampInit,
			 PhRampINit => PhRampInit,
			 AmpRampEnd => AmpRampEnd,
			 PhRampEnd => PhRampEnd,
			 RampingState => RampingState,
			 
			 FFEnable => FFEnable,
			 FFEnableLatch => FFEnableLatch,
			 
			 AmpRampInit_latch => AmpRampInit_latch,
			 PhRampINit_latch => PhRampInit_latch,
			 AmpRampEnd_latch => AmpRampEnd_latch,
			 PhRampEnd_latch => PhRampEnd_latch,
			 			 
			 ForwardMin => ForwardMin_Tuning,
			 IErrorMean => IErrorMean,
			 QErrorMean => QErrorMean,
			 TuningOn => TuningOn,
			 AmpRefOld => AmpRefOld,
			 AmpRefMin => AmpRefMin,
			 PhRefMin => PhRefMin);		

P2R : component Polar2Rect
    Port map(
			AmpRefOld 						 => AmpRefOld, 
			PhRefOld                    => PhRefOld,
			AmpRefMin                   => AmpRefMin, 
			PhRefMin 						 => PhRefMin,
			CavPhSh                     => CavPhSh,
			FwCavPhSh                   => FwCavPhSh,
			FwIOT1PhSh                  => FwIOT1PhSh,
			FwIOT2PhSh                  => FwIOT2PhSh,
			FwIOT3PhSh                  => FwIOT3PhSh,
			FwIOT4PhSh                  => FwIOT4PhSh,

			FwCavGain                   => FwCavGain,
			FwIOT1Gain                  => FwIOT1Gain,
			FwIOT2Gain                  => FwIOT2Gain,
			FwIOT3Gain                  => FwIOT3Gain,
			FwIOT4Gain                  => FwIOT4Gain,

			GainControl1 		          => GainControl1,
			PhShDACsIOT1 	             => PhShDACsIOT1,
			GainControl2 		          => GainControl2,
			PhShDACsIOT2 	             => PhShDACsIOT2,
			GainControl3 		          => GainControl3,
			PhShDACsIOT3 	             => PhShDACsIOT3,
			GainControl4 		          => GainControl4,
			PhShDACsIOT4 	             => PhShDACsIOT4,
																							
			AmpLoop_ControlOutput 	   => AmpLoop_ControlOutput,
			PhLoop_ControlOutput 	   => PhLoop_ControlOutput,
			PhCorrectionControl 	    	=> PhCorrectionControl,
			
			PhCorrectionControl_enable => PhCorrectionControl_enable,
																							
			clk                         => clk,
			IRefOld                     => IRefIn,
			QRefOld                     => QRefIn,
			IRefMin                     => IRefMin,
			QRefMin                     => QRefMin,
			sin_phsh_cav                => sin_phsh_cav,
			cos_phsh_cav                => cos_phsh_cav,
			sin_phsh_fwcav              => sin_phsh_fwcav,
			cos_phsh_fwcav              => cos_phsh_fwcav,
			sin_phsh_fwIOT1             => sin_phsh_fwIOT1,
			cos_phsh_fwIOT1             => cos_phsh_fwIOT1,
			sin_phsh_fwIOT2             => sin_phsh_fwIOT2,
			cos_phsh_fwIOT2             => cos_phsh_fwIOT2,
			sin_phsh_fwIOT3             => sin_phsh_fwIOT3,
			cos_phsh_fwIOT3             => cos_phsh_fwIOT3,
			sin_phsh_fwIOT4             => sin_phsh_fwIOT4,
			cos_phsh_fwIOT4             => cos_phsh_fwIOT4,
			sin_phsh_control1           => sin_phsh_control1,
			cos_phsh_control1           => cos_phsh_control1,
			sin_phsh_control2           => sin_phsh_control2,
			cos_phsh_control2           => cos_phsh_control2,
			sin_phsh_control3           => sin_phsh_control3,
			cos_phsh_control3           => cos_phsh_control3,
			sin_phsh_control4           => sin_phsh_control4,
			cos_phsh_control4           => cos_phsh_control4,
			I_DACsIF_out					 => I_DACsIF_out,
			Q_DACsIF_out 					 => Q_DACsIF_out,
			IControl_Polar              => IControl_Polar,
			QControl_Polar              => QControl_Polar
			 );		 
			 			 
inst_reference : component Reference
Port map ( 
			AmpRefIn 		         => AmpRefIn_Latch,	   -- Amplitude reference provided by automatic startup     
			PhRefIn 		           	=> PhRefIn_Latch, 		-- Phase reference provided by automatic startup        
			AmpRefMin 		         => AmpRefMin, 		        
			PhRefMin 		         => PhRefMin, 		        
			AmpRefOld_out 	         => AmpRefOld,				-- Amplitude reference to be used by loops or to be directly sent to DACs when working in Open Loop	 
			PhRefOld_out 			   => PhRefOld,				-- Phase reference to be used by loops or to be directly sent to DACs when working in Open Loop
         VoltIncRate 	         => VoltIncRate, 	        
         PhIncRate 		         => PhIncRate, 		        
         clk 			            => clk, 			        
			ConditionDutyCycle 		=> ConditionDutyCycle,
			ConditionDutyCycleDiag 	=> ConditionDutyCycleDiag,
			AutomaticConditioning 	=> AutomaticConditioning, 	
			Conditioning 			   => Conditioning, 			
			PulseUp 				      => PulseUp, 				
			RFONState_Delay 		   => RFONState_Delay,
			Fim_Itck_delay 			=> Fim_Itck_delay, 			
			Vacuum 					   => Vacuum, 					
			SquareRefEnable 		   => SquareRefEnable,
			FreqSquare 				   => FreqSquare, 				
			RampEnable 				   => RampEnableLatch,				
			TRG3Hz 					   => TRG3Hz, 					
			TRG3HzDiag 				   => TRG3HzDiag, 				
			AmpRampInit 			   => AmpRampInit, 			
			PhRampInit 				   => PhRampInit, 				
			AmpRampEnd 				   => AmpRampEnd_latch, 				
			PhRampEnd 				   => PhRampEnd_latch, 				
			RampingState_out 		   => RampingState, 		
			RampReady 				   => RampReady, 				
			t1ramping 				   => t1ramping, 				
			t2ramping 				   => t2ramping, 				
			t3ramping 				   => t3ramping, 				
			t4ramping 				   => t4ramping, 				
			BottomRamp 				   => BottomRamp, 				
			TopRamp 				   	=> TopRamp, 				
			SlopeAmpRampUp 			=> SlopeAmpRampUp, 			
			SlopeAmpRampDw 			=> SlopeAmpRampDw, 			
			SlopePhRampUp 			   => SlopePhRampUp, 			
			SlopePhRampDw 			   => SlopePhRampDw, 			
			RampIncRate 			   => RampIncRate, 			
			TopRampAmp_out 			=> TopRampAmp,			
			AmpRamp_out 			   => AmpRamp, 			
			PhRamp_out 				   => PhRamp,
			PolarLoopsEnable			=> PolarLoopsEnable
			);	
			  
-------------------------------------------------------------------------
--- Slow IQ Loops - Input Selection -------------------------------------

inst_LoopSelection : component LoopInput_Selection
    Port map( 	LoopInputSel 	=> LoopInputSel,
				ICav            => ICav,
				QCav            => QCav,
				IFwCav          => IFw,
				QFwCav          => QFw,
				IFwIOT1         => IFwIOT1,
				QFwIOT1         => QFwIOT1,
				IFwIOT2         => IFwIOT2,
				QFwIOT2         => QFwIOT2,
				IFwIOT3         => IFwIOT3,
				QFwIOT3         => QFwIOT3,
				IFwIOT4         => IFwIOT4,
				QFwIOT4         => QFwIOT4,
				clk             => clk,
				ILoopInput 	    => ILoopInput, 
				QLoopInput 	    => QLoopInput);


instantiate_PID_I : component PID
	port map(
			Input => ILoopInput,
			LoopEnable => LoopEnableLatch,
			Gain_OL => GainOL,
			Ref => IRefIn,
			Kp => Kp,
			Ki => Ki,
			Error => IError,
			ErrorAccumOut => IErrorAccum,
			ResetKi => ResetKi,
			IntLimit => IntLimitLatch,
			Control => IControl_Rect,
			clk => clk,
			ForwardMin => ForwardMin_SlowIQ);
			
instantiate_PID_Q : component PID
	port map(
			Input => QLoopInput,
			LoopEnable => LoopEnableLatch,
			Gain_OL => GainOL,
			Ref => QRefIn,
			Kp => Kp,
			Ki => Ki,
			Error => QError,
			ErrorAccumOut => QErrorAccum,
			ResetKi => ResetKi,
			IntLimit => IntLimitLatch,
			Control => QControl_Rect,
			clk => clk,
			ForwardMin => ForwardMin_SlowIQ);

inst_Ref_FastPI : component FastLoopInput_Selection
    Port map ( LoopInputSel 	=> LoopInputSel_FastPI,		
					IFwCav 			=> IFw, 				
					QFwCav 			=> QFw, 				
					IFwIOT1 			=> IFwIOT1, 			
					QFwIOT1 			=> QFwIOT1, 			
					IFwIOT2 			=> IFwIOT2, 			
					QFwIOT2 			=> QFwIOT2, 	
					IFwIOT3 			=> IFwIOT3, 			
					QFwIOT3 			=> QFwIOT3, 			
					IFwIOT4 			=> IFwIOT4, 			
					QFwIOT4 			=> QFwIOT4, 			
					clk 				=> clk, 				
					IRef_FastPI 	=> IRef_FastPI, 		
					QRef_FastPI 	=> QRef_FastPI, 		
					IInput_FastPI	=> IInput_FastPI, 		
					QInput_FastPI	=> QInput_FastPI); 

			
inst_Fast_PI_I : component Fast_PI
port map(Input 			=> IInput_FastPI,			
			LoopEnable 		=> LoopEnable_FastPI_latch,
			Ref 				=> IRef_FastPI, 			
			Kp 				=> Kp_FastPI, 				
			Ki 				=> Ki_FastPI, 
			IntLimit			=> IntLimit_FastPI,
			Error 			=> IError_FastPI, 			
			ErrorAccumOut 	=> IErrorAccum_FastPI, 	
			Control 			=> IControl_FastPI, 		
			clk 				=> clk, 			
			ForwardMin 		=> ForwardMin_FastIQ);
			
inst_Fast_PI_Q : component Fast_PI
port map(Input 			=> QInput_FastPI,			
			LoopEnable 		=> LoopEnable_FastPI_latch,
			Ref 				=> QRef_FastPI, 			
			Kp 				=> Kp_FastPI, 				
			Ki 				=> Ki_FastPI, 		
			IntLimit			=> IntLimit_FastPI,		
			Error 			=> QError_FastPI, 			
			ErrorAccumOut 	=> QErrorAccum_FastPI, 	
			Control 			=> QControl_FastPI, 		
			clk 				=> clk, 			
			ForwardMin 		=> ForwardMin_FastIQ);
			
inst_polarLoops : component PolarLoops
port map(
			IMuxCav 					=> ICav, 					
			QMuxCav 					=> QCav, 					
			IMuxFwCav 				=> IFw, 					
			QMuxFwCav 				=> QFw, 					
			IMuxFwIOT1				=> IFwIOT1,					
			QMuxFwIOT1				=> QFwIOT1,					
			IMuxFwIOT2				=> IFwIOT2,					
			QMuxFwIOT2				=> QFwIOT2,			
			IMuxFwIOT3				=> IFwIOT3,					
			QMuxFwIOT3				=> QFwIOT3,					
			IMuxFwIOT4				=> IFwIOT4,					
			QMuxFwIOT4				=> QFwIOT4,					
			clk 						=> clk, 						
			ForwardMin_Amp 		=> ForwardMin_Amp, 					
			ForwardMin_Ph 			=> ForwardMin_Ph, 					
			IPolarAmpLoop			=> IPolarAmpLoop,				
			QPolarAmpLoop			=> QPolarAmpLoop,				
			IPolarPhLoop 			=> IPolarPhLoop, 				
			QPolarPhLoop 			=> QPolarPhLoop, 				
			PolarLoopInputSelection_amp	=> PolarLoopInputSelection_amp,	
			PolarLoopInputSelection_ph 	=> PolarLoopInputSelection_ph, 	
			Amp_AmpLoopInput 		=> Amp_AmpLoopInput(15 downto 0), 			
			Gain_OL 					=> GainOL, 					
			IntLimit 				=> IntLimitLatch, 					
			Ph_PhLoopInput 		=> Ph_PhLoopInput, 				
			AmpLoop_ControlOutput=> AmpLoop_ControlOutput,
			AmpLoop_Error 			=> AmpLoop_Error, 				
			AmpLoop_ErrorAccum 	=> AmpLoop_ErrorAccum, 			
			AmpLoop_kp 				=> AmpLoop_kp, 					
			AmpLoop_ki 				=> AmpLoop_ki, 					
			AmpRefIn					=> AmpRefOld,					
			PhRefIn 					=> PhRefOld,					
			AmpPolarLoopEnable	=> AmpLoopEnable_latch,
			PhPolarLoopEnable 	=> PhLoopEnable_latch, 			
			PhLoop_controlOutput => PhLoop_controlOutput, 		
			PhLoop_Error 			=> PhLoop_Error, 				
			PhLoop_ErrorAccum 	=> PhLoop_ErrorAccum, 			
			PhLoop_kp 				=> PhLoop_kp, 					
			PhLoop_ki 				=> PhLoop_ki); 	

inst_ControlOut : component ControlOutputSelection
    Port map( IControl_Rect			=> IControl_Rect,
				QControl_Rect         => QControl_Rect,    
				IControl_FastPI      => IControl_FastPI,  
				QControl_FastPI      => QControl_FastPI,  
				IControl_Polar       => IControl_Polar,  
				QControl_Polar       => QControl_Polar,   
				PolarLoopsEnable     => PolarLoopsEnable, 
				clk                  => clk,              
				IControl             => IControl,
				QControl 	         => QControl);	  
			
ControlGain_and_PhSh : process (clk)
begin
	if(clk'EVENT and clk = '1') then
		if(DACsPhaseShiftEnable = '0') then
			IControl1 <= IControl;
			Qcontrol1 <= QControl;		
			IControl2 <= IControl;
			Qcontrol2 <= QControl;
			IControl3 <= IControl;
			Qcontrol3 <= QControl;		
			IControl4 <= IControl;
			Qcontrol4 <= QControl;		
		else
			IControl1 <= IControl1PS;
			Qcontrol1 <= QControl1PS;
			IControl2 <= IControl2PS;
			Qcontrol2 <= QControl2PS;	
			IControl3 <= IControl3PS;
			Qcontrol3 <= QControl3PS;
			IControl4 <= IControl4PS;
			Qcontrol4 <= QControl4PS;				
		end if;		
		

		case ClkDemux is
			when "00" => Control1Out_sig <= QControl1;
						 Control2Out_sig <= Qcontrol2;
						 Control3Out_sig <= Qcontrol3;
						 Control4Out_sig <= Qcontrol4;	
						 PhaseCorrection_sig <= Q_DACsIF_Out;						             
			when "01" => Control1Out_sig <= IControl1;
						 Control2Out_sig <= IControl2;
						 Control3Out_sig <= IControl3;
						 Control4Out_sig <= IControl4;
						 PhaseCorrection_sig <= I_DACsIF_Out;							 
			when "10" => Control1Out_sig <= not(QControl1);
						 Control2Out_sig <= not(QControl2);
						 Control3Out_sig <= not(Qcontrol3);
						 Control4Out_sig <= not(QControl4);	
						 PhaseCorrection_sig <= not(Q_DACsIF_Out);
			when "11" => Control1Out_sig <= not(IControl1);
						 Control2Out_sig <= not(IControl2);
						 Control3Out_sig <= not(IControl3);
						 Control4Out_sig <= not(IControl4);			
						 PhaseCorrection_sig <= not(I_DACsIF_Out);	
			when others => null;
		end case;
		
		  Control1 <= Control1Out_sig;
		  Control2 <= Control2Out_sig;
		  Control3 <= Control3Out_sig;
		  Control4 <= Control4Out_sig;
		  Control5_VCav <= AmpCav(15 downto 0);
		  Control8_IFDACs <= PhaseCorrection_sig;

		  
	end if;
end process controlGain_and_PhSh;
			
			
-----End PID Control------------------------------
--------------------------------------------------



---------------------------------------------------------
---Tuning Loop and Field Flatness -----------------------

inst_Tuning : component Tuning
Port map ( 
			clk 						=> clk, 						
			TuningEnable 			=> TuningEnableLatch, 				
			TunPosEnable 			=> TunPosEnable, 				
			ForwardMin 				=> ForwardMin_Tuning, 					
			PulseUp 					=> PulseUp, 					
			Conditioning 			=> Conditioning, 				
			TuningReset 			=> TuningReset, 				
			MovePLG1 				=> MovePLG1, 					
			MoveUp1 					=> MoveUp1, 				
			MovePLG2 				=> MovePLG2, 					
			MoveUp2 					=> MoveUp2, 							
			CLKPerPulse 			=> CLKPerPulse, 				
			NumSteps 				=> NumSteps, 					
			MarginUp 				=> MarginUp, 					
			MarginLow 				=> MarginLow, 	
			Conf						=> Conf,
			RampEnableLatch		=> RampEnableLatch,
			TopRamp					=> TopRamp,
			FFEnable					=> FFEnableLatch,
			FFPos						=> FFPos,
			AmpCell2					=> AmpCell2Mean,
			AmpCell4					=> AmpCell4Mean,
			AmpCell2Gain			=> AmpCell2Gain,
			AmpCell4Gain			=> AmpCell4Gain,
			FFPercentage			=> FFPercentage,
			FFError_out				=> FFError,
			AmpCell2FF_out			=> AmpCell2FF,
			AmpCell4FF_out			=> AmpCell4FF,
			FFOn_out					=> FFOn,
				
			State_out 				=> State, 					
			TuningOn_out 			=> TuningOn, 				
			TuningEna_Delay_out 	=> TuningOnDelay, 		
			PlungerMoving_Auto 	=> PlungerMovingAuto, 			
			PlungerMoving_Manual1 => PlungerMovingManual1,		
			PlungerMoving_Manual2 => PlungerMovingManual2,		
			TuningDephase 			=> TuningDephase, 				
			TuningDephase_Filt_out 		=> TuningDephase_Filt, 		
			AngCavFw_out	 		=> AngCavFw, 		
			AngCav 					=> AngCav, 						
			AngFw 					=> AngFw, 						
			PhaseOffset 			=> PhaseOffset, 				
			TTL_gpio_output_1		=> TTL1,			
			TTL_gpio_output_2		=> TTl2,						
			TTL_gpio_output_3		=> TTL3,			
			TTL_gpio_output_4		=> TTl4,		
			
			CounterTuningDelaySetting 	=> CounterTuningDelaySetting, 	
			TuningDephase80HzLPFEnable => TuningDephase80HzLPFEnable,		
			TuningTrigger_out 	=> TuningTrigger, 			
			TuningTriggerEnable 	=> TuningTriggerEnable, 		
			TuningInput_out 		=> TuningInput,
			TunFFOnTopEnable 		=> TunFFOnTopEnable);
			
inst_FwMin : component FwMinLoopsEnable
	port map (
			FwMin_Tuning 	=>  FwMin_Tuning,
			FwMin_AmpPh 	=>  FwMin_AmpPh,
			clk 				=>  clk,
			LoopsIn_SlowI 	=>  ILoopInput,
			LoopsIn_SlowQ 	=>  QLoopInput,
			LoopsIn_FastI 	=>  IInput_FastPI,
			LoopsIn_FastQ 	=>  QInput_FastPI,
			LoopsIn_Amp 	=>  Amp_AmpLoopInput(15 downto 0),
			LoopsIn_Ph 		=>  Amp_PhLoopInput(15 downto 0),
			AmpFwCav 		=>  AmpFw,
			ForwardMin_Tuning =>  ForwardMin_Tuning,
			ForwardMin_Amp 	=>  ForwardMin_Amp,
			ForwardMin_SlowIQ =>  ForwardMin_SlowIQ,
			ForwardMin_FastIQ =>  ForwardMin_FastIQ,
			ForwardMin_Ph 		=>  ForwardMin_Ph
			);



gpio_outs : process(clk)
begin
	if(clk'EVENT and clk = '1') then		
	
		gpio_output <= gpio_output_sig;
		
		ITCKOut_SetLLRF2STBY_sig <= gpio_out_itck(0);
		PinDiodeSw_sig 		<= gpio_out_itck(1);
		FDL_trig_HW_input		<= gpio_out_itck(2);
		LLRFItckOut2PLC_sig 	<= gpio_out_itck(3);
		LLRFItckOut2LLRF_sig <= gpio_out_itck(4);
		

		-- GPIO Outputs
			gpio_output_sig(0) <= PulseUp; -- connected to gpio_16 in cavity A & gpio_17 in cavity B
--			gpio_output_sig(1) <= TTL1; --direction plunger. connected to gpio_28 in cavity A and gpio_19 in cavity B
--			gpio_output_sig(2) <= TTL2; --pulse plunger. Connected to gpio_20 in cavity A and gpio_21 in cavity B
--			gpio_output_sig(3) <= TTL3; --direction plunger - field flatness. connected to gpio_19 in cavity A and NOT CONNECTED IN CAVITY B
--			gpio_output_sig(4) <= TTL4; --pulse plunger - field flatness. Connected to gpio_21 in cavity A and NOT CONNECTED IN CAVITY B
			gpio_output_sig(5) <= LLRFItckOut2PLC_sig; -- connected to gpio_22 in cavity A and connected to gpio:23 in cavity B			
--			gpio_output_sig(6) <= PinDiodeSw_sig; -- depending on cav conf, to be connected to gpio_24-25-26-27 in cavity A and connected to gpio_26-27 in cavity B		
--			gpio_output_sig(7) <= VCXO_Enable; -- connected gpio 28 in cavity A and not connected in cavity B
--			gpio_output_sig(8) <= VCXO_clk; -- connected to gpio_29 in cavity A and not connected in cavity B
--			gpio_output_sig(9) <= VCXO_Word; -- connected to gpio_30 in cavity A and not connected in cavity B
			gpio_output_sig(10) <= LLRFItckOut2LLRF_sig; -- connected to gpio_31 in cavity A&B
			
			PlungerMoving_diag1 <= PlungerMovingAuto or PlungerMovingManual1;
			PlungerMovingUp_diag1 <= PlungerMoving_diag1 and (not(TTL1));
			PlungerMoving_diag2 <= PlungerMovingAuto2 or PlungerMovingManual2;
			PlungerMovingUp_diag2 <= PlungerMoving_diag2 and (not(TTL3));
			
			LLRFItckOut <= LLRFItckOut2LLRF_sig;
			PinDiodeSw <= PinDiodeSw_sig;
		
		if(gpio_out_inversion = '1') then		-- Signals that need to be inverted when there is NO Perseus Digital Patch panel
			gpio_output_sig(1) <= TTL1; --direction plunger. connected to gpio_28 in cavity A and gpio_19 in cavity B
			gpio_output_sig(2) <= TTL2; --pulse plunger. Connected to gpio_20 in cavity A and gpio_21 in cavity B
			gpio_output_sig(3) <= TTL3; --direction plunger - field flatness. connected to gpio_19 in cavity A and NOT CONNECTED IN CAVITY B
			gpio_output_sig(4) <= TTL4; --pulse plunger - field flatness. Connected to gpio_21 in cavity A and NOT CONNECTED IN CAVITY B
			
			gpio_output_sig(6) <= not(PinDiodeSw_sig); -- depending on cav conf, to be connected to gpio_24-25-26-27 in cavity A and connected to gpio_26-27 in cavity B		
			
			gpio_output_sig(7) <= VCXO_Enable; -- connected gpio 28 in cavity A and not connected in cavity B
			gpio_output_sig(8) <= VCXO_clk; -- connected to gpio_29 in cavity A and not connected in cavity B
			gpio_output_sig(9) <= VCXO_Word; -- connected to gpio_30 in cavity A and not connected in cavity B
			
		else				
			gpio_output_sig(1) <= not(TTL1); --direction plunger. connected to gpio_28 in cavity A and gpio_19 in cavity B
			gpio_output_sig(2) <= not(TTL2); --pulse plunger. Connected to gpio_20 in cavity A and gpio_21 in cavity B
			gpio_output_sig(3) <= not(TTL3); --direction plunger - field flatness. connected to gpio_19 in cavity A and NOT CONNECTED IN CAVITY B
			gpio_output_sig(4) <= not(TTL4); --pulse plunger - field flatness. Connected to gpio_21 in cavity A and NOT CONNECTED IN CAVITY B
		
			gpio_output_sig(6) <= PinDiodeSw_sig; -- depending on cav conf, to be connected to gpio_24-25-26-27 in cavity A and connected to gpio_26-27 in cavity B		
		
			gpio_output_sig(7) <= not(VCXO_Enable); -- connected gpio 28 in cavity A and not connected in cavity B
			gpio_output_sig(8) <= not(VCXO_clk); -- connected to gpio_29 in cavity A and not connected in cavity B
			gpio_output_sig(9) <= not(VCXO_Word); -- connected to gpio_30 in cavity A and not connected in cavity B
		
		end if;
	end if;
end process gpio_outs;
		


R2P_PolarLoops : component CordicRect2Polar 
    Port map (I_in => I_in_r2p_PolarLoops,
				  Q_in => Q_in_r2p_PolarLoops,
				  clk => clk,
				  Amp_out => Amp_out_r2p_PolarLoops,
				  Ph_out => ph_out_r2p_PolarLoops,
				  id_in => id_in_r2p_PolarLoops,
				  id_out => id_out_r2p_PolarLoops);		

R2P : component CordicRect2Polar 
    Port map (I_in => I_in_r2p,
				  Q_in => Q_in_r2p,
				  clk => clk,
				  Amp_out => Amp_out_r2p,
				  Ph_out => ph_out_r2p,
				  id_in => id_in_r2p,
				  id_out => id_out_r2p);		  
			  
process(clk)
begin
	if(clk'EVENT and clk = '1') then
		mux_r2p <= mux_r2p + 1;
		
	
	case mux_r2p(0) is 
		when '0' => I_in_r2p_PolarLoops <= IPolarAmpLoop;
							Q_in_r2p_PolarLoops <= QPolarAmpLoop;
							id_in_r2p_PolarLoops <= "0010";
		when '1' => I_in_r2p_PolarLoops <= IPolarPhLoop;
							Q_in_r2p_PolarLoops <= QPolarPhLoop;
							id_in_r2p_PolarLoops <= "0011";	
		when others => null;
	end case;
	
	
	case id_out_r2p_PolarLoops is
		when "0010" => Amp_AmpLoopInput <= Amp_out_r2p_PolarLoops;
							Ph_AmpLoopInput <= Ph_out_r2p_PolarLoops;
		when "0011" => Amp_PhLoopInput <= Amp_out_r2p_PolarLoops;
							Ph_PhLoopInput <= Ph_out_r2p_PolarLoops;
		when others => null;
	end case;
		
	
			
	case mux_r2p(3 downto 0) is 
		when "0000" => I_in_r2p <= IMuxCav;
							Q_in_r2p <= QMuxCav;
							id_in_r2p <= "0000";
		when "0010" => I_in_r2p <= IMuxFwCav;
							Q_in_r2p <= QMuxFwCav;
							id_in_r2p <= "0010";
		when "0100" => I_in_r2p <= IRvIOT1;
							Q_in_r2p <= QRvIOT1;
							id_in_r2p <= "0100";
		when "0110" => I_in_r2p <= IRvIOT2;
							Q_in_r2p <= QRVIOT2;
							id_in_r2p <= "0110";
							
		when "1000" => I_in_r2p <= IRvIOT3_ICell2;
							Q_in_r2p <= QRvIOT3_QCell2;
							id_in_r2p <= "1000";
		when "1010" => I_in_r2p <= IRvIOT4_ICell4;
							Q_in_r2p <= QRvIOT4_QCEll4;
							id_in_r2p <= "1010";
		when "1100" => I_in_r2p <= IRvCav;
							Q_in_r2p <= QRvCav;
							id_in_r2p <= "1100";
		when "1110" => I_in_r2p <= IMO;
							Q_in_r2p <= QMO;
							id_in_r2p <= "1110";
							
		when others => I_in_r2p <= IMuxDACsIF;
							Q_in_r2p <= QMuxDACsIF;
							id_in_r2p <= "0001";
	end case;
	
	case id_out_r2p is
		when "0000" => AmpCav <= Amp_out_r2p;
							AngCav <= Ph_out_r2p;							
		when "0010" => AmpFw <= Amp_out_r2p;
							AngFw <= Ph_out_r2p;
		when "0100" => AmpRvIOT1 <= Amp_out_r2p;
							PhRvIOT1 <= Ph_out_r2p;
		when "0110" => AmpRvIOT2_sig <= Amp_out_r2p;
							PhRvIOT2_sig <= Ph_out_r2p;
		when "1000" => AmpRvIOT3_Cell2_sig <= Amp_out_r2p;
							PhRvIOT3_Cell2_sig <= Ph_out_r2p;
		when "1010" => AmpRvIOT4_Cell4_sig <= Amp_out_r2p;
							PhRvIOT4_Cell4_sig <= Ph_out_r2p;
		when "1100" => AmpRvCav <= Amp_out_r2p;
							PhRvCav <= Ph_out_r2p;
		when "1110" => AmpMO <= Amp_out_r2p;
							PhMO <= Ph_out_r2p;
							
		when "0001" => AmpDACsIF <= Amp_out_r2p(15 downto 0);
							PhDACsIF <= Ph_out_r2p;
							
		when others => null;
	end case;
	
	if(conf = "10") then 	--in SC case, RvIOT1&23&4 interlocks  have to be considered
		AmpRvIOT2 <= AmpRvIOT2_sig;
		PhRvIOT2 <= PhRvIOT2_sig;
		AmpRvIOT3 <= AmpRvIOT3_Cell2_sig;
		PhRvIOT3 <= PhRvIOT3_Cell2_sig;
		AmpRvIOT4 <= AmpRvIOT4_Cell4_sig;
		PhRvIOT4 <= PhRvIOT4_Cell4_sig;
		IRvIOT3_ICell2 <= IRvIOT3;
		QRvIOT3_QCell2 <= QRvIOT3;
		IRvIOT4_ICell4 <= IRvIOT4;
		QRvIOT4_QCell4 <= QRvIOT4;
		AmpCell2 <= (others => '0');
		AmpCell4 <= (others => '0');
		PhCell2 <= (others => '0');
		PhCell4 <= (others => '0');
	elsif(conf = "11") then	 -- In Booster case, only RvIOT1 is considered. RvIOT2&3&4 are not considered 
		AmpRvIOT2 <= (others => '0');
		PhRvIOT2 <= (others => '0');
		AmpRvIOT3 <= (others => '0');
		PhRvIOT3 <= (others => '0');
		AmpRvIOT4 <= (others => '0');
		PhRvIOT4 <= (others => '0');
		IRvIOT3_ICell2 <= ICell2;
		QRvIOT3_QCell2 <= QCell2;
		IRvIOT4_ICell4 <= ICell4;
		QRvIOT4_QCell4 <= QCell4;
		AmpCell2 <= AmpRvIOT3_Cell2_sig;
		AmpCell4 <= AmpRvIOT4_Cell4_sig;
		PhCell2 <= PhRvIOT4_Cell4_sig;
		PhCell4 <= PhRvIOT4_Cell4_sig;
	else							-- In NC case, only RvIOT1&2 interlocks have to be considered
		AmpRvIOT2 <= AmpRvIOT2_sig;
		PhRvIOT2 <= PhRvIOT2_sig;
		AmpRvIOT3 <= (others => '0');
		PhRvIOT3 <= (others => '0');
		AmpRvIOT4 <= (others => '0');
		PhRvIOT4 <= (others => '0');
		IRvIOT3_ICell2 <= (others => '0');
		QRvIOT3_QCell2 <= (others => '0');
		IRvIOT4_ICell4 <= (others => '0');
		QRvIOT4_QCell4 <= (others => '0');
		AmpCell2 <= (others => '0');
		AmpCell4 <= (others => '0');
		PhCell2 <= (others => '0');
		PhCell4 <= (others => '0');
	end if;
	
	
	end if;
end process;

process(clk)
begin
if(clk'EVENT and clk = '1') then
		PhCorrection_Error <= PhMO - PhDACsIF;
	if(PhCorrectionControl_enable = '1' and LookRefLatch = '0' and AnyLoopsEnable_latch = '0') then	
		PhCorrectionControl_32b <= PhCorrectionControl_32b + PhCorrection_Error + X"00000000";
		PhCorrectionControl <= PhCorrectionControl_32b(31 downto 16);
	elsif(PhCorrectionControl_enable = '0' ) then
		PhCorrectionControl_32b <= (others => '0');
		PhCorrectionControl <= (others => '0');
	end if;		
end if;
end process;




--------------------------------
-- FDL Interface ---------------


FDL: component FDL_Interface 
    Port map(
			Interface_01		  => Interface_01_sig,
			Interface_02        => Interface_02_sig,
			Interface_03        => Interface_03_sig,
			Interface_04        => Interface_04_sig,
			Interface_05        => Interface_05_sig,
			Interface_06        => Interface_06_sig,
			Interface_07        => Interface_07_sig,
			Interface_08        => Interface_08_sig,								
			clk                 => clk,
			ICav                => ICav,
			QCav                => QCav,
			IControl            => IControl,
			QControl            => QControl,
			IFwCav              => IFw,
			QFwCav              => QFw,
			IFwIOT1             => IFwIOT1,
			QFwIOT1             => QFwIOT1,
			IRvIOT1             => IRvIOT1,
			QRvIOT1             => QRvIOT1,
			IRvCav              => IRvCav,
			QRvCav              => QRvCav,
			TuningDephase 		=> TuningDephase,
			TuningDephase_filt  => TuningDephase_filt,
			AngCav 				=> AngCav, 
			AngFw 				=> AngFw,		
			TTL1 				=> TTL1,
			TTL2 				=> TTL2,
			TuningOn 			=> TuningOnDelay, 
			IRefIn              => IRefIn,
			QRefIn              => QRefIn,
			IError              => IError,
			QError              => QError,
			IErrorAccum         => IErrorAccum,
			QErrorAccum         => QErrorAccum,
			IMO                 => IMO,
			QMO                 => QMO,			
		
			IRef_FastPI				=> IRef_FastPI,	
			QRef_FastPI		   	=> QRef_FastPI,		
			IInput_FastPI	    	=> IInput_FastPI,	
			QInput_FastPI	    	=> QInput_FastPI,	
			IError_FastPI	    	=> IError_FastPI,	
			QError_FastPI	    	=> QError_FastPI,	
			IErrorAccum_FastPI  	=> IErrorAccum_FastPI, 
			QErrorAccum_FastPI  	=> QErrorAccum_FastPI,		
		
			AmpCav              => AmpCav(15 downto 0),			
			AngFwCav            => AngFw,
			AmpFwCav            => AmpFw(15 downto 0),
			AmpRefin  				=> AmpRefin_latch, 			
			PhRefin  				=> PhRefin_latch,  			
			Amp_AmpLoopInput  	=> Amp_Amploopinput(15 downto 0),  	
			Ph_PhLoopInput  		=> Ph_Phloopinput,  	
			AmpError  				=> AmpLoop_Error,  			
			PhError  				=> PhLoop_Error,  			
			AmpErrorAccum 			=> AmpLoop_ErrorAccum, 		
			PhErrorAccum  			=> PhLoop_ErrorAccum,  		
			AmpControlOutput  	=> AmpLoop_ControlOutput,  	
			PhControlOutput  		=> PhLoop_ControlOutput,  	
			IPolarControl  		=> IControl_Polar,  		
			QPolarControl  		=> QControl_Polar,  		
			IPolarAmpLoop  		=> IPolarAmploop,  		
			QPolarAmpLoop  		=> QPolarAmploop,  		
			IPolarPhLoop  			=> IPolarPhloop,  		
			QPolarPhLoop 			=> QPolarPhloop,
			VCav_16b					=> VCav_16b); 		


process (clk)
begin
	if(clk='1' and clk'EVENT) then
		if(FDL_ADCsRawData = '1') then
			Interface_01		  <= VCav_16b;
			Interface_02        <= FwCav_16b;
			Interface_03        <= RvCav_16b;
			Interface_04        <= MO_16b;		
			Interface_05        <= FwIOT1_16b;
			Interface_06        <= RvIOT1_16b;
			Interface_07        <= RFIn7_16b;
			Interface_08        <= RFIn8_16b;		
		else		
			Interface_01			<= Interface_01_sig;
			Interface_02        <= Interface_02_sig;
			Interface_03        <= Interface_03_sig;
			Interface_04        <= Interface_04_sig;
			Interface_05        <= Interface_05_sig;
			Interface_06        <= Interface_06_sig;
			Interface_07        <= Interface_07_sig;
			Interface_08        <= Interface_08_sig;				
		end if;
	end if;
end process;
			

	VCXO_inst:	component VCXO_Programming
		port map(LE_VCXO => VCXO_Enable,
					Data_VCXO => VCXO_Word,
					clk_VCXO => VCXO_clk,
					clk => clk,
					MDivider => MDivider,		
					NDivider => NDivider,           
					MuxSel => MuxSel,          
					Mux0 => Mux0,         
					Mux1 => Mux1,        
					Mux2 => Mux2,       
					Mux3 => Mux3,      
					Mux4 => Mux4,     
					CP_Dir => CP_Dir, 
					SendWordVCXO => SendWordVCXO, 
					VCXO_out_inversion  => gpio_out_inversion);
					
	process (clk)
	begin
	if (clk = '1' and clk'EVENT) then
		case conf is
			-- "00"  Configuration for Normal Conducting Cavities
			when "00" => IMuxFwIOT2 <= IRFIn7;
							 QMuxFwIOT2 <= QRFIn7;
							 
							 IRvIOT2 <= IRFIn8;
							 QRvIOT2 <= QRFIn8;
							 IRvIOT3 <= (others => '0');
							 QRvIOT3 <= (others => '0');
							 IRvIOT4 <= (others => '0');
							 QRvIOT4 <= (others => '0');
							 
							 IMuxFwIOT3 <= (others => '0');
							 QMuxFwIOT3 <= (others => '0');
							 IMuxFwIOT4 <= (others => '0');
							 QMuxFwIOT4 <= (others => '0');
							 
							 
							 ICell2 <= (others => '0');
							 QCell2 <= (others => '0');
							 ICell4 <= (others => '0');
							 QCell4 <= (others => '0');
							 
			-- "01"  Configuration for Normal Conducting Cavities									 
			when "01" => IMuxFwIOT2 <= IRFIn7;
							 QMuxFwIOT2 <= QRFIn7;
							 
							 IRvIOT2 <= IRFIn8;
							 QRvIOT2 <= QRFIn8;
							 IRvIOT3 <= (others => '0');
							 QRvIOT3 <= (others => '0');
							 IRvIOT4 <= (others => '0');
							 QRvIOT4 <= (others => '0');
							 
							 IMuxFwIOT3 <= (others => '0');
							 QMuxFwIOT3 <= (others => '0');
							 IMuxFwIOT4 <= (others => '0');
							 QMuxFwIOT4 <= (others => '0');
							 
							 ICell2 <= (others => '0');
							 QCell2 <= (others => '0');
							 ICell4 <= (others => '0');
							 QCell4 <= (others => '0');
			
			-- "10"  Configuration for Super Conducting Cavities				 
			when "10" => IMuxFwIOT2 <= IRFIn7;
							 QMuxFwIOT2 <= QRFIn7;
							 
							 IRvIOT2 <= IRFIn8;
							 QRvIOT2 <= QRFIn8;
							 IRvIOT3 <= IRFIn10;
							 QRvIOT3 <= QRFIn10;
							 IRvIOT4 <= IRFIn12;
							 QRvIOT4 <= QRFIn12;
							 
							 IMuxFwIOT3 <= IRFIn9;
							 QMuxFwIOT3 <= QRFIn9;
							 IMuxFwIOT4 <= IRFIn11;
							 QMuxFwIOT4 <= QRFIn11;
							 
							 ICell2 <= (others => '0');
							 QCell2 <= (others => '0');
							 ICell4 <= (others => '0');
							 QCell4 <= (others => '0');
			
			-- "11"  Configuration for Booster Cavity				 
			when "11" => IMuxFwIOT2 <= (others => '0');
							 QMuxFwIOT2 <= (others => '0');
							 
							 IMuxFwIOT3 <= (others => '0');
							 QMuxFwIOT3 <= (others => '0');
							 IMuxFwIOT4 <= (others => '0');
							 QMuxFwIOT4 <= (others => '0');
							 
							 ICell2 <= IRFIn7;
							 QCell2 <= QRFIn7;
							 ICell4 <= IRFIn8;
							 QCell4 <= QRFIn8;
							 							 
							 IRvIOT2 <= (others => '0');
							 QRvIOT2 <= (others => '0');
							 IRvIOT3 <= (others => '0');
							 QRvIOT3 <= (others => '0');
							 IRvIOT4 <= (others => '0');
							 QRvIOT4 <= (others => '0');
							 
			when others => null;
		end case;
	end if;
	end process;
	
	
inst_FIM : component FIM 
Port map ( 
			clk 					=> clk,
			ResetFIM 			=> ResetFIM, 						
			AmpRvIOT1 			=> AmpRvIOT1(15 downto 0), 						
			AmpRvIOT2			=> AmpRvIOT2(15 downto 0),						
			AmpRvIOT3 			=> AmpRvIOT3(15 downto 0), 						
			AmpRvIOT4 			=> AmpRvIOT4(15 downto 0), 						
			AmpRvCav 			=> AmpRvCav(15 downto 0), 						
			Manual_itck_in		=> Manual_itck_in,				
			ExtLLRF3ITCK_In	=> LLRFItckIn,					
			gpio_in_itck 		=> gpio_input,					
			RvIOT1Limit 		=> RvIOT1Limit,					
			RvIOT2Limit 		=> RvIOT2Limit, 					
			RvIOT3Limit 		=> RvIOT3Limit, 					
			RvIOT4Limit 		=> RvIOT4Limit,					
			RvCavLimit 			=> RvCavLimit, 						
			Conf 					=> Conf, 							
			DisableITCK_RvIOT1 	=> DisableITCK_RvIOT1, 				
			DisableITCK_RvIOT2 	=> DisableITCK_RvIOT2, 				
			DisableITCK_RvIOT3 	=> DisableITCK_RvIOT3, 				
			DisableITCK_RvIOT4 	=> DisableITCK_RvIOT4,				
			DisableITCK_RvCav		=> DisableITCK_RvCav,				
			DisableITCK_Manual	=> DisableITCK_Manual,				
			DisableITCK_PLC		=> DisableITCK_PLC,					
			DisableITCK_LLRF1		=> DisableITCK_LLRF1,				
			DisableITCK_LLRF2		=> DisableITCK_LLRF2,				
			DisableITCK_LLRF3		=> DisableITCK_LLRF3,				
			DisableITCK_ESwUp1	=> DisableITCK_ESwUp1,			
			DisableITCK_ESwDw1	=> DisableITCK_ESwDw1,			
			DisableITCK_ESwUp2	=> DisableITCK_ESwUp2,				
			DisableITCK_ESwDw2	=> DisableITCK_ESwDw2,				
			EndSwitchNO				=> EndSwitchNO,						
			gpio_out_itck 			=> gpio_out_itck, 					
			ITCK_Detected			=> ITCK_Detected,				
			InterlocksDisplay0 	=> InterlocksDisplay0,				
			InterlocksDisplay1 	=> InterlocksDisplay1,				
			InterlocksDisplay2 	=> InterlocksDisplay2,				
			InterlocksDisplay3 	=> InterlocksDisplay3, 				
			InterlocksDisplay4 	=> InterlocksDisplay4,				
			InterlocksDisplay5 	=> InterlocksDisplay5,				
			InterlocksDisplay6 	=> InterlocksDisplay6,				
			InterlocksDisplay7 	=> InterlocksDisplay7,				
			timestamp1_out 		=> timestamp1_out,					
			timestamp2_out 		=> timestamp2_out,					
			timestamp3_out 		=> timestamp3_out,					
			timestamp4_out 		=> timestamp4_out,					
			timestamp5_out 		=> timestamp5_out,					
			timestamp6_out 		=> timestamp6_out,					
			timestamp7_out 		=> timestamp7_out,					
			delay_interlocks   	=> delay_interlocks   				
			);

	
end MainProgram_arc;