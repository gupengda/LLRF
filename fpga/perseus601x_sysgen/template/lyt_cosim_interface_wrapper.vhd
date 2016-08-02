
library ieee;
  use ieee.std_logic_1164.all;

entity lyt_cosim_interface_wrapper is
generic
(
  RecordPortWidth_g 					: integer := %{recplay_params_rec_port_width};
  PlayBackPortWidth_g 					: integer := %{recplay_params_play_port_width};
  NumberOfRecordPorts_g 				: integer := %{recplay_params_rec_nb_ports};
  NumberOfPlayBackPorts_g 				: integer := %{recplay_params_play_nb_ports};
  Aurora_4_7_user_DATA_width            : integer := %{Aurora_4_7_user_DATA_width};
  Aurora_8_11_user_DATA_width           : integer := %{Aurora_8_11_user_DATA_width};
  Aurora_17_20_user_DATA_width          : integer := %{Aurora_17_20_user_DATA_width};
  lvds_io_params_gen_lvds_io_top_g		: integer := %{lvds_io_params_gen_lvds_io_top};
  lvds_io_params_gen_lvds_io_bottom_g	: integer := %{lvds_io_params_gen_lvds_io_bottom};
  LVDS_DATA_WIDTH_0                     : integer := %{mestor_lvds0_data_width};
  LVDS_DATA_WIDTH_1                     : integer := %{mestor_lvds1_data_width};
  LVDS_DATA_WIDTH_2                     : integer := %{mestor_lvds2_data_width};
  LVDS_DATA_WIDTH_3                     : integer := %{mestor_lvds3_data_width}
);
port
(
  iv8_SysgenBanksel_p  : in std_logic_vector(7 downto 0);
  iv24_SysgenAddr_p    : in std_logic_vector(23 downto 0);
  iv32_SysgenDataIn_p  : in std_logic_vector(31 downto 0);
  i_SysgenWe_p         : in std_logic;
  i_SysgenRe_p         : in std_logic;
  ov32_SysgenDataOut_p : out std_logic_vector(31 downto 0):= (others => '0');
  i_SysgenPciClk_p     : in std_logic;


  ov32_CustomReg0wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg0rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg1wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg1rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg2wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg2rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg3wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg3rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg4wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg4rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg5wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg5rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg6wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg6rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg7wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg7rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg8wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg8rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg9wr_p   : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg9rd_p   : in std_logic_vector(31 downto 0);
  ov32_CustomReg10wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg10rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg11wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg11rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg12wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg12rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg13wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg13rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg14wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg14rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg15wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg15rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg16wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg16rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg17wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg17rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg18wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg18rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg19wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg19rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg20wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg20rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg21wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg21rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg22wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg22rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg23wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg23rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg24wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg24rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg25wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg25rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg26wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg26rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg27wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg27rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg28wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg28rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg29wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg29rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg30wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg30rd_p  : in std_logic_vector(31 downto 0);
  ov32_CustomReg31wr_p  : out std_logic_vector(31 downto 0):= (others => '0');
  iv32_CustomReg31rd_p  : in std_logic_vector(31 downto 0);

  --- RTDEx Emac0 Section ---
  i_RTDEx_Emac0_RxReadyCh0_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh1_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh2_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh3_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh4_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh5_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh6_p				: in std_logic;
  i_RTDEx_Emac0_RxReadyCh7_p				: in std_logic;
  --
  o_RTDEx_Emac0_RxReCh0_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh1_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh2_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh3_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh4_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh5_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh6_p					: out std_logic;
  o_RTDEx_Emac0_RxReCh7_p					: out std_logic;
  --
  iv32_RTDEx_Emac0_RxDataCh0_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh1_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh2_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh3_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh4_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh5_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh6_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_Emac0_RxDataCh7_p				: in std_logic_vector(31 downto 0);
  --
  i_RTDEx_Emac0_RxDataValidCh0_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh1_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh2_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh3_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh4_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh5_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh6_p			: in std_logic;
  i_RTDEx_Emac0_RxDataValidCh7_p			: in std_logic;
  --
  i_RTDEx_Emac0_TxReadyCh0_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh1_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh2_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh3_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh4_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh5_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh6_p				: in std_logic;
  i_RTDEx_Emac0_TxReadyCh7_p				: in std_logic;
  --
  o_RTDEx_Emac0_TxWeCh0_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh1_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh2_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh3_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh4_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh5_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh6_p					: out std_logic;
  o_RTDEx_Emac0_TxWeCh7_p					: out std_logic;
  --
  ov32_RTDEx_Emac0_TxDataCh0_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh1_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh2_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh3_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh4_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh5_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh6_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_Emac0_TxDataCh7_p				: out std_logic_vector(31 downto 0);

  --- RTDEx PCIe Section ---
  i_RTDEx_PCIe_RxReadyCh0_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh1_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh2_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh3_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh4_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh5_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh6_p				: in std_logic;
  i_RTDEx_PCIe_RxReadyCh7_p				: in std_logic;
  --
  o_RTDEx_PCIe_RxReCh0_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh1_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh2_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh3_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh4_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh5_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh6_p					: out std_logic;
  o_RTDEx_PCIe_RxReCh7_p					: out std_logic;
  --
  iv32_RTDEx_PCIe_RxDataCh0_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh1_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh2_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh3_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh4_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh5_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh6_p				: in std_logic_vector(31 downto 0);
  iv32_RTDEx_PCIe_RxDataCh7_p				: in std_logic_vector(31 downto 0);
  --
  i_RTDEx_PCIe_RxDataValidCh0_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh1_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh2_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh3_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh4_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh5_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh6_p			: in std_logic;
  i_RTDEx_PCIe_RxDataValidCh7_p			: in std_logic;
  --
  i_RTDEx_PCIe_TxReadyCh0_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh1_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh2_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh3_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh4_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh5_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh6_p				: in std_logic;
  i_RTDEx_PCIe_TxReadyCh7_p				: in std_logic;
  --
  o_RTDEx_PCIe_TxWeCh0_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh1_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh2_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh3_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh4_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh5_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh6_p					: out std_logic;
  o_RTDEx_PCIe_TxWeCh7_p					: out std_logic;
  --
  ov32_RTDEx_PCIe_TxDataCh0_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh1_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh2_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh3_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh4_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh5_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh6_p				: out std_logic_vector(31 downto 0);
  ov32_RTDEx_PCIe_TxDataCh7_p				: out std_logic_vector(31 downto 0);

--- Record Playback
  o_RecTrigger_p  :    out std_logic := '0';
  ov_RecDataPort0_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort1_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort2_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort3_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort4_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort5_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort6_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort7_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort8_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort9_p :  out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort10_p : out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort11_p : out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort12_p : out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort13_p : out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort14_p : out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  ov_RecDataPort15_p : out std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  o_RecWriteEn_p :     out std_logic := '0';
  i_RecFifoFull_p :    in std_logic;

  o_PlayTriggerIn_p :   out std_logic := '0';
  iv_PlayDataPort0_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort1_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort2_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort3_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort4_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort5_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort6_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort7_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort8_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort9_p :  in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort10_p : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort11_p : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort12_p : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort13_p : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort14_p : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  iv_PlayDataPort15_p : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
  i_PlayValid_p :       in std_logic;
  o_PlayReadEn_p :      out std_logic:= '0';
  i_PlayEmpty_p :       in std_logic;

  i_RecPlayRxRe_p         : in std_logic;
  o_RecPlayRxReady_p      : out std_logic:= '0';
  o_RecPlayRxDataValid_p  : out std_logic:= '0';
  ov32_RecPlayRxDataCh0_p : out std_logic_vector(31 downto 0) := (others => '0');

  i_RecPlayTxWe_p         : in std_logic;
  o_RecPlayTxReady_p      : out std_logic:= '0';
  iv32_RecPlayTxDataCh0_p : in std_logic_vector(31 downto 0);

  o_TwrftExtCtrlEn_p       : out std_logic := '0';
  o_TwrftTxGainAtt_p       : out std_logic := '0';
  ov2_TwrftTxGainPaGain_p  : out std_logic_vector(1 downto 0):= (others => '0');
  ov5_TwrftTxGainMixAtt_p  : out std_logic_vector(4 downto 0):= (others => '0');
  ov12_TwrftRxGain_p       : out std_logic_vector(11 downto 0):= (others => '0');
  ov14_TwrftRxPllCfg_p     : out std_logic_vector(13 downto 0):= (others => '0');
  ov14_TwrftTxPllCfg_p     : out std_logic_vector(13 downto 0):= (others => '0');
  o_TwrftTxGain_update_p   : out std_logic := '0';
  o_TwrftRxGain_update_p   : out std_logic := '0';
  o_TwrftRxPllCfgUpdate_p  : out std_logic := '0';
  o_TwrftTxPllCfgUpdate_p  : out std_logic := '0';
  o_TwrftTxnRx1_p          : out std_logic := '0';
  o_TwrftTxnRx2_p          : out std_logic := '0';
  o_TwrftTransceiverId_p   : out std_logic := '0';
  i_TwrftLockDetect_p      : in std_logic;
  i_TwrftSpiBusy_p         : in std_logic;

  -- Radio420x section
  iv12_Radio420xAdcDataCh1_p       : in std_logic_vector(11 downto 0);
  iv12_Radio420xAdcDataCh2_p       : in std_logic_vector(11 downto 0);
  ov12_Radio420xDacDataCh1_p       : out std_logic_vector(11 downto 0):= (others =>'0');
  ov12_Radio420xDacDataCh2_p       : out std_logic_vector(11 downto 0):= (others =>'0');
  i_Radio420xAdcIQSelCh1_p         : in std_logic;
  i_Radio420xAdcIQSelCh2_p         : in std_logic;
  o_Radio420xDacIQSelCh1_p         : out std_logic := '0';
  o_Radio420xDacIQSelCh2_p         : out std_logic := '0';
  iv5_Radio420xExtCtrlCh1_p		     : in std_logic_vector(4 downto 0);
  iv5_Radio420xExtCtrlCh2_p		     : in std_logic_vector(4 downto 0);
  ov16_Radio420xDacRefClkCh1_p     : out std_logic_vector(15 downto 0):= (others =>'0');
  ov16_Radio420xDacRefClkCh2_p     : out std_logic_vector(15 downto 0):= (others =>'0');
  o_Radio420xDacRefClkStartCh1_p   : out std_logic := '0';
  o_Radio420xDacRefClkStartCh2_p   : out std_logic := '0';
  i_Radio420xDacRefClkBusyCh1_p    : in std_logic;
  i_Radio420xDacRefClkBusyCh2_p    : in std_logic;
  ov16_Radio420xLimeDataCh1_p      : out std_logic_vector(15 downto 0):= (others =>'0');
  ov16_Radio420xLimeDataCh2_p      : out std_logic_vector(15 downto 0):= (others =>'0');
  o_Radio420xLimeDataStartCh1_p    : out std_logic := '0';
  o_Radio420xLimeDataStartCh2_p    : out std_logic := '0';
  i_Radio420xLimeDataBusyCh1_p     : in std_logic;
  i_Radio420xLimeDataBusyCh2_p     : in std_logic;
  ov6_Radio420xRxGainCh1_p         : out std_logic_vector(5 downto 0):= (others =>'0');
  ov6_Radio420xRxGainCh2_p         : out std_logic_vector(5 downto 0):= (others =>'0');
  o_Radio420xRxGainStartCh1_p      : out std_logic := '0';
  o_Radio420xRxGainStartCh2_p      : out std_logic := '0';
  i_Radio420xRxGainBusyCh1_p       : in std_logic;
  i_Radio420xRxGainBusyCh2_p       : in std_logic;
  ov6_Radio420xTxGainCh1_p         : out std_logic_vector(5 downto 0):= (others =>'0');
  ov6_Radio420xTxGainCh2_p         : out std_logic_vector(5 downto 0):= (others =>'0');
  o_Radio420xTxGainStartCh1_p      : out std_logic := '0';
  o_Radio420xTxGainStartCh2_p      : out std_logic := '0';
  i_Radio420xTxGainBusyCh1_p       : in std_logic;
  i_Radio420xTxGainBusyCh2_p       : in std_logic;
  ov32_Radio420xPllCtrlCh1_p       : out std_logic_vector(31 downto 0):= (others =>'0');
  ov32_Radio420xPllCtrlCh2_p       : out std_logic_vector(31 downto 0):= (others =>'0');
  ov2_Radio420xPllCtrlStartCh1_p   : out std_logic_vector(1 downto 0):= (others =>'0');
  ov2_Radio420xPllCtrlStartCh2_p   : out std_logic_vector(1 downto 0):= (others =>'0');
  i_Radio420xPllCtrlBusyCh1_p      : in std_logic;
  i_Radio420xPllCtrlBusyCh2_p      : in std_logic;

  -- ADAC250 section
  iv14_Adac250_AdcDataChA_p      : in std_logic_vector(13 downto 0);
  i_Adac250_ChA_OvrFiltred_p     : in std_logic;
  i_Adac250_ChA_OvrNotFiltred_p  : in std_logic;
  iv14_Adac250_AdcDataChB_p      : in std_logic_vector(13 downto 0);
  i_Adac250_ChB_OvrFiltred_p     : in std_logic;
  i_Adac250_ChB_OvrNotFiltred_p  : in std_logic;
  i_Adac250_DataFormat_p         : in std_logic;
  ov16_Adac250_DacChA_p          : out std_logic_vector(15 downto 0) := (others => '0');
  ov16_Adac250_DacChB_p          : out std_logic_vector(15 downto 0) := (others => '0');
  i_Adac250_Trigger_p            : in std_logic;
  o_Adac250_DacDataSync_p        : out std_logic;


  iv80_Adc5000_DataChA_p            : in std_logic_vector(79 downto 0);
  iv80_Adc5000_DataChB_p            : in std_logic_vector(79 downto 0);
  iv80_Adc5000_DataChC_p            : in std_logic_vector(79 downto 0);
  iv80_Adc5000_DataChD_p            : in std_logic_vector(79 downto 0);
  i_Adc5000_OverRangeChA_p          : in std_logic;
  i_Adc5000_OverRangeChB_p          : in std_logic;
  i_Adc5000_OverRangeChC_p          : in std_logic;
  i_Adc5000_OverRangeChD_p          : in std_logic;
  i_Adc5000_ReadyChA_p              : in std_logic;
  i_Adc5000_ReadyChB_p              : in std_logic;
  i_Adc5000_ReadyChC_p              : in std_logic;
  i_Adc5000_ReadyChD_p              : in std_logic;
  i_Adc5000_Trigger_p               : in std_logic;

  -- AURORA section
   o_aurora_amc4_7_RX_Fifo_Read_Enable_p    : out std_logic;
  iv_aurora_amc4_7_RX_Fifo_Data_p           : in  std_logic_vector(Aurora_4_7_user_DATA_width-1 downto 0);
   i_aurora_amc4_7_RX_Data_Valid_p          : in  std_logic;
  ov_aurora_amc4_7_TX_Fifo_Data_p           : out std_logic_vector(Aurora_4_7_user_DATA_width-1 downto 0);
   o_aurora_amc4_7_TX_Fifo_Write_Enable_p   : out std_logic;
   i_aurora_amc4_7_TX_Fifo_Ready_p          : in  std_logic;

   o_aurora_amc8_11_RX_Fifo_Read_Enable_p   : out std_logic;
  iv_aurora_amc8_11_RX_Fifo_Data_p          : in  std_logic_vector(Aurora_8_11_user_DATA_width-1 downto 0);
   i_aurora_amc8_11_RX_Data_Valid_p         : in  std_logic;
  ov_aurora_amc8_11_TX_Fifo_Data_p          : out std_logic_vector(Aurora_8_11_user_DATA_width-1 downto 0);
   o_aurora_amc8_11_TX_Fifo_Write_Enable_p  : out std_logic;
   i_aurora_amc8_11_TX_Fifo_Ready_p         : in  std_logic;

   o_aurora_amc17_20_RX_Fifo_Read_Enable_p  : out std_logic;
  iv_aurora_amc17_20_RX_Fifo_Data_p         : in  std_logic_vector(Aurora_17_20_user_DATA_width-1 downto 0);
   i_aurora_amc17_20_RX_Data_Valid_p        : in  std_logic;
  ov_aurora_amc17_20_TX_Fifo_Data_p         : out std_logic_vector(Aurora_17_20_user_DATA_width-1 downto 0);
   o_aurora_amc17_20_TX_Fifo_Write_Enable_p : out std_logic;
   i_aurora_amc17_20_TX_Fifo_Ready_p        : in  std_logic;

  -- MI250 section
  iv14_Mi250AdcADataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcBDataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcCDataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcDDataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcEDataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcFDataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcGDataOut_p           : in std_logic_vector(13 downto 0);
  iv14_Mi250AdcHDataOut_p           : in std_logic_vector(13 downto 0);
  i_Mi250AdcADataValid_p            : in std_logic;
  i_Mi250AdcBDataValid_p            : in std_logic;
  i_Mi250AdcCDataValid_p            : in std_logic;
  i_Mi250AdcDDataValid_p            : in std_logic;
  i_Mi250AdcEDataValid_p            : in std_logic;
  i_Mi250AdcFDataValid_p            : in std_logic;
  i_Mi250AdcGDataValid_p            : in std_logic;
  i_Mi250AdcHDataValid_p            : in std_logic;
  i_Mi250AdcTrigout_p               : in std_logic;

  -- MI125 section
  iv14_Mi125AdcDataCh1_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh2_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh3_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh4_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh5_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh6_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh7_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh8_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh9_p        : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh10_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh11_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh12_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh13_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh14_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh15_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh16_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh17_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh18_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh19_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh20_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh21_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh22_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh23_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh24_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh25_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh26_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh27_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh28_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh29_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh30_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh31_p       : in std_logic_vector(13 downto 0);
  iv14_Mi125AdcDataCh32_p       : in std_logic_vector(13 downto 0);
  i_Mi125AdcCh1Valid_p          : in std_logic;
  i_Mi125AdcCh2Valid_p          : in std_logic;
  i_Mi125AdcCh3Valid_p          : in std_logic;
  i_Mi125AdcCh4Valid_p          : in std_logic;
  i_Mi125AdcCh5Valid_p          : in std_logic;
  i_Mi125AdcCh6Valid_p          : in std_logic;
  i_Mi125AdcCh7Valid_p          : in std_logic;
  i_Mi125AdcCh8Valid_p          : in std_logic;
  i_Mi125AdcCh9Valid_p          : in std_logic;
  i_Mi125AdcCh10Valid_p         : in std_logic;
  i_Mi125AdcCh11Valid_p         : in std_logic;
  i_Mi125AdcCh12Valid_p         : in std_logic;
  i_Mi125AdcCh13Valid_p         : in std_logic;
  i_Mi125AdcCh14Valid_p         : in std_logic;
  i_Mi125AdcCh15Valid_p         : in std_logic;
  i_Mi125AdcCh16Valid_p         : in std_logic;
  i_Mi125AdcCh17Valid_p         : in std_logic;
  i_Mi125AdcCh18Valid_p         : in std_logic;
  i_Mi125AdcCh19Valid_p         : in std_logic;
  i_Mi125AdcCh20Valid_p         : in std_logic;
  i_Mi125AdcCh21Valid_p         : in std_logic;
  i_Mi125AdcCh22Valid_p         : in std_logic;
  i_Mi125AdcCh23Valid_p         : in std_logic;
  i_Mi125AdcCh24Valid_p         : in std_logic;
  i_Mi125AdcCh25Valid_p         : in std_logic;
  i_Mi125AdcCh26Valid_p         : in std_logic;
  i_Mi125AdcCh27Valid_p         : in std_logic;
  i_Mi125AdcCh28Valid_p         : in std_logic;
  i_Mi125AdcCh29Valid_p         : in std_logic;
  i_Mi125AdcCh30Valid_p         : in std_logic;
  i_Mi125AdcCh31Valid_p         : in std_logic;
  i_Mi125AdcCh32Valid_p         : in std_logic;
  i_Mi125TriggerInput_p         : in std_logic;
  o_Mi125TriggerOutput_p        : out std_logic;
  i_Mi125DataFormat_p           : in std_logic;
  i_Mi125Adc1to4Enabled_p       : in std_logic;
  i_Mi125Adc5to8Enabled_p       : in std_logic;
  i_Mi125Adc9to12Enabled_p      : in std_logic;
  i_Mi125Adc13to16Enabled_p     : in std_logic;
  i_Mi125Adc17to20Enabled_p     : in std_logic;
  i_Mi125Adc21to24Enabled_p     : in std_logic;
  i_Mi125Adc25to28Enabled_p     : in std_logic;
  i_Mi125Adc29to32Enabled_p     : in std_logic;

  -- MO1000 0
  ov16_Mo1000DacDataCh1_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh2_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh3_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh4_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh5_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh6_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh7_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh8_p       : out std_logic_vector(15 downto 0);
  i_Mo1000DacRdyCh1_p           : in  std_logic;
  i_Mo1000DacRdyCh2_p           : in  std_logic;
  i_Mo1000DacRdyCh3_p           : in  std_logic;
  i_Mo1000DacRdyCh4_p           : in  std_logic;
  i_Mo1000DacRdyCh5_p           : in  std_logic;
  i_Mo1000DacRdyCh6_p           : in  std_logic;
  i_Mo1000DacRdyCh7_p           : in  std_logic;
  i_Mo1000DacRdyCh8_p           : in  std_logic;
  i_Mo1000Trigger_p             : in  std_logic;

  -- MO1000 1
  ov16_Mo1000DacDataCh9_p       : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh10_p      : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh11_p      : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh12_p      : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh13_p      : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh14_p      : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh15_p      : out std_logic_vector(15 downto 0);
  ov16_Mo1000DacDataCh16_p      : out std_logic_vector(15 downto 0);
  i_Mo1000DacRdyCh9_p           : in  std_logic;
  i_Mo1000DacRdyCh10_p          : in  std_logic;
  i_Mo1000DacRdyCh11_p          : in  std_logic;
  i_Mo1000DacRdyCh12_p          : in  std_logic;
  i_Mo1000DacRdyCh13_p          : in  std_logic;
  i_Mo1000DacRdyCh14_p          : in  std_logic;
  i_Mo1000DacRdyCh15_p          : in  std_logic;
  i_Mo1000DacRdyCh16_p          : in  std_logic;

  --
  iv_lvdsIo_IN_2_rxData0_p	   	: in  std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_IN_2_rxRdEn0_p	   : out std_logic := '0';
  i_lvdsIo_IN_2_rxValid0_p	   : in  std_logic := '0';
  i_lvdsIo_IN_2_rxEmpty0_p	   : in  std_logic := '0';
  iv_lvdsIo_IN_2_rxData1_p	   : in  std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_IN_2_rxRdEn1_p	   : out std_logic := '0';
  i_lvdsIo_IN_2_rxValid1_p	   : in  std_logic := '0';
  i_lvdsIo_IN_2_rxEmpty1_p	   : in  std_logic := '0';
  --
  ov_lvdsIo_OUT_2_txData0_p	   : out std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_OUT_2_txWrEn0_p	   : out std_logic := '0';
  i_lvdsIo_OUT_2_txWrAck0_p	   : in  std_logic := '0';
  i_lvdsIo_OUT_2_txFull0_p	   : in  std_logic := '0';
  ov_lvdsIo_OUT_2_txData1_p	   : out std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_OUT_2_txWrEn1_p	   : out std_logic := '0';
  i_lvdsIo_OUT_2_txWrAck1_p	   : in  std_logic := '0';
  i_lvdsIo_OUT_2_txFull1_p	   : in  std_logic := '0';
  --
  iv_lvdsIo_IN_1_rxData0_p	   : in  std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_IN_1_rxRdEn0_p	   : out std_logic;
  i_lvdsIo_IN_1_rxValid0_p	   : in  std_logic := '0';
  i_lvdsIo_IN_1_rxEmpty0_p	   : in  std_logic := '0';
  iv_lvdsIo_IN_1_rxData1_p	   : in  std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_IN_1_rxRdEn1_p	   : out std_logic := '0';
  i_lvdsIo_IN_1_rxValid1_p	   : in  std_logic := '0';
  i_lvdsIo_IN_1_rxEmpty1_p	   : in  std_logic := '0';
  --
  ov_lvdsIo_OUT_1_txData0_p    : out std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_OUT_1_txWrEn0_p	   : out std_logic := '0';
  i_lvdsIo_OUT_1_txWrAck0_p    : in  std_logic := '0';
  i_lvdsIo_OUT_1_txFull0_p	   : in  std_logic := '0';
  ov_lvdsIo_OUT_1_txData1_p    : out std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 ) := ( others => '0' );
  o_lvdsIo_OUT_1_txWrEn1_p	   : out std_logic := '0';
  i_lvdsIo_OUT_1_txWrAck1_p    : in  std_logic := '0';
  i_lvdsIo_OUT_1_txFull1_p	   : in  std_logic := '0';

  -- LVDS GPIO
  ov_mestor_gpio_0_data_p           : out std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
  iv_mestor_gpio_0_data_p           : in  std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_0_outputenable_p   : out std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_1_data_p           : out std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
  iv_mestor_gpio_1_data_p           : in  std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_1_outputenable_p   : out std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_2_data_p           : out std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
  iv_mestor_gpio_2_data_p           : in  std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_2_outputenable_p   : out std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_3_data_p           : out std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
  iv_mestor_gpio_3_data_p           : in  std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
  ov_mestor_gpio_3_outputenable_p   : out std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
  -- LVDS SYNC
  o_mestor_sync_0_outputenable_p    : out std_logic := '0';
  i_mestor_sync_0_rxready_p         : in  std_logic := '0';
  o_mestor_sync_0_rxre_p            : out std_logic := '0';
  iv_mestor_sync_0_rxdata_p         : in  std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
  i_mestor_sync_0_rxdatavalid_p     : in  std_logic := '0';
  i_mestor_sync_0_txready_p         : in  std_logic := '0';
  ov_mestor_sync_0_txdata_p         : out std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
  o_mestor_sync_0_txwe_p            : out std_logic := '0';
  o_mestor_sync_1_outputenable_p    : out std_logic := '0';
  i_mestor_sync_1_rxready_p         : in  std_logic := '0';
  o_mestor_sync_1_rxre_p            : out std_logic := '0';
  iv_mestor_sync_1_rxdata_p         : in  std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
  i_mestor_sync_1_rxdatavalid_p     : in  std_logic := '0';
  i_mestor_sync_1_txready_p         : in  std_logic := '0';
  ov_mestor_sync_1_txdata_p         : out std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
  o_mestor_sync_1_txwe_p            : out std_logic := '0';
  o_mestor_sync_2_outputenable_p    : out std_logic := '0';
  i_mestor_sync_2_rxready_p         : in  std_logic := '0';
  o_mestor_sync_2_rxre_p            : out std_logic := '0';
  iv_mestor_sync_2_rxdata_p         : in  std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
  i_mestor_sync_2_rxdatavalid_p     : in  std_logic := '0';
  i_mestor_sync_2_txready_p         : in  std_logic := '0';
  ov_mestor_sync_2_txdata_p         : out std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
  o_mestor_sync_2_txwe_p            : out std_logic := '0';
  o_mestor_sync_3_outputenable_p    : out std_logic := '0';
  i_mestor_sync_3_rxready_p         : in  std_logic := '0';
  o_mestor_sync_3_rxre_p            : out std_logic := '0';
  iv_mestor_sync_3_rxdata_p         : in  std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
  i_mestor_sync_3_rxdatavalid_p     : in  std_logic := '0';
  i_mestor_sync_3_txready_p         : in  std_logic := '0';
  ov_mestor_sync_3_txdata_p         : out std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
  o_mestor_sync_3_txwe_p            : out std_logic := '0';

  -- AMC GPIO section
  o_nutaq_backplane_gpio_0_p  : out std_logic := '0';
  o_nutaq_backplane_gpio_1_p  : out std_logic := '0';
  i_nutaq_backplane_gpio_0_p  : in std_logic := '0';
  i_nutaq_backplane_gpio_1_p  : in std_logic := '0';
  o_nutaq_backplane_gpio_tclk_a_p  : out std_logic := '0';
  o_nutaq_backplane_gpio_tclk_b_p  : out std_logic := '0';
  o_nutaq_backplane_gpio_tclk_c_p  : out std_logic := '0';
  o_nutaq_backplane_gpio_tclk_d_p  : out std_logic := '0';
  i_nutaq_backplane_gpio_tclk_a_p  : in std_logic := '0';
  i_nutaq_backplane_gpio_tclk_b_p  : in std_logic := '0';
  i_nutaq_backplane_gpio_tclk_c_p  : in std_logic := '0';
  i_nutaq_backplane_gpio_tclk_d_p  : in std_logic := '0';

  i_DesignClk_p : in std_logic;
  o_DesignClk_p : out std_logic := '0'

);

