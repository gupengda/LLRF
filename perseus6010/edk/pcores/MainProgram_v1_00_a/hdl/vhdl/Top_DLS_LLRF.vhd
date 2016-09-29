----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    09:21:37 07/05/2016 
-- Design Name: 
-- Module Name:    Top_DLS_LLRF - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_DLS_LLRF is
    Port ( 
				Mi125AdcDataClkTop_s : in std_logic;
				mo1000_0_Trigger_r1_s : in std_logic;
				
				i_Reset_p			: out  STD_LOGIC;
				o_DelayRdy_p		: in  STD_LOGIC;
				iv32_DioDIn_p		: out  STD_LOGIC_VECTOR (31 downto 0);
				iv32_DioDInDir_p	: out  STD_LOGIC_VECTOR (31 downto 0);
				ov32_DioDOut_p		: in  STD_LOGIC_VECTOR (31 downto 0);
				i_SetGpioDir_p		: out  STD_LOGIC;
				i_Start_p			: out  STD_LOGIC;
				ov12_AdcData0_p	: in  STD_LOGIC_VECTOR (11 downto 0);
				ov12_AdcData1_p	: in  STD_LOGIC_VECTOR (11 downto 0);
				ov12_AdcData2_p	: in  STD_LOGIC_VECTOR (11 downto 0);
				ov12_AdcData3_p	: in  STD_LOGIC_VECTOR (11 downto 0);
				o_AdcData0Valid_p 	: in  STD_LOGIC;
				o_AdcData1Valid_p 	: in  STD_LOGIC;
				o_AdcData2Valid_p 	: in  STD_LOGIC;
				o_AdcData3Valid_p 	: in  STD_LOGIC;

				v32_gpio_configuration     : in  STD_LOGIC_VECTOR (31 downto 0);
				custom_reg_gpio_read_in_s  : in  STD_LOGIC_VECTOR (15 downto 0);
				custom_reg_gpio_read_out_s : out  STD_LOGIC_VECTOR (15 downto 0);

				Control1 : out  STD_LOGIC_VECTOR (15 downto 0);
				Control2 : out  STD_LOGIC_VECTOR (15 downto 0);
				Control3 : out  STD_LOGIC_VECTOR (15 downto 0);
				Control4 : out  STD_LOGIC_VECTOR (15 downto 0);
				Control5 : out  STD_LOGIC_VECTOR (15 downto 0);
				Control6 : out  STD_LOGIC_VECTOR (15 downto 0);

				FDL_Trig_out : out  STD_LOGIC;

				v14_Mi125AdcDataCh1Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh2Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh3Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh4Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh5Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh6Top_s	: in std_logic_vector (13 downto 0);			 
				v14_Mi125AdcDataCh7Top_s	: in std_logic_vector (13 downto 0);			 
				v14_Mi125AdcDataCh8Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh9Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh10Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh11Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh12Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh13Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh14Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh15Top_s	: in std_logic_vector (13 downto 0);
				v14_Mi125AdcDataCh16Top_s	: in std_logic_vector (13 downto 0);

				v32_reg_data1_A_s : in std_logic_vector(31 downto 0);
				i_v16_reg_data2_A_s: in std_logic_vector (15 downto 0);
				o_v16_reg_data2_A_s : out std_logic_vector (15 downto 0);
				i_v17_reg_data3_A_s: in std_logic_vector (16 downto 0);
				o_v32_reg_data3_A_s : out std_logic_vector (31 downto 0);

				v32_reg_data1_B_s : in std_logic_vector(31 downto 0);
				i_v16_reg_data2_B_s: in std_logic_vector (15 downto 0);
				o_v16_reg_data2_B_s : out std_logic_vector (15 downto 0);
				i_v17_reg_data3_B_s: in std_logic_vector (16 downto 0);
				o_v32_reg_data3_B_s : out std_logic_vector (31 downto 0);

				v16_A_Interface_01 : out std_logic_vector (15 downto 0);
				v16_A_Interface_02 : out std_logic_vector (15 downto 0);
				v16_A_Interface_03 : out std_logic_vector (15 downto 0);
				v16_A_Interface_04 : out std_logic_vector (15 downto 0);
				v16_A_Interface_05 : out std_logic_vector (15 downto 0);
				v16_A_Interface_06 : out std_logic_vector (15 downto 0);
				v16_A_Interface_07 : out std_logic_vector (15 downto 0);
				v16_A_Interface_08 : out std_logic_vector (15 downto 0);	

				v16_B_Interface_01 : out std_logic_vector (15 downto 0);
				v16_B_Interface_02 : out std_logic_vector (15 downto 0);
				v16_B_Interface_03 : out std_logic_vector (15 downto 0);
				v16_B_Interface_04 : out std_logic_vector (15 downto 0);
				v16_B_Interface_05 : out std_logic_vector (15 downto 0);
				v16_B_Interface_06 : out std_logic_vector (15 downto 0);
				v16_B_Interface_07 : out std_logic_vector (15 downto 0);
				v16_B_Interface_08 : out std_logic_vector (15 downto 0);
				
				conf : in std_logic_vector (1 downto 0));

