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

------------------------------------------------------------------------------
--
-- File Name   : $Id: lyt_glitch_filter.vhd
--
-- Type        : Entity
--
-- Name        : glitch filter
--
------------------------------------------------------------------------------
-- Change History:
-- $Log: lyt_glitch_filter.vhd,v $
-- Revision 1.1  2013/08/01 20:28:00  khalid.bensadek
-- Fisrt commit: tested with Radio420 only.
--
-- Revision 1.1  2013/03/07 20:41:01  minh-quang.nguyen
-- initial add
--
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity lyt_glitch_filter is
   
   generic (
      C_INERTIAL_DELAY : integer range 0 to 255 := 5      
      );

   port (
      i_Clk_p    : in  std_logic;
      i_Rst_p       : in  std_logic;
      i_Din_p : in  std_logic;
      o_Dout_p : out std_logic
      );

end entity lyt_glitch_filter;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture rtl of lyt_glitch_filter is

	component debounce is
   
   generic (
      C_INERTIAL_DELAY : integer range 0 to 255 := 5;
      C_DEFAULT        : std_logic              := '1'
      );

   port (
      Sysclk     	: in std_logic;
      Rst     		: in std_logic;
      Stable     	: in  std_logic;
      Unstable_n 	: out std_logic;
      Noisy      	: in  std_logic;
      Clean      	: out std_logic);

	end component;

begin
   
   inst_glitch_filter : debounce
      generic map (
         C_INERTIAL_DELAY => C_INERTIAL_DELAY, 
         C_DEFAULT        => '1')
      port map (
         Sysclk    	=> i_Clk_p,
         Rst    		=> i_Rst_p,

         Stable     	=> '1',
         Unstable_n 	=> open,

         Noisy      	=> i_Din_p,  
         Clean      	=> o_Dout_p); 

end architecture rtl;