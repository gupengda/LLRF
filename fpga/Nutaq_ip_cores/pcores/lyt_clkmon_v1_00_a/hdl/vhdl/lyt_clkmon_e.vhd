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
-- File        : $Id: clkmon_e.vhd,v
--------------------------------------------------------------------------------
-- Description : Clock monitoring entity.
--               This modules samples the monitored clock to detect transitions.
--
--------------------------------------------------------------------------------
-- Notes / Assumptions : Monitoring clock is 125MHz
--                       Monitored clocks range from 10MHz to 125MHz
--
--------------------------------------------------------------------------------
-- Copyright (c) 2006 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: lyt_clkmon_e.vhd,v $
-- Revision 1.1  2013/01/24 17:25:27  julien.roy
-- Add pcore clkmon
--
-- Revision 1.2  2010/06/18 14:19:43  francois.blackburn
-- change LYR for lyt
--
-- Revision 1.1  2009/08/24 15:35:06  francois.blackburn
-- first version
--
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity lyt_clkmon is
  port (
    -- Reference clock
    i_clkRef_p                 : in std_logic;
    -- Monitored clock
    i_clkIn_p                  : in std_logic;
    o_ClkInStop_p              : out std_logic
  );
end entity lyt_clkmon;

