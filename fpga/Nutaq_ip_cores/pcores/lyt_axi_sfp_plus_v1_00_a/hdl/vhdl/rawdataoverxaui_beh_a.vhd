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
-- File        : $Id: rawdataoverxaui_beh_a.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: rawdataoverxaui_beh_a.vhd,v $
-- Revision 1.1  2013/03/20 19:59:52  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.2  2011/02/09 20:41:04  jeffrey.johnson
-- External reset changed to active low.
-- Added all clocks from FMC and MMCMs to test them.
--
-- Revision 1.1  2010/12/01 15:44:42  jeffrey.johnson
-- First commit
--
--------------------------------------------------------------------------------


library IEEE;
use ieee.numeric_std.all;

library UNISIM;
  use UNISIM.vcomponents.all;



architecture Beh of RawDataOverXaui is

  -- Architecture's local constants, types, signals functions.

  signal v64_XgmiiTxD_s             : std_logic_vector(63 downto 0); -- .
  signal v8_XgmiiTxC_s              : std_logic_vector(7 downto 0); -- .
  signal v64_XgmiiRxD_s             : std_logic_vector(63 downto 0); -- .
  signal v8_XgmiiRxC_s              : std_logic_vector(7 downto 0); -- .

  signal align_status_s             : std_logic; -- .
  signal v4_sync_status_s           : std_logic_vector(3 downto 0); -- .
  signal v8_status_vector_s         : std_logic_vector(7 downto 0); -- .

  signal MgtPllLocked_s             : std_logic; -- .
  signal MgtTxReady_s               : std_logic; -- .

  signal TxOutClk_s                 : std_logic; -- .

  
  component RawData2Xgmii
  port (
    i_Reset_p                   : in std_logic;
    i_clk_p                     : in std_logic;

    o_ReadData_p                : out std_logic;
    i_FifoEmpty_p               : in std_logic;

    iv64_RawData_p              : in std_logic_vector(63 downto 0);
    iv8_ByteEnable_p            : in std_logic_vector(7 downto 0);
    i_EndOfPacket_p             : in std_logic;

    ov64_XgmiiTxD_p             : out std_logic_vector(63 downto 0);
    ov8_XgmiiTxC_p              : out std_logic_vector(7 downto 0)
  );
  end component RawData2Xgmii;


  component xaui_v10_2_block is
    generic (
      WRAPPER_SIM_GTXRESET_SPEEDUP : integer := 0
      );
    port (
      dclk             : in  std_logic;
      clk156           : in  std_logic;
      refclk           : in  std_logic;
      reset            : in  std_logic;
      reset156         : in  std_logic;
      txoutclk         : out std_logic;
      xgmii_txd        : in  std_logic_vector(63 downto 0);
      xgmii_txc        : in  std_logic_vector(7 downto 0);
      xgmii_rxd        : out std_logic_vector(63 downto 0);
      xgmii_rxc        : out std_logic_vector(7 downto 0);
      xaui_tx_l0_p     : out std_logic;
      xaui_tx_l0_n     : out std_logic;
      xaui_tx_l1_p     : out std_logic;
      xaui_tx_l1_n     : out std_logic;
      xaui_tx_l2_p     : out std_logic;
      xaui_tx_l2_n     : out std_logic;
      xaui_tx_l3_p     : out std_logic;
      xaui_tx_l3_n     : out std_logic;
      xaui_rx_l0_p     : in  std_logic;
      xaui_rx_l0_n     : in  std_logic;
      xaui_rx_l1_p     : in  std_logic;
      xaui_rx_l1_n     : in  std_logic;
      xaui_rx_l2_p     : in  std_logic;
      xaui_rx_l2_n     : in  std_logic;
      xaui_rx_l3_p     : in  std_logic;
      xaui_rx_l3_n     : in  std_logic;
      txlock           : out std_logic;
      signal_detect    : in  std_logic_vector(3 downto 0);
      align_status     : out std_logic;
      sync_status      : out std_logic_vector(3 downto 0);
      drp_addr         : in  std_logic_vector(7 downto 0);
      drp_en           : in  std_logic_vector(3 downto 0);
      drp_i            : in  std_logic_vector(15 downto 0);
      drp_o            : out std_logic_vector(63 downto 0);
      drp_rdy          : out std_logic_vector(3 downto 0);
      drp_we           : in  std_logic_vector(3 downto 0);
      mgt_tx_ready     : out std_logic;
      loopback         : in std_logic_vector(2 downto 0);
      configuration_vector : in  std_logic_vector(6 downto 0);
      status_vector        : out std_logic_vector(7 downto 0)
  );
  end component xaui_v10_2_block;


  component Xgmii2RawData is
  port (
    i_Reset_p                   : in std_logic;
    i_clk_p                     : in std_logic;

    iv64_XgmiiRxD_p             : in std_logic_vector(63 downto 0);
    iv8_XgmiiRxC_p              : in std_logic_vector(7 downto 0);

    i_FifoFull_p                : in std_logic;
    o_WriteData_p               : out std_logic;
    o_FifoOverRun_p             : out std_logic;

    ov64_RawData_p              : out std_logic_vector(63 downto 0);
    ov8_ByteValid_p             : out std_logic_vector(7 downto 0);
    o_EndOfPacket_p             : out std_logic
  );
  end component;


  attribute keep                                : string;
  attribute keep of v64_XgmiiRxD_s              : signal is "true";
  attribute keep of v8_XgmiiRxC_s               : signal is "true";
  attribute keep of align_status_s              : signal is "true";
  attribute keep of v4_sync_status_s            : signal is "true";
  attribute keep of v8_status_vector_s          : signal is "true";
  attribute keep of MgtPllLocked_s              : signal is "true";
  attribute keep of MgtTxReady_s                : signal is "true";

  -- Reset signals
  signal Reset156_R1_s       : std_logic;
  signal Reset156_R2_s       : std_logic;
  signal Reset156_s          : std_logic;
  
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of Reset156_R1_s    : signal is "TRUE";