end Top_DLS_LLRF;

architecture Behavioral of Top_DLS_LLRF is


-- Signals declaration
	signal PinDiodeSw : STD_LOGIC_VECTOR (3 downto 0);	
	signal FDL_Trig_Out_A : STD_LOGIC;
	signal FDL_Trig_Out_B : STD_LOGIC;

	signal LLRFItckOut : std_logic;
			 
	signal v16_Control1_A : std_logic_vector (15 downto 0);
	signal v16_Control2_A : std_logic_vector (15 downto 0);
	signal v16_Control3_A : std_logic_vector (15 downto 0);
	signal v16_Control4_A : std_logic_vector (15 downto 0);
	signal v16_Control5_VCavA : std_logic_vector (15 downto 0);
	signal Control8_IFDACsA : std_logic_vector (15 downto 0);	
		 
	signal v16_Control1_B : std_logic_vector (15 downto 0);
	signal v16_Control2_B : std_logic_vector (15 downto 0);
	signal v16_Control3_B : std_logic_vector (15 downto 0);
	signal v16_Control4_B : std_logic_vector (15 downto 0);
	signal v16_Control5_VCavB : std_logic_vector (15 downto 0);
	signal Control8_IFDACsB : std_logic_vector (15 downto 0);

	signal v12_gpio_input_A : std_logic_vector (12 downto 0);
	signal v10_gpio_output_A : std_logic_vector(10 downto 0);

	signal v12_gpio_input_B : std_logic_vector (12 downto 0);
	signal v10_gpio_output_B : std_logic_vector(10 downto 0);
			
	signal FDL_Trig_A :  std_logic;
	signal PinDiodeSw_A :  std_logic;
	signal FDL_Trig_B :  std_logic;
	signal PinDiodeSw_B :  std_logic;
	signal LLRFItckOut_A :  std_logic;
	signal LLRFItckOut_B :  std_logic; 	

-- components declaration

component GPIO_Interface is
    Port ( o_Reset : out  STD_LOGIC;
           i_Ready : in  STD_LOGIC;
           ov32_Gpio_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ov32_GpioDir : out  STD_LOGIC_VECTOR (31 downto 0);
           iv32_Gpio_in : in  STD_LOGIC_VECTOR (31 downto 0);
           o_SetGpioDir : out  STD_LOGIC;
           o_StartGpio : out  STD_LOGIC;
           iv12_GpioAdcData0 : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_GpioAdcData1 : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_GpioAdcData2 : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_GpioAdcData3 : in  STD_LOGIC_VECTOR (11 downto 0);
           i_GpioAdcData0Valid : in  STD_LOGIC;
           i_GpioAdcData1Valid : in  STD_LOGIC;
           i_GpioAdcData2Valid : in  STD_LOGIC;
           i_GpioAdcData3Valid : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           custom_reg_gpio_write : in  STD_LOGIC_VECTOR (31 downto 0);
           custom_reg_gpio_read_in : in  STD_LOGIC_VECTOR (15 downto 0);
           custom_reg_gpio_read_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  gpio_input_A : out std_logic_vector (12 downto 0);
			  gpio_output_A: in std_logic_vector (10 downto 0);
			  gpio_input_B : out std_logic_vector (12 downto 0);
			  gpio_output_B: in std_logic_vector (10 downto 0);
			  PinDiodeSw : in std_logic_vector (3 downto 0);
			  LLRFITckOut : in std_logic;
			  Conf : in std_logic_vector(1 downto 0));
