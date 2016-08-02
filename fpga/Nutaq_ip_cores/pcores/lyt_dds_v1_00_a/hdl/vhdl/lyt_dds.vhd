--------------------------------------------------------------------------------
--
--    ****                              *
--   ******                            ***
--   *******                           ****
--   ********    ****  ****     **** *********    ******* ****    ***********
--   *********   ****  ****     **** *********  **************  *************
--   **** *****  ****  ****     ****   ****    *****    ****** *****     ****
--   ****  ***** ****  ****     ****   ****   *****      ****  ****      ****
--  ****    *********  ****     ****   ****   ****       ****  ****      ****
--  ****     ********  ****    *****  ****    *****     *****  ****      ****
--  ****      ******   ***** ******   *****    ****** *******  ****** *******
--  ****        ****   ************    ******   *************   *************
--  ****         ***     ****  ****     ****      *****  ****     *****  ****
--                                                                       ****
--          I N N O V A T I O N  T O D A Y  F O R  T O M M O R O W       ****
--                                                                        ***
--
--------------------------------------------------------------------------------
-- File : lyt_dds.vhd
--------------------------------------------------------------------------------
-- Description : DDS for adac250
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: lyt_dds.vhd,v $
-- Revision 1.1  2014/09/03 18:22:50  julien.roy
-- Add generic DDS pcore
--
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity lyt_dds is

  port (
    i_Clk_p             : in std_logic;
    i_Rst_p             : in std_logic;
    i_ClkEn_p           : in std_logic;
    iv32_Data_p         : in std_logic_vector(31 downto 0);
    i_WriteEn_p         : in std_logic;
    ov16_Cosine_p       : out std_logic_vector(15 downto 0);
    ov16_Sine_p         : out std_logic_vector(15 downto 0)
  );
end entity lyt_dds;

architecture rtl of lyt_dds is

  component dds_core is
    port (
      ce: in std_logic;
      clk: in std_logic;
      sclr: in std_logic;
      we: in std_logic;
      data: in std_logic_vector(31 downto 0);
      cosine: out std_logic_vector(15 downto 0);
      sine: out std_logic_vector(15 downto 0));
  end component dds_core;

begin

  dds_core_inst : dds_core
    port map (
      ce              => i_ClkEn_p,
      clk             => i_Clk_p,
      sclr            => i_Rst_p,
      we              => i_WriteEn_p,
      data            => iv32_Data_p,
      cosine          => ov16_Cosine_p,
      sine            => ov16_Sine_p
    );
  
end architecture rtl;

