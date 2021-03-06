--------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           v1_00_a
-- Description:       User Logic implementation module
-- Generated by:      julien.roy
-- Date:              2013-03-21 08:17:33
-- Generated:         using LyrtechRD REGGENUTIL based on Xilinx IPIF Wizard.
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Copyright (c) 2001-2012 LYRtech RD Inc.  All rights reserved.
------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
-- Register Memory Map & Description
-----------------------------------------------------------------------------
-- BASEADDR + 0x0   REG0   QsfpCtrlReg
--   0:0 ResetN R W O=o_ResetN_p
--   1:1 ClkSel R W O=o_ClkSel_p
--   2:2 EnClk122 R W O=o_EnClk122_p
--   3:3 EnClkUser R W O=o_EnClkUser_p

-- BASEADDR + 0x4   REG1   QsfpClkStatusReg
--   0:0 FmcRefClk0Status R I=i_FmcRefClk0Status_p
--   1:1 FmcRefClk1Status R I=i_FmcRefClk1Status_p
--   2:2 M2CClk0Status R I=i_M2CClk0Status_p
--   3:3 M2CClk1Status R I=i_M2CClk1Status_p

-- BASEADDR + 0x8   REG2   Qsfp0CtrlReg
--   0:0 Qsfp0RxPolarity R W O=o_Qsfp0RxPolarity_p
--   16:9 Qsfp0RxErrorCount R I=iv8_Qsfp0RxErrorCount_p
--   17:17 Qsfp0ResetErrCnt R W O=o_Qsfp0ResetErrCnt_p
--   3:1 Qsfp0LoopBack R W O=ov3_Qsfp0LoopBack_p
--   4:4 Qsfp0TxPrbsForceErr R W O=o_Qsfp0TxPrbsForceErr_p
--   5:5 Qsfp0RxPllLkDet R I=i_Qsfp0RxPllLkDet_p
--   6:6 Qsfp0TxResetDone R I=i_Qsfp0TxResetDone_p
--   7:7 Qsfp0RxResetDone R I=i_Qsfp0RxResetDone_p
--   8:8 Qsfp0RxValid R I=i_Qsfp0RxValid_p

-- BASEADDR + 0xc   REG3   Qsfp1CtrlReg
--   0:0 Qsfp1RxPolarity R W O=o_Qsfp1RxPolarity_p
--   16:9 Qsfp1RxErrorCount R I=iv8_Qsfp1RxErrorCount_p
--   17:17 Qsfp1ResetErrCnt R W O=o_Qsfp1ResetErrCnt_p
--   3:1 Qsfp1LoopBack R W O=ov3_Qsfp1LoopBack_p
--   4:4 Qsfp1TxPrbsForceErr R W O=o_Qsfp1TxPrbsForceErr_p
--   5:5 Qsfp1RxPllLkDet R I=i_Qsfp1RxPllLkDet_p
--   6:6 Qsfp1TxResetDone R I=i_Qsfp1TxResetDone_p
--   7:7 Qsfp1RxResetDone R I=i_Qsfp1RxResetDone_p
--   8:8 Qsfp1RxValid R I=i_Qsfp1RxValid_p

-- BASEADDR + 0x10   REG4   Qsfp2CtrlReg
--   0:0 Qsfp2RxPolarity R W O=o_Qsfp2RxPolarity_p
--   16:9 Qsfp2RxErrorCount R I=iv8_Qsfp2RxErrorCount_p
--   17:17 Qsfp2ResetErrCnt R W O=o_Qsfp2ResetErrCnt_p
--   3:1 Qsfp2LoopBack R W O=ov3_Qsfp2LoopBack_p
--   4:4 Qsfp2TxPrbsForceErr R W O=o_Qsfp2TxPrbsForceErr_p
--   5:5 Qsfp2RxPllLkDet R I=i_Qsfp2RxPllLkDet_p
--   6:6 Qsfp2TxResetDone R I=i_Qsfp2TxResetDone_p
--   7:7 Qsfp2RxResetDone R I=i_Qsfp2RxResetDone_p
--   8:8 Qsfp2RxValid R I=i_Qsfp2RxValid_p

