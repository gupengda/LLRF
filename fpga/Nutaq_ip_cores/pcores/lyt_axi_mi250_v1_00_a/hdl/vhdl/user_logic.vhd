--------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           v1_00_a
-- Description:       User Logic implementation module
-- Generated by:      julien.roy
-- Date:              2013-02-14 09:50:09
-- Generated:         using LyrtechRD REGGENUTIL based on Xilinx IPIF Wizard.
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Copyright (c) 2001-2012 LYRtech RD Inc.  All rights reserved.
------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
-- Register Memory Map & Description
-----------------------------------------------------------------------------
-- BASEADDR + 0x0   CORE_ID    core id
--   31:0 coreId R

-- BASEADDR + 0x4   CORE_RST    core reset
--   0:0 CoreResetPulse P O=o_CoreResetPulse_p
--   31:1 rsvd R

-- BASEADDR + 0x8   ADCCTRL    ADC control register
--   0:0 AdcSpiReset R W O=o_AdcSpiReset_p
--   1:1 TriggerToFpga R I=i_TriggerToFpga_p
--   2:2 SoftwareTrig R W O=o_SoftwareTrig_p
--   31:8 AdcRsvd R
--   4:3 TriggerMode R W O=ov2_TriggerMode_p
--   5:5 ChArmed R W O=o_ChArmed_p
--   7:6 TestMode R W O=ov2_TestMode_p

-- BASEADDR + 0xc   PLLCTRL    PLL control register
--   0:0 PllStatus R I=i_PllStatus_p
--   1:1 PllFunction R W O=o_PllFunction_p
--   2:2 PllRefEn R W O=o_PllRefEn_p
--   3:3 VcoPwrEn R W O=o_VcoPwrEn_p
--   31:4 PllRsvd R

-- BASEADDR + 0x10   SPIREG    SPI register
--   10:10 SpiUpdaterBusy R I=i_SpiUpdaterBusy_p
--   11:11 SpiBusy R I=i_SpiBusy_p
--   12:12 SpiReq2 R W O=o_SpiReq2_p
--   13:13 SpiGnt2 R I=i_SpiGnt2_p
--   14:14 SpiAck2 R I=i_SpiAck2_p
--   31:15 SpiRsvd1 R
--   9:0 SpiRsvd2 R

-- BASEADDR + 0x14   SPICTRL    SPI Control Register
--   31:0 SPI0 R

-- BASEADDR + 0x18   SPIDATA0    SPI Data 0 Register
--   31:0 SPI1 R

-- BASEADDR + 0x1c   SPIDATA1    Spi Data 1 Register
--   31:0 SPI2 R

-- BASEADDR + 0x20   SPIDATA2    Spi Data 2 Register
--   31:0 SPI3 R

-- BASEADDR + 0x24   SPIDATA3    Spi Data 3 Register
--   31:0 SPI4 R

-- BASEADDR + 0x28   SPIDATA4    Spi Data 4 Register
--   31:0 SPI5 R

-- BASEADDR + 0x2c   SPIDATA5    Spi Data 5 Register
--   31:0 SPI6 R

-- BASEADDR + 0x30   SPICS    Spi Chip Select Register
--   31:0 SPI7 R

-- BASEADDR + 0x34   SPIDIV    Spi Clock Div Register
--   31:0 SPI8 R

-- BASEADDR + 0x38   ADCCTRLAB    ADC Channel A-B control
--   10:10 AdcAbMmcmRst R W O=o_AdcAbMmcmRst_p
--   15:11 AdcAbIdelayValue R W O=ov5_AdcAbIdelayValue_p
--   20:16 AdcAbClkIdelayValue R W O=ov5_AdcAbClkIdelayValue_p
--   22:21 AdcAbPatternError R I=iv2_AdcAbPatternError_p
--   31:23 AdcAbRsvd R
--   8:0 AdcAbRsvd1 R
--   9:9 AdcAbMmcmLocked R I=i_AdcAbMmcmLocked_p

-- BASEADDR + 0x3c   ADCCTRLCD    ADC Channel C-D control
--   10:10 AdcCdMmcmRst R W O=o_AdcCdMmcmRst_p
--   15:11 AdcCdIdelayValue R W O=ov5_AdcCdIdelayValue_p
--   20:16 AdcCdClkIdelayValue R W O=ov5_AdcCdClkIdelayValue_p
--   22:21 AdcCdPatternError R I=iv2_AdcCdPatternError_p
--   31:23 AdcCdRsvd R
--   8:0 AdcCdRsvd1 R
--   9:9 AdcCdMmcmLocked R I=i_AdcCdMmcmLocked_p

