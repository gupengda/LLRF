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
-- File        : $Id: clk_module.vhd,v 1.4 2012/11/26 20:46:45 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : Clock Module
--               Instantiates MMCMs, BUFGs and freq counters for the clocks
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2011 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: clk_module.vhd,v $
-- Revision 1.4  2012/11/26 20:46:45  julien.roy
-- Add GENERIC port for MMCM control.
-- Modify pattern error verification to ease timing.
--
-- Revision 1.3  2012/11/20 14:02:02  khalid.bensadek
-- Cleaned-up unused signals.
--
-- Revision 1.2  2012/11/12 19:34:16  khalid.bensadek
-- Optimized design to use one MMCM only instead of 4. That way, we can use Record-playback ip core with it.
--
-- Revision 1.2  2011/05/25 20:36:54  jeffrey.johnson
-- Removed 16 to 64 bit FIFO.
--
-- Revision 1.1  2011/05/25 16:12:30  jeffrey.johnson
-- Moved MMCM from wrapper to clk_module.
-- Added freq counters for all clocks.
--
--
--------------------------------------------------------------------------------

library ieee;                                                               
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library unisim;
  use unisim.vcomponents.all;

entity clk_module is
  generic (
    ADC_CLKIN_FREQ       : real    := 250.0;
    ADC_CLKFBOUT_MULT_F  : real    := 8.0;
    ADC_DIVCLK_DIVIDE    : integer := 2;
    ADC_CLKOUT0_DIVIDE_F : real    := 4.0;
    C_REFCLK_FREQ_MHZ    : integer := 100
  );
  port (                                                                  
    i_Rst_p              : in std_logic; 
    i_RefClk_p           : in std_logic;
    -- MMCM reset inputs
    i_AdcAbMmcmRst_p     : in std_logic;
    i_AdcCdMmcmRst_p     : in std_logic;
    i_AdcEfMmcmRst_p     : in std_logic;
    i_AdcGhMmcmRst_p     : in std_logic;
    -- Clock inputs (from BUFR)
    i_ClkToFpgaBufr_p    : in std_logic;
    i_ExternClkBufr_p    : in std_logic;
    i_AdcAbClkBufr_p     : in std_logic;
    i_AdcCdClkBufr_p     : in std_logic;
    i_AdcEfClkBufr_p     : in std_logic;
    i_AdcGhClkBufr_p     : in std_logic;
    -- Global clock outputs (from BUFG)
    o_AdcAbClkOut_p      : out std_logic;
    o_AdcCdClkOut_p      : out std_logic;
    o_AdcEfClkOut_p      : out std_logic;
    o_AdcGhClkOut_p      : out std_logic;
    -- MMCM locked outputs
    o_AdcAbMmcmLocked_p  : out std_logic;
    o_AdcCdMmcmLocked_p  : out std_logic;
    o_AdcEfMmcmLocked_p  : out std_logic;
    o_AdcGhMmcmLocked_p  : out std_logic;
    -- Frequency counter outputs
    ov16_ClkToFpgaFreq_p : out std_logic_vector(15 downto 0);
    ov16_ExternClkFreq_p : out std_logic_vector(15 downto 0);
    ov16_AdcAbClkFreq_p  : out std_logic_vector(15 downto 0);
    ov16_AdcCdClkFreq_p  : out std_logic_vector(15 downto 0);
    ov16_AdcEfClkFreq_p  : out std_logic_vector(15 downto 0);
    ov16_AdcGhClkFreq_p  : out std_logic_vector(15 downto 0)
  );                                                                      
end entity;
                                                
