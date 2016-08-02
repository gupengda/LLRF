--------------------------------------------------------------------------------
--
--          **  **     **  ******  ********  ********  ********  **    **
--         **    **  **   **   ** ********  ********  ********  **    **
--        **      ***    **   **    **     **        **        **    **
--       **       **    ******     **     ****      **        ********
--      **       **    **  **     **     **        **        **    **
--     *******  **    **   **    **     ********  ********  **    **
--    *******  **    **    **   **     ********  ********  **    **
--
--                       L Y R T E C H   R D   I N C
--
--------------------------------------------------------------------------------
-- File        : $Id: xauiloopbacktest_beh_a.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2005 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: xauiloopbacktest_beh_a.vhd,v $
-- Revision 1.1  2013/03/20 19:59:52  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.4  2011/02/09 20:41:04  jeffrey.johnson
-- External reset changed to active low.
-- Added all clocks from FMC and MMCMs to test them.
--
-- Revision 1.3  2010/12/29 21:05:50  jeffrey.johnson
-- FIFO reset is now released after PLL locked.
--
-- Revision 1.2  2010/12/06 18:03:41  jeffrey.johnson
-- Added control of MGT loopback per XAUI
--
-- Revision 1.1  2010/12/01 15:44:42  jeffrey.johnson
-- First commit
--
--------------------------------------------------------------------------------


library IEEE;
  use ieee.numeric_std.all;

library UNISIM;
  use UNISIM.vcomponents.all;



architecture Beh of XauiLoopBackTest is

  -- Architecture's local constants, types, signals functions.

  constant PacketCounterSize_c        : integer := 16; -- .

  signal MgtRefClk_s                : std_logic;
  signal SystemRst_s                : std_logic;
  signal XauiReadyA_s               : std_logic;
  signal XauiReadyB_s               : std_logic;

  signal Reset_s                    : std_logic;

  signal MgtLoopBack_s              : std_logic; -- .

  signal v64_GeneratedData_s        : std_logic_vector(63 downto 0); -- .
  signal v8_DataValid_s             : std_logic_vector(7 downto 0); -- .

  signal v_cntRxValidPacketA_s       : std_logic_vector(PacketCounterSize_c - 1 downto 0); -- .
  signal v_cntRxValidPacketB_s       : std_logic_vector(PacketCounterSize_c - 1 downto 0); -- .
  signal v_cntRxCorruptPacketA_s     : std_logic_vector(PacketCounterSize_c - 1 downto 0); -- .
  signal v_cntRxCorruptPacketB_s     : std_logic_vector(PacketCounterSize_c - 1 downto 0); -- .

  signal ReadTxDataA_s               : std_logic; -- .
  signal ReadTxDataB_s               : std_logic; -- .
  signal TxFifoFullA_s               : std_logic; -- .
  signal TxFifoFullB_s               : std_logic; -- .
  signal TxFifoOverRun_s            : std_logic; -- .
  signal TxFifoWrEn_s               : std_logic; -- .
  signal RxFifoOverRunA_s            : std_logic; -- .
  signal RxFifoOverRunB_s            : std_logic; -- .
  signal v64_RawDataA_s              : std_logic_vector(63 downto 0); -- .
  signal v64_RawDataB_s              : std_logic_vector(63 downto 0); -- .
  signal v8_RawDataValidA_s          : std_logic_vector(7 downto 0); -- .
  signal v8_RawDataValidB_s          : std_logic_vector(7 downto 0); -- .
  signal RawEndOfPacketA_s           : std_logic; -- .
  signal RawEndOfPacketB_s           : std_logic; -- .

  signal v73_TxDataGen_s             : std_logic_vector(72 downto 0); -- .
  signal v73_TxDataA_s               : std_logic_vector(72 downto 0); -- .
  signal v73_TxDataB_s               : std_logic_vector(72 downto 0); -- .

  signal v73_RxDataA_s               : std_logic_vector(72 downto 0); -- .
  signal v73_RxDataB_s               : std_logic_vector(72 downto 0); -- .
  signal v73_RxDataFifoA_s           : std_logic_vector(72 downto 0); -- .
  signal v73_RxDataFifoB_s           : std_logic_vector(72 downto 0); -- .
  signal v64_RxRawDataA_s            : std_logic_vector(63 downto 0); -- .
  signal v64_RxRawDataB_s            : std_logic_vector(63 downto 0); -- .
  signal RxRawEndOfPacketA_s         : std_logic; -- .
  signal RxRawEndOfPacketB_s         : std_logic; -- .

  signal v64_RxRawDataFifoA_s        : std_logic_vector(63 downto 0); -- .
  signal v64_RxRawDataFifoB_s        : std_logic_vector(63 downto 0); -- .
  signal RxRawDataEndOfPacketFifoA_s : std_logic; -- .
  signal RxRawDataEndOfPacketFifoB_s : std_logic; -- .

  signal v8_RxRawByteValidA_s        : std_logic_vector(7 downto 0); -- .
  signal v8_RxRawByteValidB_s        : std_logic_vector(7 downto 0); -- .
  signal v8_RxRawDataValidFifoA_s    : std_logic_vector(7 downto 0); -- .
  signal v8_RxRawDataValidFifoB_s    : std_logic_vector(7 downto 0); -- .
  signal ReadRxDataA_s               : std_logic; -- .
  signal ReadRxDataB_s               : std_logic; -- .
  signal WriteRxDataA_s              : std_logic; -- .
  signal WriteRxDataB_s              : std_logic; -- .
  signal RxFifoFullA_s               : std_logic; -- .
  signal RxFifoFullB_s               : std_logic; -- .
  signal RxFifoEmptyA_s              : std_logic; -- .
  signal RxFifoEmptyB_s              : std_logic; -- .
  signal clkUser_s                  : std_logic; -- .
  signal TxFifoEmptyA_s              : std_logic; -- .
  signal TxFifoEmptyB_s              : std_logic; -- .


  signal EndOfPacketGen_s            : std_logic; -- .


  component fifo1k_w73_sync_fwft
  port (
    clk: IN std_logic;
    srst: IN std_logic;
    din: IN std_logic_VECTOR(72 downto 0);
    wr_en: IN std_logic;
    rd_en: IN std_logic;
    dout: OUT std_logic_VECTOR(72 downto 0);
    full: OUT std_logic;
    empty: OUT std_logic);
  end component;



