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
-- File : lyt_async_fifo_w256.vhd
--------------------------------------------------------------------------------
-- Description : Asynchronous fifo for adac250
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: lyt_mi125_async_fifo.vhd,v $
-- Revision 1.1  2014/10/16 13:14:03  julien.roy
-- Add mi125 async fifo core to use with the mo1000 core.
--
-- Revision 1.1  2014/07/28 18:14:10  julien.roy
-- Add mo1000 mi125 bsdk example
--
-- Revision 1.1  2013/01/08 18:52:09  julien.roy
-- Add first version of adac250 loopback edk project
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity lyt_mi125_async_fifo is

  port (
    i_Rst_p             : in std_logic;
    i_WrClk_p           : in std_logic;
    i_RdClk_p           : in std_logic;
    i_WeEn_p            : in std_logic;
    i_RdEn_p            : in std_logic;
    iv224_Data_p        : in std_logic_vector(223 downto 0);
    ov224_Data_p        : out std_logic_vector(223 downto 0);
    iv16_DataValid_p    : in std_logic_vector(15 downto 0);
    ov16_DataValid_p    : out std_logic_vector(15 downto 0);
    iv5_Misc_p          : in std_logic_vector(4 downto 0);
    ov5_Misc_p          : out std_logic_vector(4 downto 0);
    o_DataRdy_p         : out std_logic
  );
end entity lyt_mi125_async_fifo;

architecture rtl of lyt_mi125_async_fifo is

  component async_fifo_w256
    port (
      rst : in std_logic;
      wr_clk : in std_logic;
      rd_clk : in std_logic;
      din : in std_logic_vector(255 downto 0);
      wr_en : in std_logic;
      rd_en : in std_logic;
      dout : out std_logic_vector(255 downto 0);
      full : out std_logic;
      empty : out std_logic;
      valid : out std_logic
    );
  end component;
  
  signal fifo_din   : std_logic_vector(255 downto 0);
  signal fifo_dout  : std_logic_vector(255 downto 0);
  signal fifo_rd_en : std_logic;
  signal fifo_rdy   : std_logic;
  signal fifo_empty : std_logic;
  signal fifo_valid : std_logic;

begin

  fifo_din <= "11111111111" & iv5_Misc_p & iv16_DataValid_p & iv224_Data_p;

  async_fifo_w256_inst : async_fifo_w256
    port map (
      rst => i_Rst_p,
      wr_clk => i_WrClk_p,
      rd_clk => i_RdClk_p,
      din => fifo_din,
      wr_en => i_WeEn_p,
      rd_en => fifo_rd_en,
      dout => fifo_dout,
      full => open,
      empty => fifo_empty,
      valid => fifo_valid
    );
    
  process(i_RdClk_p)
  begin
    if rising_edge(i_RdClk_p) then
      fifo_rdy <= (not fifo_empty);
      
      ov224_Data_p  <= fifo_dout(223 downto 0);
      ov5_Misc_p    <= fifo_dout(244 downto 240);
      
      if fifo_valid = '1' then
        ov16_DataValid_p <= fifo_dout(239 downto 224);
      else
        ov16_DataValid_p <= (others => '0');
      end if;
      
    end if;
  end process;
  
  fifo_rd_en <= i_RdEn_p and fifo_rdy;
  
  o_DataRdy_p <= fifo_rdy;
  
end architecture rtl;

