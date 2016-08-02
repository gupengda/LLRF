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
-- File        : $Id: packetchecker_beh_a.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: packetchecker_beh_a.vhd,v $
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


architecture beh of PacketChecker is

  -- Architecture's local constants, types, signals  functions.

  type State_t is
    (
      Idle_c,
      LatchInternalHdrParam_c,
      LatchOpticalHdrParam_c,
      LatchOffsetDataColumn_c,
      LoadLFSR_c,
      CompareFieldInPacket_c,
      ProcessPartialWord_c,
      ValidatePacketIntegrity_c,
      UpdateStatCounter_c
    );


  signal State_s                    : State_t;

  signal XnorResult_s               : std_logic;
  signal CompFieldInPacketBody_s    : std_logic;
  signal PacketValid_s              : std_logic;

  signal v64_LFSR_s                 : std_logic_vector(63 downto 0); -- .
  signal v72_LFSRModified_s         : std_logic_vector(63 downto 0); -- .

  signal v64_DataInD1_s             : std_logic_vector(63 downto 0); -- .
  signal v64_DataInD2_s             : std_logic_vector(63 downto 0); -- .

  signal v8_ByteValidD1_s           : std_logic_vector(7 downto 0); -- .
  signal v8_ByteValidD2_s           : std_logic_vector(7 downto 0); -- .

  signal v_cntRxValidSimPacket_s   : unsigned(PacketCounterSize_g - 1 downto 0); -- .
  signal v_cntRxCorruptSimPacket_s : unsigned(PacketCounterSize_g - 1 downto 0); -- .

  signal DestinationNodeIDValid_s   : std_logic; -- .
  signal PcktContentTypeValid_s     : std_logic; -- .
  signal WrappedPcktValid_s         : std_logic; -- .
  signal ResentPcktValid_s          : std_logic; -- .
  signal ProtocolUpdateValid_s      : std_logic; -- .
  signal BadDecadeTagValid_s        : std_logic; -- .


begin

  v64_DataInD1_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v64_DataInD1_s <= (others => '0');
        v8_ByteValidD1_s <= (others => '0');
      else
        v64_DataInD1_s <= iv64_DataIn_p;
        v8_ByteValidD1_s <= iv8_ByteValid_p;
      end if;
    end if;
  end process v64_DataInD1_l;




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
            if i_FifoEmpty_p = '0' and i_EndOfPacket_p = '0' then

              State_s <= LoadLFSR_c;
            end if;

          when LoadLFSR_c =>
            State_s <= ValidatePacketIntegrity_c;

          when ValidatePacketIntegrity_c =>

            if i_EndOfPacket_p = '1' then
              State_s <= UpdateStatCounter_c;
            end if;

          when UpdateStatCounter_c =>
              State_s <= Idle_c;

          when others => --
            State_s <= Idle_c;
        end case;
      end if;
    end if;
  end process State_l;


  -- .
  ReadData_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        o_ReadData_p <= '0';
      else
        case State_s is
          when Idle_c =>
            if i_FifoEmpty_p = '0' and i_EndOfPacket_p = '0' then
              o_ReadData_p <= '1';
            else
              o_ReadData_p <= '0';
            end if;

          when LoadLFSR_c =>
            o_ReadData_p <= '1';

          when ValidatePacketIntegrity_c =>

            if i_EndOfPacket_p = '0' then
              o_ReadData_p <= '1';
            else
              o_ReadData_p <= '0';
            end if;

          when others =>
            o_ReadData_p <= '0';
        end case;
      end if;
    end if;
  end process ReadData_l;


  -- .
  v64_LFSR_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then

      if i_Reset_p = '1' then
        v64_LFSR_s <= (others => '0');
      else
        if State_s = LoadLFSR_c then
          v64_LFSR_s <= v64_DataInD1_s;

        elsif State_s = ValidatePacketIntegrity_c then

          v64_LFSR_s <= v64_LFSR_s(v64_LFSR_s'high - 1 downto 0) & XnorResult_s;
        end if;
      end if;
    end if;
  end process v64_LFSR_l;

  -- .
  XnorResult_l : process (i_clk_p)
  begin
      XnorResult_s <= v64_LFSR_s(63) xnor v64_LFSR_s(62) xnor v64_LFSR_s(60) xnor v64_LFSR_s(59);
  end process XnorResult_l;


  -- .
  PacketValid_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        PacketValid_s <= '0';
      else
        case State_s is
          when Idle_c | UpdateStatCounter_c =>
            PacketValid_s <= '1';

          when ValidatePacketIntegrity_c =>
            for Index in 0 to 7 loop
              if v8_ByteValidD1_s(Index) = '1' and v64_LFSR_s(Index * 8 + 8 - 1 downto Index * 8) /= v64_DataInD1_s(Index * 8 + 8 - 1 downto Index * 8) then
                PacketValid_s <= '0';
              end if;
            end loop;
          when others =>
        end case;
      end if;
    end if;
  end process PacketValid_l;


  -- .
  cntRxPacket_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' or i_ResetErrCnt_p = '1' then
        v_cntRxValidSimPacket_s <= (others => '0');
        v_cntRxCorruptSimPacket_s <= (others => '0');
      else

        if State_s = UpdateStatCounter_c then

          if PacketValid_s = '1' then
            v_cntRxValidSimPacket_s <= v_cntRxValidSimPacket_s + 1;
          else
            v_cntRxCorruptSimPacket_s <= v_cntRxCorruptSimPacket_s + 1;
          end if;
        end if;
      end if;
    end if;
  end process cntRxPacket_l;

  ov_cntRxValidPacket_p <= std_logic_vector(v_cntRxValidSimPacket_s);
  ov_cntRxCorruptPacket_p <= std_logic_vector(v_cntRxCorruptSimPacket_s);

end architecture beh;