-- BASEADDR + 0x14   REG5   Qsfp3CtrlReg
--   0:0 Qsfp3RxPolarity R W O=o_Qsfp3RxPolarity_p
--   16:9 Qsfp3RxErrorCount R I=iv8_Qsfp3RxErrorCount_p
--   17:17 Qsfp3ResetErrCnt R W O=o_Qsfp3ResetErrCnt_p
--   3:1 Qsfp3LoopBack R W O=ov3_Qsfp3LoopBack_p
--   4:4 Qsfp3TxPrbsForceErr R W O=o_Qsfp3TxPrbsForceErr_p
--   5:5 Qsfp3RxPllLkDet R I=i_Qsfp3RxPllLkDet_p
--   6:6 Qsfp3TxResetDone R I=i_Qsfp3TxResetDone_p
--   7:7 Qsfp3RxResetDone R I=i_Qsfp3RxResetDone_p
--   8:8 Qsfp3RxValid R I=i_Qsfp3RxValid_p

-- BASEADDR + 0x18   REG6   Sfp0CtrlReg
--   0:0 Sfp0RxPolarity R W O=o_Sfp0RxPolarity_p
--   16:9 Sfp0RxErrorCount R I=iv8_Sfp0RxErrorCount_p
--   17:17 Sfp0ResetErrCnt R W O=o_Sfp0ResetErrCnt_p
--   3:1 Sfp0LoopBack R W O=ov3_Sfp0LoopBack_p
--   4:4 Sfp0TxPrbsForceErr R W O=o_Sfp0TxPrbsForceErr_p
--   5:5 Sfp0RxPllLkDet R I=i_Sfp0RxPllLkDet_p
--   6:6 Sfp0TxResetDone R I=i_Sfp0TxResetDone_p
--   7:7 Sfp0RxResetDone R I=i_Sfp0RxResetDone_p
--   8:8 Sfp0RxValid R I=i_Sfp0RxValid_p

