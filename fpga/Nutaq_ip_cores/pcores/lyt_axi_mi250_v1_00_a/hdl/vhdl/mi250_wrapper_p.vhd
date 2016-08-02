--------------------------------------------------------------------------------
--
--
--          **  **     **  ******  ********  ********  ********  **    **
--         **    **   **  **   ** ********  ********  ********  **    **
--        **     *****   **   **    **     **        **        **    **
--       **       **    ******     **     ****      **        ********
--      **       **    **  **     **     **        **        **    **
--     *******  **    **   **    **     ********  ********  **    **
--    *******  **    **    **   **     ********  ********  **    **
--
--                       L Y R T E C H   R D   I N C
--
--------------------------------------------------------------------------------
-- File        : $Id: mi250_wrapper_p.vhd,v 1.10 2013/02/18 13:21:38 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : MI 250 Package
--
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2011 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: mi250_wrapper_p.vhd,v $
-- Revision 1.10  2013/02/18 13:21:38  julien.roy
-- New mi250 wrapper for v2.1
--
-- Revision 1.9  2012/11/20 14:16:35  khalid.bensadek
-- Cleaned-up unused signals.
--
-- Revision 1.8  2012/11/15 21:44:15  julien.roy
-- Modification to the mi250 core
-- - remove fifos
-- - add pattern verification
--
-- Revision 1.7  2012/11/15 16:48:06  julien.roy
-- New wrapper for the mi250_top without fifos
--
-- Revision 1.6  2012/11/13 19:21:23  khalid.bensadek
-- Updated the ipcore to AXI bus version. Working version as is with 4 MMCMs that will conflect if adding Record-Playback ipcore.
--
-- Revision 1.5  2011/06/13 16:13:15  jeffrey.johnson
-- ADC data outputs to 14 bit wide.
--
-- Revision 1.4  2011/05/25 16:21:20  jeffrey.johnson
-- Moved MMCM from wrapper to clk_module.
--
-- Revision 1.3  2011/05/19 19:20:22  jeffrey.johnson
-- Added ADC interface.
--
-- Revision 1.2  2011/05/12 15:16:45  jeffrey.johnson
-- Reference enable removed.
--
-- Revision 1.1  2011/05/10 13:16:39  jeffrey.johnson
-- First commit.
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

Package mi250_wrapper_p is