end lyt_cosim_interface_wrapper;


architecture rtl of lyt_cosim_interface_wrapper is


  signal v32_SysgenDataOut_s :  std_logic_vector(31 downto 0):= (others => '0');


  signal v32_CustomReg0wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg1wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg2wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg3wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg4wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg5wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg6wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg7wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg8wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg9wr_s   :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg10wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg11wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg12wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg13wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg14wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg15wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg16wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg17wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg18wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg19wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg20wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg21wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg22wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg23wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg24wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg25wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg26wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg27wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg28wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg29wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg30wr_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_CustomReg31wr_s  :  std_logic_vector(31 downto 0):= (others => '0');

  signal v8_RTDExEmac0RxRe_s        :  std_logic_vector(7 downto 0):= (others => '0');
  signal v8_RTDExEmac0TxWe_s        :  std_logic_vector(7 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh0_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh1_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh2_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh3_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh4_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh5_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh6_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExEmac0TxDataCh7_s  :  std_logic_vector(31 downto 0):= (others => '0');

  signal v8_RTDExPCIeRxRe_s        :  std_logic_vector(7 downto 0):= (others => '0');
  signal v8_RTDExPCIeTxWe_s        :  std_logic_vector(7 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh0_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh1_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh2_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh3_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh4_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh5_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh6_s  :  std_logic_vector(31 downto 0):= (others => '0');
  signal v32_RTDExPCIeTxDataCh7_s  :  std_logic_vector(31 downto 0):= (others => '0');

  signal RecTrigger_s           : std_logic := '0';
  signal v_RecDataPort0_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort1_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort2_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort3_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort4_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort5_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort6_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort7_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort8_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort9_s       : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort10_s      : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort11_s      : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort12_s      : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort13_s      : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort14_s      : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal v_RecDataPort15_s      : std_logic_vector((RecordPortWidth_g-1) downto 0):= (others => '0');
  signal RecWriteEn_s           : std_logic := '0';

  signal PlayTriggerIn_s        : std_logic := '0';
  signal PlayReadEn_s           : std_logic := '0';

  signal RecPlayRxReady_s       : std_logic := '0';
  signal RecPlayRxDataValid_s   : std_logic := '0';
  signal v32_RecPlayRxDataCh0_s : std_logic_vector(31 downto 0) := (others => '0');

  signal RecPlayTxReady_s       : std_logic := '0';

  signal TwrftExtCtrlEn_s       : std_logic := '0';
  signal TwrftTxGainAtt_s       : std_logic := '0';
  signal v2_TwrftTxGainPaGain_s : std_logic_vector(1 downto 0):= (others => '0');
  signal v5_TwrftTxGainMixAtt_s : std_logic_vector(4 downto 0):= (others => '0');
  signal v12_TwrftRxGain_s      : std_logic_vector(11 downto 0):= (others => '0');
  signal v14_TwrftRxPllCfg_s    : std_logic_vector(13 downto 0):= (others => '0');
  signal v14_TwrftTxPllCfg_s    : std_logic_vector(13 downto 0):= (others => '0');
  signal TwrftTxGain_update_s   : std_logic := '0';
  signal TwrftRxGain_update_s   : std_logic := '0';
  signal TwrftRxPllCfgUpdate_s  : std_logic := '0';
  signal TwrftTxPllCfgUpdate_s  : std_logic := '0';
  signal TwrftTxnRx1_s          : std_logic := '0';
  signal TwrftTxnRx2_s          : std_logic := '0';
  signal TwrftTransceiverId_s   : std_logic := '0';

  signal v12_Radio420xDacDataCh1_s     : std_logic_vector(11 downto 0):= (others => '0');
  signal v12_Radio420xDacDataCh2_s     : std_logic_vector(11 downto 0):= (others => '0');
  signal Radio420xAdcIQSelCh1_s        : std_logic := '0';
  signal Radio420xAdcIQSelCh2_s        : std_logic := '0';
  signal Radio420xDacIQSelCh1_s        : std_logic := '0';
  signal Radio420xDacIQSelCh2_s        : std_logic := '0';
  signal v16_Radio420xDacRefClkCh1_s   : std_logic_vector(15 downto 0):= (others => '0');
  signal v16_Radio420xDacRefClkCh2_s   : std_logic_vector(15 downto 0):= (others => '0');
  signal Radio420xDacRefClkStartCh1_s  : std_logic := '0';
  signal Radio420xDacRefClkStartCh2_s  : std_logic := '0';
  signal v16_Radio420xLimeDataCh1_s    : std_logic_vector(15 downto 0):= (others => '0');
  signal v16_Radio420xLimeDataCh2_s    : std_logic_vector(15 downto 0):= (others => '0');
  signal Radio420xLimeDataStartCh1_s   : std_logic := '0';
  signal Radio420xLimeDataStartCh2_s   : std_logic := '0';
  signal v6_Radio420xRxGainCh1_s       : std_logic_vector(5 downto 0):= (others => '0');
  signal v6_Radio420xRxGainCh2_s       : std_logic_vector(5 downto 0):= (others => '0');
  signal Radio420xRxGainStartCh1_s     : std_logic := '0';
  signal Radio420xRxGainStartCh2_s     : std_logic := '0';
  signal v6_Radio420xTxGainCh1_s       : std_logic_vector(5 downto 0):= (others => '0');
  signal v6_Radio420xTxGainCh2_s       : std_logic_vector(5 downto 0):= (others => '0');
  signal Radio420xTxGainStartCh1_s     : std_logic := '0';
  signal Radio420xTxGainStartCh2_s     : std_logic := '0';
  signal v32_Radio420xPllCtrlCh1_s     : std_logic_vector(31 downto 0):= (others => '0');
  signal v32_Radio420xPllCtrlCh2_s     : std_logic_vector(31 downto 0):= (others => '0');
  signal v2_Radio420xPllCtrlStartCh1_s : std_logic_vector(1 downto 0):= (others => '0');
  signal v2_Radio420xPllCtrlStartCh2_s : std_logic_vector(1 downto 0):= (others => '0');

  signal v16_Adac250_DacChA_s          : std_logic_vector(15 downto 0);
  signal v16_Adac250_DacChB_s          : std_logic_vector(15 downto 0);
  signal Adac250_DacDataSync_s         : std_logic;

  signal Mi125TriggerOutput_s          : std_logic := '0';

  signal v16_Mo1000DacDataCh1_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh2_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh3_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh4_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh5_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh6_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh7_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh8_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh9_s        : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh10_s       : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh11_s       : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh12_s       : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh13_s       : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh14_s       : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh15_s       : std_logic_vector(15 downto 0) := (others => '0');
  signal v16_Mo1000DacDataCh16_s       : std_logic_vector(15 downto 0) := (others => '0');

  signal ov_lvdsIo_OUT_2_txData0_s     : std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );
  signal ov_lvdsIo_OUT_2_txData1_s	   : std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );

  signal ov_lvdsIo_OUT_1_txData0_s	   : std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );
  signal ov_lvdsIo_OUT_1_txData1_s     : std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 ) := ( others => '0' );

  signal o_lvdsIo_IN_1_rxRdEn0_s   	   : std_logic := '0';
  signal o_lvdsIo_IN_1_rxRdEn1_s	   : std_logic := '0';
  signal o_lvdsIo_IN_2_rxRdEn0_s	   : std_logic := '0';
  signal o_lvdsIo_IN_2_rxRdEn1_s	   : std_logic := '0';
  signal o_lvdsIo_OUT_1_txWrEn0_s	   : std_logic := '0';
  signal o_lvdsIo_OUT_1_txWrEn1_s	   : std_logic := '0';
  signal o_lvdsIo_OUT_2_txWrEn0_s	   : std_logic := '0';
  signal o_lvdsIo_OUT_2_txWrEn1_s	   : std_logic := '0';

  signal nutaq_backplane_gpio_output_0_s          : std_logic := '0';
  signal nutaq_backplane_gpio_output_1_s          : std_logic := '0';
  signal nutaq_backplane_gpio_output_tclk_a_s     : std_logic := '0';
  signal nutaq_backplane_gpio_output_tclk_b_s     : std_logic := '0';
  signal nutaq_backplane_gpio_output_tclk_c_s     : std_logic := '0';
  signal nutaq_backplane_gpio_output_tclk_d_s     : std_logic := '0';


  signal DesignClk_s : std_logic := '0';


  component sysgen_hw_cosim_interface is
    port
    (

      -- Sysgen Interface
      bank_sel                  : in std_logic_vector(7 downto 0);
      addr                      : in std_logic_vector(23 downto 0);
      data_in                   : in std_logic_vector(31 downto 0);
      we                        : in std_logic;
      re                        : in std_logic;
      data_out                  : out std_logic_vector(31 downto 0);
      pci_clk                   : in std_logic;
      clk                       : in std_logic;

      -- Custom Registers
      reg0_wr  :  out std_logic_vector(31 downto 0);
      reg0_rd  :  in std_logic_vector(31 downto 0);
      reg1_wr  :  out std_logic_vector(31 downto 0);
      reg1_rd  :  in std_logic_vector(31 downto 0);
      reg2_wr  :  out std_logic_vector(31 downto 0);
      reg2_rd  :  in std_logic_vector(31 downto 0);
      reg3_wr  :  out std_logic_vector(31 downto 0);
      reg3_rd  :  in std_logic_vector(31 downto 0);
      reg4_wr  :  out std_logic_vector(31 downto 0);
      reg4_rd  :  in std_logic_vector(31 downto 0);
      reg5_wr  :  out std_logic_vector(31 downto 0);
      reg5_rd  :  in std_logic_vector(31 downto 0);
      reg6_wr  :  out std_logic_vector(31 downto 0);
      reg6_rd  :  in std_logic_vector(31 downto 0);
      reg7_wr  :  out std_logic_vector(31 downto 0);
      reg7_rd  :  in std_logic_vector(31 downto 0);
      reg8_wr  :  out std_logic_vector(31 downto 0);
      reg8_rd  :  in std_logic_vector(31 downto 0);
      reg9_wr  :  out std_logic_vector(31 downto 0);
      reg9_rd  :  in std_logic_vector(31 downto 0);
      reg10_wr :  out std_logic_vector(31 downto 0);
      reg10_rd :  in std_logic_vector(31 downto 0);
      reg11_wr :  out std_logic_vector(31 downto 0);
      reg11_rd :  in std_logic_vector(31 downto 0);
      reg12_wr :  out std_logic_vector(31 downto 0);
      reg12_rd :  in std_logic_vector(31 downto 0);
      reg13_wr :  out std_logic_vector(31 downto 0);
      reg13_rd :  in std_logic_vector(31 downto 0);
      reg14_wr :  out std_logic_vector(31 downto 0);
      reg14_rd :  in std_logic_vector(31 downto 0);
      reg15_wr :  out std_logic_vector(31 downto 0);
      reg15_rd :  in std_logic_vector(31 downto 0);
      reg16_wr :  out std_logic_vector(31 downto 0);
      reg16_rd :  in std_logic_vector(31 downto 0);
      reg17_wr :  out std_logic_vector(31 downto 0);
      reg17_rd :  in std_logic_vector(31 downto 0);
      reg18_wr :  out std_logic_vector(31 downto 0);
      reg18_rd :  in std_logic_vector(31 downto 0);
      reg19_wr :  out std_logic_vector(31 downto 0);
      reg19_rd :  in std_logic_vector(31 downto 0);
      reg20_wr :  out std_logic_vector(31 downto 0);
      reg20_rd :  in std_logic_vector(31 downto 0);
      reg21_wr :  out std_logic_vector(31 downto 0);
      reg21_rd :  in std_logic_vector(31 downto 0);
      reg22_wr :  out std_logic_vector(31 downto 0);
      reg22_rd :  in std_logic_vector(31 downto 0);
      reg23_wr :  out std_logic_vector(31 downto 0);
      reg23_rd :  in std_logic_vector(31 downto 0);
      reg24_wr :  out std_logic_vector(31 downto 0);
      reg24_rd :  in std_logic_vector(31 downto 0);
      reg25_wr :  out std_logic_vector(31 downto 0);
      reg25_rd :  in std_logic_vector(31 downto 0);
      reg26_wr :  out std_logic_vector(31 downto 0);
      reg26_rd :  in std_logic_vector(31 downto 0);
      reg27_wr :  out std_logic_vector(31 downto 0);
      reg27_rd :  in std_logic_vector(31 downto 0);
      reg28_wr :  out std_logic_vector(31 downto 0);
      reg28_rd :  in std_logic_vector(31 downto 0);
      reg29_wr :  out std_logic_vector(31 downto 0);
      reg29_rd :  in std_logic_vector(31 downto 0);
      reg30_wr :  out std_logic_vector(31 downto 0);
      reg30_rd :  in std_logic_vector(31 downto 0);
      reg31_wr :  out std_logic_vector(31 downto 0);
      reg31_rd :  in std_logic_vector(31 downto 0);

      -- ADAC250
      adac250_adc_a_data        : in std_logic_vector(13 downto 0);
      adac250_cha_ovr_f         : in std_logic;
      adac250_cha_ovr           : in std_logic;
      adac250_adc_b_data        : in std_logic_vector(13 downto 0);
      adac250_chb_ovr_f         : in std_logic;
      adac250_chb_ovr           : in std_logic;
      adac250_data_format       : in std_logic;
      adac250_dac_a_data        : out std_logic_vector(15 downto 0);
      adac250_dac_b_data        : out std_logic_vector(15 downto 0);
      adac250_trig              : in std_logic;
      adac250_dac_sync          : out std_logic;

      -- RTDEX emac
      rtdex_emac0_rx_ready_ch0 : in std_logic;
      rtdex_emac0_rx_ready_ch1 : in std_logic;
      rtdex_emac0_rx_ready_ch2 : in std_logic;
      rtdex_emac0_rx_ready_ch3 : in std_logic;
      rtdex_emac0_rx_ready_ch4 : in std_logic;
      rtdex_emac0_rx_ready_ch5 : in std_logic;
      rtdex_emac0_rx_ready_ch6 : in std_logic;
      rtdex_emac0_rx_ready_ch7 : in std_logic;

      rtdex_emac0_rx_data_valid_ch0 : in std_logic;
      rtdex_emac0_rx_data_valid_ch1 : in std_logic;
      rtdex_emac0_rx_data_valid_ch2 : in std_logic;
      rtdex_emac0_rx_data_valid_ch3 : in std_logic;
      rtdex_emac0_rx_data_valid_ch4 : in std_logic;
      rtdex_emac0_rx_data_valid_ch5 : in std_logic;
      rtdex_emac0_rx_data_valid_ch6 : in std_logic;
      rtdex_emac0_rx_data_valid_ch7 : in std_logic;

      rtdex_emac0_rx_re_ch0 : out std_logic;
      rtdex_emac0_rx_re_ch1 : out std_logic;
      rtdex_emac0_rx_re_ch2 : out std_logic;
      rtdex_emac0_rx_re_ch3 : out std_logic;
      rtdex_emac0_rx_re_ch4 : out std_logic;
      rtdex_emac0_rx_re_ch5 : out std_logic;
      rtdex_emac0_rx_re_ch6 : out std_logic;
      rtdex_emac0_rx_re_ch7 : out std_logic;

      rtdex_emac0_tx_we_ch0 : out std_logic;
      rtdex_emac0_tx_we_ch1 : out std_logic;
      rtdex_emac0_tx_we_ch2 : out std_logic;
      rtdex_emac0_tx_we_ch3 : out std_logic;
      rtdex_emac0_tx_we_ch4 : out std_logic;
      rtdex_emac0_tx_we_ch5 : out std_logic;
      rtdex_emac0_tx_we_ch6 : out std_logic;
      rtdex_emac0_tx_we_ch7 : out std_logic;

      rtdex_emac0_tx_ready_ch0 : in std_logic;
      rtdex_emac0_tx_ready_ch1 : in std_logic;
      rtdex_emac0_tx_ready_ch2 : in std_logic;
      rtdex_emac0_tx_ready_ch3 : in std_logic;
      rtdex_emac0_tx_ready_ch4 : in std_logic;
      rtdex_emac0_tx_ready_ch5 : in std_logic;
      rtdex_emac0_tx_ready_ch6 : in std_logic;
      rtdex_emac0_tx_ready_ch7 : in std_logic;

      rtdex_emac0_tx_data_ch0  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch1  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch2  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch3  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch4  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch5  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch6  : out std_logic_vector(31 downto 0);
      rtdex_emac0_tx_data_ch7  : out std_logic_vector(31 downto 0);

      rtdex_emac0_rx_data_ch0  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch1  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch2  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch3  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch4  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch5  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch6  :  in std_logic_vector(31 downto 0);
      rtdex_emac0_rx_data_ch7  :  in std_logic_vector(31 downto 0);

      -- RTDEX PCIe
      rtdex_pcie_rx_ready_ch0 : in std_logic;
      rtdex_pcie_rx_ready_ch1 : in std_logic;
      rtdex_pcie_rx_ready_ch2 : in std_logic;
      rtdex_pcie_rx_ready_ch3 : in std_logic;
      rtdex_pcie_rx_ready_ch4 : in std_logic;
      rtdex_pcie_rx_ready_ch5 : in std_logic;
      rtdex_pcie_rx_ready_ch6 : in std_logic;
      rtdex_pcie_rx_ready_ch7 : in std_logic;

      rtdex_pcie_rx_data_valid_ch0 : in std_logic;
      rtdex_pcie_rx_data_valid_ch1 : in std_logic;
      rtdex_pcie_rx_data_valid_ch2 : in std_logic;
      rtdex_pcie_rx_data_valid_ch3 : in std_logic;
      rtdex_pcie_rx_data_valid_ch4 : in std_logic;
      rtdex_pcie_rx_data_valid_ch5 : in std_logic;
      rtdex_pcie_rx_data_valid_ch6 : in std_logic;
      rtdex_pcie_rx_data_valid_ch7 : in std_logic;

      rtdex_pcie_rx_re_ch0 : out std_logic;
      rtdex_pcie_rx_re_ch1 : out std_logic;
      rtdex_pcie_rx_re_ch2 : out std_logic;
      rtdex_pcie_rx_re_ch3 : out std_logic;
      rtdex_pcie_rx_re_ch4 : out std_logic;
      rtdex_pcie_rx_re_ch5 : out std_logic;
      rtdex_pcie_rx_re_ch6 : out std_logic;
      rtdex_pcie_rx_re_ch7 : out std_logic;

      rtdex_pcie_tx_we_ch0 : out std_logic;
      rtdex_pcie_tx_we_ch1 : out std_logic;
      rtdex_pcie_tx_we_ch2 : out std_logic;
      rtdex_pcie_tx_we_ch3 : out std_logic;
      rtdex_pcie_tx_we_ch4 : out std_logic;
      rtdex_pcie_tx_we_ch5 : out std_logic;
      rtdex_pcie_tx_we_ch6 : out std_logic;
      rtdex_pcie_tx_we_ch7 : out std_logic;

      rtdex_pcie_tx_ready_ch0 : in std_logic;
      rtdex_pcie_tx_ready_ch1 : in std_logic;
      rtdex_pcie_tx_ready_ch2 : in std_logic;
      rtdex_pcie_tx_ready_ch3 : in std_logic;
      rtdex_pcie_tx_ready_ch4 : in std_logic;
      rtdex_pcie_tx_ready_ch5 : in std_logic;
      rtdex_pcie_tx_ready_ch6 : in std_logic;
      rtdex_pcie_tx_ready_ch7 : in std_logic;

      rtdex_pcie_tx_data_ch0  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch1  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch2  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch3  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch4  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch5  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch6  : out std_logic_vector(31 downto 0);
      rtdex_pcie_tx_data_ch7  : out std_logic_vector(31 downto 0);

      rtdex_pcie_rx_data_ch0  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch1  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch2  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch3  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch4  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch5  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch6  :  in std_logic_vector(31 downto 0);
      rtdex_pcie_rx_data_ch7  :  in std_logic_vector(31 downto 0);

      -- Record
      record_data_port0  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port1  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port2  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port3  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port4  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port5  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port6  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port7  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port8  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port9  : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port10 : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port11 : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port12 : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port13 : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port14 : out std_logic_vector((RecordPortWidth_g-1) downto 0);
      record_data_port15 : out std_logic_vector((RecordPortWidth_g-1) downto 0);

      record_trig        : out std_logic;
      record_wr_en         : out std_logic;
      record_fifo_full     : in std_logic;

      record_rtdex_rx_re       : in std_logic;
      record_rtdex_rx_ready    : out std_logic;
      record_rtdex_rx_data_ch0 : out std_logic_vector(31 downto 0);
      record_rtdex_rx_data_valid : out std_logic;

      -- Playback

      playback_data_port0  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port1  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port2  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port3  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port4  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port5  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port6  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port7  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port8  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port9  : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port10 : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port11 : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port12 : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port13 : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port14 : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_data_port15 : in std_logic_vector((PlayBackPortWidth_g-1) downto 0);
      playback_fifo_valid  : in std_logic;
      playback_fifo_empty  : in std_logic;

      playback_trig           : out std_logic;
      playback_rd_en          : out std_logic;

      playback_rtdex_tx_we       : in std_logic;
      playback_rtdex_tx_data_ch0 : in std_logic_vector(31 downto 0);
      playback_rtdex_tx_ready : out std_logic;


      twrft_ext_ctrl_en       : out std_logic;
      twrft_tx_gain_att       : out std_logic;
      twrft_tx_gain_pa_gain   : out std_logic_vector(1 downto 0);
      twrft_tx_gain_mix_att   : out std_logic_vector(4 downto 0);
      twrft_rx_gain           : out std_logic_vector(11 downto 0);
      twrft_rx_pll_cfg        : out std_logic_vector(13 downto 0);
      twrft_tx_pll_cfg        : out std_logic_vector(13 downto 0);
      twrft_tx_gain_update    : out std_logic;
      twrft_rx_gain_update    : out std_logic;
      twrft_rx_pll_cfg_update : out std_logic;
      twrft_tx_pll_cfg_update : out std_logic;
      twrft_tx_n_rx1          : out std_logic;
      twrft_tx_n_rx2          : out std_logic;
      twrft_transceiver_id    : out std_logic;
      twrft_lock_detect       : in std_logic;
      twrft_spi_busy          : in std_logic;

      -- Radio420x section
      radio420x_adc_1_data               : in std_logic_vector(11 downto 0);
      radio420x_adc_2_data               : in std_logic_vector(11 downto 0);
      radio420x_dac_1_data               : out std_logic_vector(11 downto 0);
      radio420x_dac_2_data               : out std_logic_vector(11 downto 0);
      radio420x_adc_iq_sel_ch1           : in std_logic;
      radio420x_adc_iq_sel_ch2           : in std_logic;
      radio420x_dac_iq_sel_ch1           : out std_logic;
      radio420x_dac_iq_sel_ch2           : out std_logic;
      radio420x_dac_ref_clk_ext_ctrl_ch1 : in std_logic;
      radio420x_dac_ref_clk_ext_ctrl_ch2 : in std_logic;
      radio420x_dac_ref_clk_ch1          : out std_logic_vector(15 downto 0);
      radio420x_dac_ref_clk_ch2          : out std_logic_vector(15 downto 0);
      radio420x_dac_ref_clk_start_ch1    : out std_logic;
      radio420x_dac_ref_clk_start_ch2    : out std_logic;
      radio420x_dac_ref_clk_busy_ch1     : in std_logic;
      radio420x_dac_ref_clk_busy_ch2     : in std_logic;
      radio420x_lime_data_ext_ctrl_ch1   : in std_logic;
      radio420x_lime_data_ext_ctrl_ch2   : in std_logic;
      radio420x_lime_data_ch1            : out std_logic_vector(15 downto 0);
      radio420x_lime_data_ch2            : out std_logic_vector(15 downto 0);
      radio420x_lime_data_start_ch1      : out std_logic;
      radio420x_lime_data_start_ch2      : out std_logic;
      radio420x_lime_data_busy_ch1       : in std_logic;
      radio420x_lime_data_busy_ch2       : in std_logic;
      radio420x_rx_gain_ext_ctrl_ch1     : in std_logic;
      radio420x_rx_gain_ext_ctrl_ch2     : in std_logic;
      radio420x_rx_gain_ch1              : out std_logic_vector(5 downto 0);
      radio420x_rx_gain_ch2              : out std_logic_vector(5 downto 0);
      radio420x_rx_gain_start_ch1        : out std_logic;
      radio420x_rx_gain_start_ch2        : out std_logic;
      radio420x_rx_gain_busy_ch1         : in std_logic;
      radio420x_rx_gain_busy_ch2         : in std_logic;
      radio420x_tx_gain_ext_ctrl_ch1     : in std_logic;
      radio420x_tx_gain_ext_ctrl_ch2     : in std_logic;
      radio420x_tx_gain_ch1              : out std_logic_vector(5 downto 0);
      radio420x_tx_gain_ch2              : out std_logic_vector(5 downto 0);
      radio420x_tx_gain_start_ch1        : out std_logic;
      radio420x_tx_gain_start_ch2        : out std_logic;
      radio420x_tx_gain_busy_ch1         : in std_logic;
      radio420x_tx_gain_busy_ch2         : in std_logic;
      radio420x_pll_ctrl_ext_ctrl_ch1    : in std_logic;
      radio420x_pll_ctrl_ext_ctrl_ch2    : in std_logic;
      radio420x_pll_ctrl_ch1             : out std_logic_vector(31 downto 0);
      radio420x_pll_ctrl_ch2             : out std_logic_vector(31 downto 0);
      radio420x_pll_ctrl_start_ch1       : out std_logic_vector(1 downto 0);
      radio420x_pll_ctrl_start_ch2       : out std_logic_vector(1 downto 0);
      radio420x_pll_ctrl_busy_ch1        : in std_logic;
      radio420x_pll_ctrl_busy_ch2        : in std_logic;

      -- ADC5000 section
      adc5000_adc_a_data      : in std_logic_vector(79 downto 0);
      adc5000_adc_b_data      : in std_logic_vector(79 downto 0);
      adc5000_adc_c_data      : in std_logic_vector(79 downto 0);
      adc5000_adc_d_data      : in std_logic_vector(79 downto 0);
      adc5000_adc_a_ready     : in std_logic;
      adc5000_adc_b_ready     : in std_logic;
      adc5000_adc_c_ready     : in std_logic;
      adc5000_adc_d_ready     : in std_logic;
      adc5000_adc_a_ovr       : in std_logic;
      adc5000_adc_b_ovr       : in std_logic;
      adc5000_adc_c_ovr       : in std_logic;
      adc5000_adc_d_ovr       : in std_logic;
      adc5000_trig            : in std_logic;

      -- AURORA section
      aurora_amc4_7_RX_Fifo_Read_Enable_p    : out std_logic;
      aurora_amc4_7_RX_Fifo_Data_p           : in  std_logic_vector(Aurora_4_7_user_DATA_width-1 downto 0);
      aurora_amc4_7_RX_Data_Valid_p          : in  std_logic;
      aurora_amc4_7_TX_Fifo_Data_p           : out std_logic_vector(Aurora_4_7_user_DATA_width-1 downto 0);
      aurora_amc4_7_TX_Fifo_Write_Enable_p   : out std_logic;
      aurora_amc4_7_TX_Fifo_Ready_p          : in  std_logic;

      aurora_amc8_11_RX_Fifo_Read_Enable_p   : out std_logic;
      aurora_amc8_11_RX_Fifo_Data_p          : in  std_logic_vector(Aurora_8_11_user_DATA_width-1 downto 0);
      aurora_amc8_11_RX_Data_Valid_p         : in  std_logic;
      aurora_amc8_11_TX_Fifo_Data_p          : out std_logic_vector(Aurora_8_11_user_DATA_width-1 downto 0);
      aurora_amc8_11_TX_Fifo_Write_Enable_p  : out std_logic;
      aurora_amc8_11_TX_Fifo_Ready_p         : in  std_logic;

      aurora_amc17_20_RX_Fifo_Read_Enable_p  : out std_logic;
      aurora_amc17_20_RX_Fifo_Data_p         : in  std_logic_vector(Aurora_17_20_user_DATA_width-1 downto 0);
      aurora_amc17_20_RX_Data_Valid_p        : in  std_logic;
      aurora_amc17_20_TX_Fifo_Data_p         : out std_logic_vector(Aurora_17_20_user_DATA_width-1 downto 0);
      aurora_amc17_20_TX_Fifo_Write_Enable_p : out std_logic;
      aurora_amc17_20_TX_Fifo_Ready_p        : in  std_logic;

      -- MI250 section
      mi250_adc_a_data        : in std_logic_vector(13 downto 0);
      mi250_adc_b_data        : in std_logic_vector(13 downto 0);
      mi250_adc_c_data        : in std_logic_vector(13 downto 0);
      mi250_adc_d_data        : in std_logic_vector(13 downto 0);
      mi250_adc_e_data        : in std_logic_vector(13 downto 0);
      mi250_adc_f_data        : in std_logic_vector(13 downto 0);
      mi250_adc_g_data        : in std_logic_vector(13 downto 0);
      mi250_adc_h_data        : in std_logic_vector(13 downto 0);
      mi250_adc_a_data_valid  : in std_logic;
      mi250_adc_b_data_valid  : in std_logic;
      mi250_adc_c_data_valid  : in std_logic;
      mi250_adc_d_data_valid  : in std_logic;
      mi250_adc_e_data_valid  : in std_logic;
      mi250_adc_f_data_valid  : in std_logic;
      mi250_adc_g_data_valid  : in std_logic;
      mi250_adc_h_data_valid  : in std_logic;
      mi250_trig              : in std_logic;

-- MI125 section
      mi125_adc_1_data        : in std_logic_vector(13 downto 0);
      mi125_adc_2_data        : in std_logic_vector(13 downto 0);
      mi125_adc_3_data        : in std_logic_vector(13 downto 0);
      mi125_adc_4_data        : in std_logic_vector(13 downto 0);
      mi125_adc_5_data        : in std_logic_vector(13 downto 0);
      mi125_adc_6_data        : in std_logic_vector(13 downto 0);
      mi125_adc_7_data        : in std_logic_vector(13 downto 0);
      mi125_adc_8_data        : in std_logic_vector(13 downto 0);
      mi125_adc_9_data        : in std_logic_vector(13 downto 0);
      mi125_adc_10_data       : in std_logic_vector(13 downto 0);
      mi125_adc_11_data       : in std_logic_vector(13 downto 0);
      mi125_adc_12_data       : in std_logic_vector(13 downto 0);
      mi125_adc_13_data       : in std_logic_vector(13 downto 0);
      mi125_adc_14_data       : in std_logic_vector(13 downto 0);
      mi125_adc_15_data       : in std_logic_vector(13 downto 0);
      mi125_adc_16_data       : in std_logic_vector(13 downto 0);
      mi125_adc_17_data       : in std_logic_vector(13 downto 0);
      mi125_adc_18_data       : in std_logic_vector(13 downto 0);
      mi125_adc_19_data       : in std_logic_vector(13 downto 0);
      mi125_adc_20_data       : in std_logic_vector(13 downto 0);
      mi125_adc_21_data       : in std_logic_vector(13 downto 0);
      mi125_adc_22_data       : in std_logic_vector(13 downto 0);
      mi125_adc_23_data       : in std_logic_vector(13 downto 0);
      mi125_adc_24_data       : in std_logic_vector(13 downto 0);
      mi125_adc_25_data       : in std_logic_vector(13 downto 0);
      mi125_adc_26_data       : in std_logic_vector(13 downto 0);
      mi125_adc_27_data       : in std_logic_vector(13 downto 0);
      mi125_adc_28_data       : in std_logic_vector(13 downto 0);
      mi125_adc_29_data       : in std_logic_vector(13 downto 0);
      mi125_adc_30_data       : in std_logic_vector(13 downto 0);
      mi125_adc_31_data       : in std_logic_vector(13 downto 0);
      mi125_adc_32_data       : in std_logic_vector(13 downto 0);
      mi125_adc_1_data_valid  : in std_logic;
      mi125_adc_2_data_valid  : in std_logic;
      mi125_adc_3_data_valid  : in std_logic;
      mi125_adc_4_data_valid  : in std_logic;
      mi125_adc_5_data_valid  : in std_logic;
      mi125_adc_6_data_valid  : in std_logic;
      mi125_adc_7_data_valid  : in std_logic;
      mi125_adc_8_data_valid  : in std_logic;
      mi125_adc_9_data_valid  : in std_logic;
      mi125_adc_10_data_valid : in std_logic;
      mi125_adc_11_data_valid : in std_logic;
      mi125_adc_12_data_valid : in std_logic;
      mi125_adc_13_data_valid : in std_logic;
      mi125_adc_14_data_valid : in std_logic;
      mi125_adc_15_data_valid : in std_logic;
      mi125_adc_16_data_valid : in std_logic;
      mi125_adc_17_data_valid : in std_logic;
      mi125_adc_18_data_valid : in std_logic;
      mi125_adc_19_data_valid : in std_logic;
      mi125_adc_20_data_valid : in std_logic;
      mi125_adc_21_data_valid : in std_logic;
      mi125_adc_22_data_valid : in std_logic;
      mi125_adc_23_data_valid : in std_logic;
      mi125_adc_24_data_valid : in std_logic;
      mi125_adc_25_data_valid : in std_logic;
      mi125_adc_26_data_valid : in std_logic;
      mi125_adc_27_data_valid : in std_logic;
      mi125_adc_28_data_valid : in std_logic;
      mi125_adc_29_data_valid : in std_logic;
      mi125_adc_30_data_valid : in std_logic;
      mi125_adc_31_data_valid : in std_logic;
      mi125_adc_32_data_valid : in std_logic;
      mi125_trig_input        : in std_logic;
      mi125_trig_output       : out std_logic;
      mi125_data_format       : in std_logic;
      mi125_adc_1to4_enabled  : in std_logic;
      mi125_adc_5to8_enabled  : in std_logic;
      mi125_adc_9to12_enabled : in std_logic;
      mi125_adc_13to16_enabled : in std_logic;
      mi125_adc_17to20_enabled : in std_logic;
      mi125_adc_21to24_enabled : in std_logic;
      mi125_adc_25to28_enabled : in std_logic;
      mi125_adc_29to32_enabled : in std_logic;

      -- mo1000 section
      mo1000_dac_1_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_2_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_3_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_4_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_5_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_6_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_7_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_8_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_9_data         : out std_logic_vector(15 downto 0);
      mo1000_dac_10_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_11_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_12_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_13_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_14_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_15_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_16_data        : out std_logic_vector(15 downto 0);
      mo1000_dac_1_rdy          : in  std_logic;
      mo1000_dac_2_rdy          : in  std_logic;
      mo1000_dac_3_rdy          : in  std_logic;
      mo1000_dac_4_rdy          : in  std_logic;
      mo1000_dac_5_rdy          : in  std_logic;
      mo1000_dac_6_rdy          : in  std_logic;
      mo1000_dac_7_rdy          : in  std_logic;
      mo1000_dac_8_rdy          : in  std_logic;
      mo1000_dac_9_rdy          : in  std_logic;
      mo1000_dac_10_rdy         : in  std_logic;
      mo1000_dac_11_rdy         : in  std_logic;
      mo1000_dac_12_rdy         : in  std_logic;
      mo1000_dac_13_rdy         : in  std_logic;
      mo1000_dac_14_rdy         : in  std_logic;
      mo1000_dac_15_rdy         : in  std_logic;
      mo1000_dac_16_rdy         : in  std_logic;
      mo1000_trigger            : in  std_logic;

      lvdsIo_IN_2_rxData0		       : in  std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 );
      lvdsIo_IN_2_rxRdEn0		  	   : out std_logic;
      lvdsIo_IN_2_rxValid0			   : in  std_logic;
      lvdsIo_IN_2_rxEmpty0			   : in  std_logic;
      lvdsIo_IN_2_rxData1			   : in  std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 );
      lvdsIo_IN_2_rxRdEn1			   : out std_logic;
      lvdsIo_IN_2_rxValid1			   : in  std_logic;
      lvdsIo_IN_2_rxEmpty1			   : in  std_logic;
      lvdsIo_OUT_2_txData0			   : out std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 );
      lvdsIo_OUT_2_txWrEn0			   : out std_logic;
      lvdsIo_OUT_2_txWrAck0			   : in  std_logic;
      lvdsIo_OUT_2_txFull0			   : in  std_logic;
      lvdsIo_OUT_2_txData1			   : out std_logic_vector( lvds_io_params_gen_lvds_io_top_g -1 downto 0 );
      lvdsIo_OUT_2_txWrEn1			   : out std_logic;
      lvdsIo_OUT_2_txWrAck1		       	   : in  std_logic;
      lvdsIo_OUT_2_txFull1			   : in  std_logic;
      lvdsIo_IN_1_rxData0		   	   : in  std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 );
      lvdsIo_IN_1_rxRdEn0		   	   : out std_logic;
      lvdsIo_IN_1_rxValid0		           : in  std_logic;
      lvdsIo_IN_1_rxEmpty0		       	   : in  std_logic;
      lvdsIo_IN_1_rxData1		   	   : in  std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 );
      lvdsIo_IN_1_rxRdEn1		           : out std_logic;
      lvdsIo_IN_1_rxValid1		       	   : in  std_logic;
      lvdsIo_IN_1_rxEmpty1		       	   : in  std_logic;
      lvdsIo_OUT_1_txData0		           : out std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 );
      lvdsIo_OUT_1_txWrEn0		           : out std_logic;
      lvdsIo_OUT_1_txWrAck0		           : in  std_logic;
      lvdsIo_OUT_1_txFull0		           : in  std_logic;
      lvdsIo_OUT_1_txData1		           : out std_logic_vector( lvds_io_params_gen_lvds_io_bottom_g -1 downto 0 );
      lvdsIo_OUT_1_txWrEn1		           : out std_logic;
      lvdsIo_OUT_1_txWrAck1		           : in  std_logic;
      lvdsIo_OUT_1_txFull1		           : in  std_logic;

      -- LVDS GPIO
      mestor_gpio_0_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
      mestor_gpio_0_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
      mestor_gpio_0_write_outputenable     : out std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
      mestor_gpio_1_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
      mestor_gpio_1_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
      mestor_gpio_1_write_outputenable     : out std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
      mestor_gpio_2_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
      mestor_gpio_2_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
      mestor_gpio_2_write_outputenable     : out std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
      mestor_gpio_3_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
      mestor_gpio_3_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
      mestor_gpio_3_write_outputenable     : out std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
      -- LVDS SYNC
      mestor_sync_0_write_outputenable     : out std_logic := '0';
      mestor_sync_0_read_ready             : in  std_logic := '0';
      mestor_sync_0_read_re                : out std_logic := '0';
      mestor_sync_0_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
      mestor_sync_0_read_valid             : in  std_logic := '0';
      mestor_sync_0_write_ready            : in  std_logic := '0';
      mestor_sync_0_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_0-1 downto 0) := ( others => '0' );
      mestor_sync_0_write_we               : out std_logic := '0';
      mestor_sync_1_write_outputenable     : out std_logic := '0';
      mestor_sync_1_read_ready             : in  std_logic := '0';
      mestor_sync_1_read_re                : out std_logic := '0';
      mestor_sync_1_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
      mestor_sync_1_read_valid             : in  std_logic := '0';
      mestor_sync_1_write_ready            : in  std_logic := '0';
      mestor_sync_1_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_1-1 downto 0) := ( others => '0' );
      mestor_sync_1_write_we               : out std_logic := '0';
      mestor_sync_2_write_outputenable     : out std_logic := '0';
      mestor_sync_2_read_ready             : in  std_logic := '0';
      mestor_sync_2_read_re                : out std_logic := '0';
      mestor_sync_2_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
      mestor_sync_2_read_valid             : in  std_logic := '0';
      mestor_sync_2_write_ready            : in  std_logic := '0';
      mestor_sync_2_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_2-1 downto 0) := ( others => '0' );
      mestor_sync_2_write_we               : out std_logic := '0';
      mestor_sync_3_write_outputenable     : out std_logic := '0';
      mestor_sync_3_read_ready             : in  std_logic := '0';
      mestor_sync_3_read_re                : out std_logic := '0';
      mestor_sync_3_read_data              : in  std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
      mestor_sync_3_read_valid             : in  std_logic := '0';
      mestor_sync_3_write_ready            : in  std_logic := '0';
      mestor_sync_3_write_data             : out std_logic_vector(LVDS_DATA_WIDTH_3-1 downto 0) := ( others => '0' );
      mestor_sync_3_write_we               : out std_logic := '0';

      -- AMC GPIO section
      nutaq_backplane_gpio_output0       : out std_logic;
      nutaq_backplane_gpio_output1       : out std_logic;
      nutaq_backplane_gpio_input0        : in  std_logic;
      nutaq_backplane_gpio_input1        : in  std_logic;
      nutaq_backplane_gpio_output_tclk_a : out std_logic;
      nutaq_backplane_gpio_output_tclk_b : out std_logic;
      nutaq_backplane_gpio_output_tclk_c : out std_logic;
      nutaq_backplane_gpio_output_tclk_d : out std_logic;
      nutaq_backplane_gpio_input_tclk_a  : in  std_logic;
      nutaq_backplane_gpio_input_tclk_b  : in  std_logic;
      nutaq_backplane_gpio_input_tclk_c  : in  std_logic;
      nutaq_backplane_gpio_input_tclk_d  : in  std_logic
    );
    end component;

    attribute keep_hierarchy : string;
    attribute keep_hierarchy of rtl : architecture is "true";