architecture behavior of clk_module is                                         

  function CalculateMMCMBandwidth( ADC_CLKIN_FREQ : real;
                                 ADC_DIVCLK_DIVIDE :integer ) return string
  is
    constant MMCM_LOW : string := "LOW";
    constant MMCM_OPT : string := "OPTIMIZED";
  begin

    if( (ADC_CLKIN_FREQ / real(ADC_DIVCLK_DIVIDE)) <= 135.0 ) then
      return MMCM_LOW;
    else
      return MMCM_OPT;
    end if;

  end CalculateMMCMBandwidth;

  constant ADC_CLKIN_PERIOD : real := 1000.0 / ADC_CLKIN_FREQ;
  
  signal MmcmResetAb_s     : std_logic;
  signal MmcmResetCd_s     : std_logic;
  signal MmcmResetEf_s     : std_logic;
  signal MmcmResetGh_s     : std_logic;
  signal MmcmABFbOutBufg_s : std_logic;
  signal MmcmABFbOut_s     : std_logic;
  signal MmcmCDFbOutBufg_s : std_logic;
  signal MmcmCDFbOut_s     : std_logic;
  signal MmcmEFFbOutBufg_s : std_logic;
  signal MmcmEFFbOut_s     : std_logic;
  signal MmcmGHFbOutBufg_s : std_logic;
  signal MmcmGHFbOut_s     : std_logic;
  signal ClkAbMmcm_s       : std_logic;
  signal ClkCdMmcm_s       : std_logic;
  signal ClkEfMmcm_s       : std_logic;
  signal ClkGhMmcm_s       : std_logic;
  signal ClkAbBufg_s       : std_logic;
  signal ClkCdBufg_s       : std_logic;
  signal ClkEfBufg_s       : std_logic;
  signal ClkGhBufg_s       : std_logic;

begin                                                                       

  ----------------------------------------------------------------------------------------------------
  -- Clock-to-FPGA Frequency counter
  ----------------------------------------------------------------------------------------------------
  
  ClkToFpga_FreqCnt  : entity work.freq_cnt
  generic map
  (
    C_REFCLK_FREQ_MHZ  =>  C_REFCLK_FREQ_MHZ
  )
  port map
  (
    i_RefClk_p         => i_RefClk_p,
    i_TestClk_p        => i_ClkToFpgaBufr_p,
    i_Rst_p            => i_Rst_p,
    ov16_Freq_p        => ov16_ClkToFpgaFreq_p
  );
    
  ----------------------------------------------------------------------------------------------------
  -- External Clock Frequency counter
  ----------------------------------------------------------------------------------------------------
  
  ExternClk_FreqCnt  : entity work.freq_cnt
  generic map
  (
    C_REFCLK_FREQ_MHZ  =>  C_REFCLK_FREQ_MHZ
  )
  port map
  (
    i_RefClk_p         => i_RefClk_p,
    i_TestClk_p        => i_ExternClkBufr_p,
    i_Rst_p            => i_Rst_p,
    ov16_Freq_p        => ov16_ExternClkFreq_p
  );
    
  ----------------------------------------------------------------------------------------------------
  -- MMCM for channel A and B
  ----------------------------------------------------------------------------------------------------

  MmcmResetAb_s <= i_Rst_p or i_AdcAbMmcmRst_p;
   
  mmcm_adv_inst_ab : entity work.mmcm_calib
  generic map
  (
    BANDWIDTH            => CalculateMMCMBandwidth( ADC_CLKIN_FREQ, ADC_DIVCLK_DIVIDE),    --Was "OPTIMIZED" with AR#38132 must be set to low if clkin/d <= 135Mhz.
    CLKOUT4_CASCADE      => FALSE,
    CLOCK_HOLD           => FALSE,
    COMPENSATION         => "ZHOLD",
    STARTUP_WAIT         => FALSE,
    DIVCLK_DIVIDE        => ADC_DIVCLK_DIVIDE,
    CLKFBOUT_MULT_F      => ADC_CLKFBOUT_MULT_F,
    CLKFBOUT_PHASE       => 0.000,
    CLKFBOUT_USE_FINE_PS => FALSE,
    CLKOUT0_DIVIDE_F     => ADC_CLKOUT0_DIVIDE_F,
    CLKOUT0_PHASE        => 0.000,
    CLKOUT0_DUTY_CYCLE   => 0.500,
    CLKOUT0_USE_FINE_PS  => FALSE,
    CLKIN1_PERIOD        => ADC_CLKIN_PERIOD,
    REF_JITTER1          => 0.010
  )
  port map
    -- Output clocks
  (
    CLKFBOUT            => MmcmABFbOut_s,
    CLKFBOUTB           => open,
    CLKOUT0             => ClkAbMmcm_s,
    CLKOUT0B            => open,
    CLKOUT1             => open,
    CLKOUT1B            => open,
    CLKOUT2             => open,
    CLKOUT2B            => open,
    CLKOUT3             => open,
    CLKOUT3B            => open,
    CLKOUT4             => open,
    CLKOUT5             => open,
    CLKOUT6             => open,
    -- Input clock control
    CLKFBIN             => MmcmABFbOutBufg_s,
    CLKIN1              => i_AdcAbClkBufr_p,
    CLKIN2              => '0',
    -- Tied to always select the primary input clock
    CLKINSEL            => '1',
    -- Ports for dynamic reconfiguration
    DADDR               => (others => '0'),
    DCLK                => '0',
    DEN                 => '0',
    DI                  => (others => '0'),
    DO                  => open,
    DRDY                => open,
    DWE                 => '0',
    -- Ports for dynamic phase shift
    PSCLK               => '0',
    PSEN                => '0',
    PSINCDEC            => '0',
    PSDONE              => open,
    -- Other control and status signals
    LOCKED              => o_AdcAbMmcmLocked_p,
    CLKINSTOPPED        => open,
    CLKFBSTOPPED        => open,
    PWRDWN              => '0',
    RST                 => MmcmResetAb_s
  );

  MmcmABClkfBufg_l : BUFG
  port map
  (
    O => MmcmABFbOutBufg_s,
    I => MmcmABFbOut_s
  );

  -- Make sure the clock is routed on a global net
  bufg_ab_inst : bufg
  port map (
    i  => ClkAbMmcm_s,
    o  => ClkAbBufg_s
  );

  
  ----------------------------------------------------------------------------------------------------
  -- MMCM for channel C and D
  ----------------------------------------------------------------------------------------------------