-- BASEADDR + 0x40   ADCCTRLEF    ADC Channel E-F control
--   10:10 AdcEfMmcmRst R W O=o_AdcEfMmcmRst_p
--   15:11 AdcEfIdelayValue R W O=ov5_AdcEfIdelayValue_p
--   20:16 AdcEfClkIdelayValue R W O=ov5_AdcEfClkIdelayValue_p
--   22:21 AdcEfPatternError R I=iv2_AdcEfPatternError_p
--   31:23 AdcEfRsvd R
--   8:0 AdcEfRsvd1 R
--   9:9 AdcEfMmcmLocked R I=i_AdcEfMmcmLocked_p

-- BASEADDR + 0x44   ADCCTRLGH    ADC Channel G-H control
--   10:10 AdcGhMmcmRst R W O=o_AdcGhMmcmRst_p
--   15:11 AdcGhIdelayValue R W O=ov5_AdcGhIdelayValue_p
--   20:16 AdcGhClkIdelayValue R W O=ov5_AdcGhClkIdelayValue_p
--   22:21 AdcGhPatternError R I=iv2_AdcGhPatternError_p
--   31:23 AdcGhRsvd R
--   8:0 AdcGhRsvd1 R
--   9:9 AdcGhMmcmLocked R I=i_AdcGhMmcmLocked_p

-- BASEADDR + 0x48   MONCTRL    Voltage/temp monitor control
--   0:0 MonInterrupt R I=i_MonInterrupt_p
--   31:1 MonRsvd R

-- BASEADDR + 0x4c   CLKFREQ    Test clock frequencies
--   15:0 ExternClkFreq R I=iv16_ExternClkFreq_p
--   31:16 ClkToFpgaFreq R I=iv16_ClkToFpgaFreq_p

-- BASEADDR + 0x50   ABCDFREQ    ADC ABCD clock frequencies
--   15:0 AdcAbClkFreq R I=iv16_AdcAbClkFreq_p
--   31:16 AdcCdClkFreq R I=iv16_AdcCdClkFreq_p

-- BASEADDR + 0x54   EFGHFREQ    ADC EFGH clock frequencies
--   15:0 AdcEfClkFreq R I=iv16_AdcEfClkFreq_p
--   31:16 AdcGhClkFreq R I=iv16_AdcGhClkFreq_p

