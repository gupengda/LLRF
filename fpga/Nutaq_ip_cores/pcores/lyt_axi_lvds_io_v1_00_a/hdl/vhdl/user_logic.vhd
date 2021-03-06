--------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           v1_00_a
-- Description:       User Logic implementation module
-- Generated by:      julien.roy
-- Date:              2013-01-28 09:09:54
-- Generated:         using LyrtechRD REGGENUTIL based on Xilinx IPIF Wizard.
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Copyright (c) 2001-2012 LYRtech RD Inc.  All rights reserved.
------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
-- Register Memory Map & Description
-----------------------------------------------------------------------------
-- BASEADDR + 0x0   INFO    LVDS_IO Core ID code and Version
--   15:0 Version R
--   31:16 CoreID R

-- BASEADDR + 0x4   CONTROL    Control register
--   0:0 dirGroup0 R W O=o_dirGroup0_p
--   1:1 dirGroup1 R W O=o_dirGroup1_p
--   2:2 CoreResetPulse P O=o_CoreResetPulse_p
--   31:2 rsvd R

--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 2;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------
    -- User ports
  i_CoreReset_p : in std_logic;

    o_dirGroup0_p : out std_logic;
    o_dirGroup1_p : out std_logic;
    o_CoreResetPulse_p : out std_logic;
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
  );

 attribute MAX_FANOUT : string;
 attribute SIGIS : string;
 attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
 attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

-------------------------------------------------------------------------------
-- Constant declarations
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--     ************** Function declaratin *******************                   
-- Return a std_logic_vector with only one bit set to one.
-- The argument BitPosition represent the bit position to set to one, starting with 0.
-- The argument Width represent the width of the returned std_logic_vector.
-------------------------------------------------------------------------------
  function OneHotVector( BitPosition : integer;                              
                Width : integer)                                             
                return std_logic_vector                                      
  is                                                                         
    variable Result                   : std_logic_vector(Width - 1 downto 0);

  begin                        
    Result := (others => '0'); 
    Result(BitPosition) := '1';
    return Result;             
  end OneHotVector;            
-------------------------------------------------------------------------------
-- Signal and Type Declarations
-------------------------------------------------------------------------------

  signal dirGroup0_s                     : std_logic;
  signal dirGroup1_s                     : std_logic;
  signal CoreResetPulse_s                     : std_logic;
  signal slv_reg_write_sel              : std_logic_vector(1 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(1 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Begin architecture
-------------------------------------------------------------------------------

-- swap bits
WrCeBitSwap: for i in 0 to slv_reg_write_sel'high generate
  slv_reg_write_sel(i) <= Bus2IP_WrCE(slv_reg_write_sel'high - i);
end generate WrCeBitSwap;

RdCeBitSwap: for i in 0 to slv_reg_read_sel'high generate
  slv_reg_read_sel(i)  <= Bus2IP_RdCE(slv_reg_read_sel'high - i);
end generate RdCeBitSwap;

-- generate write/read ack
  slv_write_ack <=   Bus2IP_WrCE(0) or   Bus2IP_WrCE(1);
  slv_read_ack  <=   Bus2IP_RdCE(0) or   Bus2IP_RdCE(1);

 -- implement slave model software accessible register(s)
 SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
 begin

  if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
    if Bus2IP_Resetn = '0' then
      dirGroup0_s <=  '1';
      dirGroup1_s <=  '1';
      CoreResetPulse_s <= '0';

    else

  -- Synchronous reset
  if ( i_CoreReset_p = '1' ) then
    dirGroup0_s <=  '1';
    dirGroup1_s <=  '1';
    CoreResetPulse_s <= '0';
  end if;

  CoreResetPulse_s <= '0';
      case slv_reg_write_sel is

        when OneHotVector(1,2) =>
          if (Bus2IP_BE(0) = '1') then
            dirGroup0_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(0) = '1') then
            dirGroup1_s <= Bus2IP_Data(1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            CoreResetPulse_s <= Bus2IP_Data(2);
          end if;
        when others =>
          null;
      end case;
    end if;
  end if;

 end process SLAVE_REG_WRITE_PROC;

 -- implement slave model software accessible register(s) read mux
SLAVE_REG_READ_PROC : process( slv_reg_read_sel, dirGroup0_s, dirGroup1_s) is
 begin
   case slv_reg_read_sel is

        when OneHotVector(0,2) =>
          slv_ip2bus_data(15 downto 0) <= X"0200";
          slv_ip2bus_data(31 downto 16) <= X"32CA";

        when OneHotVector(1,2) =>
          slv_ip2bus_data(0) <= dirGroup0_s;
          slv_ip2bus_data(1) <= dirGroup1_s;
          slv_ip2bus_data(31 downto 2) <=  "000000000000000000000000000000";
        when others =>
          slv_ip2bus_data <= (others => '0');
      end case;

 end process SLAVE_REG_READ_PROC;

------------------------------------------
-- drive IP to Bus signals
------------------------------------------
IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else (others => '0');
IP2Bus_WrAck <= slv_write_ack;
IP2Bus_RdAck <= slv_read_ack;
IP2Bus_Error <= '0';

------------------------------------------
-- Output assignments
------------------------------------------
o_dirGroup0_p <= dirGroup0_s;
o_dirGroup1_p <= dirGroup1_s;
o_CoreResetPulse_p <= CoreResetPulse_s;

end IMP;