begin

--  Reset_s <= not i_Reset_p; -- rev A
  Reset_s <= i_Reset_p; -- rev B

  -- Reset for the packet checker
  SystemRst_s <= Reset_s or (not XauiReadyA_s) or (not XauiReadyB_s);

  -- Clock buffer
  MgtRefClk_IBUFDS_GTXE1 : IBUFDS_GTXE1
  port map
  (
    I                           => i_MgtRefClkP_p,
    IB                          => i_MgtRefClkN_p,
    CEB                         => '0',
    O                           => MgtRefClk_s,
    ODIV2                       => open
  );


  PacketGen_l : entity work.PacketGen
  port map(
    i_Reset_p                   => SystemRst_s,
    i_clk_p                     => clkUser_s,

    i_GenerateEnable_p          => i_EnPktGen_p,
    i_ShiftedByteRampEn_p       => '0',

    iv_PacketSize_p             => iv20_PacketSize_p,
    iv_DutyCycleOffTime_p       => x"0020",

    iv64_SeedCode_p             => (others => '0'),

    i_FifoFull_p                => TxFifoFullA_s,
    o_FifoOverRun_p             => TxFifoOverRun_s,

    ov_cntSentPacket_p          => open,
    ov_cntStalledPacket_p       => open,

    o_FifoWrEn_p                => TxFifoWrEn_s,
    ov64_DataOut_p              => v64_GeneratedData_s,
    ov8_ByteValid_p             => v8_DataValid_s,
    o_EndOfPacket_p             => EndOfPacketGen_s
  );

  v73_TxDataGen_s <= EndOfPacketGen_s & v8_DataValid_s & v64_GeneratedData_s;

  TxFifoA_generator_v6_1_l : fifo1k_w73_sync_fwft
  port map (
    clk                         => clkUser_s,
    srst                        => SystemRst_s,
    din                         => v73_TxDataGen_s,
    wr_en                       => TxFifoWrEn_s,
    rd_en                       => ReadTxDataA_s,
    dout                        => v73_TxDataA_s,
    full                        => TxFifoFullA_s,
    empty                       => TxFifoEmptyA_s
  );


  RawEndOfPacketA_s <= v73_TxDataA_s(72);
  v8_RawDataValidA_s <= v73_TxDataA_s(71 downto 64);
  v64_RawDataA_s <= v73_TxDataA_s(63 downto 0);

  RawDataOverXauiA_l : entity work.RawDataOverXaui
  port map(
    i_Reset_p                   => Reset_s,
    i_clkMgtRef_p               => MgtRefClk_s,

    o_clkMgtOutClk_p            => clkUser_s,

    i_clkUser_p                 => clkUser_s,
    o_PllLocked_p               => o_PllLocked_p,
    o_XauiReady_p               => XauiReadyA_s,

    -- Tx user interface.
    o_ReadTxData_p              => ReadTxDataA_s,

    i_TxFifoEmpty_p             => TxFifoEmptyA_s,
    o_TxFifoUnderRun_p          => open,

    iv64_TxRawData_p            => v64_RawDataA_s,
    iv8_TxByteEnable_p          => v8_RawDataValidA_s,
    i_TxEndOfPacket_p           => RawEndOfPacketA_s,

    i_Loopback_p                => i_LoopbackA_p,

    -- Rx user interface.
    o_WriteRxData_p             => WriteRxDataA_s,

    i_RxFifoFull_p              => RxFifoFullA_s,
    o_RxFifoOverRun_p           => open,

    ov64_RxRawData_p            => v64_RxRawDataA_s,
    ov8_RxByteValid_p           => v8_RxRawByteValidA_s,
    o_RxEndOfPacket_p           => RxRawEndOfPacketA_s,

    -- Gtx back-end.
    iv4_GtxRxInP_p              => iv4_GtxRxInAP_p,
    iv4_GtxRxInN_p              => iv4_GtxRxInAN_p,

    ov4_GtxTxOutP_p             => ov4_GtxTxOutAP_p,
    ov4_GtxTxOutN_p             => ov4_GtxTxOutAN_p
  );

  v73_RxDataA_s <= RxRawEndOfPacketA_s & v8_RxRawByteValidA_s & v64_RxRawDataA_s;


  -- FWFT.
  RxFifoA_generator_v6_1_l : fifo1k_w73_sync_fwft
  port map (
    clk                         => clkUser_s,
    srst                        => SystemRst_s,
    din                         => v73_RxDataA_s,
    wr_en                       => WriteRxDataA_s,
    rd_en                       => ReadRxDataA_s,
    dout                        => v73_RxDataFifoA_s,
    full                        => RxFifoFullA_s,
    empty                       => RxFifoEmptyA_s
  );

  RxRawDataEndOfPacketFifoA_s <= v73_RxDataFifoA_s(72);
  v8_RxRawDataValidFifoA_s <= v73_RxDataFifoA_s(71 downto 64);
  v64_RxRawDataFifoA_s <= v73_RxDataFifoA_s(63 downto 0);


  PacketCheckerA_l : entity work.PacketChecker
  generic map
  (
    PacketCounterSize_g         => PacketCounterSize_c
  )
  port map(
    i_Reset_p                   => SystemRst_s,
    i_clk_p                     => clkUser_s,

    i_ResetErrCnt_p             => i_ResetErrCnt_p,
    i_FifoEmpty_p               => RxFifoEmptyA_s,

    iv64_DataIn_p               => v64_RxRawDataFifoA_s,
    iv8_ByteValid_p             => v8_RxRawDataValidFifoA_s,
    i_EndOfPacket_p             => RxRawDataEndOfPacketFifoA_s,

    o_ReadData_p                => ReadRxDataA_s,

    ov_cntRxValidPacket_p       => v_cntRxValidPacketA_s,
    ov_cntRxCorruptPacket_p     => v_cntRxCorruptPacketA_s
  );
  ov_cntRxValidPacketA_p <= v_cntRxValidPacketA_s;
  ov_cntRxCorruptPacketA_p <= v_cntRxCorruptPacketA_s;



  TxFifoB_generator_v6_1_l : fifo1k_w73_sync_fwft
  port map (
    clk                         => clkUser_s,
    srst                        => SystemRst_s,
    din                         => v73_TxDataGen_s,
    wr_en                       => TxFifoWrEn_s,
    rd_en                       => ReadTxDataB_s,
    dout                        => v73_TxDataB_s,
    full                        => TxFifoFullB_s,
    empty                       => TxFifoEmptyB_s
  );

  RawEndOfPacketB_s <= v73_TxDataB_s(72);
  v8_RawDataValidB_s <= v73_TxDataB_s(71 downto 64);
  v64_RawDataB_s <= v73_TxDataB_s(63 downto 0);

  RawDataOverXauiB_l : entity work.RawDataOverXaui
  port map(
    i_Reset_p                   => Reset_s,
    i_clkMgtRef_p               => MgtRefClk_s,

    o_clkMgtOutClk_p            => open,

    i_clkUser_p                 => clkUser_s,
    o_PllLocked_p               => open,
    o_XauiReady_p               => XauiReadyB_s,

    -- Tx user interface.
    o_ReadTxData_p              => ReadTxDataB_s,

    i_TxFifoEmpty_p             => TxFifoEmptyB_s,
    o_TxFifoUnderRun_p          => open,

    iv64_TxRawData_p            => v64_RawDataB_s,
    iv8_TxByteEnable_p          => v8_RawDataValidB_s,
    i_TxEndOfPacket_p           => RawEndOfPacketB_s,

    i_Loopback_p                => i_LoopbackB_p,

    -- Rx user interface.
    o_WriteRxData_p             => WriteRxDataB_s,

    i_RxFifoFull_p              => RxFifoFullB_s,
    o_RxFifoOverRun_p           => open,

    ov64_RxRawData_p            => v64_RxRawDataB_s,
    ov8_RxByteValid_p           => v8_RxRawByteValidB_s,
    o_RxEndOfPacket_p           => RxRawEndOfPacketB_s,

    -- Gtx back-end.
    iv4_GtxRxInP_p              => iv4_GtxRxInBP_p,
    iv4_GtxRxInN_p              => iv4_GtxRxInBN_p,

    ov4_GtxTxOutP_p             => ov4_GtxTxOutBP_p,
    ov4_GtxTxOutN_p             => ov4_GtxTxOutBN_p
  );

  v73_RxDataB_s <= RxRawEndOfPacketB_s & v8_RxRawByteValidB_s & v64_RxRawDataB_s;


  -- FWFT.
  RxFifoB_generator_v6_1_l : fifo1k_w73_sync_fwft
  port map (
    clk                         => clkUser_s,
    srst                        => SystemRst_s,
    din                         => v73_RxDataB_s,
    wr_en                       => WriteRxDataB_s,
    rd_en                       => ReadRxDataB_s,
    dout                        => v73_RxDataFifoB_s,
    full                        => RxFifoFullB_s,
    empty                       => RxFifoEmptyB_s
  );

  RxRawDataEndOfPacketFifoB_s <= v73_RxDataFifoB_s(72);
  v8_RxRawDataValidFifoB_s <= v73_RxDataFifoB_s(71 downto 64);
  v64_RxRawDataFifoB_s <= v73_RxDataFifoB_s(63 downto 0);


  PacketCheckerB_l : entity work.PacketChecker
  generic map
  (
    PacketCounterSize_g         => PacketCounterSize_c
  )
  port map(
    i_Reset_p                   => SystemRst_s,
    i_clk_p                     => clkUser_s,

    i_ResetErrCnt_p             => i_ResetErrCnt_p,
    i_FifoEmpty_p               => RxFifoEmptyB_s,

    iv64_DataIn_p               => v64_RxRawDataFifoB_s,
    iv8_ByteValid_p             => v8_RxRawDataValidFifoB_s,
    i_EndOfPacket_p             => RxRawDataEndOfPacketFifoB_s,

    o_ReadData_p                => ReadRxDataB_s,

    ov_cntRxValidPacket_p       => v_cntRxValidPacketB_s,
    ov_cntRxCorruptPacket_p     => v_cntRxCorruptPacketB_s
  );
  
  ov_cntRxValidPacketB_p <= v_cntRxValidPacketB_s;
  ov_cntRxCorruptPacketB_p <= v_cntRxCorruptPacketB_s;

end architecture Beh;