--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 22;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------
    -- User ports
  i_CoreReset_p : in std_logic;

    o_CoreResetPulse_p : out std_logic;
    -- BELOW NEEDED FOR SPI INTERFACE    
    iv32_Spi2PlbData_p    : in std_logic_vector(31 downto 0);
    ov32_Plb2SpiData_p    : out std_logic_vector(31 downto 0);
    ov9_PlbRegWriteSel_p  : out std_logic_vector(8 downto 0);
    ov9_PlbRegReadSel_p   : out std_logic_vector(8 downto 0);
    -- ABOVE NEEDED FOR SPI INTERFACE
    o_AdcSpiReset_p : out std_logic;
    i_TriggerToFpga_p : in std_logic;
    o_SoftwareTrig_p : out std_logic;
    ov2_TriggerMode_p : out std_logic_vector(1 downto 0);
    o_ChArmed_p : out std_logic;
    ov2_TestMode_p : out std_logic_vector(1 downto 0);
    i_PllStatus_p : in std_logic;
    o_PllFunction_p : out std_logic;
    o_PllRefEn_p : out std_logic;
    o_VcoPwrEn_p : out std_logic;
    i_SpiUpdaterBusy_p : in std_logic;
    i_SpiBusy_p : in std_logic;
    o_SpiReq2_p : out std_logic;
    i_SpiGnt2_p : in std_logic;
    i_SpiAck2_p : in std_logic;
    o_AdcAbMmcmRst_p : out std_logic;
    ov5_AdcAbIdelayValue_p : out std_logic_vector(4 downto 0);
    ov5_AdcAbClkIdelayValue_p : out std_logic_vector(4 downto 0);
    iv2_AdcAbPatternError_p : in std_logic_vector(1 downto 0);
    i_AdcAbMmcmLocked_p : in std_logic;
    o_AdcCdMmcmRst_p : out std_logic;
    ov5_AdcCdIdelayValue_p : out std_logic_vector(4 downto 0);
    ov5_AdcCdClkIdelayValue_p : out std_logic_vector(4 downto 0);
    iv2_AdcCdPatternError_p : in std_logic_vector(1 downto 0);
    i_AdcCdMmcmLocked_p : in std_logic;
    o_AdcEfMmcmRst_p : out std_logic;
    ov5_AdcEfIdelayValue_p : out std_logic_vector(4 downto 0);
    ov5_AdcEfClkIdelayValue_p : out std_logic_vector(4 downto 0);
    iv2_AdcEfPatternError_p : in std_logic_vector(1 downto 0);
    i_AdcEfMmcmLocked_p : in std_logic;
    o_AdcGhMmcmRst_p : out std_logic;
    ov5_AdcGhIdelayValue_p : out std_logic_vector(4 downto 0);
    ov5_AdcGhClkIdelayValue_p : out std_logic_vector(4 downto 0);
    iv2_AdcGhPatternError_p : in std_logic_vector(1 downto 0);
    i_AdcGhMmcmLocked_p : in std_logic;
    i_MonInterrupt_p : in std_logic;
    iv16_ExternClkFreq_p : in std_logic_vector(15 downto 0);
    iv16_ClkToFpgaFreq_p : in std_logic_vector(15 downto 0);
    iv16_AdcAbClkFreq_p : in std_logic_vector(15 downto 0);
    iv16_AdcCdClkFreq_p : in std_logic_vector(15 downto 0);
    iv16_AdcEfClkFreq_p : in std_logic_vector(15 downto 0);
    iv16_AdcGhClkFreq_p : in std_logic_vector(15 downto 0);
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
  );

 attribute MAX_FANOUT : string;
 attribute SIGIS : string;
 attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
 attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

-------------------------------------------------------------------------------
-- Constant declarations
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--     ************** Function declaratin *******************                   
-- Return a std_logic_vector with only one bit set to one.
-- The argument BitPosition represent the bit position to set to one, starting with 0.
-- The argument Width represent the width of the returned std_logic_vector.
-------------------------------------------------------------------------------
  function OneHotVector( BitPosition : integer;                              
                Width : integer)                                             
                return std_logic_vector                                      
  is                                                                         
    variable Result                   : std_logic_vector(Width - 1 downto 0);

  begin                        
    Result := (others => '0'); 
    Result(BitPosition) := '1';
    return Result;             
  end OneHotVector;            
