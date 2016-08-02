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
-- File        : $Id: mdioCtrl_e.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : This entity is an interface to the MDIO interface standard.
--   
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--  
--------------------------------------------------------------------------------
-- Copyright (c) 2005 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: mdioCtrl_e.vhd,v $
-- Revision 1.1  2013/03/20 19:59:52  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.1  2010/12/01 15:44:42  jeffrey.johnson
-- First commit
--
-- Revision 1.1  2010/06/02 15:49:46  david.quinn
-- *** empty log message ***
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use IEEE.Std_Logic_Arith.all;

--------------------------------------------------------------------------------
entity MdioInterface is
  generic (
    ClkDivider_g                : integer := 16
  );
  port (
    i_Reset_p                   : in std_logic;
    i_clk_p                     : in std_logic;

    i_ExtendedAdrsSpc_p         : in std_logic;

    i_TransactionRq_p           : in std_logic;

    iv2_TransactionType_p       : in std_logic_vector(1 downto 0);

    iv5_PortAddress_p           : in std_logic_vector(4 downto 0);
    iv5_DevAddress_p            : in std_logic_vector(4 downto 0);
    iv16_Data2Send_p            : in std_logic_vector(15 downto 0);

    o_MDC_p                     : out std_logic;
    o_TransactionRqD0_p           : out std_logic;
    o_TransactionDone_p         : out std_logic;
    o_Busy_p                    : out std_logic;

    ov16_ReceivedData_p         : out std_logic_vector(15 downto 0);

    i_MDIO_p                    : in std_logic;
    o_MDIO_p                    : out std_logic;
    o_MDIODisable_p             : out std_logic
  );
end entity MdioInterface;
--------------------------------------------------------------------------------
