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
-- File        : $Id: rawdata2xgmii_beh_a.vhd,v 1.1 2013/03/20 19:59:52 julien.roy Exp $
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
-- $Log: rawdata2xgmii_beh_a.vhd,v $
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

architecture beh of RawData2Xgmii is

  -- Architecture's local constants, types, signals  functions.

  type State_t is
    (
      Idle_c,
      LoadActiveCntr_c,
      GenerateSOP_c,
      GenerateOpticalHeader_c,

      TransferPacketBody_c,
      GenerateEOP_c,
      IPGPause_c,
      InactiveTime_c,
      Unused7_c
    );

  type ByteRamp_t is array(7 downto 0) of std_logic_vector(7 downto 0);


  ----------------------------------------------------------------------------
  --  Declaration des signaux internes.
  ----------------------------------------------------------------------------
  signal State_s                    : State_t;


  signal v64_RawDataD1_s            : std_logic_vector(63 downto 0); -- .
  signal v8_ByteEnableD1_s          : std_logic_vector(7 downto 0); -- .

  signal v64_ShiftedRawData_s       : std_logic_vector(63 downto 0); -- .
  signal v64_ShiftedRawDataD1_s     : std_logic_vector(63 downto 0); -- .
  signal v8_ShiftedByteEnable_s     : std_logic_vector(7 downto 0); -- .

  signal ReadData_s                 : std_logic; -- .

begin

  InputsD1_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v64_RawDataD1_s <= (others => '0');
        v8_ByteEnableD1_s <= (others => '0');
      else
        v64_RawDataD1_s <= iv64_RawData_p;
        v8_ByteEnableD1_s <= iv8_ByteEnable_p;
      end if;
    end if;
  end process InputsD1_l;

  v64_ShiftedRawData_s <= iv64_RawData_p(55 downto 0) & v64_RawDataD1_s(63 downto 56);

  v8_ShiftedByteEnable_s <= iv8_ByteEnable_p(6 downto 0) & v8_ByteEnableD1_s(7) when ReadData_s = '1' else
                            "0000000" & v8_ByteEnableD1_s(7);

  ShiftedInputsD1_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        v64_ShiftedRawDataD1_s <= (others => '0');
      else
        v64_ShiftedRawDataD1_s <= v64_ShiftedRawData_s;
      end if;
    end if;
  end process ShiftedInputsD1_l;

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
              State_s <= GenerateSOP_c;
            end if;

          when GenerateSOP_c =>
            State_s <= TransferPacketBody_c;

          when TransferPacketBody_c =>
            if i_EndOfPacket_p = '1' then
              State_s <= GenerateEOP_c;
            end if;

          when GenerateEOP_c =>
            State_s <= Idle_c;

          when others =>
            State_s <= Idle_c;
        end case;
      end if;
    end if;
  end process State_l;


  -- .
  ov64_XgmiiTxD_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      ov64_XgmiiTxD_p <= (others => '0');

      if i_Reset_p = '1' then
        ov64_XgmiiTxD_p <= (others => '0');
      else
        case State_s is
          when GenerateSOP_c =>
            ov64_XgmiiTxD_p(7 downto 0) <= StartOfPckt27K7CodeS_c;
            ov64_XgmiiTxD_p(63 downto 8) <= v64_ShiftedRawData_s(63 downto 8);

          when TransferPacketBody_c | GenerateEOP_c =>
            for Index in 0 to 7 loop
              if v8_ShiftedByteEnable_s(Index) = '1' then
                ov64_XgmiiTxD_p(Index * 8 + 8 - 1 downto Index * 8) <= v64_ShiftedRawData_s(Index * 8 + 8 - 1 downto Index * 8);
              else
                if (Index > 0) and (v8_ShiftedByteEnable_s(Index - 1) = '1') then
                  ov64_XgmiiTxD_p(Index * 8 + 8 - 1 downto Index * 8) <= EndOfPckt29K7CodeT_c;
                else
                  ov64_XgmiiTxD_p(Index * 8 + 8 - 1 downto Index * 8) <= IdleXGMIICode_c;
                end if;
              end if;
            end loop;

          when others =>
            for Index in 0 to 7 loop
              ov64_XgmiiTxD_p(Index * 8 + 8 - 1 downto Index * 8) <= IdleXGMIICode_c;
            end loop;
        end case;
      end if;
    end if;
  end process ov64_XgmiiTxD_l;


  -- .
  ov8_XgmiiTxC_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        ov8_XgmiiTxC_p <= (others => '0');
      else
        case State_s is
          when GenerateSOP_c =>
            ov8_XgmiiTxC_p <= x"01";

          when TransferPacketBody_c | GenerateEOP_c =>
            ov8_XgmiiTxC_p <= not v8_ShiftedByteEnable_s;

          when others =>
            ov8_XgmiiTxC_p <= x"FF";
        end case;
      end if;
    end if;
  end process ov8_XgmiiTxC_l;

  ReadData_l : process (i_clk_p)
  begin
    if rising_edge(i_clk_p) then
      if i_Reset_p = '1' then
        ReadData_s <= '0';
      else
        case State_s is
          when Idle_c =>
            if i_FifoEmpty_p = '0' and i_EndOfPacket_p = '0' then

              ReadData_s <= '1';
            else
              ReadData_s <= '0';
            end if;

          when GenerateSOP_c =>
            ReadData_s <= '1';

          when TransferPacketBody_c =>
            if i_EndOfPacket_p = '1' then
              ReadData_s <= '0';
            else
              ReadData_s <= '1';
            end if;

          when others =>
            ReadData_s <= '0';
        end case;
      end if;
    end if;
  end process ReadData_l;
  o_ReadData_p <= ReadData_s;

end architecture beh;