-------------------------------------------------------------------------------
-- Signal and Type Declarations
-------------------------------------------------------------------------------

  signal CoreResetPulse_s                     : std_logic;
  signal AdcSpiReset_s                     : std_logic;
  signal SoftwareTrig_s                     : std_logic;
  signal v2_TriggerMode_s                     : std_logic_vector(1 downto 0);
  signal ChArmed_s                     : std_logic;
  signal v2_TestMode_s                     : std_logic_vector(1 downto 0);
  signal PllFunction_s                     : std_logic;
  signal PllRefEn_s                     : std_logic;
  signal VcoPwrEn_s                     : std_logic;
  signal SpiReq2_s                     : std_logic;
  signal AdcAbMmcmRst_s                     : std_logic;
  signal v5_AdcAbIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal v5_AdcAbClkIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal AdcCdMmcmRst_s                     : std_logic;
  signal v5_AdcCdIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal v5_AdcCdClkIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal AdcEfMmcmRst_s                     : std_logic;
  signal v5_AdcEfIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal v5_AdcEfClkIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal AdcGhMmcmRst_s                     : std_logic;
  signal v5_AdcGhIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal v5_AdcGhClkIdelayValue_s                     : std_logic_vector(4 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(21 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(21 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Begin architecture
-------------------------------------------------------------------------------

-- swap bits
WrCeBitSwap: for i in 0 to slv_reg_write_sel'high generate
  slv_reg_write_sel(i) <= Bus2IP_WrCE(slv_reg_write_sel'high - i);
end generate WrCeBitSwap;

RdCeBitSwap: for i in 0 to slv_reg_read_sel'high generate
  slv_reg_read_sel(i)  <= Bus2IP_RdCE(slv_reg_read_sel'high - i);
end generate RdCeBitSwap;

-- generate write/read ack
  slv_write_ack <=   Bus2IP_WrCE(0) or   Bus2IP_WrCE(1) or   Bus2IP_WrCE(2) or   Bus2IP_WrCE(3) or   Bus2IP_WrCE(4) or   Bus2IP_WrCE(5) or   Bus2IP_WrCE(6) or   Bus2IP_WrCE(7) or   Bus2IP_WrCE(8) or   Bus2IP_WrCE(9) or   Bus2IP_WrCE(10) or   Bus2IP_WrCE(11) or   Bus2IP_WrCE(12) or   Bus2IP_WrCE(13) or   Bus2IP_WrCE(14) or   Bus2IP_WrCE(15) or   Bus2IP_WrCE(16) or   Bus2IP_WrCE(17) or   Bus2IP_WrCE(18) or   Bus2IP_WrCE(19) or   Bus2IP_WrCE(20) or   Bus2IP_WrCE(21);
  slv_read_ack  <=   Bus2IP_RdCE(0) or   Bus2IP_RdCE(1) or   Bus2IP_RdCE(2) or   Bus2IP_RdCE(3) or   Bus2IP_RdCE(4) or   Bus2IP_RdCE(5) or   Bus2IP_RdCE(6) or   Bus2IP_RdCE(7) or   Bus2IP_RdCE(8) or   Bus2IP_RdCE(9) or   Bus2IP_RdCE(10) or   Bus2IP_RdCE(11) or   Bus2IP_RdCE(12) or   Bus2IP_RdCE(13) or   Bus2IP_RdCE(14) or   Bus2IP_RdCE(15) or   Bus2IP_RdCE(16) or   Bus2IP_RdCE(17) or   Bus2IP_RdCE(18) or   Bus2IP_RdCE(19) or   Bus2IP_RdCE(20) or   Bus2IP_RdCE(21);

 -- implement slave model software accessible register(s)
 SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
 begin

  if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
    if Bus2IP_Resetn = '0' then
      CoreResetPulse_s <= '0';
      AdcSpiReset_s <= '0';
      SoftwareTrig_s <= '0';
      v2_TriggerMode_s <= "00";
      ChArmed_s <= '0';
      v2_TestMode_s <= "00";
      PllFunction_s <= '1';
      PllRefEn_s <= '0';
      VcoPwrEn_s <= '0';
      SpiReq2_s <= '0';
      AdcAbMmcmRst_s <= '0';
      v5_AdcAbIdelayValue_s <= "00000";
      v5_AdcAbClkIdelayValue_s <= "00000";
      AdcCdMmcmRst_s <= '0';
      v5_AdcCdIdelayValue_s <= "00000";
      v5_AdcCdClkIdelayValue_s <= "00000";
      AdcEfMmcmRst_s <= '0';
      v5_AdcEfIdelayValue_s <= "00000";
      v5_AdcEfClkIdelayValue_s <= "00000";
      AdcGhMmcmRst_s <= '0';
      v5_AdcGhIdelayValue_s <= "00000";
      v5_AdcGhClkIdelayValue_s <= "00000";

    else

  -- Synchronous reset
  if ( i_CoreReset_p = '1' ) then
    CoreResetPulse_s <= '0';
    AdcSpiReset_s <= '0';
    SoftwareTrig_s <= '0';
    v2_TriggerMode_s <= "00";
    ChArmed_s <= '0';
    v2_TestMode_s <= "00";
    PllFunction_s <= '1';
    PllRefEn_s <= '0';
    VcoPwrEn_s <= '0';
    SpiReq2_s <= '0';
    AdcAbMmcmRst_s <= '0';
    v5_AdcAbIdelayValue_s <= "00000";
    v5_AdcAbClkIdelayValue_s <= "00000";
    AdcCdMmcmRst_s <= '0';
    v5_AdcCdIdelayValue_s <= "00000";
    v5_AdcCdClkIdelayValue_s <= "00000";
    AdcEfMmcmRst_s <= '0';
    v5_AdcEfIdelayValue_s <= "00000";
    v5_AdcEfClkIdelayValue_s <= "00000";
    AdcGhMmcmRst_s <= '0';
    v5_AdcGhIdelayValue_s <= "00000";
    v5_AdcGhClkIdelayValue_s <= "00000";
  end if;

  CoreResetPulse_s <= '0';
      case slv_reg_write_sel is

        when OneHotVector(1,22) =>
          if (Bus2IP_BE(0) = '1') then
            CoreResetPulse_s <= Bus2IP_Data(0);
          end if;

        when OneHotVector(2,22) =>
          if (Bus2IP_BE(0) = '1') then
            AdcSpiReset_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(0) = '1') then
            SoftwareTrig_s <= Bus2IP_Data(2);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v2_TriggerMode_s <= Bus2IP_Data(4 downto 3);
          end if;
          if (Bus2IP_BE(0) = '1') then
            ChArmed_s <= Bus2IP_Data(5);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v2_TestMode_s <= Bus2IP_Data(7 downto 6);
          end if;

        when OneHotVector(3,22) =>
          if (Bus2IP_BE(0) = '1') then
            PllFunction_s <= Bus2IP_Data(1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            PllRefEn_s <= Bus2IP_Data(2);
          end if;
          if (Bus2IP_BE(0) = '1') then
            VcoPwrEn_s <= Bus2IP_Data(3);
          end if;

        when OneHotVector(4,22) =>
          if (Bus2IP_BE(1) = '1') then
            SpiReq2_s <= Bus2IP_Data(12);
          end if;


        when OneHotVector(14,22) =>
          if (Bus2IP_BE(1) = '1') then
            AdcAbMmcmRst_s <= Bus2IP_Data(10);
          end if;
          if (Bus2IP_BE(1) = '1') then
            v5_AdcAbIdelayValue_s <= Bus2IP_Data(15 downto 11);
          end if;
          if (Bus2IP_BE(2) = '1') then
            v5_AdcAbClkIdelayValue_s <= Bus2IP_Data(20 downto 16);
          end if;

        when OneHotVector(15,22) =>
          if (Bus2IP_BE(1) = '1') then
            AdcCdMmcmRst_s <= Bus2IP_Data(10);
          end if;
          if (Bus2IP_BE(1) = '1') then
            v5_AdcCdIdelayValue_s <= Bus2IP_Data(15 downto 11);
          end if;
          if (Bus2IP_BE(2) = '1') then
            v5_AdcCdClkIdelayValue_s <= Bus2IP_Data(20 downto 16);
          end if;

        when OneHotVector(16,22) =>
          if (Bus2IP_BE(1) = '1') then
            AdcEfMmcmRst_s <= Bus2IP_Data(10);
          end if;
          if (Bus2IP_BE(1) = '1') then
            v5_AdcEfIdelayValue_s <= Bus2IP_Data(15 downto 11);
          end if;
          if (Bus2IP_BE(2) = '1') then
            v5_AdcEfClkIdelayValue_s <= Bus2IP_Data(20 downto 16);
          end if;

        when OneHotVector(17,22) =>
          if (Bus2IP_BE(1) = '1') then
            AdcGhMmcmRst_s <= Bus2IP_Data(10);
          end if;
          if (Bus2IP_BE(1) = '1') then
            v5_AdcGhIdelayValue_s <= Bus2IP_Data(15 downto 11);
          end if;
          if (Bus2IP_BE(2) = '1') then
            v5_AdcGhClkIdelayValue_s <= Bus2IP_Data(20 downto 16);
          end if;
          
        when others =>
          null;
      end case;
    end if;
  end if;

 end process SLAVE_REG_WRITE_PROC;

 -- implement slave model software accessible register(s) read mux
SLAVE_REG_READ_PROC : process( slv_reg_read_sel, AdcSpiReset_s, i_TriggerToFpga_p, SoftwareTrig_s, v2_TriggerMode_s, ChArmed_s, v2_TestMode_s, i_PllStatus_p, PllFunction_s, PllRefEn_s, VcoPwrEn_s, i_SpiUpdaterBusy_p, i_SpiBusy_p, SpiReq2_s, i_SpiGnt2_p, i_SpiAck2_p, AdcAbMmcmRst_s, v5_AdcAbIdelayValue_s, v5_AdcAbClkIdelayValue_s, iv2_AdcAbPatternError_p, i_AdcAbMmcmLocked_p, AdcCdMmcmRst_s, v5_AdcCdIdelayValue_s, v5_AdcCdClkIdelayValue_s, iv2_AdcCdPatternError_p, i_AdcCdMmcmLocked_p, AdcEfMmcmRst_s, v5_AdcEfIdelayValue_s, v5_AdcEfClkIdelayValue_s, iv2_AdcEfPatternError_p, i_AdcEfMmcmLocked_p, AdcGhMmcmRst_s, v5_AdcGhIdelayValue_s, v5_AdcGhClkIdelayValue_s, iv2_AdcGhPatternError_p, i_AdcGhMmcmLocked_p, i_MonInterrupt_p, iv16_ExternClkFreq_p, iv16_ClkToFpgaFreq_p, iv16_AdcAbClkFreq_p, iv16_AdcCdClkFreq_p, iv16_AdcEfClkFreq_p, iv16_AdcGhClkFreq_p) is
 begin
   case slv_reg_read_sel is

        when OneHotVector(0,22) =>
          slv_ip2bus_data(31 downto 0) <= X"C2500201";

        when OneHotVector(1,22) =>
          slv_ip2bus_data(31 downto 1) <= "0000000000000000000000000000000";

        when OneHotVector(2,22) =>
          slv_ip2bus_data(0) <= AdcSpiReset_s;
          slv_ip2bus_data(1) <= i_TriggerToFpga_p;
          slv_ip2bus_data(2) <= SoftwareTrig_s;
          slv_ip2bus_data(31 downto 8) <= "000000000000000000000000";
          slv_ip2bus_data(4 downto 3) <= v2_TriggerMode_s;
          slv_ip2bus_data(5) <= ChArmed_s;
          slv_ip2bus_data(7 downto 6) <= v2_TestMode_s;

        when OneHotVector(3,22) =>
          slv_ip2bus_data(0) <= i_PllStatus_p;
          slv_ip2bus_data(1) <= PllFunction_s;
          slv_ip2bus_data(2) <= PllRefEn_s;
          slv_ip2bus_data(3) <= VcoPwrEn_s;
          slv_ip2bus_data(31 downto 4) <= "0000000000000000000000000000";

        when OneHotVector(4,22) =>
          slv_ip2bus_data(10) <= i_SpiUpdaterBusy_p;
          slv_ip2bus_data(11) <= i_SpiBusy_p;
          slv_ip2bus_data(12) <= SpiReq2_s;
          slv_ip2bus_data(13) <= i_SpiGnt2_p;
          slv_ip2bus_data(14) <= i_SpiAck2_p;
          slv_ip2bus_data(31 downto 15) <= "00000000000000000";
          slv_ip2bus_data(9 downto 0) <= "0000000000";

        when OneHotVector(5,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(6,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(7,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(8,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(9,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(10,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(11,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(12,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(13,22) =>
          slv_ip2bus_data(31 downto 0) <= iv32_Spi2PlbData_p;

        when OneHotVector(14,22) =>
          slv_ip2bus_data(10) <= AdcAbMmcmRst_s;
          slv_ip2bus_data(15 downto 11) <= v5_AdcAbIdelayValue_s;
          slv_ip2bus_data(20 downto 16) <= v5_AdcAbClkIdelayValue_s;
          slv_ip2bus_data(22 downto 21) <= iv2_AdcAbPatternError_p;
          slv_ip2bus_data(31 downto 23) <= "000000000";
          slv_ip2bus_data(8 downto 0) <= "000000000";
          slv_ip2bus_data(9) <= i_AdcAbMmcmLocked_p;

        when OneHotVector(15,22) =>
          slv_ip2bus_data(10) <= AdcCdMmcmRst_s;
          slv_ip2bus_data(15 downto 11) <= v5_AdcCdIdelayValue_s;
          slv_ip2bus_data(20 downto 16) <= v5_AdcCdClkIdelayValue_s;
          slv_ip2bus_data(22 downto 21) <= iv2_AdcCdPatternError_p;
          slv_ip2bus_data(31 downto 23) <= "000000000";
          slv_ip2bus_data(8 downto 0) <= "000000000";
          slv_ip2bus_data(9) <= i_AdcCdMmcmLocked_p;

        when OneHotVector(16,22) =>
          slv_ip2bus_data(10) <= AdcEfMmcmRst_s;
          slv_ip2bus_data(15 downto 11) <= v5_AdcEfIdelayValue_s;
          slv_ip2bus_data(20 downto 16) <= v5_AdcEfClkIdelayValue_s;
          slv_ip2bus_data(22 downto 21) <= iv2_AdcEfPatternError_p;
          slv_ip2bus_data(31 downto 23) <= "000000000";
          slv_ip2bus_data(8 downto 0) <= "000000000";
          slv_ip2bus_data(9) <= i_AdcEfMmcmLocked_p;

        when OneHotVector(17,22) =>
          slv_ip2bus_data(10) <= AdcGhMmcmRst_s;
          slv_ip2bus_data(15 downto 11) <= v5_AdcGhIdelayValue_s;
          slv_ip2bus_data(20 downto 16) <= v5_AdcGhClkIdelayValue_s;
          slv_ip2bus_data(22 downto 21) <= iv2_AdcGhPatternError_p;
          slv_ip2bus_data(31 downto 23) <= "000000000";
          slv_ip2bus_data(8 downto 0) <= "000000000";
          slv_ip2bus_data(9) <= i_AdcGhMmcmLocked_p;

        when OneHotVector(18,22) =>
          slv_ip2bus_data(0) <= i_MonInterrupt_p;
          slv_ip2bus_data(31 downto 1) <= "0000000000000000000000000000000";

        when OneHotVector(19,22) =>
          slv_ip2bus_data(15 downto 0) <= iv16_ExternClkFreq_p;
          slv_ip2bus_data(31 downto 16) <= iv16_ClkToFpgaFreq_p;

        when OneHotVector(20,22) =>
          slv_ip2bus_data(15 downto 0) <= iv16_AdcAbClkFreq_p;
          slv_ip2bus_data(31 downto 16) <= iv16_AdcCdClkFreq_p;

        when OneHotVector(21,22) =>
          slv_ip2bus_data(15 downto 0) <= iv16_AdcEfClkFreq_p;
          slv_ip2bus_data(31 downto 16) <= iv16_AdcGhClkFreq_p;
        when others =>
          slv_ip2bus_data <= (others => '0');
      end case;

 end process SLAVE_REG_READ_PROC;

------------------------------------------
-- drive IP to Bus signals
------------------------------------------
IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else (others => '0');
IP2Bus_WrAck <= slv_write_ack;
IP2Bus_RdAck <= slv_read_ack;
IP2Bus_Error <= '0';

------------------------------------------
-- Output assignments
------------------------------------------
o_CoreResetPulse_p <= CoreResetPulse_s;
o_AdcSpiReset_p <= AdcSpiReset_s;
o_SoftwareTrig_p <= SoftwareTrig_s;
ov2_TriggerMode_p <= v2_TriggerMode_s;
o_ChArmed_p <= ChArmed_s;
ov2_TestMode_p <= v2_TestMode_s;
o_PllFunction_p <= PllFunction_s;
o_PllRefEn_p <= PllRefEn_s;
o_VcoPwrEn_p <= VcoPwrEn_s;
o_SpiReq2_p <= SpiReq2_s;
o_AdcAbMmcmRst_p <= AdcAbMmcmRst_s;
ov5_AdcAbIdelayValue_p <= v5_AdcAbIdelayValue_s;
ov5_AdcAbClkIdelayValue_p <= v5_AdcAbClkIdelayValue_s;
o_AdcCdMmcmRst_p <= AdcCdMmcmRst_s;
ov5_AdcCdIdelayValue_p <= v5_AdcCdIdelayValue_s;
ov5_AdcCdClkIdelayValue_p <= v5_AdcCdClkIdelayValue_s;
o_AdcEfMmcmRst_p <= AdcEfMmcmRst_s;
ov5_AdcEfIdelayValue_p <= v5_AdcEfIdelayValue_s;
ov5_AdcEfClkIdelayValue_p <= v5_AdcEfClkIdelayValue_s;
o_AdcGhMmcmRst_p <= AdcGhMmcmRst_s;
ov5_AdcGhIdelayValue_p <= v5_AdcGhIdelayValue_s;
ov5_AdcGhClkIdelayValue_p <= v5_AdcGhClkIdelayValue_s;

-- BELOW REQUIRED FOR SPI INTERFACE
ov32_Plb2SpiData_p   <= Bus2IP_Data;
ov9_PlbRegWriteSel_p <= slv_reg_write_sel(13 downto 5);
ov9_PlbRegReadSel_p  <= slv_reg_read_sel(13 downto 5);
-- ABOVE REQUIRED FOR SPI INTERFACE

end architecture IMP;

