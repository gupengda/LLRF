-------------------------------------------------------------------------------
-- debounce.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX is PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS is" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT to NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2009 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        debounce.vhd
-- Version:         v1.01.a                        
-- Description:     
--                 This file implements a simple debounce (inertial delay)
--                 filter to remove short glitches from a signal based upon
--                 using user definable delay parameters. It accepts a "Stable"
--                 signal which allows the filter to dynamically stretch its
--                 delay based on whether another signal is Stable or not. If
--                 the filter has detected a change on is "Noisy" input then it
--                 will signal its output is "unstable". That can be cross
--                 coupled into the "Stable" input of another filter if
--                 necessary.
-- Notes:
-- 1) A default assignment based on the generic C_DEFAULT is made for the flip
-- flop output of the delay logic when C_INERTIAL_DELAY > 0. Otherwise, the
-- logic is free running and no reset is possible.
-- 2) A C_INERTIAL_DELAY value of 0 eliminates the debounce logic and connects
-- input to output directly.
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--
--           axi_iic.vhd
--              -- iic.vhd
--                  -- axi_ipif_ssp1.vhd
--                      -- axi_lite_ipif.vhd
--                      -- interrupt_control.vhd
--                      -- soft_reset.vhd
--                  -- reg_interface.vhd
--                  -- filter.vhd
--                      -- debounce.vhd
--                  -- iic_control.vhd
--                      -- upcnt_n.vhd
--                      -- shift8.vhd
--                  -- dynamic_master.vhd
--                  -- iic_pkg.vhd
--
-------------------------------------------------------------------------------
-- Author:          USM
--
--  USM     10/15/09
-- ^^^^^^
--  - Initial release of v1.00.a
-- ~~~~~~
--
--  USM     09/06/10
-- ^^^^^^
--  - Release of v1.01.a
-- ~~~~~~
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Definition of Generics:
--      C_INERTIAL_DELAY     -- Filtering delay       
--      C_DEFAULT            -- User logic high address 
-- Definition of Ports:
--      Sysclk               -- System clock
--      Stable               -- IIC signal is Stable
--      Unstable_n           -- IIC signal is unstable
--      Noisy                -- IIC signal is Noisy
--      Clean                -- IIC signal is Clean
-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------

entity debounce is
   
   generic (
      C_INERTIAL_DELAY : integer range 0 to 255 := 5;
      C_DEFAULT        : std_logic              := '1'
      );

   port (
      Sysclk     : in std_logic;
      Rst        : in std_logic;
      Stable     : in  std_logic;
      Unstable_n : out std_logic;
      Noisy      : in  std_logic;
      Clean      : out std_logic);

end entity debounce;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture RTL of debounce is

   -- XST proceses default assignments for configuration purposes
   signal clean_cs  : std_logic := C_DEFAULT;
   signal stable_cs : std_logic := '1';

begin

   ----------------------------------------------------------------------------
   --  GEN_INERTIAL : Generate when C_INERTIAL_DELAY > 0
   ----------------------------------------------------------------------------

   GEN_INERTIAL : if (C_INERTIAL_DELAY > 0) generate

   ----------------------------------------------------------------------------
   --  GEN_INERTIAL : C_INERTIAL_DELAY > 0
   -- Inertial delay filters out pulses that are smaller in width then the
   -- specified delay. If the C_INERTIAL_DELAY is 0 then the input is passed
   -- directly to the "Clean" output signal.
   --
   ----------------------------------------------------------------------------
      INRTL_PROCESS : process (Sysclk) is
         variable debounce_ct : unsigned(8 downto 0) 
                                := to_unsigned(C_INERTIAL_DELAY, 9);
      begin
          if (Sysclk'event and Sysclk = '1') then
            if Rst = '1' then 
               clean_cs <= C_DEFAULT;
            -- "to_x01" function translates 'H'->'1' and 'L'->'0'
            elsif (clean_cs = to_x01(Noisy)) then
               debounce_ct := to_unsigned(C_INERTIAL_DELAY, 9);
               Unstable_n  <= '1';
            else
               if (debounce_ct(8) = '0') then
                  debounce_ct := debounce_ct - 1;
               end if;
               if (debounce_ct(8) = '1' and Stable = '1') then
                  clean_cs <= Noisy;
               end if;
            Unstable_n <= debounce_ct(8);
            end if;
         end if;
         
      end process INRTL_PROCESS;

      s0 : Clean <= clean_cs;
   end generate GEN_INERTIAL;

   ----------------------------------------------------------------------------
   -- NO_INERTIAL : C_INERTIAL_DELAY = 0
   -- No inertial delay means output is always Stable
   ----------------------------------------------------------------------------
   NO_INERTIAL : if (C_INERTIAL_DELAY = 0) generate
      
      s0 : Clean      <= Noisy;
      s1 : Unstable_n <= '1';  
                               
   end generate NO_INERTIAL;
   
end architecture RTL;