begin

  RawData2Xgmii_l : RawData2Xgmii
  port map(
    i_Reset_p                   => i_Reset_p,
    i_clk_p                     => i_clkUser_p,

    o_ReadData_p                => o_ReadTxData_p,
    i_FifoEmpty_p               => i_TxFifoEmpty_p,

    iv64_RawData_p              => iv64_TxRawData_p,
    iv8_ByteEnable_p            => iv8_TxByteEnable_p,
    i_EndOfPacket_p             => i_TxEndOfPacket_p,

    ov64_XgmiiTxD_p             => v64_XgmiiTxD_s,
    ov8_XgmiiTxC_p              => v8_XgmiiTxC_s
  );


  -- Reset logic
  p_reset : process (i_clkUser_p, i_Reset_p)
  begin
    if i_Reset_p = '1' then
        Reset156_R1_s <= '1';
        Reset156_R2_s <= '1';
        Reset156_s    <= '1';
    elsif rising_edge(i_clkUser_p) then
        Reset156_R1_s <= not MgtPllLocked_s;
        Reset156_R2_s <= Reset156_R1_s;
        Reset156_s    <= Reset156_R2_s;
    end if;
  end process;

  xaui_v10_2_block_l : xaui_v10_2_block
  port map (
    dclk                        => '0',
    clk156                      => i_clkUser_p,
    refclk                      => i_clkMgtRef_p,
    reset                       => i_Reset_p,
    reset156                    => Reset156_s,
    txoutclk                    => TxOutClk_s,
    xgmii_txd                   => v64_XgmiiTxD_s,
    xgmii_txc                   => v8_XgmiiTxC_s,
    xgmii_rxd                   => v64_XgmiiRxD_s,
    xgmii_rxc                   => v8_XgmiiRxC_s,
    xaui_tx_l0_p                => ov4_GtxTxOutP_p(0),
    xaui_tx_l0_n                => ov4_GtxTxOutN_p(0),
    xaui_tx_l1_p                => ov4_GtxTxOutP_p(1),
    xaui_tx_l1_n                => ov4_GtxTxOutN_p(1),
    xaui_tx_l2_p                => ov4_GtxTxOutP_p(2),
    xaui_tx_l2_n                => ov4_GtxTxOutN_p(2),
    xaui_tx_l3_p                => ov4_GtxTxOutP_p(3),
    xaui_tx_l3_n                => ov4_GtxTxOutN_p(3),
    xaui_rx_l0_p                => iv4_GtxRxInP_p(0),
    xaui_rx_l0_n                => iv4_GtxRxInN_p(0),
    xaui_rx_l1_p                => iv4_GtxRxInP_p(1),
    xaui_rx_l1_n                => iv4_GtxRxInN_p(1),
    xaui_rx_l2_p                => iv4_GtxRxInP_p(2),
    xaui_rx_l2_n                => iv4_GtxRxInN_p(2),
    xaui_rx_l3_p                => iv4_GtxRxInP_p(3),
    xaui_rx_l3_n                => iv4_GtxRxInN_p(3),
    txlock                      => MgtPllLocked_s,
    signal_detect               => "1111",
    align_status                => align_status_s,
    sync_status                 => v4_sync_status_s,
    drp_addr                    => (others => '0'),
    drp_en                      => (others => '0'),
    drp_i                       => (others => '0'),
    drp_o                       => open,
    drp_rdy                     => open,
    drp_we                      => (others => '0'),
    mgt_tx_ready                => MgtTxReady_s,
    loopback                    => i_Loopback_p,
    configuration_vector        => (others => '0'),
    status_vector               => v8_status_vector_s
  );

  TxOutClkBufg_l : Bufg
  port map
  (
    I                           => TxOutClk_s,
    O                           => o_clkMgtOutClk_p
  );


  Xgmii2RawData_l : Xgmii2RawData
  port map(
    i_Reset_p                   => i_Reset_p,
    i_clk_p                     => i_clkUser_p,

    iv64_XgmiiRxD_p             => v64_XgmiiRxD_s,
    iv8_XgmiiRxC_p              => v8_XgmiiRxC_s,

    i_FifoFull_p                => i_RxFifoFull_p,
    o_WriteData_p               => o_WriteRxData_p,
    o_FifoOverRun_p             => o_RxFifoOverRun_p,

    ov64_RawData_p              => ov64_RxRawData_p,
    ov8_ByteValid_p             => ov8_RxByteValid_p,
    o_EndOfPacket_p             => o_RxEndOfPacket_p
  );

  
  
  -- Output mapping
  o_PllLocked_p <= MgtPllLocked_s;
  o_XauiReady_p <= MgtTxReady_s;
  
end architecture Beh;