-- BASEADDR + 0x1c   REG7   Sfp1CtrlReg
--   0:0 Sfp1RxPolarity R W O=o_Sfp1RxPolarity_p
--   16:9 Sfp1RxErrorCount R I=iv8_Sfp1RxErrorCount_p
--   17:17 Sfp1ResetErrCnt R W O=o_Sfp1ResetErrCnt_p
--   3:1 Sfp1LoopBack R W O=ov3_Sfp1LoopBack_p
--   4:4 Sfp1TxPrbsForceErr R W O=o_Sfp1TxPrbsForceErr_p
--   5:5 Sfp1RxPllLkDet R I=i_Sfp1RxPllLkDet_p
--   6:6 Sfp1TxResetDone R I=i_Sfp1TxResetDone_p
--   7:7 Sfp1RxResetDone R I=i_Sfp1RxResetDone_p
--   8:8 Sfp1RxValid R I=i_Sfp1RxValid_p

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
    C_NUM_REG                      : integer              := 8;
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

    o_ResetN_p : out std_logic;
    o_ClkSel_p : out std_logic;
    o_EnClk122_p : out std_logic;
    o_EnClkUser_p : out std_logic;
    i_FmcRefClk0Status_p : in std_logic;
    i_FmcRefClk1Status_p : in std_logic;
    i_M2CClk0Status_p : in std_logic;
    i_M2CClk1Status_p : in std_logic;
    o_Qsfp0RxPolarity_p : out std_logic;
    iv8_Qsfp0RxErrorCount_p : in std_logic_vector(7 downto 0);
    o_Qsfp0ResetErrCnt_p : out std_logic;
    ov3_Qsfp0LoopBack_p : out std_logic_vector(2 downto 0);
    o_Qsfp0TxPrbsForceErr_p : out std_logic;
    i_Qsfp0RxPllLkDet_p : in std_logic;
    i_Qsfp0TxResetDone_p : in std_logic;
    i_Qsfp0RxResetDone_p : in std_logic;
    i_Qsfp0RxValid_p : in std_logic;
    o_Qsfp1RxPolarity_p : out std_logic;
    iv8_Qsfp1RxErrorCount_p : in std_logic_vector(7 downto 0);
    o_Qsfp1ResetErrCnt_p : out std_logic;
    ov3_Qsfp1LoopBack_p : out std_logic_vector(2 downto 0);
    o_Qsfp1TxPrbsForceErr_p : out std_logic;
    i_Qsfp1RxPllLkDet_p : in std_logic;
    i_Qsfp1TxResetDone_p : in std_logic;
    i_Qsfp1RxResetDone_p : in std_logic;
    i_Qsfp1RxValid_p : in std_logic;
    o_Qsfp2RxPolarity_p : out std_logic;
    iv8_Qsfp2RxErrorCount_p : in std_logic_vector(7 downto 0);
    o_Qsfp2ResetErrCnt_p : out std_logic;
    ov3_Qsfp2LoopBack_p : out std_logic_vector(2 downto 0);
    o_Qsfp2TxPrbsForceErr_p : out std_logic;
    i_Qsfp2RxPllLkDet_p : in std_logic;
    i_Qsfp2TxResetDone_p : in std_logic;
    i_Qsfp2RxResetDone_p : in std_logic;
    i_Qsfp2RxValid_p : in std_logic;
    o_Qsfp3RxPolarity_p : out std_logic;
    iv8_Qsfp3RxErrorCount_p : in std_logic_vector(7 downto 0);
    o_Qsfp3ResetErrCnt_p : out std_logic;
    ov3_Qsfp3LoopBack_p : out std_logic_vector(2 downto 0);
    o_Qsfp3TxPrbsForceErr_p : out std_logic;
    i_Qsfp3RxPllLkDet_p : in std_logic;
    i_Qsfp3TxResetDone_p : in std_logic;
    i_Qsfp3RxResetDone_p : in std_logic;
    i_Qsfp3RxValid_p : in std_logic;
    o_Sfp0RxPolarity_p : out std_logic;
    iv8_Sfp0RxErrorCount_p : in std_logic_vector(7 downto 0);
    o_Sfp0ResetErrCnt_p : out std_logic;
    ov3_Sfp0LoopBack_p : out std_logic_vector(2 downto 0);
    o_Sfp0TxPrbsForceErr_p : out std_logic;
    i_Sfp0RxPllLkDet_p : in std_logic;
    i_Sfp0TxResetDone_p : in std_logic;
    i_Sfp0RxResetDone_p : in std_logic;
    i_Sfp0RxValid_p : in std_logic;
    o_Sfp1RxPolarity_p : out std_logic;
    iv8_Sfp1RxErrorCount_p : in std_logic_vector(7 downto 0);
    o_Sfp1ResetErrCnt_p : out std_logic;
    ov3_Sfp1LoopBack_p : out std_logic_vector(2 downto 0);
    o_Sfp1TxPrbsForceErr_p : out std_logic;
    i_Sfp1RxPllLkDet_p : in std_logic;
    i_Sfp1TxResetDone_p : in std_logic;
    i_Sfp1RxResetDone_p : in std_logic;
    i_Sfp1RxValid_p : in std_logic;
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

  signal ResetN_s                     : std_logic;
  signal ClkSel_s                     : std_logic;
  signal EnClk122_s                     : std_logic;
  signal EnClkUser_s                     : std_logic;
  signal Qsfp0RxPolarity_s                     : std_logic;
  signal Qsfp0ResetErrCnt_s                     : std_logic;
  signal v3_Qsfp0LoopBack_s                     : std_logic_vector(2 downto 0);
  signal Qsfp0TxPrbsForceErr_s                     : std_logic;
  signal Qsfp1RxPolarity_s                     : std_logic;
  signal Qsfp1ResetErrCnt_s                     : std_logic;
  signal v3_Qsfp1LoopBack_s                     : std_logic_vector(2 downto 0);
  signal Qsfp1TxPrbsForceErr_s                     : std_logic;
  signal Qsfp2RxPolarity_s                     : std_logic;
  signal Qsfp2ResetErrCnt_s                     : std_logic;
  signal v3_Qsfp2LoopBack_s                     : std_logic_vector(2 downto 0);
  signal Qsfp2TxPrbsForceErr_s                     : std_logic;
  signal Qsfp3RxPolarity_s                     : std_logic;
  signal Qsfp3ResetErrCnt_s                     : std_logic;
  signal v3_Qsfp3LoopBack_s                     : std_logic_vector(2 downto 0);
  signal Qsfp3TxPrbsForceErr_s                     : std_logic;
  signal Sfp0RxPolarity_s                     : std_logic;
  signal Sfp0ResetErrCnt_s                     : std_logic;
  signal v3_Sfp0LoopBack_s                     : std_logic_vector(2 downto 0);
  signal Sfp0TxPrbsForceErr_s                     : std_logic;
  signal Sfp1RxPolarity_s                     : std_logic;
  signal Sfp1ResetErrCnt_s                     : std_logic;
  signal v3_Sfp1LoopBack_s                     : std_logic_vector(2 downto 0);
  signal Sfp1TxPrbsForceErr_s                     : std_logic;
  signal slv_reg_write_sel              : std_logic_vector(7 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(7 downto 0);
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
  slv_write_ack <=   Bus2IP_WrCE(0) or   Bus2IP_WrCE(1) or   Bus2IP_WrCE(2) or   Bus2IP_WrCE(3) or   Bus2IP_WrCE(4) or   Bus2IP_WrCE(5) or   Bus2IP_WrCE(6) or   Bus2IP_WrCE(7);
  slv_read_ack  <=   Bus2IP_RdCE(0) or   Bus2IP_RdCE(1) or   Bus2IP_RdCE(2) or   Bus2IP_RdCE(3) or   Bus2IP_RdCE(4) or   Bus2IP_RdCE(5) or   Bus2IP_RdCE(6) or   Bus2IP_RdCE(7);

 -- implement slave model software accessible register(s)
 SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
 begin

  if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
    if Bus2IP_Resetn = '0' then
      ResetN_s <= '0';
      ClkSel_s <= '0';
      EnClk122_s <= '0';
      EnClkUser_s <= '0';
      Qsfp0RxPolarity_s <= '0';
      Qsfp0ResetErrCnt_s <= '0';
      v3_Qsfp0LoopBack_s <= "000";
      Qsfp0TxPrbsForceErr_s <= '0';
      Qsfp1RxPolarity_s <= '0';
      Qsfp1ResetErrCnt_s <= '0';
      v3_Qsfp1LoopBack_s <= "000";
      Qsfp1TxPrbsForceErr_s <= '0';
      Qsfp2RxPolarity_s <= '0';
      Qsfp2ResetErrCnt_s <= '0';
      v3_Qsfp2LoopBack_s <= "000";
      Qsfp2TxPrbsForceErr_s <= '0';
      Qsfp3RxPolarity_s <= '0';
      Qsfp3ResetErrCnt_s <= '0';
      v3_Qsfp3LoopBack_s <= "000";
      Qsfp3TxPrbsForceErr_s <= '0';
      Sfp0RxPolarity_s <= '0';
      Sfp0ResetErrCnt_s <= '0';
      v3_Sfp0LoopBack_s <= "000";
      Sfp0TxPrbsForceErr_s <= '0';
      Sfp1RxPolarity_s <= '0';
      Sfp1ResetErrCnt_s <= '0';
      v3_Sfp1LoopBack_s <= "000";
      Sfp1TxPrbsForceErr_s <= '0';

    else

  -- Synchronous reset
  if ( i_CoreReset_p = '1' ) then
    ResetN_s <= '0';
    ClkSel_s <= '0';
    EnClk122_s <= '0';
    EnClkUser_s <= '0';
    Qsfp0RxPolarity_s <= '0';
    Qsfp0ResetErrCnt_s <= '0';
    v3_Qsfp0LoopBack_s <= "000";
    Qsfp0TxPrbsForceErr_s <= '0';
    Qsfp1RxPolarity_s <= '0';
    Qsfp1ResetErrCnt_s <= '0';
    v3_Qsfp1LoopBack_s <= "000";
    Qsfp1TxPrbsForceErr_s <= '0';
    Qsfp2RxPolarity_s <= '0';
    Qsfp2ResetErrCnt_s <= '0';
    v3_Qsfp2LoopBack_s <= "000";
    Qsfp2TxPrbsForceErr_s <= '0';
    Qsfp3RxPolarity_s <= '0';
    Qsfp3ResetErrCnt_s <= '0';
    v3_Qsfp3LoopBack_s <= "000";
    Qsfp3TxPrbsForceErr_s <= '0';
    Sfp0RxPolarity_s <= '0';
    Sfp0ResetErrCnt_s <= '0';
    v3_Sfp0LoopBack_s <= "000";
    Sfp0TxPrbsForceErr_s <= '0';
    Sfp1RxPolarity_s <= '0';
    Sfp1ResetErrCnt_s <= '0';
    v3_Sfp1LoopBack_s <= "000";
    Sfp1TxPrbsForceErr_s <= '0';
  end if;

      case slv_reg_write_sel is

        when OneHotVector(0,8) =>
          if (Bus2IP_BE(0) = '1') then
            ResetN_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(0) = '1') then
            ClkSel_s <= Bus2IP_Data(1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            EnClk122_s <= Bus2IP_Data(2);
          end if;
          if (Bus2IP_BE(0) = '1') then
            EnClkUser_s <= Bus2IP_Data(3);
          end if;

        when OneHotVector(2,8) =>
          if (Bus2IP_BE(0) = '1') then
            Qsfp0RxPolarity_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(2) = '1') then
            Qsfp0ResetErrCnt_s <= Bus2IP_Data(17);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v3_Qsfp0LoopBack_s <= Bus2IP_Data(3 downto 1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            Qsfp0TxPrbsForceErr_s <= Bus2IP_Data(4);
          end if;

        when OneHotVector(3,8) =>
          if (Bus2IP_BE(0) = '1') then
            Qsfp1RxPolarity_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(2) = '1') then
            Qsfp1ResetErrCnt_s <= Bus2IP_Data(17);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v3_Qsfp1LoopBack_s <= Bus2IP_Data(3 downto 1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            Qsfp1TxPrbsForceErr_s <= Bus2IP_Data(4);
          end if;

        when OneHotVector(4,8) =>
          if (Bus2IP_BE(0) = '1') then
            Qsfp2RxPolarity_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(2) = '1') then
            Qsfp2ResetErrCnt_s <= Bus2IP_Data(17);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v3_Qsfp2LoopBack_s <= Bus2IP_Data(3 downto 1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            Qsfp2TxPrbsForceErr_s <= Bus2IP_Data(4);
          end if;

        when OneHotVector(5,8) =>
          if (Bus2IP_BE(0) = '1') then
            Qsfp3RxPolarity_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(2) = '1') then
            Qsfp3ResetErrCnt_s <= Bus2IP_Data(17);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v3_Qsfp3LoopBack_s <= Bus2IP_Data(3 downto 1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            Qsfp3TxPrbsForceErr_s <= Bus2IP_Data(4);
          end if;

        when OneHotVector(6,8) =>
          if (Bus2IP_BE(0) = '1') then
            Sfp0RxPolarity_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(2) = '1') then
            Sfp0ResetErrCnt_s <= Bus2IP_Data(17);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v3_Sfp0LoopBack_s <= Bus2IP_Data(3 downto 1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            Sfp0TxPrbsForceErr_s <= Bus2IP_Data(4);
          end if;

        when OneHotVector(7,8) =>
          if (Bus2IP_BE(0) = '1') then
            Sfp1RxPolarity_s <= Bus2IP_Data(0);
          end if;
          if (Bus2IP_BE(2) = '1') then
            Sfp1ResetErrCnt_s <= Bus2IP_Data(17);
          end if;
          if (Bus2IP_BE(0) = '1') then
            v3_Sfp1LoopBack_s <= Bus2IP_Data(3 downto 1);
          end if;
          if (Bus2IP_BE(0) = '1') then
            Sfp1TxPrbsForceErr_s <= Bus2IP_Data(4);
          end if;
        when others =>
          null;
      end case;
    end if;
  end if;

 end process SLAVE_REG_WRITE_PROC;

 -- implement slave model software accessible register(s) read mux
SLAVE_REG_READ_PROC : process( slv_reg_read_sel, ResetN_s, ClkSel_s, EnClk122_s, EnClkUser_s, i_FmcRefClk0Status_p, i_FmcRefClk1Status_p, i_M2CClk0Status_p, i_M2CClk1Status_p, Qsfp0RxPolarity_s, iv8_Qsfp0RxErrorCount_p, Qsfp0ResetErrCnt_s, v3_Qsfp0LoopBack_s, Qsfp0TxPrbsForceErr_s, i_Qsfp0RxPllLkDet_p, i_Qsfp0TxResetDone_p, i_Qsfp0RxResetDone_p, i_Qsfp0RxValid_p, Qsfp1RxPolarity_s, iv8_Qsfp1RxErrorCount_p, Qsfp1ResetErrCnt_s, v3_Qsfp1LoopBack_s, Qsfp1TxPrbsForceErr_s, i_Qsfp1RxPllLkDet_p, i_Qsfp1TxResetDone_p, i_Qsfp1RxResetDone_p, i_Qsfp1RxValid_p, Qsfp2RxPolarity_s, iv8_Qsfp2RxErrorCount_p, Qsfp2ResetErrCnt_s, v3_Qsfp2LoopBack_s, Qsfp2TxPrbsForceErr_s, i_Qsfp2RxPllLkDet_p, i_Qsfp2TxResetDone_p, i_Qsfp2RxResetDone_p, i_Qsfp2RxValid_p, Qsfp3RxPolarity_s, iv8_Qsfp3RxErrorCount_p, Qsfp3ResetErrCnt_s, v3_Qsfp3LoopBack_s, Qsfp3TxPrbsForceErr_s, i_Qsfp3RxPllLkDet_p, i_Qsfp3TxResetDone_p, i_Qsfp3RxResetDone_p, i_Qsfp3RxValid_p, Sfp0RxPolarity_s, iv8_Sfp0RxErrorCount_p, Sfp0ResetErrCnt_s, v3_Sfp0LoopBack_s, Sfp0TxPrbsForceErr_s, i_Sfp0RxPllLkDet_p, i_Sfp0TxResetDone_p, i_Sfp0RxResetDone_p, i_Sfp0RxValid_p, Sfp1RxPolarity_s, iv8_Sfp1RxErrorCount_p, Sfp1ResetErrCnt_s, v3_Sfp1LoopBack_s, Sfp1TxPrbsForceErr_s, i_Sfp1RxPllLkDet_p, i_Sfp1TxResetDone_p, i_Sfp1RxResetDone_p, i_Sfp1RxValid_p) is
 begin
   case slv_reg_read_sel is

        when OneHotVector(0,8) =>
          slv_ip2bus_data(0) <= ResetN_s;
          slv_ip2bus_data(1) <= ClkSel_s;
          slv_ip2bus_data(2) <= EnClk122_s;
          slv_ip2bus_data(3) <= EnClkUser_s;

        when OneHotVector(1,8) =>
          slv_ip2bus_data(0) <= i_FmcRefClk0Status_p;
          slv_ip2bus_data(1) <= i_FmcRefClk1Status_p;
          slv_ip2bus_data(2) <= i_M2CClk0Status_p;
          slv_ip2bus_data(3) <= i_M2CClk1Status_p;

        when OneHotVector(2,8) =>
          slv_ip2bus_data(0) <= Qsfp0RxPolarity_s;
          slv_ip2bus_data(16 downto 9) <= iv8_Qsfp0RxErrorCount_p;
          slv_ip2bus_data(17) <= Qsfp0ResetErrCnt_s;
          slv_ip2bus_data(3 downto 1) <= v3_Qsfp0LoopBack_s;
          slv_ip2bus_data(4) <= Qsfp0TxPrbsForceErr_s;
          slv_ip2bus_data(5) <= i_Qsfp0RxPllLkDet_p;
          slv_ip2bus_data(6) <= i_Qsfp0TxResetDone_p;
          slv_ip2bus_data(7) <= i_Qsfp0RxResetDone_p;
          slv_ip2bus_data(8) <= i_Qsfp0RxValid_p;

        when OneHotVector(3,8) =>
          slv_ip2bus_data(0) <= Qsfp1RxPolarity_s;
          slv_ip2bus_data(16 downto 9) <= iv8_Qsfp1RxErrorCount_p;
          slv_ip2bus_data(17) <= Qsfp1ResetErrCnt_s;
          slv_ip2bus_data(3 downto 1) <= v3_Qsfp1LoopBack_s;
          slv_ip2bus_data(4) <= Qsfp1TxPrbsForceErr_s;
          slv_ip2bus_data(5) <= i_Qsfp1RxPllLkDet_p;
          slv_ip2bus_data(6) <= i_Qsfp1TxResetDone_p;
          slv_ip2bus_data(7) <= i_Qsfp1RxResetDone_p;
          slv_ip2bus_data(8) <= i_Qsfp1RxValid_p;

        when OneHotVector(4,8) =>
          slv_ip2bus_data(0) <= Qsfp2RxPolarity_s;
          slv_ip2bus_data(16 downto 9) <= iv8_Qsfp2RxErrorCount_p;
          slv_ip2bus_data(17) <= Qsfp2ResetErrCnt_s;
          slv_ip2bus_data(3 downto 1) <= v3_Qsfp2LoopBack_s;
          slv_ip2bus_data(4) <= Qsfp2TxPrbsForceErr_s;
          slv_ip2bus_data(5) <= i_Qsfp2RxPllLkDet_p;
          slv_ip2bus_data(6) <= i_Qsfp2TxResetDone_p;
          slv_ip2bus_data(7) <= i_Qsfp2RxResetDone_p;
          slv_ip2bus_data(8) <= i_Qsfp2RxValid_p;

        when OneHotVector(5,8) =>
          slv_ip2bus_data(0) <= Qsfp3RxPolarity_s;
          slv_ip2bus_data(16 downto 9) <= iv8_Qsfp3RxErrorCount_p;
          slv_ip2bus_data(17) <= Qsfp3ResetErrCnt_s;
          slv_ip2bus_data(3 downto 1) <= v3_Qsfp3LoopBack_s;
          slv_ip2bus_data(4) <= Qsfp3TxPrbsForceErr_s;
          slv_ip2bus_data(5) <= i_Qsfp3RxPllLkDet_p;
          slv_ip2bus_data(6) <= i_Qsfp3TxResetDone_p;
          slv_ip2bus_data(7) <= i_Qsfp3RxResetDone_p;
          slv_ip2bus_data(8) <= i_Qsfp3RxValid_p;

        when OneHotVector(6,8) =>
          slv_ip2bus_data(0) <= Sfp0RxPolarity_s;
          slv_ip2bus_data(16 downto 9) <= iv8_Sfp0RxErrorCount_p;
          slv_ip2bus_data(17) <= Sfp0ResetErrCnt_s;
          slv_ip2bus_data(3 downto 1) <= v3_Sfp0LoopBack_s;
          slv_ip2bus_data(4) <= Sfp0TxPrbsForceErr_s;
          slv_ip2bus_data(5) <= i_Sfp0RxPllLkDet_p;
          slv_ip2bus_data(6) <= i_Sfp0TxResetDone_p;
          slv_ip2bus_data(7) <= i_Sfp0RxResetDone_p;
          slv_ip2bus_data(8) <= i_Sfp0RxValid_p;

        when OneHotVector(7,8) =>
          slv_ip2bus_data(0) <= Sfp1RxPolarity_s;
          slv_ip2bus_data(16 downto 9) <= iv8_Sfp1RxErrorCount_p;
          slv_ip2bus_data(17) <= Sfp1ResetErrCnt_s;
          slv_ip2bus_data(3 downto 1) <= v3_Sfp1LoopBack_s;
          slv_ip2bus_data(4) <= Sfp1TxPrbsForceErr_s;
          slv_ip2bus_data(5) <= i_Sfp1RxPllLkDet_p;
          slv_ip2bus_data(6) <= i_Sfp1TxResetDone_p;
          slv_ip2bus_data(7) <= i_Sfp1RxResetDone_p;
          slv_ip2bus_data(8) <= i_Sfp1RxValid_p;
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
o_ResetN_p <= ResetN_s;
o_ClkSel_p <= ClkSel_s;
o_EnClk122_p <= EnClk122_s;
o_EnClkUser_p <= EnClkUser_s;
o_Qsfp0RxPolarity_p <= Qsfp0RxPolarity_s;
o_Qsfp0ResetErrCnt_p <= Qsfp0ResetErrCnt_s;
ov3_Qsfp0LoopBack_p <= v3_Qsfp0LoopBack_s;
o_Qsfp0TxPrbsForceErr_p <= Qsfp0TxPrbsForceErr_s;
o_Qsfp1RxPolarity_p <= Qsfp1RxPolarity_s;
o_Qsfp1ResetErrCnt_p <= Qsfp1ResetErrCnt_s;
ov3_Qsfp1LoopBack_p <= v3_Qsfp1LoopBack_s;
o_Qsfp1TxPrbsForceErr_p <= Qsfp1TxPrbsForceErr_s;
o_Qsfp2RxPolarity_p <= Qsfp2RxPolarity_s;
o_Qsfp2ResetErrCnt_p <= Qsfp2ResetErrCnt_s;
ov3_Qsfp2LoopBack_p <= v3_Qsfp2LoopBack_s;
o_Qsfp2TxPrbsForceErr_p <= Qsfp2TxPrbsForceErr_s;
o_Qsfp3RxPolarity_p <= Qsfp3RxPolarity_s;
o_Qsfp3ResetErrCnt_p <= Qsfp3ResetErrCnt_s;
ov3_Qsfp3LoopBack_p <= v3_Qsfp3LoopBack_s;
o_Qsfp3TxPrbsForceErr_p <= Qsfp3TxPrbsForceErr_s;
o_Sfp0RxPolarity_p <= Sfp0RxPolarity_s;
o_Sfp0ResetErrCnt_p <= Sfp0ResetErrCnt_s;
ov3_Sfp0LoopBack_p <= v3_Sfp0LoopBack_s;
o_Sfp0TxPrbsForceErr_p <= Sfp0TxPrbsForceErr_s;
o_Sfp1RxPolarity_p <= Sfp1RxPolarity_s;
o_Sfp1ResetErrCnt_p <= Sfp1ResetErrCnt_s;
ov3_Sfp1LoopBack_p <= v3_Sfp1LoopBack_s;
o_Sfp1TxPrbsForceErr_p <= Sfp1TxPrbsForceErr_s;

end IMP;

