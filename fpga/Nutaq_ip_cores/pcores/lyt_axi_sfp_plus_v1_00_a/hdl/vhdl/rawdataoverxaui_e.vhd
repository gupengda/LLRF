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
-- File        : $Id: rawdataoverxaui_e.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: rawdataoverxaui_e.vhd,v $
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

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
entity RawDataOverXaui is
  port (
    i_Reset_p                   : in std_logic;
    i_clkMgtRef_p               : in std_logic;
    o_clkMgtOutClk_p            : out std_logic;
    i_clkUser_p                 : in std_logic;
    o_PllLocked_p               : out std_logic;
    o_XauiReady_p               : out std_logic;

    -- Tx user interface.
    o_ReadTxData_p              : out std_logic;

    i_TxFifoEmpty_p             : in std_logic;
    o_TxFifoUnderRun_p          : out std_logic;

    iv64_TxRawData_p            : in std_logic_vector(63 downto 0);
    iv8_TxByteEnable_p          : in std_logic_vector(7 downto 0);
    i_TxEndOfPacket_p           : in std_logic;

    i_Loopback_p                : in std_logic_vector(2 downto 0);

    -- Rx user interface.
    o_WriteRxData_p             : out std_logic;

    i_RxFifoFull_p              : in std_logic;
    o_RxFifoOverRun_p           : out std_logic;

    ov64_RxRawData_p            : out std_logic_vector(63 downto 0);
    ov8_RxByteValid_p           : out std_logic_vector(7 downto 0);
    o_RxEndOfPacket_p           : out std_logic;

    -- Gtx back-end.
    iv4_GtxRxInP_p              : in std_logic_vector(3 downto 0);
    iv4_GtxRxInN_p              : in std_logic_vector(3 downto 0);

    ov4_GtxTxOutP_p             : out std_logic_vector(3 downto 0);
    ov4_GtxTxOutN_p             : out std_logic_vector(3 downto 0)
  );
end entity RawDataOverXaui;
--------------------------------------------------------------------------------
