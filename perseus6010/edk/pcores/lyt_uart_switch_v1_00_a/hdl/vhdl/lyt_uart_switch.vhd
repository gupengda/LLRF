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
-- File : lyt_uart_switch.vhd
--------------------------------------------------------------------------------
-- Description : Uart switch for multiple uart ports
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2013 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: lyt_uart_switch.vhd,v $
-- Revision 1.1  2013/05/09 12:37:59  julien.roy
-- Add uart switch pcore to support both UART pins
--
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity lyt_uart_switch is
  port (
    iv2_SelectMode_p          : in std_logic_vector(1 downto 0);
    i_DaughterAbsent_p        : in std_logic;
    
    i_Daughter_RX_p   	      : in std_logic;
    io_Daughter_TX_p_I   	    : in std_logic;
    io_Daughter_TX_p_O   	    : out std_logic;
    io_Daughter_TX_p_T   	    : out std_logic;
    
    i_AMC_RX_p   	            : in std_logic;
    io_AMC_TX_p_I   	        : in std_logic;
    io_AMC_TX_p_O   	        : out std_logic;
    io_AMC_TX_p_T   	        : out std_logic;
    
    o_AXI_RX_p                : out std_logic;
    i_AXI_TX_p                : in std_logic
  );
end entity lyt_uart_switch;


architecture rtl of lyt_uart_switch is
begin

  process(iv2_SelectMode_p, i_DaughterAbsent_p, i_Daughter_RX_p, i_AMC_RX_p, i_AXI_TX_p)
  begin
    if (iv2_SelectMode_p(0) = '0' and i_DaughterAbsent_p = '0') then
      o_AXI_RX_p <= i_Daughter_RX_p and i_AMC_RX_p;
      io_Daughter_TX_p_T <= '0';
      io_AMC_TX_p_T      <= '0';
    elsif (iv2_SelectMode_p = "01") then
      o_AXI_RX_p <= i_Daughter_RX_p;
      io_Daughter_TX_p_T <= '0';
      io_AMC_TX_p_T      <= '1';
    else
      o_AXI_RX_p <= i_AMC_RX_p;
      io_Daughter_TX_p_T <= '1';
      io_AMC_TX_p_T      <= '0';
    end if;
  end process;
  
  io_Daughter_TX_p_O <= i_AXI_TX_p;
  io_AMC_TX_p_O <= i_AXI_TX_p;

end rtl;
