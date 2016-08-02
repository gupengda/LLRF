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
-- Notes / Assumptions :                                                        
-- Description: MI125 data interface to LyrtechRD Record-Playback ip core 
-- This module is used to pack the MI125 32 channels into the record IP. Since the
-- DDR3 can't keep with the throughput required for all 32 channels at 125MHz, this 
-- module will record :
-- A- If iv2_MuxSel_p(1) = 0 only 16 channels (up or bottom) depending on 
--    the i_BottomTopMuxSel_p input (if 0, the 16 bottom channels are recorded, if 1 
--    the 16 top module channels are recorded).     
-- B- If iv2_MuxSel_p(0) = 1 the 32 channels (up and bottom) downsampled by
--    2. This component will get a sample from 16 channels bottom then a sample from 16
--    channels top and so on. 
-- First version by Abdelkarim Ouadid                                                            
-- 2012/08
-- Major mofidications by Julien Roy
-- 2012/11                                                                     
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Lyrtech RD inc.                                           
-- TODO = legal notice                                                          
--------------------------------------------------------------------------------
-- $Log: lyt_mi125_record_if.vhd,v $
-- Revision 1.2  2012/12/10 14:26:26  julien.roy
-- Add adc chip enabled port,
-- delay trigger in downsampled mode instead of resetting the data sequence,
-- lighter code
--         
--                                                            
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lyt_mi125_record_if is
 	port(
 		i_Reset_p			          : in std_logic;
 		i_Clk_p			            : in std_logic;
 		-- MI125 IF --          
 		iv14_AdcDataCh1_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh2_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh3_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh4_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh5_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh6_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh7_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh8_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh9_p	      : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh10_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh11_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh12_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh13_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh14_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh15_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh16_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh17_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh18_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh19_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh20_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh21_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh22_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh23_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh24_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh25_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh26_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh27_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh28_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh29_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh30_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh31_p	    : in std_logic_vector(13 downto 0);
 		iv14_AdcDataCh32_p	    : in std_logic_vector(13 downto 0);
 		i_AdcCh1Valid_p	        : in std_logic;
 		i_AdcCh2Valid_p	        : in std_logic;
 		i_AdcCh3Valid_p	        : in std_logic;
 		i_AdcCh4Valid_p	        : in std_logic;
 		i_AdcCh5Valid_p	        : in std_logic;
 		i_AdcCh6Valid_p	        : in std_logic;
 		i_AdcCh7Valid_p	        : in std_logic;
 		i_AdcCh8Valid_p	        : in std_logic;
 		i_AdcCh9Valid_p	        : in std_logic;
 		i_AdcCh10Valid_p	      : in std_logic;
 		i_AdcCh11Valid_p	      : in std_logic;
 		i_AdcCh12Valid_p	      : in std_logic;
 		i_AdcCh13Valid_p	      : in std_logic;
 		i_AdcCh14Valid_p	      : in std_logic;
 		i_AdcCh15Valid_p	      : in std_logic;
 		i_AdcCh16Valid_p	      : in std_logic;
 		i_AdcCh17Valid_p	      : in std_logic;
 		i_AdcCh18Valid_p	      : in std_logic;
 		i_AdcCh19Valid_p	      : in std_logic;
 		i_AdcCh20Valid_p	      : in std_logic;
 		i_AdcCh21Valid_p	      : in std_logic;
 		i_AdcCh22Valid_p	      : in std_logic;
 		i_AdcCh23Valid_p	      : in std_logic;
 		i_AdcCh24Valid_p	      : in std_logic;
 		i_AdcCh25Valid_p	      : in std_logic;
 		i_AdcCh26Valid_p	      : in std_logic;
 		i_AdcCh27Valid_p	      : in std_logic;
 		i_AdcCh28Valid_p	      : in std_logic;
 		i_AdcCh29Valid_p	      : in std_logic;
 		i_AdcCh30Valid_p	      : in std_logic;
 		i_AdcCh31Valid_p	      : in std_logic;
 		i_AdcCh32Valid_p	      : in std_logic;
    i_AdcCh1to4Enabled_p    : in std_logic;
    i_AdcCh5to8Enabled_p    : in std_logic;
    i_AdcCh9to12Enabled_p   : in std_logic;
    i_AdcCh13to16Enabled_p  : in std_logic;
    i_AdcCh17to20Enabled_p  : in std_logic;
    i_AdcCh21to24Enabled_p  : in std_logic;
    i_AdcCh25to28Enabled_p  : in std_logic;
    i_AdcCh29to32Enabled_p  : in std_logic;
 		i_DataFormat_p          : in std_logic;
 		-- Trigger IF --                            
 		i_SoftOrExternalTriggSel_p : in std_logic; 
 		i_ExternalTrigger_p     : in std_logic;   
 		i_SoftTrigger_p         : in std_logic;  
 		-- Control IF --                            
 		iv2_MuxSel_p            : in std_logic_vector(1 downto 0);
 		-- Record IF --         
 		ov64_RecordData1_p	    : out std_logic_vector(63 downto 0);
 		ov64_RecordData2_p	    : out std_logic_vector(63 downto 0);
 		ov64_RecordData3_p	    : out std_logic_vector(63 downto 0);
 		ov64_RecordData4_p	    : out std_logic_vector(63 downto 0);
 		o_RecordValid_p		      : out std_logic;
    o_RecordTrigger_p		    : out std_logic
  );
