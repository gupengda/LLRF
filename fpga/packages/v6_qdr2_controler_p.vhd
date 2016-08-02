-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  / Vendor  : Xilinx
-- \   \   \/ Version  : 1.6
--  \   \ Application  : MIG
--  /   /    Filename  : v6_qdr2_controler.vhd
-- /___/   /\ Date Last Modified:  Wed Feb 15 2006
-- \   \  /  \Date Created      :  Mon May  2 2005
--  \___\/\___\
--
-- Device: Virtex-4
-- Design Name: QDRII_V4
-- Brief functional description of the module:
--    Top level design incorporating QDRII Memory Controller module.
-------------------------------------------------------------------------------

--***********************************************
--* Library declaration
--***********************************************
library ieee;
use ieee.std_logic_1164.all;

package v6_qdr2_controler_p is

  component v6_qdr2_controler is
     port (
           SYSCLK           : IN STD_LOGIC;   ----User-side Inputs
           SYSCLK_DIV4      : IN STD_LOGIC;
           CLK_200          : IN STD_LOGIC;
           USER_RESET       : IN STD_LOGIC;
           MASTER_RESET     : IN STD_LOGIC;
           B0_USER_W_n      : IN STD_LOGIC;
           B0_USER_AD_WR    : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
           B0_USER_BW_n     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           B0_USER_DW       : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
           B0_USER_R_n      : IN STD_LOGIC;
           B0_USER_AD_RD    : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
           B0_USER_QEN_n    : IN STD_LOGIC;

           B0_USER_CLK      : OUT STD_LOGIC; ----User-side Outputs
           B0_USER_WR_FULL  : OUT STD_LOGIC;
           B0_USER_RD_FULL  : OUT STD_LOGIC;
           B0_USER_QR       : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
           B0_USER_WR_EMPTY : OUT STD_LOGIC;
           B0_USER_QR_EMPTY : OUT STD_LOGIC;
           B0_USER_WR_ERR   : OUT STD_LOGIC;
           B0_USER_RD_ERR   : OUT STD_LOGIC;
           B0_USER_QR_ERR   : OUT STD_LOGIC;
           B0_DLY_CAL_DONE  : OUT STD_LOGIC;     ----------Indicates that the calibration of Input delay tap is done

           B0_QDR_C         : OUT STD_LOGIC;           ------Memory-side Outputs
           B0_QDR_C_n       : OUT STD_LOGIC;
           B0_QDR_K         : OUT STD_LOGIC;           ------Memory-side Outputs
           B0_QDR_K_n       : OUT STD_LOGIC;
           B0_QDR_SA        : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
           B0_QDR_BW_n      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
           B0_QDR_W_n       : OUT STD_LOGIC;
           B0_QDR_D         : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
           B0_QDR_R_n       : OUT STD_LOGIC;
           B0_DOFF_n        : OUT STD_LOGIC;

           B0_QDR_Q         : IN STD_LOGIC_VECTOR(17 DOWNTO 0);                                            ------Memory-side Inputs
           B0_QDR_CQ        : IN STD_LOGIC;

           B1_USER_W_n      : IN STD_LOGIC;
           B1_USER_AD_WR    : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
           B1_USER_BW_n     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           B1_USER_DW       : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
           B1_USER_R_n      : IN STD_LOGIC;
           B1_USER_AD_RD    : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
           B1_USER_QEN_n    : IN STD_LOGIC;

           B1_USER_CLK      : OUT STD_LOGIC; ----User-side Outputs
           B1_USER_WR_FULL  : OUT STD_LOGIC;
           B1_USER_RD_FULL  : OUT STD_LOGIC;
           B1_USER_QR       : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
           B1_USER_QR_EMPTY : OUT STD_LOGIC;
           B1_USER_WR_EMPTY : OUT STD_LOGIC;
           B1_USER_WR_ERR   : OUT STD_LOGIC;
           B1_USER_RD_ERR   : OUT STD_LOGIC;
           B1_USER_QR_ERR   : OUT STD_LOGIC;
           B1_DLY_CAL_DONE  : OUT STD_LOGIC;     ----------Indicates that the calibration of Input delay tap is done

           B1_QDR_C         : OUT STD_LOGIC;           ------Memory-side Outputs
           B1_QDR_C_n       : OUT STD_LOGIC;
           B1_QDR_K         : OUT STD_LOGIC;           ------Memory-side Outputs
           B1_QDR_K_n       : OUT STD_LOGIC;
           B1_QDR_SA        : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
           B1_QDR_BW_n      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
           B1_QDR_W_n       : OUT STD_LOGIC;
           B1_QDR_D         : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
           B1_QDR_R_n       : OUT STD_LOGIC;
           B1_DOFF_n        : OUT STD_LOGIC;

           B1_QDR_Q         : IN STD_LOGIC_VECTOR(17 DOWNTO 0);                                            ------Memory-side Inputs
           B1_QDR_CQ        : IN STD_LOGIC
    );
  end component v6_qdr2_controler;

end package v6_qdr2_controler_p;