--   MmcmResetCd_s <= i_Rst_p or i_AdcCdMmcmRst_p;
--    
--   mmcm_adv_inst_cd : entity work.mmcm_calib
--   generic map
--   (
--     BANDWIDTH            => CalculateMMCMBandwidth( ADC_CLKIN_FREQ, ADC_DIVCLK_DIVIDE),    --Was "OPTIMIZED" with AR#38132 must be set to low if clkin/d <= 135Mhz.
--     CLKOUT4_CASCADE      => FALSE,
--     CLOCK_HOLD           => FALSE,
--     COMPENSATION         => "ZHOLD",
--     STARTUP_WAIT         => FALSE,
--     DIVCLK_DIVIDE        => ADC_DIVCLK_DIVIDE,
--     CLKFBOUT_MULT_F      => ADC_CLKFBOUT_MULT_F,
--     CLKFBOUT_PHASE       => 0.000,
--     CLKFBOUT_USE_FINE_PS => FALSE,
--     CLKOUT0_DIVIDE_F     => ADC_CLKOUT0_DIVIDE_F,
--     CLKOUT0_PHASE        => 0.000,
--     CLKOUT0_DUTY_CYCLE   => 0.500,
--     CLKOUT0_USE_FINE_PS  => FALSE,
--     CLKIN1_PERIOD        => ADC_CLKIN_PERIOD,
--     REF_JITTER1          => 0.010
--   )
--   port map
--     -- Output clocks
--   (
--     CLKFBOUT            => MmcmCDFbOut_s,
--     CLKFBOUTB           => open,
--     CLKOUT0             => ClkCdMmcm_s,
--     CLKOUT0B            => open,
--     CLKOUT1             => open,
--     CLKOUT1B            => open,
--     CLKOUT2             => open,
--     CLKOUT2B            => open,
--     CLKOUT3             => open,
--     CLKOUT3B            => open,
--     CLKOUT4             => open,
--     CLKOUT5             => open,
--     CLKOUT6             => open,
--     -- Input clock control
--     CLKFBIN             => MmcmCDFbOutBufg_s,
--     CLKIN1              => i_AdcCdClkBufr_p,
--     CLKIN2              => '0',
--     -- Tied to always select the primary input clock
--     CLKINSEL            => '1',
--     -- Ports for dynamic reconfiguration
--     DADDR               => (others => '0'),
--     DCLK                => '0',
--     DEN                 => '0',
--     DI                  => (others => '0'),
--     DO                  => open,
--     DRDY                => open,
--     DWE                 => '0',
--     -- Ports for dynamic phase shift
--     PSCLK               => '0',
--     PSEN                => '0',
--     PSINCDEC            => '0',
--     PSDONE              => open,
--     -- Other control and status signals
--     LOCKED              => o_AdcCdMmcmLocked_p,
--     CLKINSTOPPED        => open,
--     CLKFBSTOPPED        => open,
--     PWRDWN              => '0',
--     RST                 => MmcmResetCd_s
--   );
-- 
--   MmcmCDClkfBufg_l : BUFG
--   port map
--   (
--     O => MmcmCDFbOutBufg_s,
--     I => MmcmCDFbOut_s
--   );
-- 
--   -- Make sure the clock is routed on a global net
--   bufg_cd_inst : bufg
--   port map (
--     i  => ClkCdMmcm_s,
--     o  => ClkCdBufg_s
--   );

  ClkCdBufg_s <= i_AdcCdClkBufr_p;
  
  ----------------------------------------------------------------------------------------------------
  -- MMCM for channel E and F
  ----------------------------------------------------------------------------------------------------

