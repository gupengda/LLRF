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
-- File        : $Id: lyt_mestor_mbb1_rtl_a.vhd,v 1.4 2011/02/21 22:00:23 francois.blackburn Exp $
--------------------------------------------------------------------------------
-- Description : I/O ring file.
--               Generated by generate_ioring_v2.pl (2.06)
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2010 Lyrtech RD inc.
--------------------------------------------------------------------------------
-- $Log: lyt_mestor_mbb1_rtl_a.vhd,v $
-- Revision 1.4  2011/02/21 22:00:23  francois.blackburn
-- change core name
--
-- Revision 1.3  2010/09/29 21:27:34  francois.blackburn
-- fix bit shift bug
--
-- Revision 1.2  2010/06/18 14:19:43  francois.blackburn
-- change LYR for lyt
--
-- Revision 1.1  2010/04/01 17:55:15  francois.blackburn
-- first commit
--
--------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use ieee.numeric_std.all;

library UNISIM;
  use UNISIM.vcomponents.all;

architecture rtl of lyt_mestor_mbb1 is

  signal v4_DpioFromMestorRise_s   : std_logic_vector(3 downto 0);
  signal v4_DpioFromMestorFall_s   : std_logic_vector(3 downto 0);
  signal v8_DpioFRomMestor_s : std_logic_vector(7 downto 0);

  signal v2_adcDataRise_s   : std_logic_vector(1 downto 0);
  signal v2_adcDataFall_s   : std_logic_vector(1 downto 0);

  signal v4_Dpio2MestorRise_s : std_logic_vector(3 downto 0);
  signal v4_Dpio2MestorFall_s : std_logic_vector(3 downto 0);


  signal ClkOut_s : std_logic;
  signal dp_ClkOut_s : std_logic;
  signal dn_ClkOut_s : std_logic;

  signal DlyCtrlRdy_s : std_logic;

  signal v13_AdcData0_s : std_logic_vector(12 downto 0);
  signal v13_AdcData1_s : std_logic_vector(12 downto 0);
  signal v13_AdcData2_s : std_logic_vector(12 downto 0);
  signal v13_AdcData3_s : std_logic_vector(12 downto 0);

  signal v13_AdcData0D1_s : std_logic_vector(12 downto 0);
  signal v13_AdcData1D1_s : std_logic_vector(12 downto 0);
  signal v13_AdcData2D1_s : std_logic_vector(12 downto 0);
  signal v13_AdcData3D1_s : std_logic_vector(12 downto 0);


  signal v2_DataMuxCnt_s : integer range 0 to 3;
  signal v2_DataDemuxCnt_s : integer range 0 to 3;
  signal v4_AdcMuxCnt_s : integer range 0 to 12;
  signal v5_MuxDemConfCnt_s : integer range 0 to 31;

  signal DpioConfigRise_s : std_logic;
  signal DpioConfigFall_s : std_logic;
  signal v2_DpioConfig_s : std_logic_vector(1 downto 0);

  signal v32_GpioDOut_s : std_logic_vector(31 downto 0);
  signal v8_DpioOutReg_s : std_logic_vector(7 downto 0);

  signal v32_GpioDOutD1_s : std_logic_vector(31 downto 0);
  signal AdcSet_s : std_logic;


  signal v7_OutputDataD1_s    : std_logic_vector(6 downto 0);
  signal v7_OutputDataRise_s  : std_logic_vector(6 downto 0);
  signal v7_OutputDataFall_s  : std_logic_vector(6 downto 0);
  signal v7_OutputDataDelay_s : std_logic_vector(6 downto 0);
  signal v7dp_OutputData_s    : std_logic_vector(6 downto 0);
  signal v7dn_OutputData_s    : std_logic_vector(6 downto 0);

  signal v7_InputData_s      : std_logic_vector(6 downto 0);
  signal v7_InputDataRise_s  : std_logic_vector(6 downto 0);
  signal v7_InputDataFall_s  : std_logic_vector(6 downto 0);
  signal v7_InputDataDelay_s : std_logic_vector(6 downto 0);
  signal v7dp_InputData_s    : std_logic_vector(6 downto 0);
  signal v7dn_InputData_s    : std_logic_vector(6 downto 0);

  signal DpioResetAck_s   : std_logic;
  signal DpioResetAckD1_s : std_logic;
  signal AdcResetAck_s   : std_logic;

  signal SetGpioDirD1_s : std_logic;
  signal SetGpioDirRise_s : std_logic;

  signal v3_StartD_s : std_logic_vector(2 downto 0);
  signal StartRise_s : std_logic;
  signal v3_ResetD_s : std_logic_vector(2 downto 0);
  signal ResetRise_s : std_logic;
  signal v5_ResetCnt_s : unsigned(4 downto 0);
  signal ResetDly_s : std_logic;

  signal v128_SetDirAck_s : std_logic_vector(127 downto 0);
  
  
  attribute keep : string;
  attribute init : string;
  attribute keep of v8_DpioFRomMestor_s : signal is "true";
  attribute init of v5_ResetCnt_s : signal is "00000";