end component GPIO_Interface;


component Plant_Interface is
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
end component Plant_Interface;


component MainProgram IS
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
			 
end component MainProgram;



begin


Instantiation_MainProgramA : component MainProgram
Port map(	
			VCav => v14_Mi125AdcDataCh1Top_s(13)&v14_Mi125AdcDataCh1Top_s(13)&v14_Mi125AdcDataCh1Top_s, -- VCavA
			FwCav => v14_Mi125AdcDataCh2Top_s(13)&v14_Mi125AdcDataCh2Top_s(13)&v14_Mi125AdcDataCh2Top_s, -- FwCavA
			RvCav => v14_Mi125AdcDataCh3Top_s(13)&v14_Mi125AdcDataCh3Top_s(13)&v14_Mi125AdcDataCh3Top_s, -- RvCavA
			MO => v14_Mi125AdcDataCh4Top_s(13)&v14_Mi125AdcDataCh4Top_s(13)&v14_Mi125AdcDataCh4Top_s, -- MO
			FwIOT1 => v14_Mi125AdcDataCh5Top_s(13)&v14_Mi125AdcDataCh5Top_s(13)&v14_Mi125AdcDataCh5Top_s, -- FwIOT1A
			RvIOT1 => v14_Mi125AdcDataCh6Top_s(13)&v14_Mi125AdcDataCh6Top_s(13)&v14_Mi125AdcDataCh6Top_s, -- RvIOT1A
			RFIn7 => v14_Mi125AdcDataCh7Top_s(13)&v14_Mi125AdcDataCh7Top_s(13)&v14_Mi125AdcDataCh7Top_s, -- FwIOT2A or VCell2
			RFIn8 => v14_Mi125AdcDataCh8Top_s(13)&v14_Mi125AdcDataCh8Top_s(13)&v14_Mi125AdcDataCh8Top_s, -- RvIOT2A or VCell4
			RFIn9 => v14_Mi125AdcDataCh9Top_s(13)&v14_Mi125AdcDataCh9Top_s(13)&v14_Mi125AdcDataCh9Top_s, -- VCavB, FwIOT3 or Spare1 (Pre_DriverInput)
			RFIn10 => v14_Mi125AdcDataCh10Top_s(13)&v14_Mi125AdcDataCh10Top_s(13)&v14_Mi125AdcDataCh10Top_s, -- FwCavB, RvIOT3 or Spare2 (Pre-Driver Output)
			RFIn11 => v14_Mi125AdcDataCh11Top_s(13)&v14_Mi125AdcDataCh11Top_s(13)&v14_Mi125AdcDataCh11Top_s, -- RvCavB, FwIOT4 or Spare3
			RFIn12 => v14_Mi125AdcDataCh12Top_s(13)&v14_Mi125AdcDataCh12Top_s(13)&v14_Mi125AdcDataCh12Top_s, -- FwIOT1B, RvIOT4 or Spare4
			RFIn13 => v14_Mi125AdcDataCh13Top_s(13)&v14_Mi125AdcDataCh13Top_s(13)&v14_Mi125AdcDataCh13Top_s, -- RvIOT1B, PreDriver1 or spare5
			RFIn14 => v14_Mi125AdcDataCh14Top_s(13)&v14_Mi125AdcDataCh14Top_s(13)&v14_Mi125AdcDataCh14Top_s, -- FwIOT2B, PreDriver2 or Spare6
			RFIn15 => v14_Mi125AdcDataCh15Top_s(13)&v14_Mi125AdcDataCh15Top_s(13)&v14_Mi125AdcDataCh15Top_s, -- RvIOT2B, PreDriver3 or Spare7
			DACsIF => v14_Mi125AdcDataCh16Top_s(13)&v14_Mi125AdcDataCh16Top_s(13)&v14_Mi125AdcDataCh16Top_s, -- DACs IF
			reg_data1_input => v32_reg_data1_A_s,
			reg_data2_input => i_v16_reg_data2_A_s,
			reg_data2_output => o_v16_reg_data2_A_s,
			reg_data3_input => i_v17_reg_data3_A_s,
			reg_data3_output => o_v32_reg_data3_A_s,
			Interface_01 => v16_A_Interface_01,
			Interface_02 => v16_A_Interface_02,
			Interface_03 => v16_A_Interface_03,
			Interface_04 => v16_A_Interface_04,
			Interface_05 => v16_A_Interface_05,
			Interface_06 => v16_A_Interface_06,
			Interface_07 => v16_A_Interface_07,
			Interface_08 => v16_A_Interface_08,
			Control1 => v16_Control1_A,
			Control2 => v16_Control2_A,
			Control3 => v16_Control3_A,
			Control4 => v16_Control4_A,
			Control5_VCav => v16_Control5_VCavA,
			Control8_IFDACs => Control8_IFDACsA,
			gpio_input => v12_gpio_input_A,
			gpio_output => v10_gpio_output_A,
			clk => Mi125AdcDataClkTop_s,
			FDL_Trig_out => FDL_Trig_out_A,
			PinDiodeSw => PinDiodeSw_A,
			LLRFItckOut => LLRFItckOut_A,
 			LLRFItckIn => LLRFItckOut_B,
			TRG3Hz => mo1000_0_Trigger_r1_s,
			Conf => Conf);
	