end lyt_mi125_record_if;

architecture lyt_mi125_record_if_behav of lyt_mi125_record_if is
 
  attribute keep_hierarchy : string;                        
  attribute keep_hierarchy of lyt_mi125_record_if_behav : architecture is "true";

  --------------------------------------------------------------------------
  -- Component declaration 
  --------------------------------------------------------------------------

  ---------------------------------------------------------------------------------
  --     ************** Function declaration *******************                 --  
  -- Return a std_logic_vector with a sign extension depending on the data format--
  ---------------------------------------------------------------------------------
  function SignExtend(val: std_logic_vector(13 downto 0);DataFormat:std_logic) return std_logic_vector is 
  variable tmp: std_logic_vector(15 downto 0);
  begin
     if DataFormat='1' then
        tmp:= val(13) & val(13) & val;
      else
        tmp:='0'&'0'&val;
      end if;
    return tmp;
  end SignExtend; 

  --------------------------------------------------------------------------
  -- signal
  --------------------------------------------------------------------------
  signal MuxedOrDownSampVerSel_s  : std_logic; 
  signal BottomTopMuxSel_s        : std_logic; 
  
  signal DownSampleState_s        : std_logic;
  
  signal v14_AdcDataCh17_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh18_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh19_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh20_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh21_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh22_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh23_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh24_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh25_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh26_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh27_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh28_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh29_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh30_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh31_r1	      : std_logic_vector(13 downto 0);
  signal v14_AdcDataCh32_r1	      : std_logic_vector(13 downto 0);
 