begin


  ov32_SysgenDataOut_p     <= v32_SysgenDataOut_s;

  -- in use

  ov32_CustomReg0wr_p      <= v32_CustomReg0wr_s;
  ov32_CustomReg1wr_p      <= v32_CustomReg1wr_s;
  ov32_CustomReg2wr_p      <= v32_CustomReg2wr_s;
  ov32_CustomReg3wr_p      <= v32_CustomReg3wr_s;
  ov32_CustomReg4wr_p      <= v32_CustomReg4wr_s;
  ov32_CustomReg5wr_p      <= v32_CustomReg5wr_s;
  ov32_CustomReg6wr_p      <= v32_CustomReg6wr_s;
  ov32_CustomReg7wr_p      <= v32_CustomReg7wr_s;
  ov32_CustomReg8wr_p      <= v32_CustomReg8wr_s;
  ov32_CustomReg9wr_p      <= v32_CustomReg9wr_s;
  ov32_CustomReg10wr_p     <= v32_CustomReg10wr_s;
  ov32_CustomReg11wr_p     <= v32_CustomReg11wr_s;
  ov32_CustomReg12wr_p     <= v32_CustomReg12wr_s;
  ov32_CustomReg13wr_p     <= v32_CustomReg13wr_s;
  ov32_CustomReg14wr_p     <= v32_CustomReg14wr_s;
  ov32_CustomReg15wr_p     <= v32_CustomReg15wr_s;
  ov32_CustomReg16wr_p     <= v32_CustomReg16wr_s;
  ov32_CustomReg17wr_p     <= v32_CustomReg17wr_s;
  ov32_CustomReg18wr_p     <= v32_CustomReg18wr_s;
  ov32_CustomReg19wr_p     <= v32_CustomReg19wr_s;
  ov32_CustomReg20wr_p     <= v32_CustomReg20wr_s;
  ov32_CustomReg21wr_p     <= v32_CustomReg21wr_s;
  ov32_CustomReg22wr_p     <= v32_CustomReg22wr_s;
  ov32_CustomReg23wr_p     <= v32_CustomReg23wr_s;
  ov32_CustomReg24wr_p     <= v32_CustomReg24wr_s;
  ov32_CustomReg25wr_p     <= v32_CustomReg25wr_s;
  ov32_CustomReg26wr_p     <= v32_CustomReg26wr_s;
  ov32_CustomReg27wr_p     <= v32_CustomReg27wr_s;
  ov32_CustomReg28wr_p     <= v32_CustomReg28wr_s;
  ov32_CustomReg29wr_p     <= v32_CustomReg29wr_s;
  ov32_CustomReg30wr_p     <= v32_CustomReg30wr_s;
  ov32_CustomReg31wr_p     <= v32_CustomReg31wr_s;

  -- RTDEx Emac0
  o_RTDEx_Emac0_RxReCh0_p <=  v8_RTDExEmac0RxRe_s(0);
  o_RTDEx_Emac0_RxReCh1_p <=  v8_RTDExEmac0RxRe_s(1);
  o_RTDEx_Emac0_RxReCh2_p <=  v8_RTDExEmac0RxRe_s(2);
  o_RTDEx_Emac0_RxReCh3_p <=  v8_RTDExEmac0RxRe_s(3);
  o_RTDEx_Emac0_RxReCh4_p <=  v8_RTDExEmac0RxRe_s(4);
  o_RTDEx_Emac0_RxReCh5_p <=  v8_RTDExEmac0RxRe_s(5);
  o_RTDEx_Emac0_RxReCh6_p <=  v8_RTDExEmac0RxRe_s(6);
  o_RTDEx_Emac0_RxReCh7_p <=  v8_RTDExEmac0RxRe_s(7);
  ---
  o_RTDEx_Emac0_TxWeCh0_p <=  v8_RTDExEmac0TxWe_s(0);
  o_RTDEx_Emac0_TxWeCh1_p <=  v8_RTDExEmac0TxWe_s(1);
  o_RTDEx_Emac0_TxWeCh2_p <=  v8_RTDExEmac0TxWe_s(2);
  o_RTDEx_Emac0_TxWeCh3_p <=  v8_RTDExEmac0TxWe_s(3);
  o_RTDEx_Emac0_TxWeCh4_p <=  v8_RTDExEmac0TxWe_s(4);
  o_RTDEx_Emac0_TxWeCh5_p <=  v8_RTDExEmac0TxWe_s(5);
  o_RTDEx_Emac0_TxWeCh6_p <=  v8_RTDExEmac0TxWe_s(6);
  o_RTDEx_Emac0_TxWeCh7_p <=  v8_RTDExEmac0TxWe_s(7);
  ---
  ov32_RTDEx_Emac0_TxDataCh0_p  <=  v32_RTDExEmac0TxDataCh0_s;
  ov32_RTDEx_Emac0_TxDataCh1_p  <=  v32_RTDExEmac0TxDataCh1_s;
  ov32_RTDEx_Emac0_TxDataCh2_p  <=  v32_RTDExEmac0TxDataCh2_s;
  ov32_RTDEx_Emac0_TxDataCh3_p  <=  v32_RTDExEmac0TxDataCh3_s;
  ov32_RTDEx_Emac0_TxDataCh4_p  <=  v32_RTDExEmac0TxDataCh4_s;
  ov32_RTDEx_Emac0_TxDataCh5_p  <=  v32_RTDExEmac0TxDataCh5_s;
  ov32_RTDEx_Emac0_TxDataCh6_p  <=  v32_RTDExEmac0TxDataCh6_s;
  ov32_RTDEx_Emac0_TxDataCh7_p  <=  v32_RTDExEmac0TxDataCh7_s;

  -- RTDEx PCIe
  o_RTDEx_PCIe_RxReCh0_p <=  v8_RTDExPCIeRxRe_s(0);
  o_RTDEx_PCIe_RxReCh1_p <=  v8_RTDExPCIeRxRe_s(1);
  o_RTDEx_PCIe_RxReCh2_p <=  v8_RTDExPCIeRxRe_s(2);
  o_RTDEx_PCIe_RxReCh3_p <=  v8_RTDExPCIeRxRe_s(3);
  o_RTDEx_PCIe_RxReCh4_p <=  v8_RTDExPCIeRxRe_s(4);
  o_RTDEx_PCIe_RxReCh5_p <=  v8_RTDExPCIeRxRe_s(5);
  o_RTDEx_PCIe_RxReCh6_p <=  v8_RTDExPCIeRxRe_s(6);
  o_RTDEx_PCIe_RxReCh7_p <=  v8_RTDExPCIeRxRe_s(7);
  ---
  o_RTDEx_PCIe_TxWeCh0_p <=  v8_RTDExPCIeTxWe_s(0);
  o_RTDEx_PCIe_TxWeCh1_p <=  v8_RTDExPCIeTxWe_s(1);
  o_RTDEx_PCIe_TxWeCh2_p <=  v8_RTDExPCIeTxWe_s(2);
  o_RTDEx_PCIe_TxWeCh3_p <=  v8_RTDExPCIeTxWe_s(3);
  o_RTDEx_PCIe_TxWeCh4_p <=  v8_RTDExPCIeTxWe_s(4);
  o_RTDEx_PCIe_TxWeCh5_p <=  v8_RTDExPCIeTxWe_s(5);
  o_RTDEx_PCIe_TxWeCh6_p <=  v8_RTDExPCIeTxWe_s(6);
  o_RTDEx_PCIe_TxWeCh7_p <=  v8_RTDExPCIeTxWe_s(7);
  ---
  ov32_RTDEx_PCIe_TxDataCh0_p  <=  v32_RTDExPCIeTxDataCh0_s;
  ov32_RTDEx_PCIe_TxDataCh1_p  <=  v32_RTDExPCIeTxDataCh1_s;
  ov32_RTDEx_PCIe_TxDataCh2_p  <=  v32_RTDExPCIeTxDataCh2_s;
  ov32_RTDEx_PCIe_TxDataCh3_p  <=  v32_RTDExPCIeTxDataCh3_s;
  ov32_RTDEx_PCIe_TxDataCh4_p  <=  v32_RTDExPCIeTxDataCh4_s;
  ov32_RTDEx_PCIe_TxDataCh5_p  <=  v32_RTDExPCIeTxDataCh5_s;
  ov32_RTDEx_PCIe_TxDataCh6_p  <=  v32_RTDExPCIeTxDataCh6_s;
  ov32_RTDEx_PCIe_TxDataCh7_p  <=  v32_RTDExPCIeTxDataCh7_s;