--   MmcmResetEf_s <= i_Rst_p or i_AdcEfMmcmRst_p;
--    
--   mmcm_adv_inst_ef : entity work.mmcm_calib
--   generic map
--   (
--     BANDWIDTH            => CalculateMMCMBandwidth( ADC_CLKIN_FREQ, ADC_DIVCLK_DIVIDE),    --Was "OPTIMIZED" with AR#38132 must be set to low if clkin/d <= 135Mhz.
--     CLKOUT4_CASCADE      => FALSE,
--     CLOCK_HOLD           => FALSE,
--     COMPENSATION         => "ZHOLD",
--     STARTUP_WAIT         => FALSE,
--     DIVCLK_DIVIDE        => ADC_DIVCLK_DIVIDE,
--     CLKFBOUT_MULT_F      => ADC_CLKFBOUT_MULT_F,
--     CLKFBOUT_PHASE       => 0.000,
--     CLKFBOUT_USE_FINE_PS => FALSE,
--     CLKOUT0_DIVIDE_F     => ADC_CLKOUT0_DIVIDE_F,
--     CLKOUT0_PHASE        => 0.000,
--     CLKOUT0_DUTY_CYCLE   => 0.500,
--     CLKOUT0_USE_FINE_PS  => FALSE,
--     CLKIN1_PERIOD        => ADC_CLKIN_PERIOD,
--     REF_JITTER1          => 0.010
--   )
--   port map
--     -- Output clocks
--   (
--     CLKFBOUT            => MmcmEFFbOut_s,
--     CLKFBOUTB           => open,
--     CLKOUT0             => ClkEfMmcm_s,
--     CLKOUT0B            => open,
--     CLKOUT1             => open,
--     CLKOUT1B            => open,
--     CLKOUT2             => open,
--     CLKOUT2B            => open,
--     CLKOUT3             => open,
--     CLKOUT3B            => open,
--     CLKOUT4             => open,
--     CLKOUT5             => open,
--     CLKOUT6             => open,
--     -- Input clock control
--     CLKFBIN             => MmcmEFFbOutBufg_s,
--     CLKIN1              => i_AdcEfClkBufr_p,
--     CLKIN2              => '0',
--     -- Tied to always select the primary input clock
--     CLKINSEL            => '1',
--     -- Ports for dynamic reconfiguration
--     DADDR               => (others => '0'),
--     DCLK                => '0',
--     DEN                 => '0',
--     DI                  => (others => '0'),
--     DO                  => open,
--     DRDY                => open,
--     DWE                 => '0',
--     -- Ports for dynamic phase shift
--     PSCLK               => '0',
--     PSEN                => '0',
--     PSINCDEC            => '0',
--     PSDONE              => open,
--     -- Other control and status signals
--     LOCKED              => o_AdcEfMmcmLocked_p,
--     CLKINSTOPPED        => open,
--     CLKFBSTOPPED        => open,
--     PWRDWN              => '0',
--     RST                 => MmcmResetEf_s
--   );
-- 
--   MmcmEFClkfBufg_l : BUFG
--   port map
--   (
--     O => MmcmEFFbOutBufg_s,
--     I => MmcmEFFbOut_s
--   );
-- 
--   -- Make sure the clock is routed on a global net
--   bufg_ef_inst : bufg
--   port map (
--     i  => ClkEfMmcm_s,
--     o  => ClkEfBufg_s
--   );

	ClkEfBufg_s <= i_AdcEfClkBufr_p;

  ----------------------------------------------------------------------------------------------------
  -- MMCM for channel G and H
  ----------------------------------------------------------------------------------------------------

