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
-- File        : $Id: dds_adac250_p.vhd,v 1.2 2010/07/26 18:08:48 patrick.gilbert Exp $
--------------------------------------------------------------------------------
-- Description : ADAC250Wrapper
--
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2009 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: dds_adac250_p.vhd,v $
-- Revision 1.2  2010/07/26 18:08:48  patrick.gilbert
-- work with 31 bit data port
--
-- Revision 1.1  2010/06/17 15:40:21  francois.blackburn
-- first commit
--

--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package dds_adac250_p is

    component DDS_ADAC250 is
      port (
        --addr: IN std_logic_VECTOR(0 downto 0);
        ce: IN std_logic;
        clk: IN std_logic;
        sclr: IN std_logic;
        we: IN std_logic;
        data: IN std_logic_VECTOR(31 downto 0);
        --rdy: OUT std_logic;
        cosine: OUT std_logic_VECTOR(15 downto 0);
        sine: OUT std_logic_VECTOR(15 downto 0));
    end component DDS_ADAC250;



end dds_adac250_p;