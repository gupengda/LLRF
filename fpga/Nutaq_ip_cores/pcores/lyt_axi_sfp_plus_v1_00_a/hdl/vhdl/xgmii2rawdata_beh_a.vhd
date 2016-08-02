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
-- File        : $Id: xgmii2rawdata_beh_a.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : This entity is used as a
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2005 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: xgmii2rawdata_beh_a.vhd,v $
-- Revision 1.1  2013/03/20 19:59:52  julien.roy
-- Add SFP plus axi core
--
-- Revision 1.1  2010/12/01 15:44:42  jeffrey.johnson
-- First commit
--
-- Revision 1.1  2010/05/12 15:33:00  claude.cote
-- no message
--
--------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

library work;
  use work.Xgmii_p.all;

architecture beh of Xgmii2RawData is

  -- Architecture's local constants, types, signals  functions.

  type State_t is
    (
      Idle_c,
      StripSOP_c,
      TransferPacketBody_c,
      StripEOP_c,
      WriteDummyData_c
    );

  type ByteRamp_t is array(7 downto 0) of std_logic_vector(7 downto 0);


  ----------------------------------------------------------------------------
  --  Declaration des signaux internes.
  ----------------------------------------------------------------------------
  signal State_s                    : State_t;


  signal v64_XgmiiRxDD1_s           : std_logic_vector(63 downto 0); -- .
  signal v8_XgmiiRxCD1_s            : std_logic_vector(7 downto 0); -- .

  signal v64_ShiftedXgmiiRxDLane0_s : std_logic_vector(63 downto 0); -- .
  signal v64_ShiftedXgmiiRxDLane2_s : std_logic_vector(63 downto 0); -- .
  signal v64_ShiftedXgmiiRxD_s      : std_logic_vector(63 downto 0); -- .

  signal v8_ShiftedXgmiiRxCLane0_s  : std_logic_vector(7 downto 0); -- .
  signal v8_ShiftedXgmiiRxCLane2_s  : std_logic_vector(7 downto 0); -- .
  signal v8_ShiftedXgmiiRxC_s       : std_logic_vector(7 downto 0); -- .

  signal v8_ByteValid_s             : std_logic_vector(7 downto 0); -- .

  signal SOPOnLane0_s               : std_logic; -- .

begin

  InputsD1_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v64_XgmiiRxDD1_s <= (others => '0');
        v8_XgmiiRxCD1_s <= (others => '0');
      else
        v64_XgmiiRxDD1_s <= iv64_XgmiiRxD_p;
        v8_XgmiiRxCD1_s <= iv8_XgmiiRxC_p;
      end if;
    end if;
  end process InputsD1_l;


  State_l : process (i_clk_p)
  begin
    State_s <= State_s;
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        State_s <= Idle_c;
      else
        case State_s is
          when Idle_c =>
            if iv8_XgmiiRxC_p /= x"FF" and (iv64_XgmiiRxD_p(39 downto 32) = x"FB" or iv64_XgmiiRxD_p(7 downto 0) = x"FB") then

              State_s <= StripSOP_c;
            end if;

          when StripSOP_c =>
            State_s <= TransferPacketBody_c;

          when TransferPacketBody_c =>
            if iv8_XgmiiRxC_p /= x"00" then
              State_s <= StripEOP_c;
            end if;

          when StripEOP_c =>
            State_s <= WriteDummyData_c;

          when WriteDummyData_c =>
            State_s <= Idle_c;

          when others =>
            State_s <= Idle_c;
        end case;
      end if;
    end if;
  end process State_l;


  SOPOnLane0_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        SOPOnLane0_s <= '0';
      else
        if State_s = Idle_c then
          if iv8_XgmiiRxC_p(0) = '1' and iv64_XgmiiRxD_p(7 downto 0) = StartOfPckt27K7CodeS_c then
            SOPOnLane0_s <= '1';
          else
            SOPOnLane0_s <= '0';
          end if;
        end if;
      end if;
    end if;
  end process SOPOnLane0_l;

  v64_ShiftedXgmiiRxDLane0_s <= iv64_XgmiiRxD_p(7 downto 0) & v64_XgmiiRxDD1_s(63 downto 8);
  v64_ShiftedXgmiiRxDLane2_s <= iv64_XgmiiRxD_p(39 downto 0) & v64_XgmiiRxDD1_s(63 downto 40);

  v64_ShiftedXgmiiRxD_s <= v64_ShiftedXgmiiRxDLane0_s when SOPOnLane0_s = '1' else
                           v64_ShiftedXgmiiRxDLane2_s;

  v8_ShiftedXgmiiRxCLane0_s <= iv8_XgmiiRxC_p(0) & v8_XgmiiRxCD1_s(7 downto 1);
  v8_ShiftedXgmiiRxCLane2_s <= iv8_XgmiiRxC_p(4 downto 0) & v8_XgmiiRxCD1_s(7 downto 5);

  v8_ShiftedXgmiiRxC_s <= v8_ShiftedXgmiiRxCLane0_s when SOPOnLane0_s = '1' else
                          v8_ShiftedXgmiiRxCLane2_s;

  -- .
  ov64_RawData_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        ov64_RawData_p <= (others => '0');
      else
        case State_s is
          when StripSOP_c | TransferPacketBody_c =>
            ov64_RawData_p <= v64_ShiftedXgmiiRxD_s;

          when StripEOP_c =>
            for Index in 0 to 7 loop
              if v8_ShiftedXgmiiRxC_s(Index) = '0' then
                ov64_RawData_p(Index * 8 + 8 - 1 downto Index * 8) <= v64_ShiftedXgmiiRxD_s(Index * 8 + 8 - 1 downto Index * 8);
              else
                ov64_RawData_p(Index * 8 + 8 - 1 downto Index * 8) <= IdleXGMIICode_c;
              end if;
            end loop;

          when others =>
            for Index in 0 to 7 loop
              ov64_RawData_p(Index * 8 + 8 - 1 downto Index * 8) <= IdleXGMIICode_c;
            end loop;
        end case;
      end if;
    end if;
  end process ov64_RawData_l;


  -- .
  v8_ByteValid_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v8_ByteValid_s <= (others => '0');
      else
        case State_s is
          when StripSOP_c | TransferPacketBody_c =>
            v8_ByteValid_s <= x"FF";

          when StripEOP_c =>
            v8_ByteValid_s <= not v8_ShiftedXgmiiRxC_s;
          when others =>
            v8_ByteValid_s <= x"00";
        end case;
      end if;
    end if;
  end process v8_ByteValid_l;
  ov8_ByteValid_p <= v8_ByteValid_s;

  o_WriteData_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_WriteData_p <= '0';
      else
        case State_s is
          when StripSOP_c | TransferPacketBody_c =>
            o_WriteData_p <= '1';

          when others =>
            o_WriteData_p <= '0';
        end case;

      end if;
    end if;
  end process o_WriteData_l;

  o_EndOfPacket_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_EndOfPacket_p <= '0';
      else
        if State_s = TransferPacketBody_c and iv8_XgmiiRxC_p /= x"00" then
          o_EndOfPacket_p <= '1';
        else
          o_EndOfPacket_p <= '0';
        end if;
      end if;
    end if;
  end process o_EndOfPacket_l;

  o_FifoOverRun_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_FifoOverRun_p <= '0';
      else
        if v8_ByteValid_s(0) = '1' and i_FifoFull_p = '1' then
          o_FifoOverRun_p <= '1';
        else
          o_FifoOverRun_p <= '0';
        end if;
      end if;
    end if;
  end process o_FifoOverRun_l;

end architecture beh;

