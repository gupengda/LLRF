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
-- File        : $Id: packetchecker_e.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : This entity is used as a distributed multiplexer to avoid bottlenecks and ease PAR. It supports 8 class of service, and different data rate interface(HoldDataCopyUntilEndOfTx).
--   
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--  
--------------------------------------------------------------------------------
-- Copyright (c) 2005 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: packetchecker_e.vhd,v $
-- Revision 1.1  2013/03/20 19:59:52  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.1  2010/12/01 15:44:42  jeffrey.johnson
-- First commit
--
-- Revision 1.1  2010/05/12 15:33:00  claude.cote
-- no message
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
entity PacketChecker is
  generic
  (
    PacketCounterSize_g         : in integer
  );
  port (
    i_Reset_p                   : in std_logic;
    i_clk_p                     : in std_logic;

    i_ResetErrCnt_p             : in std_logic;
    i_FifoEmpty_p               : in std_logic;

    iv64_DataIn_p               : in std_logic_vector(63 downto 0);
    iv8_ByteValid_p             : in std_logic_vector(7 downto 0);
    i_EndOfPacket_p             : in std_logic;

    o_ReadData_p                : out std_logic;

    ov_cntRxValidPacket_p       : out std_logic_vector(PacketCounterSize_g - 1 downto 0);
    ov_cntRxCorruptPacket_p     : out std_logic_vector(PacketCounterSize_g - 1 downto 0)
  );
end entity PacketChecker;
--------------------------------------------------------------------------------
