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
-- File        : $Id: packetgen_beh_a.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: packetgen_beh_a.vhd,v $
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


architecture beh of PacketGen is

  -- Return the bigger value of x or y.
  function Max(x : integer; y : integer) return integer is
  begin
    if (x >= y) then
      return x;
    else
      return y;
    end if;
  end Max;

  -- Architecture's local constants, types, signals  functions.
--  constant OnesUns_c                  : unsigned(31 downto 0) := (others => '1'); -- .
  constant ZerosUns_c                 : unsigned(31 downto 0) := (others => '0'); -- .

  type State_t is
    (
      Idle_c,
      LoadActiveCntr_c,
      GenerateSOP_c,
      GenerateOpticalHeader_c,
      ActiveTime_c,
      ManageLastDataColumn_c,
      LoadInactiveCntr_c,
      InactiveTime_c
    );

  type ByteRamp_t is array(7 downto 0) of std_logic_vector(7 downto 0);


  ----------------------------------------------------------------------------
  --  Declaration des signaux internes.
  ----------------------------------------------------------------------------
  signal State_s                    : State_t;

  signal a_ByteRamp_s               : ByteRamp_t;


  signal XnorResult_s               : std_logic;
  signal DataOutputValid_s          : std_logic;

  signal v_cntSentPacket_s          : unsigned(PacketStatCntrWidth_g - 1 downto 0);
  signal v_cntStalledPacket_s       : unsigned(PacketStatCntrWidth_g - 1 downto 0);

  signal v_PacketSizeComp_s         : unsigned(PacketSizeCntrWidth_g - 3 - 1 downto 0);

  signal v_cntDutyCycleUnit_s       : unsigned(Max(PacketSizeCntrWidth_g - 3, OffTimeCntrWidth_g) - 1 downto 0);

  signal v8_ByteRamp0_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp1_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp2_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp3_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp4_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp5_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp6_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp7_s             : unsigned(7 downto 0); -- .
  signal v8_ByteRamp8_s             : unsigned(7 downto 0); -- .

  signal v64_LFSR_s                 : std_logic_vector(63 downto 0); -- .
  signal v72_ShiftedByteRamp_s      : std_logic_vector(71 downto 0); -- .
  signal v64_PacketBody_s           : std_logic_vector(63 downto 0); -- .

  signal v8_ByteValid_s             : std_logic_vector(7 downto 0); -- .