begin

  o_StartAck_p <= DpioResetAck_s;

  o_SetGpioDirAck_p <= v128_SetDirAck_s(127);
  
  odp_DpioClk_p <= dp_ClkOut_s;
  odn_DpioClk_p <= dn_ClkOut_s;

  o_DelayRdy_p <= DlyCtrlRdy_s;

  ov32_GpioDOut_p <= v32_GpioDOutD1_s;

  ov12_AdcData0_p <= v13_AdcData0D1_s(11 downto 0);
  ov12_AdcData1_p <= v13_AdcData1D1_s(11 downto 0);
  ov12_AdcData2_p <= v13_AdcData2D1_s(11 downto 0);
  ov12_AdcData3_p <= v13_AdcData3D1_s(11 downto 0);

  o_AdcData0Valid_p <= v13_AdcData0D1_s(12);
  o_AdcData1Valid_p <= v13_AdcData1D1_s(12);
  o_AdcData2Valid_p <= v13_AdcData2D1_s(12);
  o_AdcData3Valid_p <= v13_AdcData3D1_s(12);

  ov4dp_Dpio_p <= v7dp_OutputData_s(3 downto 0);
  ov4dn_Dpio_p <= v7dn_OutputData_s(3 downto 0);

  odp_DpioSetDir_p <= v7dp_OutputData_s(4);
  odn_DpioSetDir_p <= v7dn_OutputData_s(4);

  odp_DpioReset_p  <= v7dp_OutputData_s(5);
  odn_DpioReset_p  <= v7dn_OutputData_s(5);

  odp_DpioConfig_p <= v7dp_OutputData_s(6);
  odn_DpioConfig_p <= v7dn_OutputData_s(6);

  v4_Dpio2MestorRise_s <= v8_DpioOutReg_s(7 downto 4);
  v4_Dpio2MestorFall_s <= v8_DpioOutReg_s(3 downto 0);

  v7_OutputDataRise_s <= DpioConfigRise_s & StartRise_s & SetGpioDirRise_s & v4_Dpio2MestorRise_s;
  v7_OutputDataFall_s <= DpioConfigFall_s & StartRise_s & SetGpioDirRise_s & v4_Dpio2MestorFall_s;

  v7dp_InputData_s <= idp_DpioResetAck_p & iv2dp_AdcData_p & iv4dp_Dpio_p;
  v7dn_InputData_s <= idn_DpioResetAck_p & iv2dn_AdcData_p & iv4dn_Dpio_p;

  v4_DpioFromMestorRise_s <= v7_InputDataRise_s(3 downto 0);
  v4_DpioFromMestorFall_s <= v7_InputDataFall_s(3 downto 0);

  v2_adcDataRise_s <= v7_InputDataRise_s(5 downto 4);
  v2_adcDataFall_s <= v7_InputDataFall_s(5 downto 4);

  DpioConfigRise_s <= v2_DpioConfig_s(1);
  DpioConfigFall_s <= v2_DpioConfig_s(0);

  DpioResetAck_s <= v7_InputDataRise_s(6);
  AdcResetAck_s <= v7_InputDataFall_s(6);


  RisingEdgeDetectProc_l : process( i_SysClk_p )
  begin
    if( rising_edge( i_SysClk_p ) ) then
      SetGpioDirD1_s <= i_SetGpioDir_p;
      v3_StartD_s <= v3_StartD_s( 1 downto 0 ) & i_Start_p;
      v3_ResetD_s <= v3_ResetD_s( 1 downto 0 ) & i_Reset_p;
      ResetDly_s <= '0';

      if( v5_ResetCnt_s /= "00000" ) then
        v5_ResetCnt_s <= v5_ResetCnt_s - 1;
        ResetDly_s <= '1';
      end if;

      if( ResetRise_s = '1' ) then
        v5_ResetCnt_s <= (others => '1');
      end if;

    end if;
  end process;

  ResetRise_s <= (not v3_ResetD_s(2)) and v3_ResetD_s(1);

  SetGpioDirRise_s <= ( not SetGpioDirD1_s ) and  i_SetGpioDir_p;
  StartRise_s <= ( not v3_StartD_s(2) ) and  v3_StartD_s(1);

  v8_DpioFRomMestor_s <= v4_DpioFromMestorRise_s & v4_DpioFromMestorFall_s;

  DataCntProcess_l : process( i_SysClk_p )
  begin
    if( rising_edge( i_SysClk_p ) ) then

      v128_SetDirAck_s <= v128_SetDirAck_s(126 downto 0) & SetGpioDirRise_s;
    
      DpioResetAckD1_s <= DpioResetAck_s;

      if( DpioResetAckD1_s = '1' ) then
         v2_DataDemuxCnt_s <= 0;
         v32_GpioDOutD1_s <= v32_GpioDOut_s;
      else
         v2_DataDemuxCnt_s <= v2_DataDemuxCnt_s + 1;
      end if;

      if( DlyCtrlRdy_s = '0' ) then
        v32_GpioDOut_s <= ( others => '0' );
      else
        v32_GpioDOut_s( ( 8*( v2_DataDemuxCnt_s + 1)) - 1 downto ( 8 * v2_DataDemuxCnt_s ) ) <= v8_DpioFRomMestor_s;
      end if;

      if( StartRise_s = '1' ) then
        v2_DataMuxCnt_s <= 0;
      else
        v2_DataMuxCnt_s <= v2_DataMuxCnt_s + 1;
        v8_DpioOutReg_s <= iv32_GpioDIn_p( ( 8*( v2_DataMuxCnt_s + 1)) - 1 downto ( 8 * v2_DataMuxCnt_s ) );
      end if;

    end if;
  end process;

  AdcDataCntProcess_l : process( i_SysClk_p )
  begin
    if( rising_edge( i_SysClk_p ) ) then

      if( DlyCtrlRdy_s = '0' ) then
        AdcSet_s <= '0';
        v4_AdcMuxCnt_s <= 0;
        v13_AdcData0D1_s <= (others => '0');
        v13_AdcData1D1_s <= (others => '0');
        v13_AdcData2D1_s <= (others => '0');
        v13_AdcData3D1_s <= (others => '0');

      else
        v4_AdcMuxCnt_s <= v4_AdcMuxCnt_s + 1;

        if( AdcSet_s = '1' ) then
          v13_AdcData0D1_s <= v13_AdcData0_s;
          v13_AdcData1D1_s <= v13_AdcData1_s;
          v13_AdcData2D1_s <= v13_AdcData2_s;
          v13_AdcData3D1_s <= v13_AdcData3_s;
          AdcSet_s <= '0';
        elsif( AdcResetAck_s = '1' ) then
          AdcSet_s <= '1';
          v4_AdcMuxCnt_s <= 0;
        end if;

        v13_AdcData0_s(v4_AdcMuxCnt_s) <= v2_adcDataRise_s(0);
        v13_AdcData1_s(v4_AdcMuxCnt_s) <= v2_adcDataFall_s(0);
        v13_AdcData2_s(v4_AdcMuxCnt_s) <= v2_adcDataRise_s(1);
        v13_AdcData3_s(v4_AdcMuxCnt_s) <= v2_adcDataFall_s(1);
      end if;
    end if;
  end process;

  ConfigCntProcess_l : process( i_SysClk_p )
  begin
    if( rising_edge( i_SysClk_p ) ) then
      if( SetGpioDirRise_s = '1' ) then
        v2_DpioConfig_s <= (others =>'0');
        v5_MuxDemConfCnt_s <= 0;
      else
        if( v5_MuxDemConfCnt_s /= 31 ) then
          v5_MuxDemConfCnt_s <= v5_MuxDemConfCnt_s + 1;
          v2_DpioConfig_s <= iv32_GpioDir_p( ( 2*( v5_MuxDemConfCnt_s + 1)) - 1 downto ( 2 * v5_MuxDemConfCnt_s ) );
        end if;
      end if;
    end if;
  end process;



  IdelayCtrl_l : IdelayCtrl
  port map
  (
    rdy    => DlyCtrlRdy_s,
    refclk => i_SysClk_p,
    rst    => ResetDly_s
  );

  Clkout_l : ODDR
  generic map
  (
    DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
    INIT         => '0',    -- Initial value of Q: '0' or '1'
    SRTYPE       => "ASYNC"
  ) -- Set/Reset type: "SYNC" or "ASYNC"
  port map
  (
    Q  => ClkOut_s,  -- 1-bit DDR output
    C  => i_SysClk_p,  -- 1-bit clock input
    CE => '1', -- 1-bit clock enable input
    D1 => '1', -- 1-bit data input (positive edge)
    D2 => '0', -- 1-bit data input (negative edge)
    R  => '0',  -- 1-bit reset
    S  => '0'   -- 1-bit set
  );


  ObufClk_l : OBUFDS
  port map
  (
    --I => '0',
    I  =>  ClkOut_s,
    O  =>  dp_ClkOut_s,
    OB =>  dn_ClkOut_s
  );

  InputCaptureGen_l : for i in 0 to 6
  generate

    Ibufgds_l : IBUFDS
    generic map
    (
        DIFF_TERM  => TRUE
    )
    port map
    (
        O   =>  v7_InputData_s(i),
        I   =>  v7dp_InputData_s(i),
        IB  =>  v7dn_InputData_s(i)
    );

    InputDelay1_l : IODELAYE1
    GENERIC MAP
    (
      ODELAY_TYPE => "FIXED",
      IDELAY_TYPE => "FIXED",
      DELAY_src=> "I",
      REFCLK_FREQUENCY => 200.0,
      HIGH_PERFORMANCE_MODE => TRUE,
      SIGNAL_PATTERN => "DATA",
      IDELAY_VALUE => 0,
      ODELAY_VALUE => 0
    )
    PORT MAP
    (
        CNTVALUEIN => "00000",
        CNTVALUEOUT => open,
        DATAOUT => v7_InputDataDelay_s(i),
        CINVCTRL => '0',
        C => i_SysClk_p,
        CLKIN =>i_SysClk_p,
        CE => '0',
        datain => '0',
        ODATAIN  => '0',
        IDATAIN => v7_InputData_s(i),
        INC => '0',
        T => '1',
        RST => '0'
     );


    IddrDataIn : IDDR
    generic map
    (
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",
      SRTYPE => "SYNC"
    )
    port map
    (
      Q1 => v7_InputDataRise_s(i), -- 1-bit output for positive edge of clock
      Q2 => v7_InputDataFall_s(i), -- 1-bit output for negative edge of clock
      C => i_SysClk_p,   -- 1-bit clock input
      CE => '1', -- 1-bit clock enable input
      D => v7_InputDataDelay_s(i),   -- 1-bit DDR data input
      R => '0',   -- 1-bit reset
      S => '0'    -- 1-bit set
    );

  end generate;

  OutputCaptureGen_l : for i in 0 to 6
  generate

     OutputDelay1_l : IODELAYE1
      GENERIC MAP (
       ODELAY_TYPE => "FIXED",
       IDELAY_TYPE => "FIXED",
       DELAY_src=> "O",
       REFCLK_FREQUENCY => 200.0,
       SIGNAL_PATTERN => "DATA",
       HIGH_PERFORMANCE_MODE => TRUE,
       IDELAY_VALUE => 0,
       ODELAY_VALUE => 13)
      PORT MAP
      (
         CNTVALUEIN => "00000",
         CNTVALUEOUT => open,
         DATAOUT => v7_OutputDataDelay_s(i),
         CINVCTRL => '0',
         C => i_SysClk_p,
         CLKIN => i_SysClk_p,
         CE => '0',
         datain => '0',
         ODATAIN  => v7_OutputDataD1_s(i),
         IDATAIN => '0',
         INC => '0',
         T => '0',
         RST => '0'
     );


   OddrDataOut : ODDR
   generic map
   (
      DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
      INIT => '0',      -- Initial value of Q: '0' or '1'
      SRTYPE => "ASYNC"
   ) -- Set/Reset type: "SYNC" or "ASYNC"
   port map
   (
      Q => v7_OutputDataD1_s(i),   -- 1-bit DDR output
      C => i_SysClk_p,   -- 1-bit clock input
      CE => '1', -- 1-bit clock enable input
      D1 => v7_OutputDataRise_s(i), -- 1-bit data input (positive edge)
      D2 => v7_OutputDataFall_s(i), -- 1-bit data input (negative edge)
      R => '0',   -- 1-bit reset
      S => '0'    -- 1-bit set
   );

   ObufC2m_l : OBUFDS
   port map
   (
     I  =>  v7_OutputDataDelay_s(i),
     --I => '0',
     O  =>  v7dp_OutputData_s(i),
     OB =>  v7dn_OutputData_s(i)
   );

  end generate;


end architecture rtl;