component mi250_top is
port
(
  -- Global ports
  i_SystemClk_p                : in std_logic;
  i_RefClk200MHz_p             : in std_logic;
  i_Rst_p                      : in std_logic;
  
  -- SPI PLL
  o_Mi250PllScl_p              : out std_logic;
  o_Mi250PllMosi_p             : out std_logic;
  i_Mi250PllMiso_p             : in  std_logic;
  o_nMi250PllCs_p              : out std_logic;

  -- SPI shared ADC                               
  o_Mi250AdcScl_p              : out std_logic;
  o_Mi250AdcMosi_p             : out std_logic;
  i_Mi250AdcMisoAb_p           : in  std_logic;
  i_Mi250AdcMisoCd_p           : in  std_logic;
  i_Mi250AdcMisoEf_p           : in  std_logic;
  i_Mi250AdcMisoGh_p           : in  std_logic;
  o_nMi250AdcCsAb_p            : out std_logic;
  o_nMi250AdcCsCd_p            : out std_logic;
  o_nMi250AdcCsEf_p            : out std_logic;
  o_nMi250AdcCsGh_p            : out std_logic;
  o_Mi250AdcRst_p              : out std_logic;

  -- PLL control                               
  i_Mi250PllStatus_p           : in std_logic;
  o_Mi250PllFunction_p         : out std_logic;

  -- Monitor interrupt                               
  i_nMi250MonInt_p             : in  std_logic;

  -- Trigger                               
  i_Mi250TrigToFpga_p          : in  std_logic;

  -- ADC interface clocks
  idp_Mi250AdcClkAB_p          : in std_logic;
  idn_Mi250AdcClkAB_p          : in std_logic;
  idp_Mi250AdcClkCD_p          : in std_logic;
  idn_Mi250AdcClkCD_p          : in std_logic;
  idp_Mi250AdcClkEF_p          : in std_logic;
  idn_Mi250AdcClkEF_p          : in std_logic;
  idp_Mi250AdcClkGH_p          : in std_logic;
  idn_Mi250AdcClkGH_p          : in std_logic;
  
  -- ADC interface data
  iv7dp_Mi250AdcAData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcAData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcBData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcBData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcCData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcCData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcDData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcDData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcEData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcEData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcFData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcFData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcGData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcGData_p        : in std_logic_vector(6 downto 0);
  iv7dp_Mi250AdcHData_p        : in std_logic_vector(6 downto 0);
  iv7dn_Mi250AdcHData_p        : in std_logic_vector(6 downto 0);
  
  iv5_AdcABIdelayValue_p        : in  std_logic_vector(4 downto 0);
  iv5_AdcCDIdelayValue_p        : in  std_logic_vector(4 downto 0);
  iv5_AdcEFIdelayValue_p        : in  std_logic_vector(4 downto 0);
  iv5_AdcGHIdelayValue_p        : in  std_logic_vector(4 downto 0);
  iv5_AdcABClkIdelayValue_p     : in  std_logic_vector(4 downto 0);
  iv5_AdcCDClkIdelayValue_p     : in  std_logic_vector(4 downto 0);
  iv5_AdcEFClkIdelayValue_p     : in  std_logic_vector(4 downto 0);
  iv5_AdcGHClkIdelayValue_p     : in  std_logic_vector(4 downto 0);
    
  ov2_AdcAbPatternError_p       : out std_logic_vector(1 downto 0);
  ov2_AdcCdPatternError_p       : out std_logic_vector(1 downto 0);
  ov2_AdcEfPatternError_p       : out std_logic_vector(1 downto 0);
  ov2_AdcGhPatternError_p       : out std_logic_vector(1 downto 0);
    
  -- ADC interface control
  i_ChArmed_p                  : in std_logic;
  iv2_TriggerMode_p            : in std_logic_vector(1 downto 0);
  iv2_TestMode_p               : in std_logic_vector(1 downto 0);
  i_SoftwareTrig_p             : in std_logic;
  
  -- ADC data outputs
  ov14_Mi250AdcADataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcBDataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcCDataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcDDataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcEDataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcFDataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcGDataOut_p      : out std_logic_vector(13 downto 0);
  ov14_Mi250AdcHDataOut_p      : out std_logic_vector(13 downto 0);
  
  -- ADC data valid outputs
  o_Mi250AdcADataValid_p       : out std_logic;
  o_Mi250AdcBDataValid_p       : out std_logic;
  o_Mi250AdcCDataValid_p       : out std_logic;
  o_Mi250AdcDDataValid_p       : out std_logic;
  o_Mi250AdcEDataValid_p       : out std_logic;
  o_Mi250AdcFDataValid_p       : out std_logic;
  o_Mi250AdcGDataValid_p       : out std_logic;
  o_Mi250AdcHDataValid_p       : out std_logic;
  
  --  Trigger output
  o_Mi250AdcTrigout_p  		   : out std_logic;
  
  -- ADC Clock outputs (from BUFR)
  o_AdcAbClkBufr_p             : out std_logic;
  o_AdcCdClkBufr_p             : out std_logic;
  o_AdcEfClkBufr_p             : out std_logic;
  o_AdcGhClkBufr_p             : out std_logic;
  
  -- ADC Global clocks (from BUFG)
  i_AdcAbClkBufg_p             : in std_logic;
  i_AdcCdClkBufg_p             : in std_logic;
  i_AdcEfClkBufg_p             : in std_logic;
  i_AdcGhClkBufg_p             : in std_logic;
    
  o_SpiBusy_p                  : out std_logic;
  
  -- External module 2 interface
  iv9_writeaddr2_p             : in  std_logic_vector (8 downto 0);
  iv9_readaddr2_p              : in  std_logic_vector (8 downto 0);
  i_req2_p                     : in  std_logic;
  iv32_din2_p                  : in  std_logic_vector (31 downto 0);
  o_gnt2_p                     : out std_logic;
  ov32_dout2_p                 : out std_logic_vector (31 downto 0);
  o_ack2_p                     : out std_logic;
  
  -- From/To custom logic
  i_AdcSpiReset_p              : in std_logic;
  o_PllStatus_p                : out std_logic;
  i_PllFunction_p              : in std_logic
);
end component;

end mi250_wrapper_p;