--------------------------------------------------------------------------------
--
--          **  **     **  ******  ********  ********  ********  **    **    
--         **    **  **   **   ** ********  ********  ********  **    **
--        **      ***    **   **    **     **        **        **    **
--       **       **    ******     **     ****      **        ********
--      **       **    **  **     **     **        **        **    **
--     *******  **    **   **    **     ********  ********  **    **
--    *******  **    **    **   **     ********  ********  **    **  
--
--                       L Y R T E C H   R D   I N C
--
--------------------------------------------------------------------------------
-- File        : $Id: mdioCtrl_a.vhd,v 1.1 2013/03/20 19:59:51 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : This entity is used as a distributed multiplexer to avoid bottlenecks and ease PAR. It supports 8 class of service, and different data rate interface(HoldDataCopyUntilEndOfTx).
--   
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--  
--------------------------------------------------------------------------------
-- Copyright (c) 2005 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: mdioCtrl_a.vhd,v $
-- Revision 1.1  2013/03/20 19:59:51  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.1  2010/12/01 15:44:41  jeffrey.johnson
-- First commit
--
-- Revision 1.1  2010/06/02 15:49:46  david.quinn
-- *** empty log message ***
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

architecture behavioral of MdioInterface is

  constant Ones_c                       : std_logic_vector(31 downto 0) := (others => '1'); -- .
  constant Zeros_c                      : std_logic_vector(31 downto 0) := (others => '0'); -- .


  -- Architecture's local constants, types, signals  functions.

  type TransactionState_t is
    (
      Idle_c,
      SendPreambule1_c,
      SendPreambule2_c,
      SendCtrlWord_c,
      SendDataWord_c,
      Unused5_c,
      Unused6_c,
      Unused7_c
    );

  type ShiftRegState_t is
    (
      Idle_c,
      LoadShiftReg_c,
      Shift_c,
      EmptyPipe_c,
      TransferDone_c,
      Unused5_c,
      Unused6_c,
      Unused7_c
    );

  signal TransactionState_s         : TransactionState_t;
  signal ShiftRegState_s            : ShiftRegState_t;

  signal DataOut_s                  : std_logic; -- .
  signal DividedClock_s             : std_logic; -- .

  signal InputCaptureEn_s           : std_logic; -- .

  signal MDIO_s                     : std_logic; -- .
  signal MDIOEnable_p               : std_logic; -- .

  signal ShiftRegStateBusy_s        : std_logic; -- .
  signal TransactionRq_s            : std_logic; -- .
  signal Transition_s               : std_logic := '0'; -- .

  constant CntClkDividerLen_c       : integer := 32;
  signal gv_cntClkDivider_s         : std_logic_vector(CntClkDividerLen_c - 1 downto 0); -- .


  signal cntShiftReg_s              : std_logic_vector(3 downto 0); -- .
  signal ShiftReg_s                 : std_logic_vector(15 downto 0); -- .
  signal v16_ShiftRegLoadValue_s    : std_logic_vector(15 downto 0); -- .


  signal RegAddress_in_sig : std_logic_vector(4 downto 0);
  signal RegAddress_out_sig : std_logic_vector(4 downto 0);
  signal PortAddress_in_sig : std_logic_vector(4 downto 0);
  signal PortAddress_out_sig : std_logic_vector(4 downto 0);
  signal TransactionType_in_sig : std_logic_vector(1 downto 0);
  signal TransactionType_out_sig : std_logic_vector(1 downto 0);
  signal ExtendedAdrsSpc_in_sig : std_logic;
  signal ExtendedAdrsSpc_out_sig : std_logic;
  signal TransactionDone_in_sig : std_logic;
  signal TransactionDone_out_sig : std_logic;
  signal TransactionRq_in_sig : std_logic;
  signal TransactionRq_out_sig : std_logic;
  signal Data_in_sig : std_logic_vector(15 downto 0);
  signal Data_out_sig : std_logic_vector(15 downto 0);


  signal TransactionDone_s     : std_logic;
  signal TransactionRqD0_s     : std_logic;

begin


  -- .
  TransactionRqD0_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        TransactionRqD0_s <= '0';
      else
        TransactionRqD0_s <= i_TransactionRq_p;
      end if;
    end if;
  end process TransactionRqD0_l;