begin
 
  MuxedOrDownSampVerSel_s <= iv2_MuxSel_p(1);
  BottomTopMuxSel_s       <= iv2_MuxSel_p(0);

  ---- Data section ----------
  process(i_Clk_p,i_Reset_p)
  begin
    if rising_edge(i_Clk_p) then
    
      -- Latch Top data for synchronization with bottom data
      -- in downsample mode
      v14_AdcDataCh17_r1 <= iv14_AdcDataCh17_p;
      v14_AdcDataCh18_r1 <= iv14_AdcDataCh18_p;
      v14_AdcDataCh19_r1 <= iv14_AdcDataCh19_p;
      v14_AdcDataCh20_r1 <= iv14_AdcDataCh20_p;
      v14_AdcDataCh21_r1 <= iv14_AdcDataCh21_p;
      v14_AdcDataCh22_r1 <= iv14_AdcDataCh22_p;
      v14_AdcDataCh23_r1 <= iv14_AdcDataCh23_p;
      v14_AdcDataCh24_r1 <= iv14_AdcDataCh24_p;
      v14_AdcDataCh25_r1 <= iv14_AdcDataCh25_p;
      v14_AdcDataCh26_r1 <= iv14_AdcDataCh26_p;
      v14_AdcDataCh27_r1 <= iv14_AdcDataCh27_p;
      v14_AdcDataCh28_r1 <= iv14_AdcDataCh28_p;
      v14_AdcDataCh29_r1 <= iv14_AdcDataCh29_p;
      v14_AdcDataCh30_r1 <= iv14_AdcDataCh30_p;
      v14_AdcDataCh31_r1 <= iv14_AdcDataCh31_p;
      v14_AdcDataCh32_r1 <= iv14_AdcDataCh32_p;
      
      -- Select MI250 Top data
      if ((MuxedOrDownSampVerSel_s and DownSampleState_s) 
        or ((not MuxedOrDownSampVerSel_s) and BottomTopMuxSel_s)) = '1' then
        
        -- Downsample mode
        if MuxedOrDownSampVerSel_s = '1' then
          ov64_RecordData1_p <= SignExtend(v14_AdcDataCh20_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh19_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh18_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh17_r1,i_DataFormat_p);
          
          ov64_RecordData2_p <= SignExtend(v14_AdcDataCh24_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh23_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh22_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh21_r1,i_DataFormat_p);
          
          ov64_RecordData3_p <= SignExtend(v14_AdcDataCh28_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh27_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh26_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh25_r1,i_DataFormat_p);
          
          ov64_RecordData4_p <= SignExtend(v14_AdcDataCh32_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh31_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh30_r1,i_DataFormat_p) &
            SignExtend(v14_AdcDataCh29_r1,i_DataFormat_p);
        
        -- Mux mode
        else
          ov64_RecordData1_p <= SignExtend(iv14_AdcDataCh20_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh19_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh18_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh17_p,i_DataFormat_p);
          
          ov64_RecordData2_p <= SignExtend(iv14_AdcDataCh24_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh23_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh22_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh21_p,i_DataFormat_p);
          
          ov64_RecordData3_p <= SignExtend(iv14_AdcDataCh28_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh27_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh26_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh25_p,i_DataFormat_p);
          
          ov64_RecordData4_p <= SignExtend(iv14_AdcDataCh32_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh31_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh30_p,i_DataFormat_p) &
            SignExtend(iv14_AdcDataCh29_p,i_DataFormat_p);
        end if;
      
      -- Select MI250 Bottom data
      else
      
        ov64_RecordData1_p <= SignExtend(iv14_AdcDataCh4_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh3_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh2_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh1_p,i_DataFormat_p);
      
        ov64_RecordData2_p <= SignExtend(iv14_AdcDataCh8_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh7_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh6_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh5_p,i_DataFormat_p);
      
        ov64_RecordData3_p <= SignExtend(iv14_AdcDataCh12_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh11_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh10_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh9_p,i_DataFormat_p);
      
        ov64_RecordData4_p <= SignExtend(iv14_AdcDataCh16_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh15_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh14_p,i_DataFormat_p) &
          SignExtend(iv14_AdcDataCh13_p,i_DataFormat_p);
          
      end if;
      
      DownSampleState_s <= not DownSampleState_s;
      
      -- Reset section -------------
      if i_Reset_p = '1' then
        DownSampleState_s <= '0';
      end if;
      
    end if;
  end process;
  
  ---- Data Valid section ----
  process(i_Clk_p,i_Reset_p)
    variable AdcCh1to4Valid     : std_logic;
    variable AdcCh5to8Valid     : std_logic;
    variable AdcCh9to12Valid    : std_logic;
    variable AdcCh13to16Valid   : std_logic;
    variable AdcCh17to20Valid   : std_logic;
    variable AdcCh21to24Valid   : std_logic;
    variable AdcCh25to28Valid   : std_logic;
    variable AdcCh29to32Valid   : std_logic;
  begin
    if rising_edge(i_Clk_p) then
    
      -- Set valid when ADCs are powerdown or when powerup and all channels valid
      -- It is normal that ADCs are not valid in powerdown mode
      AdcCh1to4Valid    := (not i_AdcCh1to4Enabled_p)    or (i_AdcCh1Valid_p   and i_AdcCh2Valid_p   and i_AdcCh3Valid_p   and i_AdcCh4Valid_p);
      AdcCh5to8Valid    := (not i_AdcCh5to8Enabled_p)    or (i_AdcCh5Valid_p   and i_AdcCh6Valid_p   and i_AdcCh7Valid_p   and i_AdcCh8Valid_p);
      AdcCh9to12Valid   := (not i_AdcCh9to12Enabled_p)   or (i_AdcCh9Valid_p   and i_AdcCh10Valid_p  and i_AdcCh11Valid_p  and i_AdcCh12Valid_p);
      AdcCh13to16Valid  := (not i_AdcCh13to16Enabled_p)  or (i_AdcCh13Valid_p  and i_AdcCh14Valid_p  and i_AdcCh15Valid_p  and i_AdcCh16Valid_p);
      AdcCh17to20Valid  := (not i_AdcCh17to20Enabled_p)  or (i_AdcCh17Valid_p  and i_AdcCh18Valid_p  and i_AdcCh19Valid_p  and i_AdcCh20Valid_p);
      AdcCh21to24Valid  := (not i_AdcCh21to24Enabled_p)  or (i_AdcCh21Valid_p  and i_AdcCh22Valid_p  and i_AdcCh23Valid_p  and i_AdcCh24Valid_p);
      AdcCh25to28Valid  := (not i_AdcCh25to28Enabled_p)  or (i_AdcCh25Valid_p  and i_AdcCh26Valid_p  and i_AdcCh27Valid_p  and i_AdcCh28Valid_p);
      AdcCh29to32Valid  := (not i_AdcCh29to32Enabled_p)  or (i_AdcCh29Valid_p  and i_AdcCh30Valid_p  and i_AdcCh31Valid_p  and i_AdcCh32Valid_p);
    
      -- All channels must be valid
      if MuxedOrDownSampVerSel_s = '1' then
        o_RecordValid_p <= 
          AdcCh1to4Valid and
          AdcCh5to8Valid and
          AdcCh9to12Valid and
          AdcCh13to16Valid and
          AdcCh17to20Valid and
          AdcCh21to24Valid and
          AdcCh25to28Valid and
          AdcCh29to32Valid;
      else
        -- Top channels must be valid
        if BottomTopMuxSel_s = '1' then
          o_RecordValid_p <= 
            AdcCh17to20Valid and
            AdcCh21to24Valid and
            AdcCh25to28Valid and
            AdcCh29to32Valid;
        -- Bottom channels must be valid
        else
          o_RecordValid_p <= 
            AdcCh1to4Valid and
            AdcCh5to8Valid and
            AdcCh9to12Valid and
            AdcCh13to16Valid;
        end if;
      end if;
    
      -- Reset section -------------
      if i_Reset_p = '1' then
        o_RecordValid_p <= '0';
      end if;
      
    end if;
  end process;
  
  ---- Trigger section ----
  -- When alternating between bottom and top value
  -- only trig when sending bottom values. This allows
  -- the user to identify the first 256 bits received from
  -- RTDEx to be the bottom values.
  process(i_Clk_p,i_Reset_p)
    variable ExternalTrigger_r1   : std_logic;
    variable SoftTrigger_r1       : std_logic;
    variable SoftTrigger_r2       : std_logic;
    variable SoftTrigger_r3       : std_logic;
    variable TriggerPulse         : std_logic;
    variable TriggerPulse_r1      : std_logic;
  begin
    if rising_edge(i_Clk_p) then
    
      -- Trigger selection and edge detection
      if i_SoftOrExternalTriggSel_p = '1' then
          TriggerPulse := i_ExternalTrigger_p and (not ExternalTrigger_r1);
      else
          TriggerPulse := SoftTrigger_r2 and (not SoftTrigger_r3);
      end if;

      -- Only trig with bottom values in down sampling mode
      if MuxedOrDownSampVerSel_s = '1' then
        if DownSampleState_s = '1' then
          o_RecordTrigger_p <= '0';
        else
          o_RecordTrigger_p <= TriggerPulse or TriggerPulse_r1;
        end if;
      else
        o_RecordTrigger_p <= TriggerPulse;
      end if;
      
      -- Register section ----------
      ExternalTrigger_r1  := i_ExternalTrigger_p;
      SoftTrigger_r3      := SoftTrigger_r2;
      SoftTrigger_r2      := SoftTrigger_r1;
      SoftTrigger_r1      := i_SoftTrigger_p;
      TriggerPulse_r1     := TriggerPulse;
    
      -- Reset section -------------
      if i_Reset_p = '1' then
        ExternalTrigger_r1  := '0';
        SoftTrigger_r1      := '0';
        SoftTrigger_r2      := '0';
        SoftTrigger_r3      := '0';
        TriggerPulse_r1     := '0';
        o_RecordTrigger_p   <= '0';
      end if;
      
    end if;
  end process;
  
 
 end lyt_mi125_record_if_behav;