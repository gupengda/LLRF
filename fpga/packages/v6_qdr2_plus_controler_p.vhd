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
package v6_qdr2_plus_controler_p is

  component v6_qdr2_plus_controler is
  port
    (

       sys_clk   :  in   std_logic;
       sys_rst_n :  in   std_logic;
       clkref    :  in   std_logic;
       qdr_cq_p  :  in   std_logic_vector(0 downto 0);
       qdr_cq_n  :  in   std_logic_vector(0 downto 0);
       qdr_qvld  :  in   std_logic_vector(0 downto 0);
       qdr_q     :  in   std_logic_vector(17 downto 0);
       qdr_k_p   :  out  std_logic_vector(0 downto 0);
       qdr_k_n   :  out  std_logic_vector(0 downto 0);
       qdr_d     :  out  std_logic_vector(17 downto 0);
       qdr_sa    :  out  std_logic_vector(19 downto 0);
       qdr_w_n   :  out  std_logic;
       qdr_r_n   :  out  std_logic;
       qdr_bw_n  :  out  std_logic_vector(1 downto 0);

       user_wr_cmd0    : in  std_logic;
       user_wr_cmd1    : in  std_logic;
       user_wr_addr0   : in  std_logic_vector(19 downto 0);
       user_wr_addr1   : in  std_logic_vector(19 downto 0);
       user_rd_cmd0    : in  std_logic;
       user_rd_cmd1    : in  std_logic;
       user_rd_addr0   : in  std_logic_vector(19 downto 0);
       user_rd_addr1   : in  std_logic_vector(19 downto 0);
       user_wr_data0   : in  std_logic_vector(71 downto 0);
       user_wr_data1   : in  std_logic_vector(35 downto 0);
       user_wr_bw_n0   : in  std_logic_vector(7 downto 0);
       user_wr_bw_n1   : in  std_logic_vector(3 downto 0);
       clk_tb          : out std_logic;
       rst_clk_tb      : out std_logic;
       user_rd_valid0  : out std_logic;
       user_rd_valid1  : out std_logic;
       user_rd_data0   : out std_logic_vector(71 downto 0);
       user_rd_data1   : out std_logic_vector(35 downto 0);
       qdr_dll_off_n   : out std_logic;
       cal_done        : out std_logic
    );
  end component v6_qdr2_plus_controler;

end package v6_qdr2_plus_controler_p;