Instantiation_MainProgramB : component MainProgram
Port map(
			VCav => v14_Mi125AdcDataCh9Top_s(13)&v14_Mi125AdcDataCh9Top_s(13)&v14_Mi125AdcDataCh9Top_s, -- VCavB
			FwCav => v14_Mi125AdcDataCh10Top_s(13)&v14_Mi125AdcDataCh10Top_s(13)&v14_Mi125AdcDataCh10Top_s, --FwCavB
			RvCav => v14_Mi125AdcDataCh11Top_s(13)&v14_Mi125AdcDataCh11Top_s(13)&v14_Mi125AdcDataCh11Top_s, -- RvCavB
			MO => v14_Mi125AdcDataCh4Top_s(13)&v14_Mi125AdcDataCh4Top_s(13)&v14_Mi125AdcDataCh4Top_s, -- MO
			FwIOT1 => v14_Mi125AdcDataCh12Top_s(13)&v14_Mi125AdcDataCh12Top_s(13)&v14_Mi125AdcDataCh12Top_s, -- FwIOT1B
			RvIOT1 => v14_Mi125AdcDataCh13Top_s(13)&v14_Mi125AdcDataCh13Top_s(13)&v14_Mi125AdcDataCh13Top_s, -- RvIOT1B
			RFIn7 => v14_Mi125AdcDataCh14Top_s(13)&v14_Mi125AdcDataCh14Top_s(13)&v14_Mi125AdcDataCh14Top_s, -- FwIOT2B
			RFIn8 => v14_Mi125AdcDataCh15Top_s(13)&v14_Mi125AdcDataCh15Top_s(13)&v14_Mi125AdcDataCh15Top_s, -- RvIOT2B
			RFIn9 => X"0000", -- not used 
			RFIn10 => X"0000", -- not used
			RFIn11 => X"0000", -- not used
			RFIn12 => X"0000", -- not used
			RFIn13 => X"0000", -- not used
			RFIn14 => X"0000", -- not used
			RFIn15 => X"0000", -- not used
			DACsIF => v14_Mi125AdcDataCh16Top_s(13)&v14_Mi125AdcDataCh16Top_s(13)&v14_Mi125AdcDataCh16Top_s,
			reg_data1_input => v32_reg_data1_B_s,
			reg_data2_input => i_v16_reg_data2_B_s,
			reg_data2_output => o_v16_reg_data2_B_s,
			reg_data3_input => i_v17_reg_data3_B_s,
			reg_data3_output => o_v32_reg_data3_B_s,
			Interface_01 => v16_B_Interface_01,
			Interface_02 => v16_B_Interface_02,
			Interface_03 => v16_B_Interface_03,
			Interface_04 => v16_B_Interface_04,
			Interface_05 => v16_B_Interface_05,
			Interface_06 => v16_B_Interface_06,
			Interface_07 => v16_B_Interface_07,
			Interface_08 => v16_B_Interface_08,
			Control1 => v16_Control1_B,
			Control2 => v16_Control2_B,
			Control3 => v16_Control3_B,
			Control4 => v16_Control4_B,
			Control5_VCav => v16_Control5_VCavB,
			Control8_IFDACs => Control8_IFDACsB,
			gpio_input => v12_gpio_input_B,
			gpio_output => v10_gpio_output_B,
			clk => Mi125AdcDataClkTop_s,
			FDL_Trig_out => FDL_Trig_out_B,
			PinDiodeSw => PinDiodeSw_B,
			LLRFItckOut => LLRFItckOut_B,
 			LLRFItckIn => LLRFItckOut_A,
			TRG3Hz => mo1000_0_Trigger_r1_s,
			Conf => Conf);

	inst_GPIO : component GPIO_Interface 
	Port map( 
		o_Reset => i_Reset_p,
		i_Ready => o_DelayRdy_p,
		ov32_Gpio_out => iv32_DioDIn_p,
		ov32_GpioDir => iv32_DioDInDir_p,
		iv32_Gpio_in => ov32_DioDOut_p,
		o_SetGpioDir => i_SetGpioDir_p,
		o_StartGpio => i_Start_p,
		iv12_GpioAdcData0 => ov12_AdcData0_p,
		iv12_GpioAdcData1 => ov12_AdcData1_p,
		iv12_GpioAdcData2 => ov12_AdcData2_p,
		iv12_GpioAdcData3 => ov12_AdcData3_p,
		i_GpioAdcData0Valid => o_AdcData0Valid_p,
		i_GpioAdcData1Valid => o_AdcData1Valid_p,
		i_GpioAdcData2Valid => o_AdcData2Valid_p,
		i_GpioAdcData3Valid => o_AdcData3Valid_p,
		clk => Mi125AdcDataClkTop_s,
		custom_reg_gpio_write => v32_gpio_configuration,
		custom_reg_gpio_read_in => custom_reg_gpio_read_in_s,
		custom_reg_gpio_read_out => custom_reg_gpio_read_out_s,
		gpio_input_A => v12_gpio_input_A,
		gpio_output_A => v10_gpio_output_A,
		gpio_input_B => v12_gpio_input_B,
		gpio_output_B => v10_gpio_output_B,
		PinDiodeSw => PinDiodeSw,
		LLRFItckOut => LLRFItckOut,
		Conf => Conf);
		
	inst_PlantInterface : component Plant_Interface 
		Port map( 
			Conf => Conf,
			PinDiodeSw_A => PinDiodeSw_A,
			PinDiodeSw_B => PinDiodeSw_B,
			FDL_Trig_Out_A => FDL_Trig_Out_A,
			FDL_Trig_Out_B => FDL_Trig_Out_B,
			ControlA1 => v16_Control1_A,
			ControlA2 => v16_Control2_A,
			ControlA3 => v16_Control3_A,
			ControlA4 => v16_Control4_A,
			ControlB1 => v16_Control1_B,
			ControlB2 => v16_Control2_B,
			VCavA => v16_Control5_VCavA,
			VCavB => v16_Control5_VCavB,
			LLRFItck_A => LLRFItckOut_A,
			LLRFItck_B => LLRFItckOut_B,
			Control1 => Control1,
			Control2 => Control2,
			Control3 => Control3,
			Control4 => Control4,
			Control5 => Control5,
			Control6 => Control6,
			PinDiodeSw => PinDiodeSw,
			FDL_Trig_out => FDL_Trig_out,
			LLRFItckOut => LLRFItckOut,
			clk => Mi125AdcDataClkTop_s);

end Behavioral;

