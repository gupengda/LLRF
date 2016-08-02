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
-- File        : $Id: xauiloopbacktest_e.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: xauiloopbacktest_e.vhd,v $
-- Revision 1.1  2013/03/20 19:59:52  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.3  2011/02/09 20:41:04  jeffrey.johnson
-- External reset changed to active low.
-- Added all clocks from FMC and MMCMs to test them.
--
-- Revision 1.2  2010/12/06 18:03:41  jeffrey.johnson
-- Added control of MGT loopback per XAUI
--
-- Revision 1.1  2010/12/01 15:44:42  jeffrey.johnson
-- First commit
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
entity XauiLoopBackTest is
  port (
    i_Reset_p                   : in std_logic;

    i_MgtRefClkP_p              : in std_logic;
    i_MgtRefClkN_p              : in std_logic;
    
    o_PllLocked_p               : out std_logic;
    
    i_LoopbackA_p               : in std_logic_vector(2 downto 0);
    i_LoopbackB_p               : in std_logic_vector(2 downto 0);
    i_ResetErrCnt_p             : in std_logic;
    i_EnPktGen_p                : in std_logic;
    iv20_PacketSize_p           : in std_logic_vector(19 downto 0);

    iv4_GtxRxInAP_p             : in std_logic_vector(3 downto 0);
    iv4_GtxRxInAN_p             : in std_logic_vector(3 downto 0);

    ov4_GtxTxOutAP_p            : out std_logic_vector(3 downto 0);
    ov4_GtxTxOutAN_p            : out std_logic_vector(3 downto 0);

    iv4_GtxRxInBP_p             : in std_logic_vector(3 downto 0);
    iv4_GtxRxInBN_p             : in std_logic_vector(3 downto 0);

    ov4_GtxTxOutBP_p            : out std_logic_vector(3 downto 0);
    ov4_GtxTxOutBN_p            : out std_logic_vector(3 downto 0);

    ov_cntRxValidPacketA_p      : out std_logic_vector(15 downto 0);
    ov_cntRxCorruptPacketA_p    : out std_logic_vector(15 downto 0);

    ov_cntRxValidPacketB_p      : out std_logic_vector(15 downto 0);
    ov_cntRxCorruptPacketB_p    : out std_logic_vector(15 downto 0)
  );
end entity XauiLoopBackTest;
--------------------------------------------------------------------------------
