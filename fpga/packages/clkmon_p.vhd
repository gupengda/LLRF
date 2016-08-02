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
-- File        : $Id: LYR_clkmon_p.vhd,v
--------------------------------------------------------------------------------
-- Description : Clock monitoring package.
--
--
--------------------------------------------------------------------------------
-- Notes / Assumptions : Monitoring clock is 125MHz
--                       Monitored clocks range from 10MHz to 125MHz
--
--------------------------------------------------------------------------------
-- Copyright (c) 2006 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: clkmon_p.vhd,v $
-- Revision 1.1  2009/11/03 14:56:07  francois.blackburn
-- file move
--
-- Revision 1.1  2009/10/20 19:01:44  francois.blackburn
-- first working version
--
-- Revision 1.1  2009/08/24 15:35:06  francois.blackburn
-- first version
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

package clkmon_p is
  component clkmon
    port (
      -- Reference clock
      i_clkRef_p                 : in std_logic;
      -- Monitored clock
      i_clkIn_p                  : in std_logic;
      o_ClkInStop_p              : out std_logic
    );
  end component clkmon;
end clkmon_p;
