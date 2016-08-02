--------------------------------------------------------------------------------
--
--    ****                              *
--   ******                            ***
--   *******                           ****
--   ********    ****  ****     **** *********    ******* ****    ***********
--   *********   ****  ****     **** *********  **************  *************
--   **** *****  ****  ****     ****   ****    *****    ****** *****     ****
--   ****  ***** ****  ****     ****   ****   *****      ****  ****      ****
--  ****    *********  ****     ****   ****   ****       ****  ****      ****
--  ****     ********  ****    *****  ****    *****     *****  ****      ****
--  ****      ******   ***** ******   *****    ****** *******  ****** *******
--  ****        ****   ************    ******   *************   *************
--  ****         ***     ****  ****     ****      *****  ****     *****  ****
--                                                                       ****
--          I N N O V A T I O N  T O D A Y  F O R  T O M M O R O W       ****
--                                                                        ***
--
--------------------------------------------------------------------------------
-- File : lyt_mi250_record_if.vhd
--------------------------------------------------------------------------------
-- Description : MI250 data interface to LyrtechRD Record-Playback ip core 
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2013 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: lyt_mi250_record_if.vhd,v $
-- Revision 1.2  2013/12/13 14:45:53  julien.roy
-- Change the comment header
--
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


 entity lyt_mi250_record_if is
 	port( 		
 		-- MI250 IF --
 		i_DataClk_p	 		: in std_logic;
 		iv14_DataChA_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChB_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChC_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChD_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChE_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChF_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChG_p		: in std_logic_vector(13 downto 0);
 		iv14_DataChH_p		: in std_logic_vector(13 downto 0);
 		i_DataValid_p		: in std_logic;
 		i_DataTrigOut_p	: in std_logic;
 		-- Record IF --
 		o_RecordClk_p		: out std_logic; 		
 		ov16_RecordData0_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData1_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData2_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData3_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData4_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData5_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData6_p	: out std_logic_vector(15 downto 0);
 		ov16_RecordData7_p	: out std_logic_vector(15 downto 0); 		
 		o_RecordEn_p		: out std_logic;
 		o_RecTrigger_p		: out std_logic;
 		i_RecFifoFull_p		: in std_logic
 		);

 end lyt_mi250_record_if;

 architecture lyt_mi250_record_if_behav of lyt_mi250_record_if is
 
 
 
 begin
 
 
 o_RecordClk_p <= i_DataClk_p;
 
 o_RecordEn_p <= i_DataValid_p;
 o_RecTrigger_p <= i_DataTrigOut_p;
 
 -- Align data to be recorded to 16-bit word.
 ov16_RecordData0_p <= iv14_DataChA_p(13) & iv14_DataChA_p(13) & iv14_DataChA_p;
 ov16_RecordData1_p <= iv14_DataChB_p(13) & iv14_DataChB_p(13) & iv14_DataChB_p;
 ov16_RecordData2_p <= iv14_DataChC_p(13) & iv14_DataChC_p(13) & iv14_DataChC_p;
 ov16_RecordData3_p <= iv14_DataChD_p(13) & iv14_DataChD_p(13) & iv14_DataChD_p;
 ov16_RecordData4_p <= iv14_DataChE_p(13) & iv14_DataChE_p(13) & iv14_DataChE_p;
 ov16_RecordData5_p <= iv14_DataChF_p(13) & iv14_DataChF_p(13) & iv14_DataChF_p;
 ov16_RecordData6_p <= iv14_DataChG_p(13) & iv14_DataChG_p(13) & iv14_DataChG_p;
 ov16_RecordData7_p <= iv14_DataChH_p(13) & iv14_DataChH_p(13) & iv14_DataChH_p;
 
 
 
 
 end lyt_mi250_record_if_behav;