o_TransactionRqD0_p <= TransactionRqD0_s;

  -- .
  TransactionRq_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        TransactionRq_s <= '0';
      else
        if TransactionState_s = SendDataWord_c then

          TransactionRq_s <= '0';
        elsif i_TransactionRq_p = '1' and TransactionRqD0_s = '0' then
          TransactionRq_s <= '1';
        end if;
      end if;
    end if;
  end process TransactionRq_l;



  -- .
  TransactionState_l : process (i_clk_p)
  begin
    TransactionState_s <= TransactionState_s;
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        TransactionState_s <= Idle_c;
      else
        case TransactionState_s is
          when Idle_c =>
            if TransactionRq_s = '1' then
              TransactionState_s <= SendPreambule1_c;
            end if;

          when SendPreambule1_c =>
            if (cntShiftReg_s = Zeros_c(cntShiftReg_s'range) and Transition_s = '1') then
              TransactionState_s <= SendPreambule2_c;
            end if;

          when SendPreambule2_c =>
            if (cntShiftReg_s = Zeros_c(cntShiftReg_s'range) and Transition_s = '1') then
              TransactionState_s <= SendCtrlWord_c;
            end if;

          when SendCtrlWord_c =>
            if (cntShiftReg_s = Zeros_c(cntShiftReg_s'range) and Transition_s = '1') then
              TransactionState_s <= SendDataWord_c;
            end if;

          when SendDataWord_c =>
            if (cntShiftReg_s = Zeros_c(cntShiftReg_s'range) and Transition_s = '1') then
              TransactionState_s <= Idle_c;
            end if;

          when others =>
            TransactionState_s <= Idle_c;
        end case;
      end if;
    end if;
  end process TransactionState_l;


  -- .
  ShiftRegState_l : process (i_clk_p)
  begin
    ShiftRegState_s <= ShiftRegState_s;
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        ShiftRegState_s <= Idle_c;
      else
        case ShiftRegState_s is
          when Idle_c =>
            if TransactionRq_s = '1' then
              ShiftRegState_s <= LoadShiftReg_c;
            end if;

          when LoadShiftReg_c =>
            if Transition_s = '1' then
              ShiftRegState_s <= Shift_c;
            end if;

          when Shift_c =>
            if (cntShiftReg_s = Zeros_c(cntShiftReg_s'range) and Transition_s = '1') then

              if TransactionState_s = SendDataWord_c then
                ShiftRegState_s <= EmptyPipe_c;
              else
                ShiftRegState_s <= LoadShiftReg_c;
              end if;
            end if;

          when EmptyPipe_c =>
            if Transition_s = '1' then

              ShiftRegState_s <= TransferDone_c;
            end if;

          when TransferDone_c =>
            ShiftRegState_s <= Idle_c;

          when others =>
            ShiftRegState_s <= Idle_c;

        end case;
      end if;
    end if;
  end process ShiftRegState_l;


  -- .
  Busy_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_Busy_p <= '0';
      else
        if ShiftRegState_s = Idle_c then
          o_Busy_p <= '0';
        else
          o_Busy_p <= '1';
        end if;
      end if;
    end if;
  end process Busy_l;


  -- .
  ShiftRegStateBusy_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        ShiftRegStateBusy_s <= '0';
      else
        if ShiftRegState_s /= Idle_c then
          if Transition_s = '1' then
            ShiftRegStateBusy_s <= '1';
          end if;
        else
          ShiftRegStateBusy_s <= '0';
        end if;
      end if;
    end if;
  end process ShiftRegStateBusy_l;


  -- .
  v16_ShiftRegLoadValue_l : process (i_clk_p)
  begin
    case TransactionState_s is

      when SendPreambule1_c | SendPreambule2_c =>
        v16_ShiftRegLoadValue_s <= Ones_c(v16_ShiftRegLoadValue_s'range);

      when SendCtrlWord_c =>
        v16_ShiftRegLoadValue_s <= '0' & not(i_ExtendedAdrsSpc_p) & iv2_TransactionType_p & iv5_PortAddress_p & iv5_DevAddress_p & "10";

      when others =>
        v16_ShiftRegLoadValue_s <= iv16_Data2Send_p;
    end case;
  end process v16_ShiftRegLoadValue_l;


  -- .
  gv_cntClkDivider_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        gv_cntClkDivider_s <= conv_std_logic_vector(ClkDivider_g / 2 - 1, CntClkDividerLen_c);
      else
        if ShiftRegState_s = Idle_c or gv_cntClkDivider_s = 0 then
          gv_cntClkDivider_s <= conv_std_logic_vector(ClkDivider_g / 2 - 1, CntClkDividerLen_c);
        else
          gv_cntClkDivider_s <= gv_cntClkDivider_s - "1";
        end if;
      end if;
    end if;
  end process gv_cntClkDivider_l;

  -- .
  DividedClock_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        DividedClock_s <= '0';
      else
        if (gv_cntClkDivider_s = 0) then
          DividedClock_s <= (not DividedClock_s);
        end if;
      end if;
    end if;
  end process DividedClock_l;


  Transition_s <= '1' when gv_cntClkDivider_s = 0 and DividedClock_s = '1' else
                  '0';

  -- .
  InputCaptureEn_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        InputCaptureEn_s <= '0';
      else
        InputCaptureEn_s <= Transition_s;
      end if;
    end if;
  end process InputCaptureEn_l;


  -- .
  cntShiftReg_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        cntShiftReg_s <= (others => '1');
      else
        if Transition_s = '1' then
          if ShiftRegState_s = LoadShiftReg_c then
            cntShiftReg_s <= Ones_c(cntShiftReg_s'high downto 1) & '0';
          elsif ShiftRegState_s = Shift_c then
            cntShiftReg_s <= cntShiftReg_s - "1";
          end if;
        end if;
      end if;
    end if;
  end process cntShiftReg_l;

  -- .
  ShiftReg_l : process (i_clk_p)
  begin
ShiftReg_s <= ShiftReg_s;
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        ShiftReg_s <= (others => '0');
      else
        if Transition_s = '1' then
          if ShiftRegState_s = LoadShiftReg_c then
            if iv2_TransactionType_p(1) = '1' and TransactionState_s = SendDataWord_c then
              ShiftReg_s <= ShiftReg_s(ShiftReg_s'high - 1 downto 0) & MDIO_s;

            else
              ShiftReg_s <= v16_ShiftRegLoadValue_s;
            end if;
          elsif ShiftRegState_s = Shift_c then
            ShiftReg_s <= ShiftReg_s(ShiftReg_s'high - 1 downto 0) & MDIO_s;

          end if;
        end if;
      end if;
    end if;
  end process ShiftReg_l;
  ov16_ReceivedData_p <= ShiftReg_s;

  -- .
  DataOut_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        DataOut_s <= '1';
      else
        if ShiftRegStateBusy_s = '1' then
          DataOut_s <= ShiftReg_s(ShiftReg_s'high);
        else
          DataOut_s <= '1';
        end if;
      end if;
    end if;
  end process DataOut_l;

  -- .
  MDIOEnable_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        MDIOEnable_p <= '1';
      else
        if TransactionState_s = SendCtrlWord_c and cntShiftReg_s = Zeros_c(cntShiftReg_s'range) and InputCaptureEn_s = '1' and iv2_TransactionType_p(iv2_TransactionType_p'high) = '1' then
          MDIOEnable_p <= '0';
        elsif ShiftRegStateBusy_s = '0' then
          MDIOEnable_p <= '1';
        end if;
      end if;
    end if;
  end process MDIOEnable_l;

  MDIO_s <= i_MDIO_p;
  o_MDIO_p <= DataOut_s;
  o_MDIODisable_p <= not MDIOEnable_p;

  -- .
  MDC_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_MDC_p <= '0';
      else
        if ShiftRegStateBusy_s = '1' then

          o_MDC_p <= DividedClock_s;
        end if;
      end if;
    end if;
  end process MDC_l;


  -- .
  TransactionDone_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        TransactionDone_s <= '0';
      else
        if ShiftRegState_s = TransferDone_c then
          TransactionDone_s <= '1';
        else
          TransactionDone_s <= '0';
        end if;
      end if;
    end if;
  end process TransactionDone_l;
  o_TransactionDone_p <= TransactionDone_s;


end architecture behavioral;


