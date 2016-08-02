------------------------------------------------------------------------------
--
-- File Name   : $Id: ddr_bist_p.vhd,v 1.1 2009/11/11 18:28:19 francois.blackburn Exp $
--
-- Type        : Package
--
-- Name        : DdrBist_p
--
------------------------------------------------------------------------------
-- Change History:
-- $Log: ddr_bist_p.vhd,v $
-- Revision 1.1  2009/11/11 18:28:19  francois.blackburn
-- first commit
--
------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

package DdrBist_p is
  component DdrBist
    generic(
      DataWidth_g                : integer := 128;
      DataSeed_g                 : std_logic_vector;
      AddressWidth_g             : integer ;
      TapNumber_g                : integer := 4;
      Tap1_g                     : integer := 0;
      Tap2_g                     : integer := 0;
      Tap3_g                     : integer := 0;
      Tap4_g                     : integer := 0

    );
    port
    (
      iv_AddrTestDataSeed_p      : in std_logic_vector( DataWidth_g -1 downto 0 ) ;

      i_BistStart_p              : in std_logic; -- Pulse
      o_BistFail_p               : out std_logic;
      o_DataTestFail_p           : out std_logic;
      o_AddrTestFail_p           : out std_logic;
      o_BistDone_p               : out std_logic;
      ov16_BistErrCnt_p          : out std_logic_vector(15 downto 0);
      o_WrOperation_p            : out std_logic;
      ov_ErrorAddr_p             : out std_logic_vector(AddressWidth_g-11 downto 0);
      ov_ErrorData0_p            : out std_logic_vector((DataWidth_g/2)-1 downto 0);
      ov_ErrorData1_p            : out std_logic_vector((DataWidth_g/2)-1 downto 0);

      i_DataValid_p              : in std_logic;
      iv_DataCmp_p               : in std_logic_vector(DataWidth_g-1 downto 0);

      ov_DataOut_p               : out std_logic_vector(DataWidth_g-1 downto 0);
      o_DataValid_p              : out std_logic;
      i_WrRdy_p                  : in std_logic;

      iv_AddressStart_p          : in std_logic_vector(AddressWidth_g-1 downto 0);
      iv_AddressStop_p           : in std_logic_vector(AddressWidth_g-1 downto 0);
      ov_AddressOut_p            : out std_logic_vector(AddressWidth_g-1 downto 0);
      o_AddressValid_p           : out std_logic;

      i_clk_p                    : in std_logic;
      i_Reset_p                  : in std_logic
    );

  end component DdrBist;
end DdrBist_p;