begin

  -- .
  State_l : process (i_clk_p)
  begin
    State_s <= State_s;
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        State_s <= Idle_c;
      else
        case State_s is
          when Idle_c =>
            if i_GenerateEnable_p = '1' then
              State_s <= LoadActiveCntr_c;
            end if;

          when LoadActiveCntr_c =>
            State_s <= ActiveTime_c;

          when ActiveTime_c =>
            if v_cntDutyCycleUnit_s = 1 then
              State_s <= ManageLastDataColumn_c;
            end if;

          when ManageLastDataColumn_c =>
            State_s <= LoadInactiveCntr_c;

          when LoadInactiveCntr_c =>
            State_s <= InactiveTime_c;

          when InactiveTime_c =>
            if v_cntDutyCycleUnit_s = 1 then
              if i_GenerateEnable_p = '1' then
                State_s <= LoadActiveCntr_c;
              else
                State_s <= Idle_c;
              end if;
            end if;

          when others =>
            State_s <= Idle_c;
        end case;
      end if;
    end if;
  end process State_l;


  v_PacketSizeComp_s <= unsigned(iv_PacketSize_p(iv_PacketSize_p'high downto 3)) when iv_PacketSize_p(2 downto 0) = "000" else
                        unsigned(iv_PacketSize_p(iv_PacketSize_p'high downto 3)) + 1;

  cntDutyCycleUnit_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v_cntDutyCycleUnit_s <= (others => '0');
      else
        case State_s is
          when LoadActiveCntr_c =>
            v_cntDutyCycleUnit_s <= ZerosUns_c(v_cntDutyCycleUnit_s'high downto iv_PacketSize_p'high + 1) & v_PacketSizeComp_s;

          when LoadInactiveCntr_c =>
            v_cntDutyCycleUnit_s <= ZerosUns_c(v_cntDutyCycleUnit_s'high downto iv_DutyCycleOffTime_p'high + 1) & unsigned(iv_DutyCycleOffTime_p);

          when ActiveTime_c | InactiveTime_c =>
            v_cntDutyCycleUnit_s <= v_cntDutyCycleUnit_s - 1;
          when others =>
        end case;
      end if;
    end if;
  end process cntDutyCycleUnit_l;


  ByteRampx_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        for Index in 0 to 6 loop
          a_ByteRamp_s(Index) <= x"00";
        end loop;
        a_ByteRamp_s(7) <= (others => '0');

      else
        for Index in 0 to 6 loop
          a_ByteRamp_s(Index) <= a_ByteRamp_s(Index + 1);
        end loop;
        a_ByteRamp_s(7) <= std_logic_vector(unsigned(a_ByteRamp_s(7)) + 1);

      end if;
    end if;
  end process ByteRampx_l;


  -- .
  LFSR_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v64_LFSR_s <= (others => '0');
      else
        if State_s = Idle_c then
          v64_LFSR_s <= iv64_SeedCode_p;
        elsif State_s = ActiveTime_c or State_s = ManageLastDataColumn_c then
          v64_LFSR_s <= v64_LFSR_s(v64_LFSR_s'high - 1 downto 0) & XnorResult_s;

        end if;
      end if;
    end if;
  end process LFSR_l;

  -- .
  XnorResult_l : process (i_clk_p)
  begin
      XnorResult_s <= v64_LFSR_s(63) xnor v64_LFSR_s(62) xnor v64_LFSR_s(60) xnor v64_LFSR_s(59);
  end process XnorResult_l;


  v64_PacketBody_s <= a_ByteRamp_s(7) & a_ByteRamp_s(6) & a_ByteRamp_s(5) & a_ByteRamp_s(4) & a_ByteRamp_s(3) & a_ByteRamp_s(2) & a_ByteRamp_s(1) & a_ByteRamp_s(0) when i_ShiftedByteRampEn_p = '1' else
                      v64_LFSR_s;

  -- .
  ov64_DataOut_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      ov64_DataOut_p <= (others => '0');

      if i_Reset_p = '1' then
        ov64_DataOut_p <= (others => '0');
      else
        case State_s is
          when ActiveTime_c =>
            ov64_DataOut_p <= v64_PacketBody_s;

          when ManageLastDataColumn_c =>
            for Index in 0 to 7 loop
              if Index < unsigned(iv_PacketSize_p(2 downto 0)) then
                ov64_DataOut_p(Index * 8 + 8 - 1 downto Index * 8) <= v64_PacketBody_s(Index * 8 + 8 - 1 downto Index * 8);
              else
                ov64_DataOut_p(Index * 8 + 8 - 1 downto Index * 8) <= IdleXGMIICode_c;
              end if;
            end loop;

          when others =>
            for Index in 0 to 7 loop
              ov64_DataOut_p(Index * 8 + 8 - 1 downto Index * 8) <= IdleXGMIICode_c;
            end loop;
        end case;
      end if;
    end if;
  end process ov64_DataOut_l;

  -- .
  v8_ByteValid_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v8_ByteValid_s <= (others => '0');
      else
        case State_s is
          when ActiveTime_c =>
            v8_ByteValid_s <= x"FF";

          when ManageLastDataColumn_c =>
            for Index in 0 to 7 loop
              if Index < unsigned(iv_PacketSize_p(2 downto 0)) then
                v8_ByteValid_s(Index) <= '1';
              else
                v8_ByteValid_s(Index) <= '0';
              end if;
            end loop;

          when others =>
            v8_ByteValid_s <= x"00";
        end case;
      end if;
    end if;
  end process v8_ByteValid_l;
  ov8_ByteValid_p <= v8_ByteValid_s;


  o_EndOfPacket_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_EndOfPacket_p <= '0';
      else
        if State_s = ActiveTime_c and v_cntDutyCycleUnit_s = 1 then
          o_EndOfPacket_p <= '1';
        else
          o_EndOfPacket_p <= '0';
        end if;
      end if;
    end if;
  end process o_EndOfPacket_l;


  o_FifoWrEn_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_FifoWrEn_p <= '0';
      else
        case State_s is
          when ActiveTime_c =>

            o_FifoWrEn_p <= '1';

          when others =>
            o_FifoWrEn_p <= '0';
        end case;
      end if;
    end if;
  end process o_FifoWrEn_l;


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


  DataOutputValid_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        DataOutputValid_s <= '0';
      else
        case State_s is
          when Idle_c | LoadActiveCntr_c =>
            DataOutputValid_s <= '1';

          when others =>
            if v8_ByteValid_s(0) = '1' and i_FifoFull_p = '1' then
              DataOutputValid_s <= '0';
            end if;
        end case;
      end if;
    end if;
  end process DataOutputValid_l;


  -- .
  cntPacketStat_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v_cntSentPacket_s <= (others => '0');
        v_cntStalledPacket_s <= (others => '0');
      else
        if State_s = LoadActiveCntr_c then
          if DataOutputValid_s = '1' then
            v_cntSentPacket_s <= v_cntSentPacket_s + 1;
          else
            v_cntStalledPacket_s <= v_cntStalledPacket_s + 1;
          end if;
        end if;
      end if;
    end if;
  end process cntPacketStat_l;
  ov_cntSentPacket_p <= std_logic_vector(v_cntSentPacket_s);
  ov_cntStalledPacket_p <= std_logic_vector(v_cntStalledPacket_s);

end architecture beh;

