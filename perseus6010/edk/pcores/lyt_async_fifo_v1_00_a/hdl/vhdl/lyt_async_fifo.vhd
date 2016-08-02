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
-- File : lyt_async_fifo.vhd
--------------------------------------------------------------------------------
-- Description : Asynchronous fifo for adac250
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: lyt_async_fifo.vhd,v $
-- Revision 1.1  2014/07/28 18:14:10  julien.roy
-- Add mo1000 mi125 bsdk example
--
-- Revision 1.1  2013/01/08 18:52:09  julien.roy
-- Add first version of adac250 loopback edk project
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity lyt_async_fifo is

  port (
    i_Rst_p             : in std_logic;
    i_WrClk_p           : in std_logic;
    i_RdClk_p           : in std_logic;
    i_WeEn_p            : in std_logic;
    i_RdEn_p            : in std_logic;
    iv32_Data_p         : in std_logic_vector(31 downto 0);
    ov32_Data_p         : out std_logic_vector(31 downto 0)
  );
end entity lyt_async_fifo;

architecture rtl of lyt_async_fifo is

  component async_fifo
    port (
      rst : in std_logic;
      wr_clk : in std_logic;
      rd_clk : in std_logic;
      din : in std_logic_vector(31 downto 0);
      wr_en : in std_logic;
      rd_en : in std_logic;
      dout : out std_logic_vector(31 downto 0);
      full : out std_logic;
      empty : out std_logic
    );
  end component;
  
  signal fifo_rd_en : std_logic;
  signal fifo_empty : std_logic;

begin

  async_fifo_inst : async_fifo
    port map (
      rst => i_Rst_p,
      wr_clk => i_WrClk_p,
      rd_clk => i_RdClk_p,
      din => iv32_Data_p,
      wr_en => i_WeEn_p,
      rd_en => fifo_rd_en,
      dout => ov32_Data_p,
      full => open,
      empty => fifo_empty
    );
    
  fifo_rd_en <= i_RdEn_p and (not fifo_empty);
  
end architecture rtl;

