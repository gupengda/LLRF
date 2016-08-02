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
-- File        : $Id: radio420x_internal_p.vhd,v 1.3 2013/02/28 20:16:34 jd.gagnon Exp $
--------------------------------------------------------------------------------
-- Description : Package to Radio420x internal use
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: radio420x_internal_p.vhd,v $
-- Revision 1.3  2013/02/28 20:16:34  jd.gagnon
-- Add ADC fifo reset
--
-- Revision 1.2  2013/01/18 19:03:45  julien.roy
-- Merge changes from ZedBoard reference design to Perseus
--
-- Revision 1.1  2012/09/28 19:31:26  khalid.bensadek
-- First commit of a stable AXI version. Xilinx 13.4
--
-- Revision 1.5  2012/06/27 20:10:02  david.quinn
-- Support the new calibration method (DFT)
--
-- Revision 1.4  2011/09/12 14:53:04  jeffrey.johnson
-- Fixed component names.
--
-- Revision 1.3  2011/09/08 21:08:49  jeffrey.johnson
-- Added "radio420x" to module names.
--
-- Revision 1.2  2011/08/30 20:00:17  patrick.gilbert
-- add calibration core inside FPGA : beta
--
-- Revision 1.1  2011/06/15 21:12:51  jeffrey.johnson
-- Changed core name.
--
-- Revision 1.2  2011/06/14 22:22:12  patrick.gilbert
-- add mimo modification...add generic to instantiate FMCclk0 BUFG. + add dac idelayctrl
--
-- Revision 1.1  2011/05/27 13:37:56  patrick.gilbert
-- first commit: revA
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package radio420x_internal_p is

  component lime_adc_interface is
    port (
      i_AdcDataClk_p     : in std_logic;
      i_RefClk200MHz_p   : in std_logic;
      i_Rst_p            : in std_logic;
      i_RstFifo_p        : in std_logic;

      i_IQSel_p          : in std_logic;
      iv12_ADCData_p     : in std_logic_vector(11 downto 0);

      o_IDelayRdy_p      : out std_logic;

      i_DesignClk_p      : in std_logic;
      ov12_userAdcData_p : out std_logic_vector (11 downto 0);
      o_userAdcIQSel_p   : out std_logic
      );
  end component;

  component lime_dac_interface is
    port (
      i_DesignClk_p          : in std_logic;
      i_RefClk200MHz_p       : in std_logic;
      i_Rst_p                : in std_logic;
      --USer Data port
      i_UserDacIQSel_p       : in std_logic;
      iv12_UserDacData_p     : in std_logic_vector(11 downto 0);

      -- Interface interface.
      ov12_DacData_p         : out std_logic_vector (11 downto 0);
      o_DacIQSel_p           : out std_logic
    );
  end component;

  component spi_radio420x is
    port (
      i_clk_p           : in std_logic;
      i_rst_p           : in std_logic;
      iv5_FpgaCtrlEn_p  : in std_logic_vector(4 downto 0);

      iv16_refDacSpiData_p       : in  std_logic_vector(15 downto 0);
      i_refDacSpiStart_p         : in  std_logic;
      iv16_HostRefDacSpiData_p   : in  std_logic_vector(15 downto 0);
      i_HostRefDacSpiStart_p     : in  std_logic;
      o_refDacSpiBusy_p          : out std_logic;

      iv16_limeSpiData_p         : in  std_logic_vector(15 downto 0);
      i_limeSpiStart_p           : in std_logic;
      iv16_HostLimeSpiData_p     : in  std_logic_vector(15 downto 0);
      ov16_HostLimeSpiData_p     : out std_logic_vector(15 downto 0);
      i_HostLimeSpiStart_p       : in std_logic;
      o_limeSpiBusy_p            : out std_logic;

      iv6_rxGainSpiData_p        : in std_logic_vector(5 downto 0);
      iv3_rxGainSpiStart_p       : in std_logic_vector(2 downto 0);
      iv6_HostRxGainSpiData_p    : in std_logic_vector(5 downto 0);
      iv3_HostRxGainSpiStart_p   : in std_logic_vector(2 downto 0);
      o_rxGainSpiBusy_p          : out std_logic;

      iv6_txGainSpiData_p        : in std_logic_vector(5 downto 0);
      i_txGainSpiStart_p         : in std_logic;
      iv6_HostTxGainSpiData_p    : in std_logic_vector(5 downto 0);
      i_HostTxGainSpiStart_p     : in std_logic;
      o_txGainSpiBusy_p          : out std_logic;

      iv32_pllCtrlSpiData_p      : in  std_logic_vector(31 downto 0);
      iv2_pllCtrlSpiStart_p      : in  std_logic_vector(1 downto 0);
      iv32_HostPllCtrlSpiData_p  : in  std_logic_vector(31 downto 0);
      ov32_HostPllCtrlSpiData_p  : out std_logic_vector(31 downto 0);
      iv2_HostPllCtrlSpiStart_p  : in  std_logic_vector(1 downto 0);
      o_pllCtrlSpiBusy_p         : out std_logic;

      o_limeSpiCs_p          : out std_logic;
      o_limeSpiClk_p         : out std_logic;
      o_limeSpiMosi_p        : out std_logic;
      i_limeSpiMiso_p        : in  std_logic;

      o_refDacSpiCs_p        : out std_logic;
      o_refDacSpiClk_p       : out std_logic;
      o_refDacSpiMosi_p      : out std_logic;

      ov2_pllCtrlSpiCs_p     : out std_logic_vector(1 downto 0);
      o_pllCtrlSpiClk_p      : out std_logic;
      o_pllCtrlSpiMosi_p     : out std_logic;
      i_pllCtrlSpiMiso_p     : in  std_logic;

      ov3_rxGainSpiCs_p      : out std_logic_vector(2 downto 0);
      o_rxGainSpiClk_p       : out std_logic;
      o_rxGainSpiMosi_p      : out std_logic;

      o_txGainSpiCs_p        : out std_logic;
      o_txGainSpiClk_p       : out std_logic;
      o_txGainSpiMosi_p      : out std_logic
    );
  end component;


  component io_dff is
    generic (
      io_dff_Falling_edge : boolean := FALSE
    );
    port (
      clk     : in std_logic;
      din     : in std_logic;
      dout    : out std_logic
    );
  end component io_dff;


  component radio420x_fifo1k_18b_async
    port (
      rst: IN std_logic;
      wr_clk: IN std_logic;
      rd_clk: IN std_logic;
      din: IN std_logic_VECTOR(17 downto 0);
      wr_en: IN std_logic;
      rd_en: IN std_logic;
      dout: OUT std_logic_VECTOR(17 downto 0);
      full: OUT std_logic;
      empty: OUT std_logic
    );
  end component;

  component spi_register
    generic(
      SPI_DATA_WIDTH  : integer := 16;
      SPI_NUMBER_CS : integer := 1;
      SPI_CLK_DOWNSAMPLING : integer := 4   --max 254
    );
    port  (
      -- SPI Interface
      i_clk_p            : in     std_logic;
      i_rst_p            : in     std_logic;
      iv_spiStart_p      : in     std_logic_vector(SPI_NUMBER_CS-1 downto 0);
      i_spiClkPol_p      : in     std_logic;
      i_spiMsbf_p        : in     std_logic;
      iv_spiDataIn_p     : in     std_logic_vector((SPI_DATA_WIDTH - 1) downto 0);
      ov_spiDataOut_p    : out    std_logic_vector((SPI_DATA_WIDTH - 1) downto 0);
      o_spiBusy_p        : out    std_logic;

      o_spiClkOutPin_p   : out    std_logic;
      ov_spiCsPin_p      : out    std_logic_vector(SPI_NUMBER_CS-1 downto 0);
      o_spiMosiPin_p     : out    std_logic;
      i_spiMisoPin_p     : in    std_logic
    );
  end component;

  component DataOutOfRange
    generic (
      FilterLength : positive
    );
    port(
      i_clk_p                 : in std_logic;
      i_rst_p                 : in std_logic;
      iv12_DataCh1_p          : in std_logic_vector (11 downto 0);
      iv12_DataCh2_p          : in std_logic_vector (11 downto 0);
      i_DataType_p            : in std_logic;                                   -- 0 = offset binary output format / 1= 2s complement output format
      o_Ch1_OvrNotFiltred_p   : out std_logic;
      o_Ch1_OvrFiltred_p      : out std_logic;
      o_Ch2_OvrNotFiltred_p   : out std_logic;
      o_Ch2_OvrFiltred_p      : out std_logic

    );
  end component;


  -- Custom component build in matlab netlist to evaluate the
  -- error function and rx dc offset level.
  component radio420x_rxerrorfunc12b_netlist_cw  port (
      ce                     : in std_logic := '1';
      clk                    : in std_logic;
      i_freqvalid_p          : in std_logic;
      i_start_p              : in std_logic;
      iv12_datai_p           : in std_logic_vector(11 downto 0);
      iv12_dataq_p           : in std_logic_vector(11 downto 0);
      iv14_n_p               : in std_logic_vector(13 downto 0);
      iv_freq_p              : in std_logic_vector(23 downto 0);
      o_done_p               : out std_logic;
      ov12_dcleveli_p        : out std_logic_vector(11 downto 0);
      ov12_dclevelq_p        : out std_logic_vector(11 downto 0);
      ov32_erri_p            : out std_logic_vector(31 downto 0);
      ov32_errq_p            : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Custom component build in matlab netlist to calibrate the
  -- TX IQ imbalance.
  component radio420x_iqcomp12b_netlist  
  port (
      ce_1: in std_logic; 
      clk_1: in std_logic; 
      i_iqsel_p: in std_logic; 
      iv12_iqdata_p: in std_logic_vector(11 downto 0); 
      iv13p11_backoff_p: in std_logic_vector(12 downto 0); 
      iv13p11_gainoffset_p: in std_logic_vector(12 downto 0); 
      iv13p11_phaseoffsetcos_p: in std_logic_vector(12 downto 0); 
      iv13p11_phaseoffsetsin_p: in std_logic_vector(12 downto 0); 
      iv24_ddsfreq_p: in std_logic_vector(23 downto 0); 
      iv3_dacoutsel_p: in std_logic_vector(2 downto 0); 
      o_iqsel_p: out std_logic; 
      ov12_iqdata_p: out std_logic_vector(11 downto 0)
    );
  end component;

end radio420x_internal_p;