--   MmcmResetGh_s <= i_Rst_p or i_AdcGhMmcmRst_p;
--    
--   mmcm_adv_inst_gh : entity work.mmcm_calib
--   generic map
--   (
--     BANDWIDTH            => CalculateMMCMBandwidth( ADC_CLKIN_FREQ, ADC_DIVCLK_DIVIDE),    --Was "OPTIMIZED" with AR#38132 must be set to low if clkin/d <= 135Mhz.
--     CLKOUT4_CASCADE      => FALSE,
--     CLOCK_HOLD           => FALSE,
--     COMPENSATION         => "ZHOLD",
--     STARTUP_WAIT         => FALSE,
--     DIVCLK_DIVIDE        => ADC_DIVCLK_DIVIDE,
--     CLKFBOUT_MULT_F      => ADC_CLKFBOUT_MULT_F,
--     CLKFBOUT_PHASE       => 0.000,
--     CLKFBOUT_USE_FINE_PS => FALSE,
--     CLKOUT0_DIVIDE_F     => ADC_CLKOUT0_DIVIDE_F,
--     CLKOUT0_PHASE        => 0.000,
--     CLKOUT0_DUTY_CYCLE   => 0.500,
--     CLKOUT0_USE_FINE_PS  => FALSE,
--     CLKIN1_PERIOD        => ADC_CLKIN_PERIOD,
--     REF_JITTER1          => 0.010
--   )
--   port map
--     -- Output clocks
--   (
--     CLKFBOUT            => MmcmGHFbOut_s,
--     CLKFBOUTB           => open,
--     CLKOUT0             => ClkGhMmcm_s,
--     CLKOUT0B            => open,
--     CLKOUT1             => open,
--     CLKOUT1B            => open,
--     CLKOUT2             => open,
--     CLKOUT2B            => open,
--     CLKOUT3             => open,
--     CLKOUT3B            => open,
--     CLKOUT4             => open,
--     CLKOUT5             => open,
--     CLKOUT6             => open,
--     -- Input clock control
--     CLKFBIN             => MmcmGHFbOutBufg_s,
--     CLKIN1              => i_AdcGhClkBufr_p,
--     CLKIN2              => '0',
--     -- Tied to always select the primary input clock
--     CLKINSEL            => '1',
--     -- Ports for dynamic reconfiguration
--     DADDR               => (others => '0'),
--     DCLK                => '0',
--     DEN                 => '0',
--     DI                  => (others => '0'),
--     DO                  => open,
--     DRDY                => open,
--     DWE                 => '0',
--     -- Ports for dynamic phase shift
--     PSCLK               => '0',
--     PSEN                => '0',
--     PSINCDEC            => '0',
--     PSDONE              => open,
--     -- Other control and status signals
--     LOCKED              => o_AdcGhMmcmLocked_p,
--     CLKINSTOPPED        => open,
--     CLKFBSTOPPED        => open,
--     PWRDWN              => '0',
--     RST                 => MmcmResetGh_s
--   );
-- 
--   MmcmGHClkfBufg_l : BUFG
--   port map
--   (
--     O => MmcmGHFbOutBufg_s,
--     I => MmcmGHFbOut_s
--   );
-- 
--   -- Make sure the clock is routed on a global net
--   bufg_gh_inst : bufg
--   port map (
--     i  => ClkGhMmcm_s,
--     o  => ClkGhBufg_s
--   );

  	ClkGhBufg_s <= i_AdcGhClkBufr_p;
  ----------------------------------------------------------------------------------------------------
  -- Frequency counter for ADC channel AB
  ----------------------------------------------------------------------------------------------------
  
  AdcAb_FreqCnt  : entity work.freq_cnt
  generic map
  (
    C_REFCLK_FREQ_MHZ  =>  C_REFCLK_FREQ_MHZ
  )
  port map
  (
    i_RefClk_p         => i_RefClk_p,
    i_TestClk_p        => ClkAbBufg_s,
    i_Rst_p            => i_Rst_p,
    ov16_Freq_p        => ov16_AdcAbClkFreq_p
  );
    
  ----------------------------------------------------------------------------------------------------
  -- Frequency counter for ADC channel CD
  ----------------------------------------------------------------------------------------------------
  
  AdcCd_FreqCnt  : entity work.freq_cnt
  generic map
  (
    C_REFCLK_FREQ_MHZ  =>  C_REFCLK_FREQ_MHZ
  )
  port map
  (
    i_RefClk_p         => i_RefClk_p,
    i_TestClk_p        => ClkCdBufg_s,
    i_Rst_p            => i_Rst_p,
    ov16_Freq_p        => ov16_AdcCdClkFreq_p
  );
    
  ----------------------------------------------------------------------------------------------------
  -- Frequency counter for ADC channel EF
  ----------------------------------------------------------------------------------------------------
  
  AdcEf_FreqCnt  : entity work.freq_cnt
  generic map
  (
    C_REFCLK_FREQ_MHZ  =>  C_REFCLK_FREQ_MHZ
  )
  port map
  (
    i_RefClk_p         => i_RefClk_p,
    i_TestClk_p        => ClkEfBufg_s,
    i_Rst_p            => i_Rst_p,
    ov16_Freq_p        => ov16_AdcEfClkFreq_p
  );
    
  ----------------------------------------------------------------------------------------------------
  -- Frequency counter for ADC channel GH
  ----------------------------------------------------------------------------------------------------
  
  AdcGh_FreqCnt  : entity work.freq_cnt
  generic map
  (
    C_REFCLK_FREQ_MHZ  =>  C_REFCLK_FREQ_MHZ
  )
  port map
  (
    i_RefClk_p         => i_RefClk_p,
    i_TestClk_p        => ClkGhBufg_s,
    i_Rst_p            => i_Rst_p,
    ov16_Freq_p        => ov16_AdcGhClkFreq_p
  );
    
  ----------------------------------------------------------------------------------------------------
  -- Output mapping
  ----------------------------------------------------------------------------------------------------
  o_AdcAbClkOut_p <= ClkAbBufg_s;
  o_AdcCdClkOut_p <= ClkCdBufg_s;
  o_AdcEfClkOut_p <= ClkEfBufg_s;
  o_AdcGhClkOut_p <= ClkGhBufg_s;

end architecture;                                                           
                                                                            
                                                                            