---
  o_RecTrigger_p          <= RecTrigger_s;
  ov_RecDataPort0_p       <= v_RecDataPort0_s;
  ov_RecDataPort1_p       <= v_RecDataPort1_s;
  ov_RecDataPort2_p       <= v_RecDataPort2_s;
  ov_RecDataPort3_p       <= v_RecDataPort3_s;
  ov_RecDataPort4_p       <= v_RecDataPort4_s;
  ov_RecDataPort5_p       <= v_RecDataPort5_s;
  ov_RecDataPort6_p       <= v_RecDataPort6_s;
  ov_RecDataPort7_p       <= v_RecDataPort7_s;
  ov_RecDataPort8_p       <= v_RecDataPort8_s;
  ov_RecDataPort9_p       <= v_RecDataPort9_s;
  ov_RecDataPort10_p      <= v_RecDataPort10_s;
  ov_RecDataPort11_p      <= v_RecDataPort11_s;
  ov_RecDataPort12_p      <= v_RecDataPort12_s;
  ov_RecDataPort13_p      <= v_RecDataPort13_s;
  ov_RecDataPort14_p      <= v_RecDataPort14_s;
  ov_RecDataPort15_p      <= v_RecDataPort15_s;
  o_RecWriteEn_p          <= RecWriteEn_s;

  o_PlayTriggerIn_p       <= PlayTriggerIn_s;
  o_PlayReadEn_p          <= PlayReadEn_s;

  o_RecPlayRxReady_p      <= RecPlayRxReady_s;
  o_RecPlayRxDataValid_p  <= RecPlayRxDataValid_s;
  ov32_RecPlayRxDataCh0_p <= v32_RecPlayRxDataCh0_s;

  o_RecPlayTxReady_p      <= RecPlayTxReady_s;

  o_TwrftExtCtrlEn_p      <= TwrftExtCtrlEn_s;						   --{TWRFT port :: fpga_ctrl}
  o_TwrftExtCtrlEn_p      <= '0';										   --{TWRFT port :: no_fpga_ctrl}
  o_TwrftTxGainAtt_p      <= TwrftTxGainAtt_s;						   --{TWRFT port :: fpga_ctrl}
  o_TwrftTxGainAtt_p      <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  ov2_TwrftTxGainPaGain_p <= v2_TwrftTxGainPaGain_s;                     --{TWRFT port :: fpga_ctrl}
  ov2_TwrftTxGainPaGain_p <= "00";                                       --{TWRFT port :: no_fpga_ctrl}
  ov5_TwrftTxGainMixAtt_p <= v5_TwrftTxGainMixAtt_s;                     --{TWRFT port :: fpga_ctrl}
  ov5_TwrftTxGainMixAtt_p <= "00000";                                    --{TWRFT port :: no_fpga_ctrl}
  ov12_TwrftRxGain_p      <= v12_TwrftRxGain_s;                          --{TWRFT port :: fpga_ctrl}
  ov12_TwrftRxGain_p      <= x"000";                                     --{TWRFT port :: no_fpga_ctrl}
  ov14_TwrftRxPllCfg_p    <= v14_TwrftRxPllCfg_s;                        --{TWRFT port :: fpga_ctrl}
  ov14_TwrftRxPllCfg_p    <= x"000"&"00";                                --{TWRFT port :: no_fpga_ctrl}
  ov14_TwrftTxPllCfg_p    <= v14_TwrftTxPllCfg_s;                        --{TWRFT port :: fpga_ctrl}
  ov14_TwrftTxPllCfg_p    <= x"000"&"00";                                --{TWRFT port :: no_fpga_ctrl}
  o_TwrftTxGain_update_p  <= TwrftTxGain_update_s;                       --{TWRFT port :: fpga_ctrl}
  o_TwrftTxGain_update_p  <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  o_TwrftRxGain_update_p  <= TwrftRxGain_update_s;                       --{TWRFT port :: fpga_ctrl}
  o_TwrftRxGain_update_p  <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  o_TwrftRxPllCfgUpdate_p <= TwrftRxPllCfgUpdate_s;                      --{TWRFT port :: fpga_ctrl}
  o_TwrftRxPllCfgUpdate_p <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  o_TwrftTxPllCfgUpdate_p <= TwrftTxPllCfgUpdate_s;                      --{TWRFT port :: fpga_ctrl}
  o_TwrftTxPllCfgUpdate_p <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  o_TwrftTxnRx1_p         <= TwrftTxnRx1_s;                              --{TWRFT port :: fpga_ctrl}
  o_TwrftTxnRx1_p         <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  o_TwrftTxnRx2_p         <= TwrftTxnRx2_s;                              --{TWRFT port :: fpga_ctrl}
  o_TwrftTxnRx2_p         <= '0';                                        --{TWRFT port :: no_fpga_ctrl}
  o_TwrftTransceiverId_p  <= TwrftTransceiverId_s;                       --{TWRFT port :: fpga_ctrl}
  o_TwrftTransceiverId_p  <= '0';                                        --{TWRFT port :: no_fpga_ctrl}

  -- Radio420x section
  ov12_Radio420xDacDataCh1_p <= v12_Radio420xDacDataCh1_s;               --{RADIO420X port :: dac_1_in_use}
  ov12_Radio420xDacDataCh1_p <= x"000";                                  --{RADIO420X port :: dac_1_unused}
  ov12_Radio420xDacDataCh2_p <= v12_Radio420xDacDataCh2_s;               --{RADIO420X port :: dac_2_in_use}
  ov12_Radio420xDacDataCh2_p <= x"000";                                  --{RADIO420X port :: dac_2_unused}
  o_Radio420xDacIQSelCh1_p   <= Radio420xDacIQSelCh1_s;                  --{RADIO420X port :: dac_1_in_use}
  o_Radio420xDacIQSelCh1_p   <= '0';                                     --{RADIO420X port :: dac_1_unused}
  o_Radio420xDacIQSelCh2_p   <= Radio420xDacIQSelCh2_s;                  --{RADIO420X port :: dac_2_in_use}
  o_Radio420xDacIQSelCh2_p   <= '0';                                     --{RADIO420X port :: dac_2_unused}
  ov16_Radio420xDacRefClkCh1_p <= v16_Radio420xDacRefClkCh1_s;           --{RADIO420X port :: dac_ref_clk_1_in_use}
  ov16_Radio420xDacRefClkCh2_p <= v16_Radio420xDacRefClkCh2_s;           --{RADIO420X port :: dac_ref_clk_2_in_use}
  o_Radio420xDacRefClkStartCh1_p <= Radio420xDacRefClkStartCh1_s;        --{RADIO420X port :: dac_ref_clk_1_in_use}
  o_Radio420xDacRefClkStartCh2_p <= Radio420xDacRefClkStartCh2_s;        --{RADIO420X port :: dac_ref_clk_2_in_use}
  ov16_Radio420xLimeDataCh1_p <= v16_Radio420xLimeDataCh1_s;             --{RADIO420X port :: lime_data_1_in_use}
  ov16_Radio420xLimeDataCh2_p <= v16_Radio420xLimeDataCh2_s;             --{RADIO420X port :: lime_data_2_in_use}
  o_Radio420xLimeDataStartCh1_p <= Radio420xLimeDataStartCh1_s;          --{RADIO420X port :: lime_data_1_in_use}
  o_Radio420xLimeDataStartCh2_p <= Radio420xLimeDataStartCh2_s;          --{RADIO420X port :: lime_data_2_in_use}
  ov6_Radio420xRxGainCh1_p <= v6_Radio420xRxGainCh1_s;                   --{RADIO420X port :: rx_gain_1_in_use}
  ov6_Radio420xRxGainCh2_p <= v6_Radio420xRxGainCh2_s;                   --{RADIO420X port :: rx_gain_2_in_use}
  o_Radio420xRxGainStartCh1_p <= Radio420xRxGainStartCh1_s;              --{RADIO420X port :: rx_gain_1_in_use}
  o_Radio420xRxGainStartCh2_p <= Radio420xRxGainStartCh2_s;              --{RADIO420X port :: rx_gain_2_in_use}
  ov6_Radio420xTxGainCh1_p <= v6_Radio420xTxGainCh1_s;                   --{RADIO420X port :: tx_gain_1_in_use}
  ov6_Radio420xTxGainCh2_p <= v6_Radio420xTxGainCh2_s;                   --{RADIO420X port :: tx_gain_2_in_use}
  o_Radio420xTxGainStartCh1_p <= Radio420xTxGainStartCh1_s;              --{RADIO420X port :: tx_gain_1_in_use}
  o_Radio420xTxGainStartCh2_p <= Radio420xTxGainStartCh2_s;              --{RADIO420X port :: tx_gain_2_in_use}
  ov32_Radio420xPllCtrlCh1_p <= v32_Radio420xPllCtrlCh1_s;               --{RADIO420X port :: pll_ctrl_1_in_use}
  ov32_Radio420xPllCtrlCh2_p <= v32_Radio420xPllCtrlCh2_s;               --{RADIO420X port :: pll_ctrl_2_in_use}
  ov2_Radio420xPllCtrlStartCh1_p <= v2_Radio420xPllCtrlStartCh1_s;       --{RADIO420X port :: pll_ctrl_1_in_use}
  ov2_Radio420xPllCtrlStartCh2_p <= v2_Radio420xPllCtrlStartCh2_s;       --{RADIO420X port :: pll_ctrl_2_in_use}

  -- ADAC250 section
  ov16_Adac250_DacChA_p     <= v16_Adac250_DacChA_s;                     --{ADAC250 port :: dac_a_in_use}
  ov16_Adac250_DacChA_p     <= x"0000";                                  --{ADAC250 port :: dac_a_unused}
  ov16_Adac250_DacChB_p     <= v16_Adac250_DacChB_s;                     --{ADAC250 port :: dac_b_in_use}
  ov16_Adac250_DacChB_p     <= x"0000";                                  --{ADAC250 port :: dac_b_unused}
  o_Adac250_DacDataSync_p   <= Adac250_DacDataSync_s;                    --{ADAC250 port :: dac_sync_in_use}
  o_Adac250_DacDataSync_p   <= '1';                                      --{ADAC250 port :: dac_sync_unused}

  -- MI125 section
  o_Mi125TriggerOutput_p <= Mi125TriggerOutput_s;                        --{MI125 port :: bottom_trigger_output_in_use}
  o_Mi125TriggerOutput_p <= '0';                                         --{MI125 port :: bottom_trigger_output_unused}
  
  -- MO1000 section
  ov16_Mo1000DacDataCh1_p <= v16_Mo1000DacDataCh1_s;                     --{MO1000 port :: dac1_in_use}
  ov16_Mo1000DacDataCh1_p <= (others => '0');                            --{MO1000 port :: dac1_unused}
  ov16_Mo1000DacDataCh2_p <= v16_Mo1000DacDataCh2_s;                     --{MO1000 port :: dac2_in_use}
  ov16_Mo1000DacDataCh2_p <= (others => '0');                            --{MO1000 port :: dac2_unused}
  ov16_Mo1000DacDataCh3_p <= v16_Mo1000DacDataCh3_s;                     --{MO1000 port :: dac3_in_use}
  ov16_Mo1000DacDataCh3_p <= (others => '0');                            --{MO1000 port :: dac3_unused}
  ov16_Mo1000DacDataCh4_p <= v16_Mo1000DacDataCh4_s;                     --{MO1000 port :: dac4_in_use}
  ov16_Mo1000DacDataCh4_p <= (others => '0');                            --{MO1000 port :: dac4_unused}
  ov16_Mo1000DacDataCh5_p <= v16_Mo1000DacDataCh5_s;                     --{MO1000 port :: dac5_in_use}
  ov16_Mo1000DacDataCh5_p <= (others => '0');                            --{MO1000 port :: dac5_unused}
  ov16_Mo1000DacDataCh6_p <= v16_Mo1000DacDataCh6_s;                     --{MO1000 port :: dac6_in_use}
  ov16_Mo1000DacDataCh6_p <= (others => '0');                            --{MO1000 port :: dac6_unused}
  ov16_Mo1000DacDataCh7_p <= v16_Mo1000DacDataCh7_s;                     --{MO1000 port :: dac7_in_use}
  ov16_Mo1000DacDataCh7_p <= (others => '0');                            --{MO1000 port :: dac7_unused}
  ov16_Mo1000DacDataCh8_p <= v16_Mo1000DacDataCh8_s;                     --{MO1000 port :: dac8_in_use}
  ov16_Mo1000DacDataCh8_p <= (others => '0');                            --{MO1000 port :: dac8_unused}
  ov16_Mo1000DacDataCh9_p <= v16_Mo1000DacDataCh9_s;                     --{MO1000 port :: dac9_in_use}
  ov16_Mo1000DacDataCh9_p <= (others => '0');                            --{MO1000 port :: dac9_unused}
  ov16_Mo1000DacDataCh10_p <= v16_Mo1000DacDataCh10_s;                   --{MO1000 port :: dac10_in_use}
  ov16_Mo1000DacDataCh10_p <= (others => '0');                           --{MO1000 port :: dac10_unused}
  ov16_Mo1000DacDataCh11_p <= v16_Mo1000DacDataCh11_s;                   --{MO1000 port :: dac11_in_use}
  ov16_Mo1000DacDataCh11_p <= (others => '0');                           --{MO1000 port :: dac11_unused}
  ov16_Mo1000DacDataCh12_p <= v16_Mo1000DacDataCh12_s;                   --{MO1000 port :: dac12_in_use}
  ov16_Mo1000DacDataCh12_p <= (others => '0');                           --{MO1000 port :: dac12_unused}
  ov16_Mo1000DacDataCh13_p <= v16_Mo1000DacDataCh13_s;                   --{MO1000 port :: dac13_in_use}
  ov16_Mo1000DacDataCh13_p <= (others => '0');                           --{MO1000 port :: dac13_unused}
  ov16_Mo1000DacDataCh14_p <= v16_Mo1000DacDataCh14_s;                   --{MO1000 port :: dac14_in_use}
  ov16_Mo1000DacDataCh14_p <= (others => '0');                           --{MO1000 port :: dac14_unused}
  ov16_Mo1000DacDataCh15_p <= v16_Mo1000DacDataCh15_s;                   --{MO1000 port :: dac15_in_use}
  ov16_Mo1000DacDataCh15_p <= (others => '0');                           --{MO1000 port :: dac15_unused}
  ov16_Mo1000DacDataCh16_p <= v16_Mo1000DacDataCh16_s;                   --{MO1000 port :: dac16_in_use}
  ov16_Mo1000DacDataCh16_p <= (others => '0');                           --{MO1000 port :: dac16_unused}

  ov_lvdsIo_OUT_2_txData0_p	<= ov_lvdsIo_OUT_2_txData0_s;
  ov_lvdsIo_OUT_2_txData1_p	<= ov_lvdsIo_OUT_2_txData1_s;

  ov_lvdsIo_OUT_1_txData0_p	<= ov_lvdsIo_OUT_1_txData0_s;
  ov_lvdsIo_OUT_1_txData1_p	<= ov_lvdsIo_OUT_1_txData1_s;

  o_lvdsIo_IN_1_rxRdEn0_p	    <= o_lvdsIo_IN_1_rxRdEn0_s;
  o_lvdsIo_IN_1_rxRdEn1_p	    <= o_lvdsIo_IN_1_rxRdEn1_s;
  o_lvdsIo_IN_2_rxRdEn0_p     <= o_lvdsIo_IN_2_rxRdEn0_s;
  o_lvdsIo_IN_2_rxRdEn1_p     <= o_lvdsIo_IN_2_rxRdEn1_s;
  o_lvdsIo_OUT_1_txWrEn0_p    <= o_lvdsIo_OUT_1_txWrEn0_s;
  o_lvdsIo_OUT_1_txWrEn1_p    <= o_lvdsIo_OUT_1_txWrEn1_s;
  o_lvdsIo_OUT_2_txWrEn0_p    <= o_lvdsIo_OUT_2_txWrEn0_s;
  o_lvdsIo_OUT_2_txWrEn1_p    <= o_lvdsIo_OUT_2_txWrEn1_s;

  -- AMC GPIO section
  o_nutaq_backplane_gpio_0_p  <= nutaq_backplane_gpio_output_0_s;
  o_nutaq_backplane_gpio_1_p  <= nutaq_backplane_gpio_output_1_s;
  o_nutaq_backplane_gpio_tclk_a_p  <= nutaq_backplane_gpio_output_tclk_a_s;
  o_nutaq_backplane_gpio_tclk_b_p  <= nutaq_backplane_gpio_output_tclk_b_s;
  o_nutaq_backplane_gpio_tclk_c_p  <= nutaq_backplane_gpio_output_tclk_c_s;
  o_nutaq_backplane_gpio_tclk_d_p  <= nutaq_backplane_gpio_output_tclk_d_s;


  o_DesignClk_p  <=  DesignClk_s;

  DesignClk_s <= i_DesignClk_p;

  CosimInterface_l : sysgen_hw_cosim_interface
    port map(

      -- Sysgen Interface
      bank_sel                  => iv8_SysgenBanksel_p,
      addr                      => iv24_SysgenAddr_p,
      data_in                   => iv32_SysgenDataIn_p,
      we                        => i_SysgenWe_p,
      re                        => i_SysgenRe_p,
      data_out                  => v32_SysgenDataOut_s,
      pci_clk                   => i_SysgenPciClk_p,
      clk                       => i_DesignClk_p,

      -- Custom Registers
      reg0_wr  =>  v32_CustomReg0wr_s,    							   --{CUSTOM_REG port :: reg0_wr_in_use}
      reg0_rd  =>  iv32_CustomReg0rd_p,
      reg1_wr  =>  v32_CustomReg1wr_s,    							   --{CUSTOM_REG port :: reg1_wr_in_use}
      reg1_rd  =>  iv32_CustomReg1rd_p,
      reg2_wr  =>  v32_CustomReg2wr_s,    							   --{CUSTOM_REG port :: reg2_wr_in_use}
      reg2_rd  =>  iv32_CustomReg2rd_p,
      reg3_wr  =>  v32_CustomReg3wr_s,    							   --{CUSTOM_REG port :: reg3_wr_in_use}
      reg3_rd  =>  iv32_CustomReg3rd_p,
      reg4_wr  =>  v32_CustomReg4wr_s,    							   --{CUSTOM_REG port :: reg4_wr_in_use}
      reg4_rd  =>  iv32_CustomReg4rd_p,
      reg5_wr  =>  v32_CustomReg5wr_s,    							   --{CUSTOM_REG port :: reg5_wr_in_use}
      reg5_rd  =>  iv32_CustomReg5rd_p,
      reg6_wr  =>  v32_CustomReg6wr_s,    							   --{CUSTOM_REG port :: reg6_wr_in_use}
      reg6_rd  =>  iv32_CustomReg6rd_p,
      reg7_wr  =>  v32_CustomReg7wr_s,    							   --{CUSTOM_REG port :: reg7_wr_in_use}
      reg7_rd  =>  iv32_CustomReg7rd_p,
      reg8_wr  =>  v32_CustomReg8wr_s,    							   --{CUSTOM_REG port :: reg8_wr_in_use}
      reg8_rd  =>  iv32_CustomReg8rd_p,
      reg9_wr  =>  v32_CustomReg9wr_s,    							   --{CUSTOM_REG port :: reg9_wr_in_use}
      reg9_rd  =>  iv32_CustomReg9rd_p,
      reg10_wr =>  v32_CustomReg10wr_s,   							   --{CUSTOM_REG port :: reg10_wr_in_use}
      reg10_rd =>  iv32_CustomReg10rd_p,
      reg11_wr =>  v32_CustomReg11wr_s,   							   --{CUSTOM_REG port :: reg11_wr_in_use}
      reg11_rd =>  iv32_CustomReg11rd_p,
      reg12_wr =>  v32_CustomReg12wr_s,   							   --{CUSTOM_REG port :: reg12_wr_in_use}
      reg12_rd =>  iv32_CustomReg12rd_p,
      reg13_wr =>  v32_CustomReg13wr_s,   							   --{CUSTOM_REG port :: reg13_wr_in_use}
      reg13_rd =>  iv32_CustomReg13rd_p,
      reg14_wr =>  v32_CustomReg14wr_s,   							   --{CUSTOM_REG port :: reg14_wr_in_use}
      reg14_rd =>  iv32_CustomReg14rd_p,
      reg15_wr =>  v32_CustomReg15wr_s,   							   --{CUSTOM_REG port :: reg15_wr_in_use}
      reg15_rd =>  iv32_CustomReg15rd_p,
      reg16_wr =>  v32_CustomReg16wr_s,   							   --{CUSTOM_REG port :: reg16_wr_in_use}
      reg16_rd =>  iv32_CustomReg16rd_p,
      reg17_wr =>  v32_CustomReg17wr_s,   							   --{CUSTOM_REG port :: reg17_wr_in_use}
      reg17_rd =>  iv32_CustomReg17rd_p,
      reg18_wr =>  v32_CustomReg18wr_s,   							   --{CUSTOM_REG port :: reg18_wr_in_use}
      reg18_rd =>  iv32_CustomReg18rd_p,
      reg19_wr =>  v32_CustomReg19wr_s,   							   --{CUSTOM_REG port :: reg19_wr_in_use}
      reg19_rd =>  iv32_CustomReg19rd_p,
      reg20_wr =>  v32_CustomReg20wr_s,   							   --{CUSTOM_REG port :: reg20_wr_in_use}
      reg20_rd =>  iv32_CustomReg20rd_p,
      reg21_wr =>  v32_CustomReg21wr_s,   							   --{CUSTOM_REG port :: reg21_wr_in_use}
      reg21_rd =>  iv32_CustomReg21rd_p,
      reg22_wr =>  v32_CustomReg22wr_s,   							   --{CUSTOM_REG port :: reg22_wr_in_use}
      reg22_rd =>  iv32_CustomReg22rd_p,
      reg23_wr =>  v32_CustomReg23wr_s,   							   --{CUSTOM_REG port :: reg23_wr_in_use}
      reg23_rd =>  iv32_CustomReg23rd_p,
      reg24_wr =>  v32_CustomReg24wr_s,   							   --{CUSTOM_REG port :: reg24_wr_in_use}
      reg24_rd =>  iv32_CustomReg24rd_p,
      reg25_wr =>  v32_CustomReg25wr_s,   							   --{CUSTOM_REG port :: reg25_wr_in_use}
      reg25_rd =>  iv32_CustomReg25rd_p,
      reg26_wr =>  v32_CustomReg26wr_s,   							   --{CUSTOM_REG port :: reg26_wr_in_use}
      reg26_rd =>  iv32_CustomReg26rd_p,
      reg27_wr =>  v32_CustomReg27wr_s,   							   --{CUSTOM_REG port :: reg27_wr_in_use}
      reg27_rd =>  iv32_CustomReg27rd_p,
      reg28_wr =>  v32_CustomReg28wr_s,   							   --{CUSTOM_REG port :: reg28_wr_in_use}
      reg28_rd =>  iv32_CustomReg28rd_p,
      reg29_wr =>  v32_CustomReg29wr_s,   							   --{CUSTOM_REG port :: reg29_wr_in_use}
      reg29_rd =>  iv32_CustomReg29rd_p,
      reg30_wr =>  v32_CustomReg30wr_s,   							   --{CUSTOM_REG port :: reg30_wr_in_use}
      reg30_rd =>  iv32_CustomReg30rd_p,
      reg31_wr =>  v32_CustomReg31wr_s,   							   --{CUSTOM_REG port :: reg31_wr_in_use}
      reg31_rd =>  iv32_CustomReg31rd_p,

      -- Record and playback
      record_trig        => RecTrigger_s,                       		   --{RECORD_PLAYBACK port :: record_trigger_in_use}
      record_fifo_full   => i_RecFifoFull_p,

      record_rtdex_rx_data_ch0 => v32_RecPlayRxDataCh0_s,       		   --{RECORD_PLAYBACK port :: record_rtdex_in_use}
      record_rtdex_rx_re       => i_RecPlayRxRe_p,
      record_rtdex_rx_ready    => RecPlayRxReady_s,             		   --{RECORD_PLAYBACK port :: record_rtdex_in_use}
      record_rtdex_rx_data_valid => RecPlayRxDataValid_s,       		   --{RECORD_PLAYBACK port :: record_rtdex_in_use}

      playback_trig       => PlayTriggerIn_s,                   		   --{RECORD_PLAYBACK port :: playback_trigger_in_use}
      playback_fifo_empty => i_PlayEmpty_p,

      playback_rtdex_tx_data_ch0 => iv32_RecPlayTxDataCh0_p,
      playback_rtdex_tx_we       => i_RecPlayTxWe_p,
      playback_rtdex_tx_ready    => RecPlayTxReady_s,           		   --{RECORD_PLAYBACK port :: playback_rtdex_in_use}

      record_data_port0  => v_RecDataPort0_s,                   		   --{RECORD_PLAYBACK port :: record_data_port0_in_use}
      record_data_port1  => v_RecDataPort1_s,                   		   --{RECORD_PLAYBACK port :: record_data_port1_in_use}
      record_data_port2  => v_RecDataPort2_s,                   		   --{RECORD_PLAYBACK port :: record_data_port2_in_use}
      record_data_port3  => v_RecDataPort3_s,                   		   --{RECORD_PLAYBACK port :: record_data_port3_in_use}
      record_data_port4  => v_RecDataPort4_s,                   		   --{RECORD_PLAYBACK port :: record_data_port4_in_use}
      record_data_port5  => v_RecDataPort5_s,                   		   --{RECORD_PLAYBACK port :: record_data_port5_in_use}
      record_data_port6  => v_RecDataPort6_s,                   		   --{RECORD_PLAYBACK port :: record_data_port6_in_use}
      record_data_port7  => v_RecDataPort7_s,                   		   --{RECORD_PLAYBACK port :: record_data_port7_in_use}
      record_data_port8  => v_RecDataPort8_s,                   		   --{RECORD_PLAYBACK port :: record_data_port8_in_use}
      record_data_port9  => v_RecDataPort9_s,                   		   --{RECORD_PLAYBACK port :: record_data_port9_in_use}
      record_data_port10 => v_RecDataPort10_s,                  		   --{RECORD_PLAYBACK port :: record_data_port10_in_use}
      record_data_port11 => v_RecDataPort11_s,                  		   --{RECORD_PLAYBACK port :: record_data_port11_in_use}
      record_data_port12 => v_RecDataPort12_s,                  		   --{RECORD_PLAYBACK port :: record_data_port12_in_use}
      record_data_port13 => v_RecDataPort13_s,                  		   --{RECORD_PLAYBACK port :: record_data_port13_in_use}
      record_data_port14 => v_RecDataPort14_s,                  		   --{RECORD_PLAYBACK port :: record_data_port14_in_use}
      record_data_port15 => v_RecDataPort15_s,                  		   --{RECORD_PLAYBACK port :: record_data_port15_in_use}
      record_wr_en       => RecWriteEn_s,                       		   --{RECORD_PLAYBACK port :: record_in_use}


      playback_data_port0  => iv_PlayDataPort0_p,
      playback_data_port1  => iv_PlayDataPort1_p,
      playback_data_port2  => iv_PlayDataPort2_p,
      playback_data_port3  => iv_PlayDataPort3_p,
      playback_data_port4  => iv_PlayDataPort4_p,
      playback_data_port5  => iv_PlayDataPort5_p,
      playback_data_port6  => iv_PlayDataPort6_p,
      playback_data_port7  => iv_PlayDataPort7_p,
      playback_data_port8  => iv_PlayDataPort8_p,
      playback_data_port9  => iv_PlayDataPort9_p,
      playback_data_port10 => iv_PlayDataPort10_p,
      playback_data_port11 => iv_PlayDataPort11_p,
      playback_data_port12 => iv_PlayDataPort12_p,
      playback_data_port13 => iv_PlayDataPort13_p,
      playback_data_port14 => iv_PlayDataPort14_p,
      playback_data_port15 => iv_PlayDataPort15_p,
      playback_rd_en      => PlayReadEn_s,                    		   --{RECORD_PLAYBACK port :: playback_in_use}
      playback_fifo_valid => i_PlayValid_p,

      -- Twin WiMAX RF Transceiver
      twrft_ext_ctrl_en           => TwrftExtCtrlEn_s,				   --{TWRFT port :: fpga_ctrl}
      twrft_tx_gain_att           => TwrftTxGainAtt_s,				   --{TWRFT port :: fpga_ctrl}
      twrft_tx_gain_pa_gain       => v2_TwrftTxGainPaGain_s,             --{TWRFT port :: fpga_ctrl}
      twrft_tx_gain_mix_att       => v5_TwrftTxGainMixAtt_s,             --{TWRFT port :: fpga_ctrl}
      twrft_rx_gain               => v12_TwrftRxGain_s,                  --{TWRFT port :: fpga_ctrl}
      twrft_rx_pll_cfg            => v14_TwrftRxPllCfg_s,                --{TWRFT port :: fpga_ctrl}
      twrft_tx_pll_cfg            => v14_TwrftTxPllCfg_s,                --{TWRFT port :: fpga_ctrl}
      twrft_tx_gain_update        => TwrftTxGain_update_s,               --{TWRFT port :: fpga_ctrl}
      twrft_rx_gain_update        => TwrftRxGain_update_s,               --{TWRFT port :: fpga_ctrl}
      twrft_rx_pll_cfg_update     => TwrftRxPllCfgUpdate_s,              --{TWRFT port :: fpga_ctrl}
      twrft_tx_pll_cfg_update     => TwrftTxPllCfgUpdate_s,              --{TWRFT port :: fpga_ctrl}
      twrft_tx_n_rx1              => TwrftTxnRx1_s,                      --{TWRFT port :: fpga_ctrl}
      twrft_tx_n_rx2              => TwrftTxnRx2_s,                      --{TWRFT port :: fpga_ctrl}
      twrft_transceiver_id        => TwrftTransceiverId_s,               --{TWRFT port :: fpga_ctrl}
      twrft_lock_detect           => i_TwrftLockDetect_p,                --{TWRFT port :: fpga_ctrl}
      twrft_spi_busy              => i_TwrftSpiBusy_p,                   --{TWRFT port :: fpga_ctrl}

      twrft_ext_ctrl_en           => open,				   			   --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_gain_att           => open,							   --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_gain_pa_gain       => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_gain_mix_att       => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_rx_gain               => open,			                   --{TWRFT port :: no_fpga_ctrl}
      twrft_rx_pll_cfg            => open,			                   --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_pll_cfg            => open,			                   --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_gain_update        => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_rx_gain_update        => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_rx_pll_cfg_update     => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_pll_cfg_update     => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_n_rx1              => open,		                       --{TWRFT port :: no_fpga_ctrl}
      twrft_tx_n_rx2              => open,		                       --{TWRFT port :: no_fpga_ctrl}
      twrft_transceiver_id        => open,				               --{TWRFT port :: no_fpga_ctrl}
      twrft_lock_detect           => '0',                                --{TWRFT port :: no_fpga_ctrl}
      twrft_spi_busy              => '0',                                --{TWRFT port :: no_fpga_ctrl}

      twrft_ext_ctrl_en           => open,				   			   --{TWRFT port :: unused}
      twrft_tx_gain_att           => open,							   --{TWRFT port :: unused}
      twrft_tx_gain_pa_gain       => open,				               --{TWRFT port :: unused}
      twrft_tx_gain_mix_att       => open,				               --{TWRFT port :: unused}
      twrft_rx_gain               => open,			                   --{TWRFT port :: unused}
      twrft_rx_pll_cfg            => open,			                   --{TWRFT port :: unused}
      twrft_tx_pll_cfg            => open,			                   --{TWRFT port :: unused}
      twrft_tx_gain_update        => open,				               --{TWRFT port :: unused}
      twrft_rx_gain_update        => open,				               --{TWRFT port :: unused}
      twrft_rx_pll_cfg_update     => open,				               --{TWRFT port :: unused}
      twrft_tx_pll_cfg_update     => open,				               --{TWRFT port :: unused}
      twrft_tx_n_rx1              => open,		                       --{TWRFT port :: unused}
      twrft_tx_n_rx2              => open,		                       --{TWRFT port :: unused}
      twrft_transceiver_id        => open,				               --{TWRFT port :: unused}
      twrft_lock_detect           => '0',                                --{TWRFT port :: unused}
      twrft_spi_busy              => '0',                                --{TWRFT port :: unused}

      -- Radio420X (in use section)
      radio420x_adc_1_data               => iv12_Radio420xAdcDataCh1_p,       --{RADIO420X port :: adc_1_in_use}
      radio420x_adc_2_data               => iv12_Radio420xAdcDataCh2_p,       --{RADIO420X port :: adc_2_in_use}
      radio420x_dac_1_data               => v12_Radio420xDacDataCh1_s,        --{RADIO420X port :: dac_1_in_use}
      radio420x_dac_2_data               => v12_Radio420xDacDataCh2_s,        --{RADIO420X port :: dac_2_in_use}
      radio420x_adc_iq_sel_ch1           => i_Radio420xAdcIQSelCh1_p,         --{RADIO420X port :: adc_1_in_use}
      radio420x_adc_iq_sel_ch2           => i_Radio420xAdcIQSelCh2_p,         --{RADIO420X port :: adc_2_in_use}
      radio420x_dac_iq_sel_ch1           => Radio420xDacIQSelCh1_s,           --{RADIO420X port :: dac_1_in_use}
      radio420x_dac_iq_sel_ch2           => Radio420xDacIQSelCh2_s,           --{RADIO420X port :: dac_2_in_use}
      radio420x_dac_ref_clk_ext_ctrl_ch1 => iv5_Radio420xExtCtrlCh1_p(0),     --{RADIO420X port :: dac_ref_clk_1_in_use}
      radio420x_dac_ref_clk_ext_ctrl_ch2 => iv5_Radio420xExtCtrlCh2_p(0),     --{RADIO420X port :: dac_ref_clk_2_in_use}
      radio420x_dac_ref_clk_ch1          => v16_Radio420xDacRefClkCh1_s,      --{RADIO420X port :: dac_ref_clk_1_in_use}
      radio420x_dac_ref_clk_ch2          => v16_Radio420xDacRefClkCh2_s,      --{RADIO420X port :: dac_ref_clk_2_in_use}
      radio420x_dac_ref_clk_start_ch1    => Radio420xDacRefClkStartCh1_s,     --{RADIO420X port :: dac_ref_clk_1_in_use}
      radio420x_dac_ref_clk_start_ch2    => Radio420xDacRefClkStartCh2_s,     --{RADIO420X port :: dac_ref_clk_2_in_use}
      radio420x_dac_ref_clk_busy_ch1     => i_Radio420xDacRefClkBusyCh1_p,    --{RADIO420X port :: dac_ref_clk_1_in_use}
      radio420x_dac_ref_clk_busy_ch2     => i_Radio420xDacRefClkBusyCh2_p,    --{RADIO420X port :: dac_ref_clk_2_in_use}
      radio420x_lime_data_ext_ctrl_ch1   => iv5_Radio420xExtCtrlCh1_p(1),     --{RADIO420X port :: lime_data_1_in_use}
      radio420x_lime_data_ext_ctrl_ch2   => iv5_Radio420xExtCtrlCh2_p(1),     --{RADIO420X port :: lime_data_2_in_use}
      radio420x_lime_data_ch1            => v16_Radio420xLimeDataCh1_s,       --{RADIO420X port :: lime_data_1_in_use}
      radio420x_lime_data_ch2            => v16_Radio420xLimeDataCh2_s,       --{RADIO420X port :: lime_data_2_in_use}
      radio420x_lime_data_start_ch1      => Radio420xLimeDataStartCh1_s,      --{RADIO420X port :: lime_data_1_in_use}
      radio420x_lime_data_start_ch2      => Radio420xLimeDataStartCh2_s,      --{RADIO420X port :: lime_data_2_in_use}
      radio420x_lime_data_busy_ch1       => i_Radio420xLimeDataBusyCh1_p,     --{RADIO420X port :: lime_data_1_in_use}
      radio420x_lime_data_busy_ch2       => i_Radio420xLimeDataBusyCh2_p,     --{RADIO420X port :: lime_data_2_in_use}
      radio420x_rx_gain_ext_ctrl_ch1     => iv5_Radio420xExtCtrlCh1_p(2),     --{RADIO420X port :: rx_gain_1_in_use}
      radio420x_rx_gain_ext_ctrl_ch2     => iv5_Radio420xExtCtrlCh2_p(2),     --{RADIO420X port :: rx_gain_2_in_use}
      radio420x_rx_gain_ch1              => v6_Radio420xRxGainCh1_s,          --{RADIO420X port :: rx_gain_1_in_use}
      radio420x_rx_gain_ch2              => v6_Radio420xRxGainCh2_s,          --{RADIO420X port :: rx_gain_2_in_use}
      radio420x_rx_gain_start_ch1        => Radio420xRxGainStartCh1_s,        --{RADIO420X port :: rx_gain_1_in_use}
      radio420x_rx_gain_start_ch2        => Radio420xRxGainStartCh2_s,        --{RADIO420X port :: rx_gain_2_in_use}
      radio420x_rx_gain_busy_ch1         => i_Radio420xRxGainBusyCh1_p,       --{RADIO420X port :: rx_gain_1_in_use}
      radio420x_rx_gain_busy_ch2         => i_Radio420xRxGainBusyCh2_p,       --{RADIO420X port :: rx_gain_2_in_use}
      radio420x_tx_gain_ext_ctrl_ch1     => iv5_Radio420xExtCtrlCh1_p(3),     --{RADIO420X port :: tx_gain_1_in_use}
      radio420x_tx_gain_ext_ctrl_ch2     => iv5_Radio420xExtCtrlCh2_p(3),     --{RADIO420X port :: tx_gain_2_in_use}
      radio420x_tx_gain_ch1              => v6_Radio420xTxGainCh1_s,          --{RADIO420X port :: tx_gain_1_in_use}
      radio420x_tx_gain_ch2              => v6_Radio420xTxGainCh2_s,          --{RADIO420X port :: tx_gain_2_in_use}
      radio420x_tx_gain_start_ch1        => Radio420xTxGainStartCh1_s,        --{RADIO420X port :: tx_gain_1_in_use}
      radio420x_tx_gain_start_ch2        => Radio420xTxGainStartCh2_s,        --{RADIO420X port :: tx_gain_2_in_use}
      radio420x_tx_gain_busy_ch1         => i_Radio420xTxGainBusyCh1_p,       --{RADIO420X port :: tx_gain_1_in_use}
      radio420x_tx_gain_busy_ch2         => i_Radio420xTxGainBusyCh2_p,       --{RADIO420X port :: tx_gain_2_in_use}
      radio420x_pll_ctrl_ext_ctrl_ch1    => iv5_Radio420xExtCtrlCh1_p(4),    --{RADIO420X port :: pll_ctrl_1_in_use}
      radio420x_pll_ctrl_ext_ctrl_ch2    => iv5_Radio420xExtCtrlCh2_p(4),    --{RADIO420X port :: pll_ctrl_2_in_use}
      radio420x_pll_ctrl_ch1             => v32_Radio420xPllCtrlCh1_s,        --{RADIO420X port :: pll_ctrl_1_in_use}
      radio420x_pll_ctrl_ch2             => v32_Radio420xPllCtrlCh2_s,        --{RADIO420X port :: pll_ctrl_2_in_use}
      radio420x_pll_ctrl_start_ch1       => v2_Radio420xPllCtrlStartCh1_s,    --{RADIO420X port :: pll_ctrl_1_in_use}
      radio420x_pll_ctrl_start_ch2       => v2_Radio420xPllCtrlStartCh2_s,    --{RADIO420X port :: pll_ctrl_2_in_use}
      radio420x_pll_ctrl_busy_ch1        => i_Radio420xPllCtrlBusyCh1_p,      --{RADIO420X port :: pll_ctrl_1_in_use}
      radio420x_pll_ctrl_busy_ch2        => i_Radio420xPllCtrlBusyCh2_p,      --{RADIO420X port :: pll_ctrl_2_in_use}
      -- Radio420X (unused section)
      radio420x_adc_1_data               => x"000",                      --{RADIO420X port :: adc_1_unused}
      radio420x_adc_2_data               => x"000",                      --{RADIO420X port :: adc_2_unused}
      --radio420x_dac_1_data             => open,                        --{RADIO420X port :: dac_1_unused}
      --radio420x_dac_2_data             => open,                        --{RADIO420X port :: dac_2_unused}
      radio420x_adc_iq_sel_ch1           => '0',                         --{RADIO420X port :: adc_1_unused}
      radio420x_adc_iq_sel_ch2           => '0',                         --{RADIO420X port :: adc_2_unused}
      --radio420x_dac_iq_sel_ch1         => open,                        --{RADIO420X port :: dac_1_unused}
      --radio420x_dac_iq_sel_ch2         => open,                        --{RADIO420X port :: dac_2_unused}
      radio420x_dac_ref_clk_ext_ctrl_ch1 => '0',                         --{RADIO420X port :: dac_ref_clk_1_unused}
      radio420x_dac_ref_clk_ext_ctrl_ch2 => '0',	                       --{RADIO420X port :: dac_ref_clk_2_unused}
      radio420x_dac_ref_clk_busy_ch1     => '0',                         --{RADIO420X port :: dac_ref_clk_1_unused}
      radio420x_dac_ref_clk_busy_ch2     => '0',                         --{RADIO420X port :: dac_ref_clk_2_unused}
      radio420x_lime_data_ext_ctrl_ch1   => '0',                         --{RADIO420X port :: lime_data_1_unused}
      radio420x_lime_data_ext_ctrl_ch2   => '0',                         --{RADIO420X port :: lime_data_2_unused}
      radio420x_lime_data_busy_ch1       => '0',                         --{RADIO420X port :: lime_data_1_unused}
      radio420x_lime_data_busy_ch2       => '0',                         --{RADIO420X port :: lime_data_2_unused}
      radio420x_rx_gain_ext_ctrl_ch1     => '0',                         --{RADIO420X port :: rx_gain_1_unused}
      radio420x_rx_gain_ext_ctrl_ch2     => '0',                         --{RADIO420X port :: rx_gain_2_unused}
      radio420x_rx_gain_busy_ch1         => '0',                         --{RADIO420X port :: rx_gain_1_unused}
      radio420x_rx_gain_busy_ch2         => '0',                         --{RADIO420X port :: rx_gain_2_unused}
      radio420x_tx_gain_ext_ctrl_ch1     => '0',                         --{RADIO420X port :: tx_gain_1_unused}
      radio420x_tx_gain_ext_ctrl_ch2     => '0',                         --{RADIO420X port :: tx_gain_2_unused}
      radio420x_tx_gain_busy_ch1         => '0',                         --{RADIO420X port :: tx_gain_1_unused}
      radio420x_tx_gain_busy_ch2         => '0',                         --{RADIO420X port :: tx_gain_2_unused}
      radio420x_pll_ctrl_ext_ctrl_ch1    => '0',                         --{RADIO420X port :: pll_ctrl_1_unused}
      radio420x_pll_ctrl_ext_ctrl_ch2    => '0',                         --{RADIO420X port :: pll_ctrl_2_unused}
      radio420x_pll_ctrl_busy_ch1        => '0',                         --{RADIO420X port :: pll_ctrl_1_unused}
      radio420x_pll_ctrl_busy_ch2        => '0',                         --{RADIO420X port :: pll_ctrl_2_unused}

      -- ADAC250 section (in use section)
      adac250_adc_a_data    => iv14_Adac250_AdcDataChA_p,                --{ADAC250 port :: adc_a_in_use}
      adac250_cha_ovr_f     => i_Adac250_ChA_OvrFiltred_p,               --{ADAC250 port :: adc_a_ovr_f_in_use}
      adac250_cha_ovr       => i_Adac250_ChA_OvrNotFiltred_p,            --{ADAC250 port :: adc_a_ovr_in_use}
      adac250_adc_b_data    => iv14_Adac250_AdcDataChB_p,                --{ADAC250 port :: adc_b_in_use}
      adac250_chb_ovr_f     => i_Adac250_ChB_OvrFiltred_p,               --{ADAC250 port :: adc_b_ovr_f_in_use}
      adac250_chb_ovr       => i_Adac250_ChB_OvrNotFiltred_p,            --{ADAC250 port :: adc_b_ovr_in_use}
      adac250_data_format   => i_Adac250_DataFormat_p,                   --{ADAC250 port :: data_format_in_use}
      adac250_dac_a_data    => v16_Adac250_DacChA_s,                     --{ADAC250 port :: dac_a_in_use}
      adac250_dac_b_data    => v16_Adac250_DacChB_s,                     --{ADAC250 port :: dac_b_in_use}
      adac250_trig          => i_Adac250_Trigger_p,                      --{ADAC250 port :: trigger_in_use}
      adac250_dac_sync      => Adac250_DacDataSync_s,                    --{ADAC250 port :: dac_sync_in_use}
      -- ADAC250 section (unused section)
      adac250_adc_a_data    => "00000000000000",                         --{ADAC250 port :: adc_a_unused}
      adac250_cha_ovr_f     => '0',                                      --{ADAC250 port :: adc_a_ovr_f_unused}
      adac250_cha_ovr       => '0',                                      --{ADAC250 port :: adc_a_ovr_unused}
      adac250_adc_b_data    => "00000000000000",                         --{ADAC250 port :: adc_b_unused}
      adac250_chb_ovr_f     => '0',                                      --{ADAC250 port :: adc_b_ovr_f_unused}
      adac250_chb_ovr       => '0',                                      --{ADAC250 port :: adc_b_ovr_unused}
      adac250_data_format   => '0',                                      --{ADAC250 port :: data_format_unused}
      --adac250_dac_a_data    => open,                                   --{ADAC250 port :: dac_a_unused}
      --adac250_dac_b_data    => open,                                   --{ADAC250 port :: dac_b_unused}
      adac250_trig          => '0',                                      --{ADAC250 port :: trigger_unused}
      --adac250_dac_sync      => open,                                   --{ADAC250 port :: dac_sync_unused}

      -- ADC5000 section (in use section)
      adc5000_adc_a_data      => iv80_Adc5000_DataChA_p,                 --{ADC5000 port :: adc_a_in_use}
      adc5000_adc_b_data      => iv80_Adc5000_DataChB_p,                 --{ADC5000 port :: adc_b_in_use}
      adc5000_adc_c_data      => iv80_Adc5000_DataChC_p,                 --{ADC5000 port :: adc_c_in_use}
      adc5000_adc_d_data      => iv80_Adc5000_DataChD_p,                 --{ADC5000 port :: adc_d_in_use}
      adc5000_adc_a_ready     => i_Adc5000_ReadyChA_p,                   --{ADC5000 port :: adc_a_ovr_in_use}
      adc5000_adc_b_ready     => i_Adc5000_ReadyChB_p,                   --{ADC5000 port :: adc_b_ovr_in_use}
      adc5000_adc_c_ready     => i_Adc5000_ReadyChC_p,                   --{ADC5000 port :: adc_c_ovr_in_use}
      adc5000_adc_d_ready     => i_Adc5000_ReadyChD_p,                   --{ADC5000 port :: adc_d_ovr_in_use}
      adc5000_adc_a_ovr       => i_Adc5000_OverRangeChA_p,               --{ADC5000 port :: adc_a_in_use}
      adc5000_adc_b_ovr       => i_Adc5000_OverRangeChB_p,               --{ADC5000 port :: adc_b_in_use}
      adc5000_adc_c_ovr       => i_Adc5000_OverRangeChC_p,               --{ADC5000 port :: adc_c_in_use}
      adc5000_adc_d_ovr       => i_Adc5000_OverRangeChD_p,               --{ADC5000 port :: adc_d_in_use}
      adc5000_trig            => i_Adc5000_Trigger_p,                    --{ADC5000 port :: control_in_use}
      -- ADC5000 section (unused section)
      adc5000_adc_a_data      => X"00000000000000000000",                --{ADC5000 port :: adc_a_unused}
      adc5000_adc_b_data      => X"00000000000000000000",                --{ADC5000 port :: adc_b_unused}
      adc5000_adc_c_data      => X"00000000000000000000",                --{ADC5000 port :: adc_c_unused}
      adc5000_adc_d_data      => X"00000000000000000000",                --{ADC5000 port :: adc_d_unused}
      adc5000_adc_a_ready     => '0',                                    --{ADC5000 port :: adc_a_ovr_unused}
      adc5000_adc_b_ready     => '0',                                    --{ADC5000 port :: adc_b_ovr_unused}
      adc5000_adc_c_ready     => '0',                                    --{ADC5000 port :: adc_c_ovr_unused}
      adc5000_adc_d_ready     => '0',                                    --{ADC5000 port :: adc_d_ovr_unused}
      adc5000_adc_a_ovr       => '0',                                    --{ADC5000 port :: adc_a_unused}
      adc5000_adc_b_ovr       => '0',                                    --{ADC5000 port :: adc_b_unused}
      adc5000_adc_c_ovr       => '0',                                    --{ADC5000 port :: adc_c_unused}
      adc5000_adc_d_ovr       => '0',                                    --{ADC5000 port :: adc_d_unused}
      adc5000_trig            => '0',                                    --{ADC5000 port :: control_unused}

      -- AURORA section (in use section)
      aurora_amc4_7_RX_Fifo_Read_Enable_p    =>  o_aurora_amc4_7_RX_Fifo_Read_Enable_p   ,             --{AURORA port :: 4_7_in_use}
      aurora_amc4_7_RX_Fifo_Data_p           => iv_aurora_amc4_7_RX_Fifo_Data_p          ,             --{AURORA port :: 4_7_in_use}
      aurora_amc4_7_RX_Data_Valid_p          =>  i_aurora_amc4_7_RX_Data_Valid_p         ,             --{AURORA port :: 4_7_in_use}
      aurora_amc4_7_TX_Fifo_Data_p           => ov_aurora_amc4_7_TX_Fifo_Data_p          ,             --{AURORA port :: 4_7_in_use}
      aurora_amc4_7_TX_Fifo_Write_Enable_p   =>  o_aurora_amc4_7_TX_Fifo_Write_Enable_p  ,             --{AURORA port :: 4_7_in_use}
      aurora_amc4_7_TX_Fifo_Ready_p          =>  i_aurora_amc4_7_TX_Fifo_Ready_p         ,             --{AURORA port :: 4_7_in_use}

      aurora_amc8_11_RX_Fifo_Read_Enable_p   =>  o_aurora_amc8_11_RX_Fifo_Read_Enable_p  ,             --{AURORA port :: 8_11_in_use}
      aurora_amc8_11_RX_Fifo_Data_p          => iv_aurora_amc8_11_RX_Fifo_Data_p         ,             --{AURORA port :: 8_11_in_use}
      aurora_amc8_11_RX_Data_Valid_p         =>  i_aurora_amc8_11_RX_Data_Valid_p        ,             --{AURORA port :: 8_11_in_use}
      aurora_amc8_11_TX_Fifo_Data_p          => ov_aurora_amc8_11_TX_Fifo_Data_p         ,             --{AURORA port :: 8_11_in_use}
      aurora_amc8_11_TX_Fifo_Write_Enable_p  =>  o_aurora_amc8_11_TX_Fifo_Write_Enable_p ,             --{AURORA port :: 8_11_in_use}
      aurora_amc8_11_TX_Fifo_Ready_p         =>  i_aurora_amc8_11_TX_Fifo_Ready_p        ,             --{AURORA port :: 8_11_in_use}

      aurora_amc17_20_RX_Fifo_Read_Enable_p  =>  o_aurora_amc17_20_RX_Fifo_Read_Enable_p ,             --{AURORA port :: 17_20_in_use}
      aurora_amc17_20_RX_Fifo_Data_p         => iv_aurora_amc17_20_RX_Fifo_Data_p        ,             --{AURORA port :: 17_20_in_use}
      aurora_amc17_20_RX_Data_Valid_p        =>  i_aurora_amc17_20_RX_Data_Valid_p       ,             --{AURORA port :: 17_20_in_use}
      aurora_amc17_20_TX_Fifo_Data_p         => ov_aurora_amc17_20_TX_Fifo_Data_p        ,             --{AURORA port :: 17_20_in_use}
      aurora_amc17_20_TX_Fifo_Write_Enable_p =>  o_aurora_amc17_20_TX_Fifo_Write_Enable_p,             --{AURORA port :: 17_20_in_use}
      aurora_amc17_20_TX_Fifo_Ready_p        =>  i_aurora_amc17_20_TX_Fifo_Ready_p       ,             --{AURORA port :: 17_20_in_use}

      -- AURORA section (unused section)
      aurora_amc4_7_RX_Fifo_Read_Enable_p    => open           ,              --{AURORA port :: 4_7_unused}
      aurora_amc4_7_RX_Fifo_Data_p           => (others => '0'),              --{AURORA port :: 4_7_unused}
      aurora_amc4_7_RX_Data_Valid_p          => '0'            ,              --{AURORA port :: 4_7_unused}
      aurora_amc4_7_TX_Fifo_Data_p           => open           ,              --{AURORA port :: 4_7_unused}
      aurora_amc4_7_TX_Fifo_Write_Enable_p   => open           ,              --{AURORA port :: 4_7_unused}
      aurora_amc4_7_TX_Fifo_Ready_p          => '0'            ,              --{AURORA port :: 4_7_unused}

      aurora_amc8_11_RX_Fifo_Read_Enable_p   => open           ,              --{AURORA port :: 8_11_unused}
      aurora_amc8_11_RX_Fifo_Data_p          => (others => '0'),              --{AURORA port :: 8_11_unused}
      aurora_amc8_11_RX_Data_Valid_p         => '0'            ,              --{AURORA port :: 8_11_unused}
      aurora_amc8_11_TX_Fifo_Data_p          => open           ,              --{AURORA port :: 8_11_unused}
      aurora_amc8_11_TX_Fifo_Write_Enable_p  => open           ,              --{AURORA port :: 8_11_unused}
      aurora_amc8_11_TX_Fifo_Ready_p         => '0'            ,              --{AURORA port :: 8_11_unused}

      aurora_amc17_20_RX_Fifo_Read_Enable_p  => open           ,              --{AURORA port :: 17_20_unused}
      aurora_amc17_20_RX_Fifo_Data_p         => (others => '0'),              --{AURORA port :: 17_20_unused}
      aurora_amc17_20_RX_Data_Valid_p        => '0'            ,              --{AURORA port :: 17_20_unused}
      aurora_amc17_20_TX_Fifo_Data_p         => open           ,              --{AURORA port :: 17_20_unused}
      aurora_amc17_20_TX_Fifo_Write_Enable_p => open           ,              --{AURORA port :: 17_20_unused}
      aurora_amc17_20_TX_Fifo_Ready_p        => '0'            ,              --{AURORA port :: 17_20_unused}

      -- MI250 section (in use section)
      mi250_adc_a_data        => iv14_Mi250AdcADataOut_p,                --{MI250 port :: adc_a_in_use}
      mi250_adc_b_data        => iv14_Mi250AdcBDataOut_p,                --{MI250 port :: adc_b_in_use}
      mi250_adc_c_data        => iv14_Mi250AdcCDataOut_p,                --{MI250 port :: adc_c_in_use}
      mi250_adc_d_data        => iv14_Mi250AdcDDataOut_p,                --{MI250 port :: adc_d_in_use}
      mi250_adc_e_data        => iv14_Mi250AdcEDataOut_p,                --{MI250 port :: adc_e_in_use}
      mi250_adc_f_data        => iv14_Mi250AdcFDataOut_p,                --{MI250 port :: adc_f_in_use}
      mi250_adc_g_data        => iv14_Mi250AdcGDataOut_p,                --{MI250 port :: adc_g_in_use}
      mi250_adc_h_data        => iv14_Mi250AdcHDataOut_p,                --{MI250 port :: adc_h_in_use}
      mi250_adc_a_data_valid  => i_Mi250AdcADataValid_p,                 --{MI250 port :: adc_a_in_use}
      mi250_adc_b_data_valid  => i_Mi250AdcBDataValid_p,                 --{MI250 port :: adc_b_in_use}
      mi250_adc_c_data_valid  => i_Mi250AdcCDataValid_p,                 --{MI250 port :: adc_c_in_use}
      mi250_adc_d_data_valid  => i_Mi250AdcDDataValid_p,                 --{MI250 port :: adc_d_in_use}
      mi250_adc_e_data_valid  => i_Mi250AdcEDataValid_p,                 --{MI250 port :: adc_e_in_use}
      mi250_adc_f_data_valid  => i_Mi250AdcFDataValid_p,                 --{MI250 port :: adc_f_in_use}
      mi250_adc_g_data_valid  => i_Mi250AdcGDataValid_p,                 --{MI250 port :: adc_g_in_use}
      mi250_adc_h_data_valid  => i_Mi250AdcHDataValid_p,                 --{MI250 port :: adc_h_in_use}
      mi250_trig              => i_Mi250AdcTrigout_p,                    --{MI250 port :: control_in_use}
      -- MI250 section (unused section)
      mi250_adc_a_data        => "00000000000000",                       --{MI250 port :: adc_a_unused}
      mi250_adc_b_data        => "00000000000000",                       --{MI250 port :: adc_b_unused}
      mi250_adc_c_data        => "00000000000000",                       --{MI250 port :: adc_c_unused}
      mi250_adc_d_data        => "00000000000000",                       --{MI250 port :: adc_d_unused}
      mi250_adc_e_data        => "00000000000000",                       --{MI250 port :: adc_e_unused}
      mi250_adc_f_data        => "00000000000000",                       --{MI250 port :: adc_f_unused}
      mi250_adc_g_data        => "00000000000000",                       --{MI250 port :: adc_g_unused}
      mi250_adc_h_data        => "00000000000000",                       --{MI250 port :: adc_h_unused}
      mi250_adc_a_data_valid  => '0',                                    --{MI250 port :: adc_a_unused}
      mi250_adc_b_data_valid  => '0',                                    --{MI250 port :: adc_b_unused}
      mi250_adc_c_data_valid  => '0',                                    --{MI250 port :: adc_c_unused}
      mi250_adc_d_data_valid  => '0',                                    --{MI250 port :: adc_d_unused}
      mi250_adc_e_data_valid  => '0',                                    --{MI250 port :: adc_e_unused}
      mi250_adc_f_data_valid  => '0',                                    --{MI250 port :: adc_f_unused}
      mi250_adc_g_data_valid  => '0',                                    --{MI250 port :: adc_g_unused}
      mi250_adc_h_data_valid  => '0',                                    --{MI250 port :: adc_h_unused}
      mi250_trig              => '0',                                    --{MI250 port :: control_unused}

      -- MI125 section (in use section)
      mi125_adc_1_data        => iv14_Mi125AdcDataCh1_p,                 --{MI125 port :: adc1_in_use}
      mi125_adc_2_data        => iv14_Mi125AdcDataCh2_p,                 --{MI125 port :: adc2_in_use}
      mi125_adc_3_data        => iv14_Mi125AdcDataCh3_p,                 --{MI125 port :: adc3_in_use}
      mi125_adc_4_data        => iv14_Mi125AdcDataCh4_p,                 --{MI125 port :: adc4_in_use}
      mi125_adc_5_data        => iv14_Mi125AdcDataCh5_p,                 --{MI125 port :: adc5_in_use}
      mi125_adc_6_data        => iv14_Mi125AdcDataCh6_p,                 --{MI125 port :: adc6_in_use}
      mi125_adc_7_data        => iv14_Mi125AdcDataCh7_p,                 --{MI125 port :: adc7_in_use}
      mi125_adc_8_data        => iv14_Mi125AdcDataCh8_p,                 --{MI125 port :: adc8_in_use}
      mi125_adc_9_data        => iv14_Mi125AdcDataCh9_p,                 --{MI125 port :: adc9_in_use}
      mi125_adc_10_data       => iv14_Mi125AdcDataCh10_p,                --{MI125 port :: adc10_in_use}
      mi125_adc_11_data       => iv14_Mi125AdcDataCh11_p,                --{MI125 port :: adc11_in_use}
      mi125_adc_12_data       => iv14_Mi125AdcDataCh12_p,                --{MI125 port :: adc12_in_use}
      mi125_adc_13_data       => iv14_Mi125AdcDataCh13_p,                --{MI125 port :: adc13_in_use}
      mi125_adc_14_data       => iv14_Mi125AdcDataCh14_p,                --{MI125 port :: adc14_in_use}
      mi125_adc_15_data       => iv14_Mi125AdcDataCh15_p,                --{MI125 port :: adc15_in_use}
      mi125_adc_16_data       => iv14_Mi125AdcDataCh16_p,                --{MI125 port :: adc16_in_use}
      mi125_adc_17_data       => iv14_Mi125AdcDataCh17_p,                --{MI125 port :: adc17_in_use}
      mi125_adc_18_data       => iv14_Mi125AdcDataCh18_p,                --{MI125 port :: adc18_in_use}
      mi125_adc_19_data       => iv14_Mi125AdcDataCh19_p,                --{MI125 port :: adc19_in_use}
      mi125_adc_20_data       => iv14_Mi125AdcDataCh20_p,                --{MI125 port :: adc20_in_use}
      mi125_adc_21_data       => iv14_Mi125AdcDataCh21_p,                --{MI125 port :: adc21_in_use}
      mi125_adc_22_data       => iv14_Mi125AdcDataCh22_p,                --{MI125 port :: adc22_in_use}
      mi125_adc_23_data       => iv14_Mi125AdcDataCh23_p,                --{MI125 port :: adc23_in_use}
      mi125_adc_24_data       => iv14_Mi125AdcDataCh24_p,                --{MI125 port :: adc24_in_use}
      mi125_adc_25_data       => iv14_Mi125AdcDataCh25_p,                --{MI125 port :: adc25_in_use}
      mi125_adc_26_data       => iv14_Mi125AdcDataCh26_p,                --{MI125 port :: adc26_in_use}
      mi125_adc_27_data       => iv14_Mi125AdcDataCh27_p,                --{MI125 port :: adc27_in_use}
      mi125_adc_28_data       => iv14_Mi125AdcDataCh28_p,                --{MI125 port :: adc28_in_use}
      mi125_adc_29_data       => iv14_Mi125AdcDataCh29_p,                --{MI125 port :: adc29_in_use}
      mi125_adc_30_data       => iv14_Mi125AdcDataCh30_p,                --{MI125 port :: adc30_in_use}
      mi125_adc_31_data       => iv14_Mi125AdcDataCh31_p,                --{MI125 port :: adc31_in_use}
      mi125_adc_32_data       => iv14_Mi125AdcDataCh32_p,                --{MI125 port :: adc32_in_use}
      mi125_adc_1_data_valid  => i_Mi125AdcCh1Valid_p,                   --{MI125 port :: adc1_in_use}
      mi125_adc_2_data_valid  => i_Mi125AdcCh2Valid_p,                   --{MI125 port :: adc2_in_use}
      mi125_adc_3_data_valid  => i_Mi125AdcCh3Valid_p,                   --{MI125 port :: adc3_in_use}
      mi125_adc_4_data_valid  => i_Mi125AdcCh4Valid_p,                   --{MI125 port :: adc4_in_use}
      mi125_adc_5_data_valid  => i_Mi125AdcCh5Valid_p,                   --{MI125 port :: adc5_in_use}
      mi125_adc_6_data_valid  => i_Mi125AdcCh6Valid_p,                   --{MI125 port :: adc6_in_use}
      mi125_adc_7_data_valid  => i_Mi125AdcCh7Valid_p,                   --{MI125 port :: adc7_in_use}
      mi125_adc_8_data_valid  => i_Mi125AdcCh8Valid_p,                   --{MI125 port :: adc8_in_use}
      mi125_adc_9_data_valid  => i_Mi125AdcCh9Valid_p,                   --{MI125 port :: adc9_in_use}
      mi125_adc_10_data_valid => i_Mi125AdcCh10Valid_p,                  --{MI125 port :: adc10_in_use}
      mi125_adc_11_data_valid => i_Mi125AdcCh11Valid_p,                  --{MI125 port :: adc11_in_use}
      mi125_adc_12_data_valid => i_Mi125AdcCh12Valid_p,                  --{MI125 port :: adc12_in_use}
      mi125_adc_13_data_valid => i_Mi125AdcCh13Valid_p,                  --{MI125 port :: adc13_in_use}
      mi125_adc_14_data_valid => i_Mi125AdcCh14Valid_p,                  --{MI125 port :: adc14_in_use}
      mi125_adc_15_data_valid => i_Mi125AdcCh15Valid_p,                  --{MI125 port :: adc15_in_use}
      mi125_adc_16_data_valid => i_Mi125AdcCh16Valid_p,                  --{MI125 port :: adc16_in_use}
      mi125_adc_17_data_valid => i_Mi125AdcCh17Valid_p,                  --{MI125 port :: adc17_in_use}
      mi125_adc_18_data_valid => i_Mi125AdcCh18Valid_p,                  --{MI125 port :: adc18_in_use}
      mi125_adc_19_data_valid => i_Mi125AdcCh19Valid_p,                  --{MI125 port :: adc19_in_use}
      mi125_adc_20_data_valid => i_Mi125AdcCh20Valid_p,                  --{MI125 port :: adc20_in_use}
      mi125_adc_21_data_valid => i_Mi125AdcCh21Valid_p,                  --{MI125 port :: adc21_in_use}
      mi125_adc_22_data_valid => i_Mi125AdcCh22Valid_p,                  --{MI125 port :: adc22_in_use}
      mi125_adc_23_data_valid => i_Mi125AdcCh23Valid_p,                  --{MI125 port :: adc23_in_use}
      mi125_adc_24_data_valid => i_Mi125AdcCh24Valid_p,                  --{MI125 port :: adc24_in_use}
      mi125_adc_25_data_valid => i_Mi125AdcCh25Valid_p,                  --{MI125 port :: adc25_in_use}
      mi125_adc_26_data_valid => i_Mi125AdcCh26Valid_p,                  --{MI125 port :: adc26_in_use}
      mi125_adc_27_data_valid => i_Mi125AdcCh27Valid_p,                  --{MI125 port :: adc27_in_use}
      mi125_adc_28_data_valid => i_Mi125AdcCh28Valid_p,                  --{MI125 port :: adc28_in_use}
      mi125_adc_29_data_valid => i_Mi125AdcCh29Valid_p,                  --{MI125 port :: adc29_in_use}
      mi125_adc_30_data_valid => i_Mi125AdcCh30Valid_p,                  --{MI125 port :: adc30_in_use}
      mi125_adc_31_data_valid => i_Mi125AdcCh31Valid_p,                  --{MI125 port :: adc31_in_use}
      mi125_adc_32_data_valid => i_Mi125AdcCh32Valid_p,                  --{MI125 port :: adc32_in_use}
      mi125_trig_input        => i_Mi125TriggerInput_p,                  --{MI125 port :: trigger_input_in_use}
      mi125_trig_output       => Mi125TriggerOutput_s,                   --{MI125 port :: trigger_output_in_use}
      mi125_data_format       => i_Mi125DataFormat_p,                    --{MI125 port :: data_format_in_use}
      mi125_adc_1to4_enabled  => i_Mi125Adc1to4Enabled_p,                --{MI125 port :: adc_1to4_enabled_in_use}
      mi125_adc_5to8_enabled  => i_Mi125Adc5to8Enabled_p,                --{MI125 port :: adc_5to8_enabled_in_use}
      mi125_adc_9to12_enabled => i_Mi125Adc9to12Enabled_p,               --{MI125 port :: adc_9to12_enabled_in_use}
      mi125_adc_13to16_enabled => i_Mi125Adc13to16Enabled_p,             --{MI125 port :: adc_13to16_enabled_in_use}
      mi125_adc_17to20_enabled => i_Mi125Adc17to20Enabled_p,             --{MI125 port :: adc_17to20_enabled_in_use}
      mi125_adc_21to24_enabled => i_Mi125Adc21to24Enabled_p,             --{MI125 port :: adc_21to24_enabled_in_use}
      mi125_adc_25to28_enabled => i_Mi125Adc25to28Enabled_p,             --{MI125 port :: adc_25to28_enabled_in_use}
      mi125_adc_29to32_enabled => i_Mi125Adc29to32Enabled_p,             --{MI125 port :: adc_29to32_enabled_in_use}

      -- MI125 section (unused section)
      mi125_adc_1_data        => "00000000000000",                       --{MI125 port :: adc1_unused}
      mi125_adc_2_data        => "00000000000000",                       --{MI125 port :: adc2_unused}
      mi125_adc_3_data        => "00000000000000",                       --{MI125 port :: adc3_unused}
      mi125_adc_4_data        => "00000000000000",                       --{MI125 port :: adc4_unused}
      mi125_adc_5_data        => "00000000000000",                       --{MI125 port :: adc5_unused}
      mi125_adc_6_data        => "00000000000000",                       --{MI125 port :: adc6_unused}
      mi125_adc_7_data        => "00000000000000",                       --{MI125 port :: adc7_unused}
      mi125_adc_8_data        => "00000000000000",                       --{MI125 port :: adc8_unused}
      mi125_adc_9_data        => "00000000000000",                       --{MI125 port :: adc9_unused}
      mi125_adc_10_data       => "00000000000000",                       --{MI125 port :: adc10_unused}
      mi125_adc_11_data       => "00000000000000",                       --{MI125 port :: adc11_unused}
      mi125_adc_12_data       => "00000000000000",                       --{MI125 port :: adc12_unused}
      mi125_adc_13_data       => "00000000000000",                       --{MI125 port :: adc13_unused}
      mi125_adc_14_data       => "00000000000000",                       --{MI125 port :: adc14_unused}
      mi125_adc_15_data       => "00000000000000",                       --{MI125 port :: adc15_unused}
      mi125_adc_16_data       => "00000000000000",                       --{MI125 port :: adc16_unused}
      mi125_adc_17_data       => "00000000000000",                       --{MI125 port :: adc17_unused}
      mi125_adc_18_data       => "00000000000000",                       --{MI125 port :: adc18_unused}
      mi125_adc_19_data       => "00000000000000",                       --{MI125 port :: adc19_unused}
      mi125_adc_20_data       => "00000000000000",                       --{MI125 port :: adc20_unused}
      mi125_adc_21_data       => "00000000000000",                       --{MI125 port :: adc21_unused}
      mi125_adc_22_data       => "00000000000000",                       --{MI125 port :: adc22_unused}
      mi125_adc_23_data       => "00000000000000",                       --{MI125 port :: adc23_unused}
      mi125_adc_24_data       => "00000000000000",                       --{MI125 port :: adc24_unused}
      mi125_adc_25_data       => "00000000000000",                       --{MI125 port :: adc25_unused}
      mi125_adc_26_data       => "00000000000000",                       --{MI125 port :: adc26_unused}
      mi125_adc_27_data       => "00000000000000",                       --{MI125 port :: adc27_unused}
      mi125_adc_28_data       => "00000000000000",                       --{MI125 port :: adc28_unused}
      mi125_adc_29_data       => "00000000000000",                       --{MI125 port :: adc29_unused}
      mi125_adc_30_data       => "00000000000000",                       --{MI125 port :: adc30_unused}
      mi125_adc_31_data       => "00000000000000",                       --{MI125 port :: adc31_unused}
      mi125_adc_32_data       => "00000000000000",                       --{MI125 port :: adc32_unused}
      mi125_adc_1_data_valid  => '0',                                    --{MI125 port :: adc1_unused}
      mi125_adc_2_data_valid  => '0',                                    --{MI125 port :: adc2_unused}
      mi125_adc_3_data_valid  => '0',                                    --{MI125 port :: adc3_unused}
      mi125_adc_4_data_valid  => '0',                                    --{MI125 port :: adc4_unused}
      mi125_adc_5_data_valid  => '0',                                    --{MI125 port :: adc5_unused}
      mi125_adc_6_data_valid  => '0',                                    --{MI125 port :: adc6_unused}
      mi125_adc_7_data_valid  => '0',                                    --{MI125 port :: adc7_unused}
      mi125_adc_8_data_valid  => '0',                                    --{MI125 port :: adc8_unused}
      mi125_adc_9_data_valid  => '0',                                    --{MI125 port :: adc9_unused}
      mi125_adc_10_data_valid => '0',                                    --{MI125 port :: adc10_unused}
      mi125_adc_11_data_valid => '0',                                    --{MI125 port :: adc11_unused}
      mi125_adc_12_data_valid => '0',                                    --{MI125 port :: adc12_unused}
      mi125_adc_13_data_valid => '0',                                    --{MI125 port :: adc13_unused}
      mi125_adc_14_data_valid => '0',                                    --{MI125 port :: adc14_unused}
      mi125_adc_15_data_valid => '0',                                    --{MI125 port :: adc15_unused}
      mi125_adc_16_data_valid => '0',                                    --{MI125 port :: adc16_unused}
      mi125_adc_17_data_valid => '0',                                    --{MI125 port :: adc17_unused}
      mi125_adc_18_data_valid => '0',                                    --{MI125 port :: adc18_unused}
      mi125_adc_19_data_valid => '0',                                    --{MI125 port :: adc19_unused}
      mi125_adc_20_data_valid => '0',                                    --{MI125 port :: adc20_unused}
      mi125_adc_21_data_valid => '0',                                    --{MI125 port :: adc21_unused}
      mi125_adc_22_data_valid => '0',                                    --{MI125 port :: adc22_unused}
      mi125_adc_23_data_valid => '0',                                    --{MI125 port :: adc23_unused}
      mi125_adc_24_data_valid => '0',                                    --{MI125 port :: adc24_unused}
      mi125_adc_25_data_valid => '0',                                    --{MI125 port :: adc25_unused}
      mi125_adc_26_data_valid => '0',                                    --{MI125 port :: adc26_unused}
      mi125_adc_27_data_valid => '0',                                    --{MI125 port :: adc27_unused}
      mi125_adc_28_data_valid => '0',                                    --{MI125 port :: adc28_unused}
      mi125_adc_29_data_valid => '0',                                    --{MI125 port :: adc29_unused}
      mi125_adc_30_data_valid => '0',                                    --{MI125 port :: adc30_unused}
      mi125_adc_31_data_valid => '0',                                    --{MI125 port :: adc31_unused}
      mi125_adc_32_data_valid => '0',                                    --{MI125 port :: adc32_unused}
      mi125_trig_input        => '0',                                    --{MI125 port :: trigger_input_unused}
      -- mi125_trig_output       => open,                                --{MI125 port :: trigger_output_unused}
      mi125_data_format       => '0',                                    --{MI125 port :: data_format_unused}
      mi125_adc_1to4_enabled  => '0',                                    --{MI125 port :: adc_1to4_enabled_unused}
      mi125_adc_5to8_enabled  => '0',                                    --{MI125 port :: adc_5to8_enabled_unused}
      mi125_adc_9to12_enabled => '0',                                    --{MI125 port :: adc_9to12_enabled_unused}
      mi125_adc_13to16_enabled => '0',                                   --{MI125 port :: adc_13to16_enabled_unused}
      mi125_adc_17to20_enabled => '0',                                   --{MI125 port :: adc_17to20_enabled_unused}
      mi125_adc_21to24_enabled => '0',                                   --{MI125 port :: adc_21to24_enabled_unused}
      mi125_adc_25to28_enabled => '0',                                   --{MI125 port :: adc_25to28_enabled_unused}
      mi125_adc_29to32_enabled => '0',                                   --{MI125 port :: adc_29to32_enabled_unused}
      
      -- MO1000 section
      mo1000_dac_1_data         => v16_Mo1000DacDataCh1_s,               --{MO1000 port :: dac1_in_use}
      mo1000_dac_2_data         => v16_Mo1000DacDataCh2_s,               --{MO1000 port :: dac2_in_use}
      mo1000_dac_3_data         => v16_Mo1000DacDataCh3_s,               --{MO1000 port :: dac3_in_use}
      mo1000_dac_4_data         => v16_Mo1000DacDataCh4_s,               --{MO1000 port :: dac4_in_use}
      mo1000_dac_5_data         => v16_Mo1000DacDataCh5_s,               --{MO1000 port :: dac5_in_use}
      mo1000_dac_6_data         => v16_Mo1000DacDataCh6_s,               --{MO1000 port :: dac6_in_use}
      mo1000_dac_7_data         => v16_Mo1000DacDataCh7_s,               --{MO1000 port :: dac7_in_use}
      mo1000_dac_8_data         => v16_Mo1000DacDataCh8_s,               --{MO1000 port :: dac8_in_use}
      mo1000_dac_9_data         => v16_Mo1000DacDataCh9_s,               --{MO1000 port :: dac9_in_use}
      mo1000_dac_10_data        => v16_Mo1000DacDataCh10_s,              --{MO1000 port :: dac10_in_use}
      mo1000_dac_11_data        => v16_Mo1000DacDataCh11_s,              --{MO1000 port :: dac11_in_use}
      mo1000_dac_12_data        => v16_Mo1000DacDataCh12_s,              --{MO1000 port :: dac12_in_use}
      mo1000_dac_13_data        => v16_Mo1000DacDataCh13_s,              --{MO1000 port :: dac13_in_use}
      mo1000_dac_14_data        => v16_Mo1000DacDataCh14_s,              --{MO1000 port :: dac14_in_use}
      mo1000_dac_15_data        => v16_Mo1000DacDataCh15_s,              --{MO1000 port :: dac15_in_use}
      mo1000_dac_16_data        => v16_Mo1000DacDataCh16_s,              --{MO1000 port :: dac16_in_use}
      mo1000_dac_1_rdy          => i_Mo1000DacRdyCh1_p,                  --{MO1000 port :: dac1_in_use}
      mo1000_dac_2_rdy          => i_Mo1000DacRdyCh2_p,                  --{MO1000 port :: dac2_in_use}
      mo1000_dac_3_rdy          => i_Mo1000DacRdyCh3_p,                  --{MO1000 port :: dac3_in_use}
      mo1000_dac_4_rdy          => i_Mo1000DacRdyCh4_p,                  --{MO1000 port :: dac4_in_use}
      mo1000_dac_5_rdy          => i_Mo1000DacRdyCh5_p,                  --{MO1000 port :: dac5_in_use}
      mo1000_dac_6_rdy          => i_Mo1000DacRdyCh6_p,                  --{MO1000 port :: dac6_in_use}
      mo1000_dac_7_rdy          => i_Mo1000DacRdyCh7_p,                  --{MO1000 port :: dac7_in_use}
      mo1000_dac_8_rdy          => i_Mo1000DacRdyCh8_p,                  --{MO1000 port :: dac8_in_use}
      mo1000_dac_9_rdy          => i_Mo1000DacRdyCh9_p,                  --{MO1000 port :: dac9_in_use}
      mo1000_dac_10_rdy         => i_Mo1000DacRdyCh10_p,                 --{MO1000 port :: dac10_in_use}
      mo1000_dac_11_rdy         => i_Mo1000DacRdyCh11_p,                 --{MO1000 port :: dac11_in_use}
      mo1000_dac_12_rdy         => i_Mo1000DacRdyCh12_p,                 --{MO1000 port :: dac12_in_use}
      mo1000_dac_13_rdy         => i_Mo1000DacRdyCh13_p,                 --{MO1000 port :: dac13_in_use}
      mo1000_dac_14_rdy         => i_Mo1000DacRdyCh14_p,                 --{MO1000 port :: dac14_in_use}
      mo1000_dac_15_rdy         => i_Mo1000DacRdyCh15_p,                 --{MO1000 port :: dac15_in_use}
      mo1000_dac_16_rdy         => i_Mo1000DacRdyCh16_p,                 --{MO1000 port :: dac16_in_use}
      mo1000_trigger            => i_Mo1000Trigger_p,                    --{MO1000 port :: trig_in_use}

      -- MO1000 unused section
      mo1000_dac_1_rdy          => '0',                                  --{MO1000 port :: dac1_unused}
      mo1000_dac_2_rdy          => '0',                                  --{MO1000 port :: dac2_unused}
      mo1000_dac_3_rdy          => '0',                                  --{MO1000 port :: dac3_unused}
      mo1000_dac_4_rdy          => '0',                                  --{MO1000 port :: dac4_unused}
      mo1000_dac_5_rdy          => '0',                                  --{MO1000 port :: dac5_unused}
      mo1000_dac_6_rdy          => '0',                                  --{MO1000 port :: dac6_unused}
      mo1000_dac_7_rdy          => '0',                                  --{MO1000 port :: dac7_unused}
      mo1000_dac_8_rdy          => '0',                                  --{MO1000 port :: dac8_unused}
      mo1000_dac_9_rdy          => '0',                                  --{MO1000 port :: dac9_unused}
      mo1000_dac_10_rdy         => '0',                                  --{MO1000 port :: dac10_unused}
      mo1000_dac_11_rdy         => '0',                                  --{MO1000 port :: dac11_unused}
      mo1000_dac_12_rdy         => '0',                                  --{MO1000 port :: dac12_unused}
      mo1000_dac_13_rdy         => '0',                                  --{MO1000 port :: dac13_unused}
      mo1000_dac_14_rdy         => '0',                                  --{MO1000 port :: dac14_unused}
      mo1000_dac_15_rdy         => '0',                                  --{MO1000 port :: dac15_unused}
      mo1000_dac_16_rdy         => '0',                                  --{MO1000 port :: dac16_unused}
      mo1000_trigger            => '0',                                  --{MO1000 port :: trig_unused}
      
      -- RTDEX emac0 (in use section)
      rtdex_emac0_rx_ready_ch0 => i_RTDEx_Emac0_RxReadyCh0_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_in_use}
      rtdex_emac0_rx_ready_ch1 => i_RTDEx_Emac0_RxReadyCh1_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_in_use}
      rtdex_emac0_rx_ready_ch2 => i_RTDEx_Emac0_RxReadyCh2_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_in_use}
      rtdex_emac0_rx_ready_ch3 => i_RTDEx_Emac0_RxReadyCh3_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_in_use}
      rtdex_emac0_rx_ready_ch4 => i_RTDEx_Emac0_RxReadyCh4_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_in_use}
      rtdex_emac0_rx_ready_ch5 => i_RTDEx_Emac0_RxReadyCh5_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_in_use}
      rtdex_emac0_rx_ready_ch6 => i_RTDEx_Emac0_RxReadyCh6_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_in_use}
      rtdex_emac0_rx_ready_ch7 => i_RTDEx_Emac0_RxReadyCh7_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_in_use}

      rtdex_emac0_rx_data_valid_ch0 => i_RTDEx_Emac0_RxDataValidCh0_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_in_use}
      rtdex_emac0_rx_data_valid_ch1 => i_RTDEx_Emac0_RxDataValidCh1_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_in_use}
      rtdex_emac0_rx_data_valid_ch2 => i_RTDEx_Emac0_RxDataValidCh2_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_in_use}
      rtdex_emac0_rx_data_valid_ch3 => i_RTDEx_Emac0_RxDataValidCh3_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_in_use}
      rtdex_emac0_rx_data_valid_ch4 => i_RTDEx_Emac0_RxDataValidCh4_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_in_use}
      rtdex_emac0_rx_data_valid_ch5 => i_RTDEx_Emac0_RxDataValidCh5_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_in_use}
      rtdex_emac0_rx_data_valid_ch6 => i_RTDEx_Emac0_RxDataValidCh6_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_in_use}
      rtdex_emac0_rx_data_valid_ch7 => i_RTDEx_Emac0_RxDataValidCh7_p,   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_in_use}

      rtdex_emac0_tx_ready_ch0 => i_RTDEx_Emac0_TxReadyCh0_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch0_in_use}
      rtdex_emac0_tx_ready_ch1 => i_RTDEx_Emac0_TxReadyCh1_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch1_in_use}
      rtdex_emac0_tx_ready_ch2 => i_RTDEx_Emac0_TxReadyCh2_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch2_in_use}
      rtdex_emac0_tx_ready_ch3 => i_RTDEx_Emac0_TxReadyCh3_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch3_in_use}
      rtdex_emac0_tx_ready_ch4 => i_RTDEx_Emac0_TxReadyCh4_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch4_in_use}
      rtdex_emac0_tx_ready_ch5 => i_RTDEx_Emac0_TxReadyCh5_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch5_in_use}
      rtdex_emac0_tx_ready_ch6 => i_RTDEx_Emac0_TxReadyCh6_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch6_in_use}
      rtdex_emac0_tx_ready_ch7 => i_RTDEx_Emac0_TxReadyCh7_p,            --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch7_in_use}

      rtdex_emac0_rx_data_ch0  =>  iv32_RTDEx_Emac0_RxDataCh0_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_in_use}
      rtdex_emac0_rx_data_ch1  =>  iv32_RTDEx_Emac0_RxDataCh1_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_in_use}
      rtdex_emac0_rx_data_ch2  =>  iv32_RTDEx_Emac0_RxDataCh2_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_in_use}
      rtdex_emac0_rx_data_ch3  =>  iv32_RTDEx_Emac0_RxDataCh3_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_in_use}
      rtdex_emac0_rx_data_ch4  =>  iv32_RTDEx_Emac0_RxDataCh4_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_in_use}
      rtdex_emac0_rx_data_ch5  =>  iv32_RTDEx_Emac0_RxDataCh5_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_in_use}
      rtdex_emac0_rx_data_ch6  =>  iv32_RTDEx_Emac0_RxDataCh6_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_in_use}
      rtdex_emac0_rx_data_ch7  =>  iv32_RTDEx_Emac0_RxDataCh7_p,         --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_in_use}

      rtdex_emac0_rx_re_ch0 => v8_RTDExEmac0RxRe_s(0),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_in_use}
      rtdex_emac0_rx_re_ch1 => v8_RTDExEmac0RxRe_s(1),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_in_use}
      rtdex_emac0_rx_re_ch2 => v8_RTDExEmac0RxRe_s(2),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_in_use}
      rtdex_emac0_rx_re_ch3 => v8_RTDExEmac0RxRe_s(3),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_in_use}
      rtdex_emac0_rx_re_ch4 => v8_RTDExEmac0RxRe_s(4),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_in_use}
      rtdex_emac0_rx_re_ch5 => v8_RTDExEmac0RxRe_s(5),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_in_use}
      rtdex_emac0_rx_re_ch6 => v8_RTDExEmac0RxRe_s(6),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_in_use}
      rtdex_emac0_rx_re_ch7 => v8_RTDExEmac0RxRe_s(7),                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_in_use}

      rtdex_emac0_tx_we_ch0 => v8_RTDExEmac0TxWe_s(0),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch0_in_use}
      rtdex_emac0_tx_we_ch1 => v8_RTDExEmac0TxWe_s(1),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch1_in_use}
      rtdex_emac0_tx_we_ch2 => v8_RTDExEmac0TxWe_s(2),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch2_in_use}
      rtdex_emac0_tx_we_ch3 => v8_RTDExEmac0TxWe_s(3),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch3_in_use}
      rtdex_emac0_tx_we_ch4 => v8_RTDExEmac0TxWe_s(4),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch4_in_use}
      rtdex_emac0_tx_we_ch5 => v8_RTDExEmac0TxWe_s(5),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch5_in_use}
      rtdex_emac0_tx_we_ch6 => v8_RTDExEmac0TxWe_s(6),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch6_in_use}
      rtdex_emac0_tx_we_ch7 => v8_RTDExEmac0TxWe_s(7),                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch7_in_use}

      rtdex_emac0_tx_data_ch0  => v32_RTDExEmac0TxDataCh0_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch0_in_use}
      rtdex_emac0_tx_data_ch1  => v32_RTDExEmac0TxDataCh1_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch1_in_use}
      rtdex_emac0_tx_data_ch2  => v32_RTDExEmac0TxDataCh2_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch2_in_use}
      rtdex_emac0_tx_data_ch3  => v32_RTDExEmac0TxDataCh3_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch3_in_use}
      rtdex_emac0_tx_data_ch4  => v32_RTDExEmac0TxDataCh4_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch4_in_use}
      rtdex_emac0_tx_data_ch5  => v32_RTDExEmac0TxDataCh5_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch5_in_use}
      rtdex_emac0_tx_data_ch6  => v32_RTDExEmac0TxDataCh6_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch6_in_use}
      rtdex_emac0_tx_data_ch7  => v32_RTDExEmac0TxDataCh7_s,             --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch7_in_use}

      -- RTDEX emac0 (unused section)
      rtdex_emac0_rx_ready_ch0 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_unused}
      rtdex_emac0_rx_ready_ch1 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_unused}
      rtdex_emac0_rx_ready_ch2 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_unused}
      rtdex_emac0_rx_ready_ch3 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_unused}
      rtdex_emac0_rx_ready_ch4 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_unused}
      rtdex_emac0_rx_ready_ch5 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_unused}
      rtdex_emac0_rx_ready_ch6 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_unused}
      rtdex_emac0_rx_ready_ch7 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_unused}

      rtdex_emac0_rx_data_valid_ch0 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_unused}
      rtdex_emac0_rx_data_valid_ch1 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_unused}
      rtdex_emac0_rx_data_valid_ch2 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_unused}
      rtdex_emac0_rx_data_valid_ch3 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_unused}
      rtdex_emac0_rx_data_valid_ch4 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_unused}
      rtdex_emac0_rx_data_valid_ch5 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_unused}
      rtdex_emac0_rx_data_valid_ch6 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_unused}
      rtdex_emac0_rx_data_valid_ch7 => '0',                              --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_unused}

      rtdex_emac0_tx_ready_ch0 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch0_unused}
      rtdex_emac0_tx_ready_ch1 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch1_unused}
      rtdex_emac0_tx_ready_ch2 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch2_unused}
      rtdex_emac0_tx_ready_ch3 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch3_unused}
      rtdex_emac0_tx_ready_ch4 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch4_unused}
      rtdex_emac0_tx_ready_ch5 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch5_unused}
      rtdex_emac0_tx_ready_ch6 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch6_unused}
      rtdex_emac0_tx_ready_ch7 => '0',                                   --{RTDEX_EMAC0 port :: rtdex_emac0_tx_data_ch7_unused}

      rtdex_emac0_rx_data_ch0  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch0_unused}
      rtdex_emac0_rx_data_ch1  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch1_unused}
      rtdex_emac0_rx_data_ch2  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch2_unused}
      rtdex_emac0_rx_data_ch3  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch3_unused}
      rtdex_emac0_rx_data_ch4  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch4_unused}
      rtdex_emac0_rx_data_ch5  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch5_unused}
      rtdex_emac0_rx_data_ch6  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch6_unused}
      rtdex_emac0_rx_data_ch7  =>  X"00000000",                          --{RTDEX_EMAC0 port :: rtdex_emac0_rx_data_ch7_unused}

      -- RTDEX PCIe
      rtdex_pcie_rx_ready_ch0 => i_RTDEx_PCIe_RxReadyCh0_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_in_use}
      rtdex_pcie_rx_ready_ch1 => i_RTDEx_PCIe_RxReadyCh1_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_in_use}
      rtdex_pcie_rx_ready_ch2 => i_RTDEx_PCIe_RxReadyCh2_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_in_use}
      rtdex_pcie_rx_ready_ch3 => i_RTDEx_PCIe_RxReadyCh3_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_in_use}
      rtdex_pcie_rx_ready_ch4 => i_RTDEx_PCIe_RxReadyCh4_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_in_use}
      rtdex_pcie_rx_ready_ch5 => i_RTDEx_PCIe_RxReadyCh5_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_in_use}
      rtdex_pcie_rx_ready_ch6 => i_RTDEx_PCIe_RxReadyCh6_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_in_use}
      rtdex_pcie_rx_ready_ch7 => i_RTDEx_PCIe_RxReadyCh7_p,              --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_in_use}

      rtdex_pcie_rx_data_valid_ch0 => i_RTDEx_PCIe_RxDataValidCh0_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_in_use}
      rtdex_pcie_rx_data_valid_ch1 => i_RTDEx_PCIe_RxDataValidCh1_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_in_use}
      rtdex_pcie_rx_data_valid_ch2 => i_RTDEx_PCIe_RxDataValidCh2_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_in_use}
      rtdex_pcie_rx_data_valid_ch3 => i_RTDEx_PCIe_RxDataValidCh3_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_in_use}
      rtdex_pcie_rx_data_valid_ch4 => i_RTDEx_PCIe_RxDataValidCh4_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_in_use}
      rtdex_pcie_rx_data_valid_ch5 => i_RTDEx_PCIe_RxDataValidCh5_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_in_use}
      rtdex_pcie_rx_data_valid_ch6 => i_RTDEx_PCIe_RxDataValidCh6_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_in_use}
      rtdex_pcie_rx_data_valid_ch7 => i_RTDEx_PCIe_RxDataValidCh7_p,     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_in_use}

      rtdex_pcie_tx_ready_ch0 => i_RTDEx_PCIe_TxReadyCh0_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch0_in_use}
      rtdex_pcie_tx_ready_ch1 => i_RTDEx_PCIe_TxReadyCh1_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch1_in_use}
      rtdex_pcie_tx_ready_ch2 => i_RTDEx_PCIe_TxReadyCh2_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch2_in_use}
      rtdex_pcie_tx_ready_ch3 => i_RTDEx_PCIe_TxReadyCh3_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch3_in_use}
      rtdex_pcie_tx_ready_ch4 => i_RTDEx_PCIe_TxReadyCh4_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch4_in_use}
      rtdex_pcie_tx_ready_ch5 => i_RTDEx_PCIe_TxReadyCh5_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch5_in_use}
      rtdex_pcie_tx_ready_ch6 => i_RTDEx_PCIe_TxReadyCh6_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch6_in_use}
      rtdex_pcie_tx_ready_ch7 => i_RTDEx_PCIe_TxReadyCh7_p,              --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch7_in_use}

      rtdex_pcie_rx_data_ch0  =>  iv32_RTDEx_PCIe_RxDataCh0_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_in_use}
      rtdex_pcie_rx_data_ch1  =>  iv32_RTDEx_PCIe_RxDataCh1_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_in_use}
      rtdex_pcie_rx_data_ch2  =>  iv32_RTDEx_PCIe_RxDataCh2_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_in_use}
      rtdex_pcie_rx_data_ch3  =>  iv32_RTDEx_PCIe_RxDataCh3_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_in_use}
      rtdex_pcie_rx_data_ch4  =>  iv32_RTDEx_PCIe_RxDataCh4_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_in_use}
      rtdex_pcie_rx_data_ch5  =>  iv32_RTDEx_PCIe_RxDataCh5_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_in_use}
      rtdex_pcie_rx_data_ch6  =>  iv32_RTDEx_PCIe_RxDataCh6_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_in_use}
      rtdex_pcie_rx_data_ch7  =>  iv32_RTDEx_PCIe_RxDataCh7_p,           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_in_use}

      rtdex_pcie_rx_re_ch0 => v8_RTDExPCIeRxRe_s(0),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_in_use}
      rtdex_pcie_rx_re_ch1 => v8_RTDExPCIeRxRe_s(1),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_in_use}
      rtdex_pcie_rx_re_ch2 => v8_RTDExPCIeRxRe_s(2),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_in_use}
      rtdex_pcie_rx_re_ch3 => v8_RTDExPCIeRxRe_s(3),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_in_use}
      rtdex_pcie_rx_re_ch4 => v8_RTDExPCIeRxRe_s(4),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_in_use}
      rtdex_pcie_rx_re_ch5 => v8_RTDExPCIeRxRe_s(5),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_in_use}
      rtdex_pcie_rx_re_ch6 => v8_RTDExPCIeRxRe_s(6),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_in_use}
      rtdex_pcie_rx_re_ch7 => v8_RTDExPCIeRxRe_s(7),                     --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_in_use}

      rtdex_pcie_tx_we_ch0 => v8_RTDExPCIeTxWe_s(0),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch0_in_use}
      rtdex_pcie_tx_we_ch1 => v8_RTDExPCIeTxWe_s(1),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch1_in_use}
      rtdex_pcie_tx_we_ch2 => v8_RTDExPCIeTxWe_s(2),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch2_in_use}
      rtdex_pcie_tx_we_ch3 => v8_RTDExPCIeTxWe_s(3),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch3_in_use}
      rtdex_pcie_tx_we_ch4 => v8_RTDExPCIeTxWe_s(4),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch4_in_use}
      rtdex_pcie_tx_we_ch5 => v8_RTDExPCIeTxWe_s(5),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch5_in_use}
      rtdex_pcie_tx_we_ch6 => v8_RTDExPCIeTxWe_s(6),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch6_in_use}
      rtdex_pcie_tx_we_ch7 => v8_RTDExPCIeTxWe_s(7),                     --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch7_in_use}

      rtdex_pcie_tx_data_ch0  => v32_RTDExPCIeTxDataCh0_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch0_in_use}
      rtdex_pcie_tx_data_ch1  => v32_RTDExPCIeTxDataCh1_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch1_in_use}
      rtdex_pcie_tx_data_ch2  => v32_RTDExPCIeTxDataCh2_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch2_in_use}
      rtdex_pcie_tx_data_ch3  => v32_RTDExPCIeTxDataCh3_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch3_in_use}
      rtdex_pcie_tx_data_ch4  => v32_RTDExPCIeTxDataCh4_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch4_in_use}
      rtdex_pcie_tx_data_ch5  => v32_RTDExPCIeTxDataCh5_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch5_in_use}
      rtdex_pcie_tx_data_ch6  => v32_RTDExPCIeTxDataCh6_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch6_in_use}
      rtdex_pcie_tx_data_ch7  => v32_RTDExPCIeTxDataCh7_s,               --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch7_in_use}

      -- RTDEX pcie (unused section)
      rtdex_pcie_rx_ready_ch0 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_unused}
      rtdex_pcie_rx_ready_ch1 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_unused}
      rtdex_pcie_rx_ready_ch2 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_unused}
      rtdex_pcie_rx_ready_ch3 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_unused}
      rtdex_pcie_rx_ready_ch4 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_unused}
      rtdex_pcie_rx_ready_ch5 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_unused}
      rtdex_pcie_rx_ready_ch6 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_unused}
      rtdex_pcie_rx_ready_ch7 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_unused}

      rtdex_pcie_rx_data_valid_ch0 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_unused}
      rtdex_pcie_rx_data_valid_ch1 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_unused}
      rtdex_pcie_rx_data_valid_ch2 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_unused}
      rtdex_pcie_rx_data_valid_ch3 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_unused}
      rtdex_pcie_rx_data_valid_ch4 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_unused}
      rtdex_pcie_rx_data_valid_ch5 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_unused}
      rtdex_pcie_rx_data_valid_ch6 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_unused}
      rtdex_pcie_rx_data_valid_ch7 => '0',                               --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_unused}

      rtdex_pcie_tx_ready_ch0 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch0_unused}
      rtdex_pcie_tx_ready_ch1 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch1_unused}
      rtdex_pcie_tx_ready_ch2 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch2_unused}
      rtdex_pcie_tx_ready_ch3 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch3_unused}
      rtdex_pcie_tx_ready_ch4 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch4_unused}
      rtdex_pcie_tx_ready_ch5 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch5_unused}
      rtdex_pcie_tx_ready_ch6 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch6_unused}
      rtdex_pcie_tx_ready_ch7 => '0',                                    --{RTDEX_PCIE port :: rtdex_pcie_tx_data_ch7_unused}

      rtdex_pcie_rx_data_ch0  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch0_unused}
      rtdex_pcie_rx_data_ch1  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch1_unused}
      rtdex_pcie_rx_data_ch2  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch2_unused}
      rtdex_pcie_rx_data_ch3  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch3_unused}
      rtdex_pcie_rx_data_ch4  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch4_unused}
      rtdex_pcie_rx_data_ch5  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch5_unused}
      rtdex_pcie_rx_data_ch6  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch6_unused}
      rtdex_pcie_rx_data_ch7  =>  X"00000000",                           --{RTDEX_PCIE port :: rtdex_pcie_rx_data_ch7_unused}

		-- ################################ Input/output wiring ################################

      lvdsIo_IN_1_rxData0     =>  iv_lvdsIo_IN_1_rxData0_p,
      lvdsIo_IN_1_rxRdEn0     =>  o_lvdsIo_IN_1_rxRdEn0_s,			   --{lvdsIO port :: bot_group0_use_input_fifo}
      lvdsIo_IN_1_rxValid0    =>  i_lvdsIo_IN_1_rxValid0_p,
      lvdsIo_IN_1_rxEmpty0    =>  i_lvdsIo_IN_1_rxEmpty0_p,

      lvdsIo_IN_1_rxData1     =>  iv_lvdsIo_IN_1_rxData1_p,
      lvdsIo_IN_1_rxRdEn1     =>  o_lvdsIo_IN_1_rxRdEn1_s,              	   --{lvdsIO port :: bot_group1_use_input_fifo}
      lvdsIo_IN_1_rxValid1    =>  i_lvdsIo_IN_1_rxValid1_p,
      lvdsIo_IN_1_rxEmpty1    =>  i_lvdsIo_IN_1_rxEmpty1_p,


      lvdsIo_IN_2_rxData0     =>  iv_lvdsIo_IN_2_rxData0_p,
      lvdsIo_IN_2_rxRdEn0     =>  o_lvdsIo_IN_2_rxRdEn0_s,                         --{lvdsIO port :: top_group0_use_input_fifo}
      lvdsIo_IN_2_rxValid0    =>  i_lvdsIo_IN_2_rxValid0_p,
      lvdsIo_IN_2_rxEmpty0    =>  i_lvdsIo_IN_2_rxEmpty0_p,

      lvdsIo_IN_2_rxData1     =>  iv_lvdsIo_IN_2_rxData1_p,
      lvdsIo_IN_2_rxRdEn1     =>  o_lvdsIo_IN_2_rxRdEn1_s,                         --{lvdsIO port :: top_group1_use_input_fifo}
      lvdsIo_IN_2_rxValid1    =>  i_lvdsIo_IN_2_rxValid1_p,
      lvdsIo_IN_2_rxEmpty1    =>  i_lvdsIo_IN_2_rxEmpty1_p,

      lvdsIo_OUT_1_txData0    =>  ov_lvdsIo_OUT_1_txData0_s,			   		   --{lvdsIO port :: bot_group0_as_output}
      lvdsIo_OUT_1_txWrEn0    =>  o_lvdsIo_OUT_1_txWrEn0_s,			   			   --{lvdsIO port :: bot_group0_use_output_fifo}
      lvdsIo_OUT_1_txWrAck0   =>  i_lvdsIo_OUT_1_txWrAck0_p,
      lvdsIo_OUT_1_txFull0    =>  i_lvdsIo_OUT_1_txFull0_p ,

      lvdsIo_OUT_1_txData1    =>  ov_lvdsIo_OUT_1_txData1_s,                       --{lvdsIO port :: bot_group1_as_output}
      lvdsIo_OUT_1_txWrEn1    =>  o_lvdsIo_OUT_1_txWrEn1_s,                        --{lvdsIO port :: bot_group1_use_output_fifo}
      lvdsIo_OUT_1_txWrAck1   =>  i_lvdsIo_OUT_1_txWrAck1_p,
      lvdsIo_OUT_1_txFull1    =>  i_lvdsIo_OUT_1_txFull1_p,

      lvdsIo_OUT_2_txData0    =>  ov_lvdsIo_OUT_2_txData0_s,     	           	   --{lvdsIO port :: top_group0_as_output}
      lvdsIo_OUT_2_txWrEn0    =>  o_lvdsIo_OUT_2_txWrEn0_s,                        --{lvdsIO port :: top_group0_use_output_fifo}
      lvdsIo_OUT_2_txWrAck0   =>  i_lvdsIo_OUT_2_txWrAck0_p,
      lvdsIo_OUT_2_txFull0    =>  i_lvdsIo_OUT_2_txFull0_p,

      lvdsIo_OUT_2_txData1    =>  ov_lvdsIo_OUT_2_txData1_s,  	                   --{lvdsIO port :: top_group1_as_output}
      lvdsIo_OUT_2_txWrEn1    =>  o_lvdsIo_OUT_2_txWrEn1_s,                        --{lvdsIO port :: top_group1_use_output_fifo}
      lvdsIo_OUT_2_txWrAck1   =>  i_lvdsIo_OUT_2_txWrAck1_p,
      lvdsIo_OUT_2_txFull1    =>  i_lvdsIo_OUT_2_txFull1_p,

      -- LVDS GPIO
      mestor_gpio_0_write_data              => ov_mestor_gpio_0_data_p,            --{LVDS port :: lvds_gpio_0_write_in_use}
      mestor_gpio_0_read_data               => iv_mestor_gpio_0_data_p,
      mestor_gpio_0_write_outputenable      => ov_mestor_gpio_0_outputenable_p,    --{LVDS port :: lvds_gpio_0_write_in_use}
      mestor_gpio_1_write_data              => ov_mestor_gpio_1_data_p,            --{LVDS port :: lvds_gpio_1_write_in_use}
      mestor_gpio_1_read_data               => iv_mestor_gpio_1_data_p,
      mestor_gpio_1_write_outputenable      => ov_mestor_gpio_1_outputenable_p,    --{LVDS port :: lvds_gpio_1_write_in_use}
      mestor_gpio_2_write_data              => ov_mestor_gpio_2_data_p,            --{LVDS port :: lvds_gpio_2_write_in_use}
      mestor_gpio_2_read_data               => iv_mestor_gpio_2_data_p,
      mestor_gpio_2_write_outputenable      => ov_mestor_gpio_2_outputenable_p,    --{LVDS port :: lvds_gpio_2_write_in_use}
      mestor_gpio_3_write_data              => ov_mestor_gpio_3_data_p,            --{LVDS port :: lvds_gpio_3_write_in_use}
      mestor_gpio_3_read_data               => iv_mestor_gpio_3_data_p,
      mestor_gpio_3_write_outputenable      => ov_mestor_gpio_3_outputenable_p,    --{LVDS port :: lvds_gpio_3_write_in_use}
      -- LVDS SYNC
      mestor_sync_0_write_outputenable      => o_mestor_sync_0_outputenable_p,     --{LVDS port :: lvds_sync_0_write_in_use}
      mestor_sync_0_read_ready              => i_mestor_sync_0_rxready_p,
      mestor_sync_0_read_re                 => o_mestor_sync_0_rxre_p,             --{LVDS port :: lvds_sync_0_read_in_use}
      mestor_sync_0_read_data               => iv_mestor_sync_0_rxdata_p,
      mestor_sync_0_read_valid              => i_mestor_sync_0_rxdatavalid_p,
      mestor_sync_0_write_ready             => i_mestor_sync_0_txready_p,
      mestor_sync_0_write_data              => ov_mestor_sync_0_txdata_p,          --{LVDS port :: lvds_sync_0_write_in_use}
      mestor_sync_0_write_we                => o_mestor_sync_0_txwe_p,             --{LVDS port :: lvds_sync_0_write_in_use}
      mestor_sync_1_write_outputenable      => o_mestor_sync_1_outputenable_p,     --{LVDS port :: lvds_sync_1_write_in_use}
      mestor_sync_1_read_ready              => i_mestor_sync_1_rxready_p,
      mestor_sync_1_read_re                 => o_mestor_sync_1_rxre_p,             --{LVDS port :: lvds_sync_1_read_in_use}
      mestor_sync_1_read_data               => iv_mestor_sync_1_rxdata_p,
      mestor_sync_1_read_valid              => i_mestor_sync_1_rxdatavalid_p,
      mestor_sync_1_write_ready             => i_mestor_sync_1_txready_p,
      mestor_sync_1_write_data              => ov_mestor_sync_1_txdata_p,          --{LVDS port :: lvds_sync_1_write_in_use}
      mestor_sync_1_write_we                => o_mestor_sync_1_txwe_p,             --{LVDS port :: lvds_sync_1_write_in_use}
      mestor_sync_2_write_outputenable      => o_mestor_sync_2_outputenable_p,     --{LVDS port :: lvds_sync_2_write_in_use}
      mestor_sync_2_read_ready              => i_mestor_sync_2_rxready_p,
      mestor_sync_2_read_re                 => o_mestor_sync_2_rxre_p,             --{LVDS port :: lvds_sync_2_read_in_use}
      mestor_sync_2_read_data               => iv_mestor_sync_2_rxdata_p,
      mestor_sync_2_read_valid              => i_mestor_sync_2_rxdatavalid_p,
      mestor_sync_2_write_ready             => i_mestor_sync_2_txready_p,
      mestor_sync_2_write_data              => ov_mestor_sync_2_txdata_p,          --{LVDS port :: lvds_sync_2_write_in_use}
      mestor_sync_2_write_we                => o_mestor_sync_2_txwe_p,             --{LVDS port :: lvds_sync_2_write_in_use}
      mestor_sync_3_write_outputenable      => o_mestor_sync_3_outputenable_p,     --{LVDS port :: lvds_sync_3_write_in_use}
      mestor_sync_3_read_ready              => i_mestor_sync_3_rxready_p,
      mestor_sync_3_read_re                 => o_mestor_sync_3_rxre_p,             --{LVDS port :: lvds_sync_3_read_in_use}
      mestor_sync_3_read_data               => iv_mestor_sync_3_rxdata_p,
      mestor_sync_3_read_valid              => i_mestor_sync_3_rxdatavalid_p,
      mestor_sync_3_write_ready             => i_mestor_sync_3_txready_p,
      mestor_sync_3_write_data              => ov_mestor_sync_3_txdata_p,          --{LVDS port :: lvds_sync_3_write_in_use}
      mestor_sync_3_write_we                => o_mestor_sync_3_txwe_p,             --{LVDS port :: lvds_sync_3_write_in_use}

      -- AMC GPIO section
      nutaq_backplane_gpio_output0   => nutaq_backplane_gpio_output_0_s,           --{NUTAQ_BACKPLANE port :: gpio_output_0_in_use}
      nutaq_backplane_gpio_output1   => nutaq_backplane_gpio_output_1_s,           --{NUTAQ_BACKPLANE port :: gpio_output_1_in_use}
      nutaq_backplane_gpio_input0    => i_nutaq_backplane_gpio_0_p,
      nutaq_backplane_gpio_input1    => i_nutaq_backplane_gpio_1_p,
      nutaq_backplane_gpio_output_tclk_a    => nutaq_backplane_gpio_output_tclk_a_s,    --{NUTAQ_BACKPLANE port :: gpio_output_tclk_a_in_use}
      nutaq_backplane_gpio_output_tclk_b    => nutaq_backplane_gpio_output_tclk_b_s,    --{NUTAQ_BACKPLANE port :: gpio_output_tclk_b_in_use}
      nutaq_backplane_gpio_output_tclk_c    => nutaq_backplane_gpio_output_tclk_c_s,    --{NUTAQ_BACKPLANE port :: gpio_output_tclk_c_in_use}
      nutaq_backplane_gpio_output_tclk_d    => nutaq_backplane_gpio_output_tclk_d_s,    --{NUTAQ_BACKPLANE port :: gpio_output_tclk_d_in_use}
      nutaq_backplane_gpio_input_tclk_a     => i_nutaq_backplane_gpio_tclk_a_p,
      nutaq_backplane_gpio_input_tclk_b     => i_nutaq_backplane_gpio_tclk_b_p,
      nutaq_backplane_gpio_input_tclk_c     => i_nutaq_backplane_gpio_tclk_c_p,
      nutaq_backplane_gpio_input_tclk_d     => i_nutaq_backplane_gpio_tclk_d_p
  );

end rtl;