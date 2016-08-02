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
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: 
--------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;


package RTDEx_RxTxp is

component EmacRtdexRx
generic
(
  NbChannel_g : integer := 1;
  bReverseEndiannessRx_g : boolean := false
);
port
(
   -- User fifo Interface
   i_UserClk_p        : in std_logic; -- Rd Fifo Clock

   iv8_RxUsrReset_p        : in std_logic_vector(7 downto 0);
   iv8_RxRe_p              : in std_logic_vector(7 downto 0);
   ov8_RxReady_p           : out std_logic_vector(7 downto 0);
   ov8_RxDataValid_p       : out std_logic_vector(7 downto 0);
   ov8_RxLastData_p        : out std_logic_vector(7 downto 0);

   ov32_RxDataCh0_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh0_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh1_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh1_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh2_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh2_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh3_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh3_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh4_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh4_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh5_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh5_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh6_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh6_p   : out std_logic_vector(12 downto 0);

   ov32_RxDataCh7_p        : out std_logic_vector(31 downto 0);
   ov13_RxFifoCountCh7_p   : out std_logic_vector(12 downto 0);

   -- Config Interface
   iv8_StartNewTransfer_p   : in std_logic_vector(7 downto 0);

   iv15_FrameSizeCh0_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh0_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh1_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh1_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh2_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh2_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh3_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh3_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh4_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh4_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh5_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh5_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh6_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh6_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh7_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh7_p   : in std_logic_vector(31 downto 0);


   ov32_BadFrameCnt_p        : out std_logic_vector(31 downto 0);

   iv8_ProtIdCh0_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh1_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh2_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh3_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh4_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh5_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh6_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh7_p          : in std_logic_vector(7 downto 0);


   iv48_SourceMacAddr_p    : in std_logic_vector(47 downto 0);

   ov32_FrameLostCntCh0_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh1_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh2_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh3_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh4_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh5_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh6_p    : out std_logic_vector(31 downto 0);
   ov32_FrameLostCntCh7_p    : out std_logic_vector(31 downto 0);


   i_RxReset_p             : in std_logic;

   -- Emac Receiver Interface
   i_EmacReset_p                 : in std_logic;
   iv8_EmacClientRxd_p           : in std_logic_vector(7 downto 0);
   i_ClientEmacRxDvld_p          : in std_logic;
   i_EmacClientRxFrameDrop_p     : in std_logic;
   i_EmacClientRxGoodFrame_p     : in std_logic;
   i_EmacClientRxBadFrame_p      : in std_logic;
   o_ClientEmacPauseReq_p        : out std_logic;

   i_ClientEmacRxClientClkin_p   : in std_logic;  -- Wr Fifo Clock
   i_EmacClientRxClientClkout_p  : in std_logic  -- Wr Fifo Clock Enable for 10/100 support
);
end component EmacRtdexRx;

component EmacRtdexTx 
generic
(
  NbChannel_g : integer := 1;
  bReverseEndiannessTx_g : boolean := false
);
port
(
   -- User Interface
   i_UserClk_p           : in std_logic; -- write fifo clk
   iv8_TxUsrReset_p      : in std_logic_vector(7 downto 0);

   iv8_TxWe_p            : in std_logic_vector(7 downto 0);
   ov8_TxReady_p         : out std_logic_vector(7 downto 0);

   iv32_TxDataCh0_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh0_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh1_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh1_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh2_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh2_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh3_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh3_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh4_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh4_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh5_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh5_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh6_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh6_p  : out std_logic_vector(12 downto 0);

   iv32_TxDataCh7_p       : in std_logic_vector(31 downto 0);
   ov13_TxFifoCountCh7_p  : out std_logic_vector(12 downto 0);

   -- Config Interface
   iv8_StartNewTransfer_p  : in std_logic_vector(7 downto 0);
   iv8_FlushFifo_p         : in std_logic_vector(7 downto 0);
   ov8_TxFifoEmpty_p       : out std_logic_vector(7 downto 0);

   iv15_FrameSizeCh0_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh0_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh1_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh1_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh2_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh2_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh3_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh3_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh4_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh4_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh5_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh5_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh6_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh6_p   : in std_logic_vector(31 downto 0);

   iv15_FrameSizeCh7_p      : in std_logic_vector(14 downto 0);
   iv32_TransferSizeCh7_p   : in std_logic_vector(31 downto 0);

   iv8_ProtIdCh0_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh1_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh2_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh3_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh4_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh5_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh6_p          : in std_logic_vector(7 downto 0);
   iv8_ProtIdCh7_p          : in std_logic_vector(7 downto 0);


   iv48_DestMacAddr_p      : in std_logic_vector(47 downto 0);
   iv48_SourceMacAddr_p    : in std_logic_vector(47 downto 0);

   i_TxReset_p             : in std_logic;

   ov32_TxNbDataInfoCh0_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh1_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh2_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh3_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh4_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh5_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh6_p  : out std_logic_vector(31 downto 0);
   ov32_TxNbDataInfoCh7_p  : out std_logic_vector(31 downto 0);

   iv32_FrameGap_p         : in std_logic_vector(31 downto 0);

   -- Emac Receiver Interface
   i_EmacReset_p                 : in std_logic;
   ov8_ClientEmacTxd_p           : out std_logic_vector(7 downto 0);
   o_ClientEmacTxDvld_p          : out std_logic;
   o_ClientEmacTxUnderrun_p      : out std_logic;
   i_ClientEmacTxClientClkin_p   : in std_logic; -- read fifo clk.

   i_EmacClientTxAck_p           : in std_logic
);
end component EmacRtdexTx;


end RTDEx_RxTxp;