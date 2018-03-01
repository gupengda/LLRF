//-----------------------------------------------------------------------------
// perseus6010_mo1000_mi125_bsdk_top.v
//-----------------------------------------------------------------------------

module perseus6010_mo1000_mi125_bsdk_top
  (
    i_SysRst_p,
    i_pSysClk_p,
    i_nSysClk_p,
    i_pSodimmclk_p,
    i_nSodimmclk_p,
    o_nFpgaProg_p,
    fpga_0_FLASH_Mem_A_pin,
    Flash_Mem_WEN_pin,
    Flash_Mem_DQ_pin,
    Flash_Mem_CEN_pin,
    Flash_Mem_OEN_pin,
    o_nFlashRst_p,
    axi_ethernet_0_MGT_CLK_P_pin,
    axi_ethernet_0_MGT_CLK_N_pin,
    axi_ethernet_0_TXP_pin,
    axi_ethernet_0_TXN_pin,
    axi_ethernet_0_RXP_pin,
    axi_ethernet_0_RXN_pin,
    i_FpUartRX_p,
    io_FpUartTX_p,
    i_AMCUartRX_p,
    io_AMCUartTX_p,
    i_IpmiUartRX_p,
    o_IpmiUartTX_p,
    axi_v6_ddrx_0_ddr_addr_pin,
    axi_v6_ddrx_0_ddr_ba_pin,
    axi_v6_ddrx_0_ddr_cas_n_pin,
    axi_v6_ddrx_0_ddr_ck_p_pin,
    axi_v6_ddrx_0_ddr_ck_n_pin,
    axi_v6_ddrx_0_ddr_cke_pin,
    axi_v6_ddrx_0_ddr_cs_n_pin,
    axi_v6_ddrx_0_ddr_dm_pin,
    axi_v6_ddrx_0_ddr_odt_pin,
    axi_v6_ddrx_0_ddr_ras_n_pin,
    axi_v6_ddrx_0_ddr_reset_n_pin,
    axi_v6_ddrx_0_ddr_we_n_pin,
    axi_v6_ddrx_0_ddr_dqs_p,
    axi_v6_ddrx_0_ddr_dqs_n,
    axi_v6_ddrx_0_ddr_dq,
    axi_record_playback_ddr3_dq,
    axi_record_playback_ddr3_addr_pin,
    axi_record_playback_ddr3_ba_pin,
    axi_record_playback_ddr3_ras_n_pin,
    axi_record_playback_ddr3_cas_n_pin,
    axi_record_playback_ddr3_we_n_pin,
    axi_record_playback_ddr3_reset_n_pin,
    axi_record_playback_ddr3_cs_n_pin,
    axi_record_playback_ddr3_odt_pin,
    axi_record_playback_ddr3_cke_pin,
    axi_record_playback_ddr3_dm_pin,
    axi_record_playback_ddr3_dqs_p,
    axi_record_playback_ddr3_dqs_n,
    axi_record_playback_ddr3_ck_p_pin,
    axi_record_playback_ddr3_ck_n_pin,
    io_FmcI2cSCL_p,
    io_FmcI2cSDA_p,
    i_DaughterIoAbsent_p,
    i_FmcAbsent_p,
    i_FmcStackAbsent_p,
    io_Ddr3I2cSDA_p,
    io_Ddr3I2cSCL_p,
    o_CtrlTclkdTxEn_p,
    o_CtrlTclkdRxDis_p,
    o_CtrlAmctclkc2Fmcclk3En_p,
    o_CtrlAmctclka2Fmcclk2En_p,
    o_CtrlFclkaHighz_p,
    o_Ctrl100mhzOutEn_p,
    o_CtrlTclkaTxEn_p,
    o_CtrlFmcclk02AmctclkbEn_p,
    o_CtrlTclkcTxEn_p,
    o_CtrlVadjEn_p,
    o_CtrlTclkbRxDis_p,
    ov2_CtrlVadjSel_p,
    o_CtrlTclkbTxEn_p,
    o_CtrlFmcclk12AmctclkdEn_p,
    o_CtrlTclkcRxDis_p,
    o_CtrlTclkaRxDis_p,
    o_CtrlLedBufOd_p,
    ov8_nCtrlLedGrn_p,
    ov8_nCtrlLedRed_p,
    i_MmcI2cReleaseAck_p,
    o_MmcI2cReleaseReq_p,
    idp_MO1000_0_ClockFromFMC_p,
    idn_MO1000_0_ClockFromFMC_p,
    odp_MO1000_0_DataToFMC_p,
    odn_MO1000_0_DataToFMC_p,
    odp_MO1000_0_DciToFMC_p,
    odn_MO1000_0_DciToFMC_p,
    odp_MO1000_0_FrameToFMC_p,
    odn_MO1000_0_FrameToFMC_p,
    i_MO1000_0_TriggerFromFMC_p,
    idp_DataFromADCTop_p,
    idn_DataFromADCTop_p,
    idp_ClockFromADCTop_p,
    idn_ClockFromADCTop_p,
    idp_FrameFromADCTop_p,
    idn_FrameFromADCTop_p,
    odp_DioSetDir_p,
    odn_DioSetDir_p,
    odp_DioReset_p,
    odn_DioReset_p,
    ov4dp_Dpio_p,
    ov4dn_Dpio_p,
    iv4dp_Dpio_p,
    iv4dn_Dpio_p,
    odp_DpioClk_p,
    odn_DpioClk_p,
    iv2dp_AdcData_p,
    iv2dn_AdcData_p,
    odp_DioConfig_p,
    odn_DioConfig_p,
    idp_DioResetAck_p,
    idn_DioResetAck_p
  );
  input i_SysRst_p;
  input i_pSysClk_p;
  input i_nSysClk_p;
  input i_pSodimmclk_p;
  input i_nSodimmclk_p;
  output o_nFpgaProg_p;
  output [0:24] fpga_0_FLASH_Mem_A_pin;
  output Flash_Mem_WEN_pin;
  inout [0:15] Flash_Mem_DQ_pin;
  output Flash_Mem_CEN_pin;
  output Flash_Mem_OEN_pin;
  output o_nFlashRst_p;
  input axi_ethernet_0_MGT_CLK_P_pin;
  input axi_ethernet_0_MGT_CLK_N_pin;
  output axi_ethernet_0_TXP_pin;
  output axi_ethernet_0_TXN_pin;
  input axi_ethernet_0_RXP_pin;
  input axi_ethernet_0_RXN_pin;
  input i_FpUartRX_p;
  inout io_FpUartTX_p;
  input i_AMCUartRX_p;
  inout io_AMCUartTX_p;
  input i_IpmiUartRX_p;
  output o_IpmiUartTX_p;
  output [13:0] axi_v6_ddrx_0_ddr_addr_pin;
  output [2:0] axi_v6_ddrx_0_ddr_ba_pin;
  output axi_v6_ddrx_0_ddr_cas_n_pin;
  output axi_v6_ddrx_0_ddr_ck_p_pin;
  output axi_v6_ddrx_0_ddr_ck_n_pin;
  output axi_v6_ddrx_0_ddr_cke_pin;
  output axi_v6_ddrx_0_ddr_cs_n_pin;
  output axi_v6_ddrx_0_ddr_dm_pin;
  output axi_v6_ddrx_0_ddr_odt_pin;
  output axi_v6_ddrx_0_ddr_ras_n_pin;
  output axi_v6_ddrx_0_ddr_reset_n_pin;
  output axi_v6_ddrx_0_ddr_we_n_pin;
  inout axi_v6_ddrx_0_ddr_dqs_p;
  inout axi_v6_ddrx_0_ddr_dqs_n;
  inout [7:0] axi_v6_ddrx_0_ddr_dq;
  inout [63:0] axi_record_playback_ddr3_dq;
  output [15:0] axi_record_playback_ddr3_addr_pin;
  output [2:0] axi_record_playback_ddr3_ba_pin;
  output axi_record_playback_ddr3_ras_n_pin;
  output axi_record_playback_ddr3_cas_n_pin;
  output axi_record_playback_ddr3_we_n_pin;
  output axi_record_playback_ddr3_reset_n_pin;
  output axi_record_playback_ddr3_cs_n_pin;
  output axi_record_playback_ddr3_odt_pin;
  output axi_record_playback_ddr3_cke_pin;
  output [7:0] axi_record_playback_ddr3_dm_pin;
  inout [7:0] axi_record_playback_ddr3_dqs_p;
  inout [7:0] axi_record_playback_ddr3_dqs_n;
  output [1:0] axi_record_playback_ddr3_ck_p_pin;
  output [1:0] axi_record_playback_ddr3_ck_n_pin;
  inout io_FmcI2cSCL_p;
  inout io_FmcI2cSDA_p;
  input i_DaughterIoAbsent_p;
  input i_FmcAbsent_p;
  input i_FmcStackAbsent_p;
  inout io_Ddr3I2cSDA_p;
  inout io_Ddr3I2cSCL_p;
  output o_CtrlTclkdTxEn_p;
  output o_CtrlTclkdRxDis_p;
  output o_CtrlAmctclkc2Fmcclk3En_p;
  output o_CtrlAmctclka2Fmcclk2En_p;
  output o_CtrlFclkaHighz_p;
  output o_Ctrl100mhzOutEn_p;
  output o_CtrlTclkaTxEn_p;
  output o_CtrlFmcclk02AmctclkbEn_p;
  output o_CtrlTclkcTxEn_p;
  output o_CtrlVadjEn_p;
  output o_CtrlTclkbRxDis_p;
  output [1:0] ov2_CtrlVadjSel_p;
  output o_CtrlTclkbTxEn_p;
  output o_CtrlFmcclk12AmctclkdEn_p;
  output o_CtrlTclkcRxDis_p;
  output o_CtrlTclkaRxDis_p;
  output o_CtrlLedBufOd_p;
  output [7:0] ov8_nCtrlLedGrn_p;
  output [7:0] ov8_nCtrlLedRed_p;
  input i_MmcI2cReleaseAck_p;
  output o_MmcI2cReleaseReq_p;
  input idp_MO1000_0_ClockFromFMC_p;
  input idn_MO1000_0_ClockFromFMC_p;
  output [31:0] odp_MO1000_0_DataToFMC_p;
  output [31:0] odn_MO1000_0_DataToFMC_p;
  output odp_MO1000_0_DciToFMC_p;
  output odn_MO1000_0_DciToFMC_p;
  output odp_MO1000_0_FrameToFMC_p;
  output odn_MO1000_0_FrameToFMC_p;
  input i_MO1000_0_TriggerFromFMC_p;
  input [31:0] idp_DataFromADCTop_p;
  input [31:0] idn_DataFromADCTop_p;
  input idp_ClockFromADCTop_p;
  input idn_ClockFromADCTop_p;
  input idp_FrameFromADCTop_p;
  input idn_FrameFromADCTop_p;
  output odp_DioSetDir_p;
  output odn_DioSetDir_p;
  output odp_DioReset_p;
  output odn_DioReset_p;
  output [3:0] ov4dp_Dpio_p;
  output [3:0] ov4dn_Dpio_p;
  input [3:0] iv4dp_Dpio_p;
  input [3:0] iv4dn_Dpio_p;
  output odp_DpioClk_p;
  output odn_DpioClk_p;
  input [1:0] iv2dp_AdcData_p;
  input [1:0] iv2dn_AdcData_p;
  output odp_DioConfig_p;
  output odn_DioConfig_p;
  input idp_DioResetAck_p;
  input idn_DioResetAck_p;
  //wire [31:0] glenn_input = 32'h78486cf0;
  wire [31:0] glenn_input;
  
	// USR_ACCESS_VIRTEX6: Configuration Data Access
	//                     Virtex-6
	// Xilinx HDL Language Template, version 13.4

	USR_ACCESS_VIRTEX6 USR_ACCESS_VIRTEX6_inst (
		.CFGCLK(),       // 1-bit output: Configuration Clock output
		.DATA(glenn_input),           // 32-bit output: Configuration Data output
		.DATAVALID()  // 1-bit output: Active high data valid output
	);

	// End of USR_ACCESS_VIRTEX6_inst instantiation

  (* BOX_TYPE = "user_black_box" *)
  perseus6010_mo1000_mi125_bsdk
    perseus6010_mo1000_mi125_bsdk_i (
      .i_SysRst_p ( i_SysRst_p ),
      .i_pSysClk_p ( i_pSysClk_p ),
      .i_nSysClk_p ( i_nSysClk_p ),
      .i_pSodimmclk_p ( i_pSodimmclk_p ),
      .i_nSodimmclk_p ( i_nSodimmclk_p ),
      .o_nFpgaProg_p ( o_nFpgaProg_p ),
      .fpga_0_FLASH_Mem_A_pin ( fpga_0_FLASH_Mem_A_pin ),
      .Flash_Mem_WEN_pin ( Flash_Mem_WEN_pin ),
      .Flash_Mem_DQ_pin ( Flash_Mem_DQ_pin ),
      .Flash_Mem_CEN_pin ( Flash_Mem_CEN_pin ),
      .Flash_Mem_OEN_pin ( Flash_Mem_OEN_pin ),
      .o_nFlashRst_p ( o_nFlashRst_p ),
      .axi_ethernet_0_MGT_CLK_P_pin ( axi_ethernet_0_MGT_CLK_P_pin ),
      .axi_ethernet_0_MGT_CLK_N_pin ( axi_ethernet_0_MGT_CLK_N_pin ),
      .axi_ethernet_0_TXP_pin ( axi_ethernet_0_TXP_pin ),
      .axi_ethernet_0_TXN_pin ( axi_ethernet_0_TXN_pin ),
      .axi_ethernet_0_RXP_pin ( axi_ethernet_0_RXP_pin ),
      .axi_ethernet_0_RXN_pin ( axi_ethernet_0_RXN_pin ),
      .i_FpUartRX_p ( i_FpUartRX_p ),
      .io_FpUartTX_p ( io_FpUartTX_p ),
      .i_AMCUartRX_p ( i_AMCUartRX_p ),
      .io_AMCUartTX_p ( io_AMCUartTX_p ),
      .i_IpmiUartRX_p ( i_IpmiUartRX_p ),
      .o_IpmiUartTX_p ( o_IpmiUartTX_p ),
      .axi_v6_ddrx_0_ddr_addr_pin ( axi_v6_ddrx_0_ddr_addr_pin ),
      .axi_v6_ddrx_0_ddr_ba_pin ( axi_v6_ddrx_0_ddr_ba_pin ),
      .axi_v6_ddrx_0_ddr_cas_n_pin ( axi_v6_ddrx_0_ddr_cas_n_pin ),
      .axi_v6_ddrx_0_ddr_ck_p_pin ( axi_v6_ddrx_0_ddr_ck_p_pin ),
      .axi_v6_ddrx_0_ddr_ck_n_pin ( axi_v6_ddrx_0_ddr_ck_n_pin ),
      .axi_v6_ddrx_0_ddr_cke_pin ( axi_v6_ddrx_0_ddr_cke_pin ),
      .axi_v6_ddrx_0_ddr_cs_n_pin ( axi_v6_ddrx_0_ddr_cs_n_pin ),
      .axi_v6_ddrx_0_ddr_dm_pin ( axi_v6_ddrx_0_ddr_dm_pin ),
      .axi_v6_ddrx_0_ddr_odt_pin ( axi_v6_ddrx_0_ddr_odt_pin ),
      .axi_v6_ddrx_0_ddr_ras_n_pin ( axi_v6_ddrx_0_ddr_ras_n_pin ),
      .axi_v6_ddrx_0_ddr_reset_n_pin ( axi_v6_ddrx_0_ddr_reset_n_pin ),
      .axi_v6_ddrx_0_ddr_we_n_pin ( axi_v6_ddrx_0_ddr_we_n_pin ),
      .axi_v6_ddrx_0_ddr_dqs_p ( axi_v6_ddrx_0_ddr_dqs_p ),
      .axi_v6_ddrx_0_ddr_dqs_n ( axi_v6_ddrx_0_ddr_dqs_n ),
      .axi_v6_ddrx_0_ddr_dq ( axi_v6_ddrx_0_ddr_dq ),
      .axi_record_playback_ddr3_dq ( axi_record_playback_ddr3_dq ),
      .axi_record_playback_ddr3_addr_pin ( axi_record_playback_ddr3_addr_pin ),
      .axi_record_playback_ddr3_ba_pin ( axi_record_playback_ddr3_ba_pin ),
      .axi_record_playback_ddr3_ras_n_pin ( axi_record_playback_ddr3_ras_n_pin ),
      .axi_record_playback_ddr3_cas_n_pin ( axi_record_playback_ddr3_cas_n_pin ),
      .axi_record_playback_ddr3_we_n_pin ( axi_record_playback_ddr3_we_n_pin ),
      .axi_record_playback_ddr3_reset_n_pin ( axi_record_playback_ddr3_reset_n_pin ),
      .axi_record_playback_ddr3_cs_n_pin ( axi_record_playback_ddr3_cs_n_pin ),
      .axi_record_playback_ddr3_odt_pin ( axi_record_playback_ddr3_odt_pin ),
      .axi_record_playback_ddr3_cke_pin ( axi_record_playback_ddr3_cke_pin ),
      .axi_record_playback_ddr3_dm_pin ( axi_record_playback_ddr3_dm_pin ),
      .axi_record_playback_ddr3_dqs_p ( axi_record_playback_ddr3_dqs_p ),
      .axi_record_playback_ddr3_dqs_n ( axi_record_playback_ddr3_dqs_n ),
      .axi_record_playback_ddr3_ck_p_pin ( axi_record_playback_ddr3_ck_p_pin ),
      .axi_record_playback_ddr3_ck_n_pin ( axi_record_playback_ddr3_ck_n_pin ),
      .io_FmcI2cSCL_p ( io_FmcI2cSCL_p ),
      .io_FmcI2cSDA_p ( io_FmcI2cSDA_p ),
      .i_DaughterIoAbsent_p ( i_DaughterIoAbsent_p ),
      .i_FmcAbsent_p ( i_FmcAbsent_p ),
      .i_FmcStackAbsent_p ( i_FmcStackAbsent_p ),
      .io_Ddr3I2cSDA_p ( io_Ddr3I2cSDA_p ),
      .io_Ddr3I2cSCL_p ( io_Ddr3I2cSCL_p ),
      .o_CtrlTclkdTxEn_p ( o_CtrlTclkdTxEn_p ),
      .o_CtrlTclkdRxDis_p ( o_CtrlTclkdRxDis_p ),
      .o_CtrlAmctclkc2Fmcclk3En_p ( o_CtrlAmctclkc2Fmcclk3En_p ),
      .o_CtrlAmctclka2Fmcclk2En_p ( o_CtrlAmctclka2Fmcclk2En_p ),
      .o_CtrlFclkaHighz_p ( o_CtrlFclkaHighz_p ),
      .o_Ctrl100mhzOutEn_p ( o_Ctrl100mhzOutEn_p ),
      .o_CtrlTclkaTxEn_p ( o_CtrlTclkaTxEn_p ),
      .o_CtrlFmcclk02AmctclkbEn_p ( o_CtrlFmcclk02AmctclkbEn_p ),
      .o_CtrlTclkcTxEn_p ( o_CtrlTclkcTxEn_p ),
      .o_CtrlVadjEn_p ( o_CtrlVadjEn_p ),
      .o_CtrlTclkbRxDis_p ( o_CtrlTclkbRxDis_p ),
      .ov2_CtrlVadjSel_p ( ov2_CtrlVadjSel_p ),
      .o_CtrlTclkbTxEn_p ( o_CtrlTclkbTxEn_p ),
      .o_CtrlFmcclk12AmctclkdEn_p ( o_CtrlFmcclk12AmctclkdEn_p ),
      .o_CtrlTclkcRxDis_p ( o_CtrlTclkcRxDis_p ),
      .o_CtrlTclkaRxDis_p ( o_CtrlTclkaRxDis_p ),
      .o_CtrlLedBufOd_p ( o_CtrlLedBufOd_p ),
      .ov8_nCtrlLedGrn_p ( ov8_nCtrlLedGrn_p ),
      .ov8_nCtrlLedRed_p ( ov8_nCtrlLedRed_p ),
      .i_MmcI2cReleaseAck_p ( i_MmcI2cReleaseAck_p ),
      .o_MmcI2cReleaseReq_p ( o_MmcI2cReleaseReq_p ),
      .idp_MO1000_0_ClockFromFMC_p ( idp_MO1000_0_ClockFromFMC_p ),
      .idn_MO1000_0_ClockFromFMC_p ( idn_MO1000_0_ClockFromFMC_p ),
      .odp_MO1000_0_DataToFMC_p ( odp_MO1000_0_DataToFMC_p ),
      .odn_MO1000_0_DataToFMC_p ( odn_MO1000_0_DataToFMC_p ),
      .odp_MO1000_0_DciToFMC_p ( odp_MO1000_0_DciToFMC_p ),
      .odn_MO1000_0_DciToFMC_p ( odn_MO1000_0_DciToFMC_p ),
      .odp_MO1000_0_FrameToFMC_p ( odp_MO1000_0_FrameToFMC_p ),
      .odn_MO1000_0_FrameToFMC_p ( odn_MO1000_0_FrameToFMC_p ),
      .i_MO1000_0_TriggerFromFMC_p ( i_MO1000_0_TriggerFromFMC_p ),
      .idp_DataFromADCTop_p ( idp_DataFromADCTop_p ),
      .idn_DataFromADCTop_p ( idn_DataFromADCTop_p ),
      .idp_ClockFromADCTop_p ( idp_ClockFromADCTop_p ),
      .idn_ClockFromADCTop_p ( idn_ClockFromADCTop_p ),
      .idp_FrameFromADCTop_p ( idp_FrameFromADCTop_p ),
      .idn_FrameFromADCTop_p ( idn_FrameFromADCTop_p ),
      .odp_DioSetDir_p ( odp_DioSetDir_p ),
      .odn_DioSetDir_p ( odn_DioSetDir_p ),
      .odp_DioReset_p ( odp_DioReset_p ),
      .odn_DioReset_p ( odn_DioReset_p ),
      .ov4dp_Dpio_p ( ov4dp_Dpio_p ),
      .ov4dn_Dpio_p ( ov4dn_Dpio_p ),
      .iv4dp_Dpio_p ( iv4dp_Dpio_p ),
      .iv4dn_Dpio_p ( iv4dn_Dpio_p ),
      .odp_DpioClk_p ( odp_DpioClk_p ),
      .odn_DpioClk_p ( odn_DpioClk_p ),
      .iv2dp_AdcData_p ( iv2dp_AdcData_p ),
      .iv2dn_AdcData_p ( iv2dn_AdcData_p ),
      .odp_DioConfig_p ( odp_DioConfig_p ),
      .odn_DioConfig_p ( odn_DioConfig_p ),
      .idp_DioResetAck_p ( idp_DioResetAck_p ),
      .idn_DioResetAck_p ( idn_DioResetAck_p ),
      .glenn_input ( glenn_input )
    );

endmodule

