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
-- File        : $Id: rawdata2xgmii_e.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: rawdata2xgmii_e.vhd,v $
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
entity RawData2Xgmii is
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
end entity RawData2Xgmii;
--------------------------------------------------------------------------------
