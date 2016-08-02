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
-- File        : $Id: lyt_axi_qsfp_plus.vhd,v 1.2 2013/03/27 14:58:25 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : Top module for QSFP+ peripheral
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2011 Lyrtech RD inc.
--------------------------------------------------------------------------------
-- $Log: lyt_axi_qsfp_plus.vhd,v $
-- Revision 1.2  2013/03/27 14:58:25  julien.roy
-- Change gtx core from v1.5 to v1.12
--
-- Revision 1.1  2013/03/25 15:32:19  julien.roy
-- Add AXI QSFP pcore
--
-- Revision 1.2  2011/04/26 20:06:59  jeffrey.johnson
-- Changed 156MHz references to 122MHz.
--
-- Revision 1.1  2011/03/18 16:06:07  jeffrey.johnson
-- First commit
--
--
--------------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library lyt_axi_qsfp_plus_v1_00_a;
  use lyt_axi_qsfp_plus_v1_00_a.all;

-------------------------------------------------------------------------------
-- Entity Section
-------------------------------------------------------------------------------
entity lyt_axi_qsfp_plus is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    REF_CLK_FREQ                   : integer              := 125;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_FAMILY                       : string               := "virtex6"
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
    (
    -- User ports
    i_FmcRefClk0P_p                : in std_logic;
    i_FmcRefClk0N_p                : in std_logic;
    i_FmcRefClk1P_p                : in std_logic;
    i_FmcRefClk1N_p                : in std_logic;
    i_M2CClk0P_p                   : in std_logic;
    i_M2CClk0N_p                   : in std_logic;
    i_M2CClk1P_p                   : in std_logic;
    i_M2CClk1N_p                   : in std_logic;

    iv4_QsfpGtxRxInP_p             : in std_logic_vector(3 downto 0);
    iv4_QsfpGtxRxInN_p             : in std_logic_vector(3 downto 0);
    ov4_QsfpGtxTxOutP_p            : out std_logic_vector(3 downto 0);
    ov4_QsfpGtxTxOutN_p            : out std_logic_vector(3 downto 0);

    iv2_SfpGtxRxInP_p              : in std_logic_vector(1 downto 0);
    iv2_SfpGtxRxInN_p              : in std_logic_vector(1 downto 0);
    ov2_SfpGtxTxOutP_p             : out std_logic_vector(1 downto 0);
    ov2_SfpGtxTxOutN_p             : out std_logic_vector(1 downto 0);

    o_ResetN_p                     : out std_logic;
    o_ClkSel_p                     : out std_logic;
    o_EnClk122_p                   : out std_logic;
    o_EnClkUser_p                  : out std_logic;

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT                     : string;
  attribute SIGIS                          : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN    : signal is "10000";
  attribute SIGIS of S_AXI_ACLK            : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN         : signal is "Rst";

end entity lyt_axi_qsfp_plus;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of lyt_axi_qsfp_plus is

 ------------------------------------------
 -- Resets
 ------------------------------------------

  signal Reset_s                    : std_logic;
  signal UserResetN_s               : std_logic;
  signal QsfpReset_s                : std_logic;
  signal SfpReset_s                 : std_logic;
  
 ------------------------------------------
 -- QSFP
 ------------------------------------------

  -- QSFP channel 0
  signal Qsfp0ResetErrCnt_s         : std_logic;
  signal v3_Qsfp0LoopBack_s         : std_logic_vector(2 downto 0);
  signal Qsfp0RxPllLkDet_s          : std_logic;
  signal Qsfp0RxResetDone_s         : std_logic;
  signal Qsfp0RxValid_s             : std_logic;
  signal Qsfp0RxPolarity_s          : std_logic;
  signal Qsfp0TxResetDone_s         : std_logic;
  signal Qsfp0TxPrbsForceErr_s      : std_logic;
  signal v8_Qsfp0RxErrorCount_s     : std_logic_vector(7 downto 0);
 
  -- QSFP channel 1
  signal Qsfp1ResetErrCnt_s         : std_logic;
  signal v3_Qsfp1LoopBack_s         : std_logic_vector(2 downto 0);
  signal Qsfp1RxPllLkDet_s          : std_logic;
  signal Qsfp1RxResetDone_s         : std_logic;
  signal Qsfp1RxValid_s             : std_logic;
  signal Qsfp1RxPolarity_s          : std_logic;
  signal Qsfp1TxResetDone_s         : std_logic;
  signal Qsfp1TxPrbsForceErr_s      : std_logic;
  signal v8_Qsfp1RxErrorCount_s     : std_logic_vector(7 downto 0);
 
  -- QSFP channel 2
  signal Qsfp2ResetErrCnt_s         : std_logic;
  signal v3_Qsfp2LoopBack_s         : std_logic_vector(2 downto 0);
  signal Qsfp2RxPllLkDet_s          : std_logic;
  signal Qsfp2RxResetDone_s         : std_logic;
  signal Qsfp2RxValid_s             : std_logic;
  signal Qsfp2RxPolarity_s          : std_logic;
  signal Qsfp2TxResetDone_s         : std_logic;
  signal Qsfp2TxPrbsForceErr_s      : std_logic;
  signal v8_Qsfp2RxErrorCount_s     : std_logic_vector(7 downto 0);
 
  -- QSFP channel 3
  signal Qsfp3ResetErrCnt_s         : std_logic;
  signal v3_Qsfp3LoopBack_s         : std_logic_vector(2 downto 0);
  signal Qsfp3RxPllLkDet_s          : std_logic;
  signal Qsfp3RxResetDone_s         : std_logic;
  signal Qsfp3RxValid_s             : std_logic;
  signal Qsfp3RxPolarity_s          : std_logic;
  signal Qsfp3TxResetDone_s         : std_logic;
  signal Qsfp3TxPrbsForceErr_s      : std_logic;
  signal v8_Qsfp3RxErrorCount_s     : std_logic_vector(7 downto 0);
    
  -- TX out clock from GTX
  signal QsfpTxOutClk_s             : std_logic;
  signal QsfpTxOutClkBuf_s          : std_logic;
  
 ------------------------------------------
 -- SFP+
 ------------------------------------------
  
  -- SFP0
  signal Sfp0ResetErrCnt_s          : std_logic;
  signal v3_Sfp0LoopBack_s          : std_logic_vector(2 downto 0);
  signal Sfp0RxPllLkDet_s           : std_logic;
  signal Sfp0RxResetDone_s          : std_logic;
  signal Sfp0RxValid_s              : std_logic;
  signal Sfp0RxPolarity_s           : std_logic;
  signal Sfp0TxResetDone_s          : std_logic;
  signal Sfp0TxPrbsForceErr_s       : std_logic;
  signal v8_Sfp0RxErrorCount_s      : std_logic_vector(7 downto 0);
 
  -- SFP1
  signal Sfp1ResetErrCnt_s          : std_logic;
  signal v3_Sfp1LoopBack_s          : std_logic_vector(2 downto 0);
  signal Sfp1RxPllLkDet_s           : std_logic;
  signal Sfp1RxResetDone_s          : std_logic;
  signal Sfp1RxValid_s              : std_logic;
  signal Sfp1RxPolarity_s           : std_logic;
  signal Sfp1TxResetDone_s          : std_logic;
  signal Sfp1TxPrbsForceErr_s       : std_logic;
  signal v8_Sfp1RxErrorCount_s      : std_logic_vector(7 downto 0);
  
  -- TX out clock from GTX
  signal SfpTxOutClk_s              : std_logic;
  signal SfpTxOutClkBuf_s           : std_logic;
  
 ------------------------------------------
 -- Clocks and clock status
 ------------------------------------------

  signal FmcRefClk0Status_s         : std_logic;
  signal FmcRefClk1Status_s         : std_logic;
  signal M2CClk0Status_s            : std_logic;
  signal M2CClk1Status_s            : std_logic;
                                    
  signal FmcRefClk0_s               : std_logic;
  signal FmcRefClk1_s               : std_logic;
  signal M2CClk0_s                  : std_logic;
  signal M2CClk0Bufg_s              : std_logic;
  signal M2CClk1_s                  : std_logic;
  signal M2CClk1Bufg_s              : std_logic;
  signal M2CClk0FB_s                : std_logic;
  signal M2CClk0FBBufg_s            : std_logic;
  signal M2CClk1FB_s                : std_logic;
  signal M2CClk1FBBufg_s            : std_logic;

begin
    
  ------------------------------------------
  -- Resets
  ------------------------------------------
  
  Reset_s <= (not S_AXI_ARESETN) or (not UserResetN_s);
  o_ResetN_p <= UserResetN_s;
  QsfpReset_s <= not FmcRefClk0Status_s;
  SfpReset_s <= not FmcRefClk1Status_s;
  
  ------------------------------------------
  -- GTX wrappers for the QSFP+ connectors
  ------------------------------------------
  
  Qsfp0GtxWrapper_l : entity work.gtx_test_wrapper
  generic map
  (
    -- Reference Clock Frequencies
    REF_CLK_FREQ                => REF_CLK_FREQ
  )
  port map
  (
    -- Resets
    i_Reset_p                   => Reset_s,
    i_TxReset_p                 => QsfpReset_s,
    i_RxReset_p                 => QsfpReset_s,

    -- GTX clocks
    i_MgtRefClk_p               => FmcRefClk0_s,
    o_TxOutClk_p                => QsfpTxOutClk_s,
    i_RxUsrClk2_p               => QsfpTxOutClkBuf_s,
    i_TxUsrClk2_p               => QsfpTxOutClkBuf_s,

    -- GTX tx and rx
    i_RxN_p                     => iv4_QsfpGtxRxInN_p(0),
    i_RxP_p                     => iv4_QsfpGtxRxInP_p(0),
    o_TxN_p                     => ov4_QsfpGtxTxOutN_p(0),
    o_TxP_p                     => ov4_QsfpGtxTxOutP_p(0),
    
    -- PLB register section.
    iv3_LoopBack_p              => v3_Qsfp0LoopBack_s,
    o_RxPllLkDet_p              => Qsfp0RxPllLkDet_s,
    o_RxResetDone_p             => Qsfp0RxResetDone_s,
    o_RxValid_p                 => Qsfp0RxValid_s,
    i_RxPolarity_p              => Qsfp0RxPolarity_s,
    o_TxPllLkDet_p              => FmcRefClk0Status_s,
    o_TxResetDone_p             => Qsfp0TxResetDone_s,
    i_TxPrbsForceErr_p          => Qsfp0TxPrbsForceErr_s,
    ov8_RxErrorCount_p          => v8_Qsfp0RxErrorCount_s,
    i_ResetErrCnt_p             => Qsfp0ResetErrCnt_s
  );
  
  Qsfp1GtxWrapper_l : entity work.gtx_test_wrapper
  generic map
  (
    -- Reference Clock Frequencies
    REF_CLK_FREQ                => REF_CLK_FREQ
  )
  port map
  (
    -- Resets
    i_Reset_p                   => Reset_s,
    i_TxReset_p                 => QsfpReset_s,
    i_RxReset_p                 => QsfpReset_s,

    -- GTX clocks
    i_MgtRefClk_p               => FmcRefClk0_s,
    o_TxOutClk_p                => open,
    i_RxUsrClk2_p               => QsfpTxOutClkBuf_s,
    i_TxUsrClk2_p               => QsfpTxOutClkBuf_s,

    -- GTX tx and rx
    i_RxN_p                     => iv4_QsfpGtxRxInN_p(1),
    i_RxP_p                     => iv4_QsfpGtxRxInP_p(1),
    o_TxN_p                     => ov4_QsfpGtxTxOutN_p(1),
    o_TxP_p                     => ov4_QsfpGtxTxOutP_p(1),
    
    -- PLB register section.
    iv3_LoopBack_p              => v3_Qsfp1LoopBack_s,
    o_RxPllLkDet_p              => Qsfp1RxPllLkDet_s,
    o_RxResetDone_p             => Qsfp1RxResetDone_s,
    o_RxValid_p                 => Qsfp1RxValid_s,
    i_RxPolarity_p              => Qsfp1RxPolarity_s,
    o_TxPllLkDet_p              => open,
    o_TxResetDone_p             => Qsfp1TxResetDone_s,
    i_TxPrbsForceErr_p          => Qsfp1TxPrbsForceErr_s,
    ov8_RxErrorCount_p          => v8_Qsfp1RxErrorCount_s,
    i_ResetErrCnt_p             => Qsfp1ResetErrCnt_s
  );
  
  Qsfp2GtxWrapper_l : entity work.gtx_test_wrapper
  generic map
  (
    -- Reference Clock Frequencies
    REF_CLK_FREQ                => REF_CLK_FREQ
  )
  port map
  (
    -- Resets
    i_Reset_p                   => Reset_s,
    i_TxReset_p                 => QsfpReset_s,
    i_RxReset_p                 => QsfpReset_s,

    -- GTX clocks
    i_MgtRefClk_p               => FmcRefClk0_s,
    o_TxOutClk_p                => open,
    i_RxUsrClk2_p               => QsfpTxOutClkBuf_s,
    i_TxUsrClk2_p               => QsfpTxOutClkBuf_s,

    -- GTX tx and rx
    i_RxN_p                     => iv4_QsfpGtxRxInN_p(2),
    i_RxP_p                     => iv4_QsfpGtxRxInP_p(2),
    o_TxN_p                     => ov4_QsfpGtxTxOutN_p(2),
    o_TxP_p                     => ov4_QsfpGtxTxOutP_p(2),
    
    -- PLB register section.
    iv3_LoopBack_p              => v3_Qsfp2LoopBack_s,
    o_RxPllLkDet_p              => Qsfp2RxPllLkDet_s,
    o_RxResetDone_p             => Qsfp2RxResetDone_s,
    o_RxValid_p                 => Qsfp2RxValid_s,
    i_RxPolarity_p              => Qsfp2RxPolarity_s,
    o_TxPllLkDet_p              => open,
    o_TxResetDone_p             => Qsfp2TxResetDone_s,
    i_TxPrbsForceErr_p          => Qsfp2TxPrbsForceErr_s,
    ov8_RxErrorCount_p          => v8_Qsfp2RxErrorCount_s,
    i_ResetErrCnt_p             => Qsfp2ResetErrCnt_s
  );
  
  Qsfp3GtxWrapper_l : entity work.gtx_test_wrapper
  generic map
  (
    -- Reference Clock Frequencies
    REF_CLK_FREQ                => REF_CLK_FREQ
  )
  port map
  (
    -- Resets
    i_Reset_p                   => Reset_s,
    i_TxReset_p                 => QsfpReset_s,
    i_RxReset_p                 => QsfpReset_s,

    -- GTX clocks
    i_MgtRefClk_p               => FmcRefClk0_s,
    o_TxOutClk_p                => open,
    i_RxUsrClk2_p               => QsfpTxOutClkBuf_s,
    i_TxUsrClk2_p               => QsfpTxOutClkBuf_s,

    -- GTX tx and rx
    i_RxN_p                     => iv4_QsfpGtxRxInN_p(3),
    i_RxP_p                     => iv4_QsfpGtxRxInP_p(3),
    o_TxN_p                     => ov4_QsfpGtxTxOutN_p(3),
    o_TxP_p                     => ov4_QsfpGtxTxOutP_p(3),
    
    -- PLB register section.
    iv3_LoopBack_p              => v3_Qsfp3LoopBack_s,
    o_RxPllLkDet_p              => Qsfp3RxPllLkDet_s,
    o_RxResetDone_p             => Qsfp3RxResetDone_s,
    o_RxValid_p                 => Qsfp3RxValid_s,
    i_RxPolarity_p              => Qsfp3RxPolarity_s,
    o_TxPllLkDet_p              => open,
    o_TxResetDone_p             => Qsfp3TxResetDone_s,
    i_TxPrbsForceErr_p          => Qsfp3TxPrbsForceErr_s,
    ov8_RxErrorCount_p          => v8_Qsfp3RxErrorCount_s,
    i_ResetErrCnt_p             => Qsfp3ResetErrCnt_s
  );
  
  ------------------------------------------
  -- GTX wrappers for the SFP+ connectors
  ------------------------------------------
  
  Sfp0GtxWrapper_l : entity work.gtx_test_wrapper
  generic map
  (
    -- Reference Clock Frequencies
    REF_CLK_FREQ                => REF_CLK_FREQ
  )
  port map
  (
    -- Resets
    i_Reset_p                   => Reset_s,
    i_TxReset_p                 => SfpReset_s,
    i_RxReset_p                 => SfpReset_s,

    -- GTX clocks
    i_MgtRefClk_p               => FmcRefClk1_s,
    o_TxOutClk_p                => open,
    i_RxUsrClk2_p               => SfpTxOutClkBuf_s,
    i_TxUsrClk2_p               => SfpTxOutClkBuf_s,

    -- GTX tx and rx
    i_RxN_p                     => iv2_SfpGtxRxInN_p(0),
    i_RxP_p                     => iv2_SfpGtxRxInP_p(0),
    o_TxN_p                     => ov2_SfpGtxTxOutN_p(0),
    o_TxP_p                     => ov2_SfpGtxTxOutP_p(0),
    
    -- PLB register section.
    iv3_LoopBack_p              => v3_Sfp0LoopBack_s,
    o_RxPllLkDet_p              => Sfp0RxPllLkDet_s,
    o_RxResetDone_p             => Sfp0RxResetDone_s,
    o_RxValid_p                 => Sfp0RxValid_s,
    i_RxPolarity_p              => Sfp0RxPolarity_s,
    o_TxPllLkDet_p              => open,
    o_TxResetDone_p             => Sfp0TxResetDone_s,
    i_TxPrbsForceErr_p          => Sfp0TxPrbsForceErr_s,
    ov8_RxErrorCount_p          => v8_Sfp0RxErrorCount_s,
    i_ResetErrCnt_p             => Sfp0ResetErrCnt_s
  );
  
  Sfp1GtxWrapper_l : entity work.gtx_test_wrapper
  generic map
  (
    -- Reference Clock Frequencies
    REF_CLK_FREQ                => REF_CLK_FREQ
  )
  port map
  (
    -- Resets
    i_Reset_p                   => Reset_s,
    i_TxReset_p                 => SfpReset_s,
    i_RxReset_p                 => SfpReset_s,

    -- GTX clocks
    i_MgtRefClk_p               => FmcRefClk1_s,
    o_TxOutClk_p                => SfpTxOutClk_s,
    i_RxUsrClk2_p               => SfpTxOutClkBuf_s,
    i_TxUsrClk2_p               => SfpTxOutClkBuf_s,

    -- GTX tx and rx
    i_RxN_p                     => iv2_SfpGtxRxInN_p(1),
    i_RxP_p                     => iv2_SfpGtxRxInP_p(1),
    o_TxN_p                     => ov2_SfpGtxTxOutN_p(1),
    o_TxP_p                     => ov2_SfpGtxTxOutP_p(1),
    
    -- PLB register section.
    iv3_LoopBack_p              => v3_Sfp1LoopBack_s,
    o_RxPllLkDet_p              => Sfp1RxPllLkDet_s,
    o_RxResetDone_p             => Sfp1RxResetDone_s,
    o_RxValid_p                 => Sfp1RxValid_s,
    i_RxPolarity_p              => Sfp1RxPolarity_s,
    o_TxPllLkDet_p              => FmcRefClk1Status_s,
    o_TxResetDone_p             => Sfp1TxResetDone_s,
    i_TxPrbsForceErr_p          => Sfp1TxPrbsForceErr_s,
    ov8_RxErrorCount_p          => v8_Sfp1RxErrorCount_s,
    i_ResetErrCnt_p             => Sfp1ResetErrCnt_s
  );
  
  
  ------------------------------------------
  -- MMCMs for testing clocks
  ------------------------------------------

  FmcRefClk0_IBUFDS_GTXE1 : IBUFDS_GTXE1
  port map
  (
    I                 => i_FmcRefClk0P_p,
    IB                => i_FmcRefClk0N_p,
    CEB               => '0',
    O                 => FmcRefClk0_s,
    ODIV2             => open
  );
  
  FmcRefClk1_IBUFDS_GTXE1 : IBUFDS_GTXE1
  port map
  (
    I                 => i_FmcRefClk1P_p,
    IB                => i_FmcRefClk1N_p,
    CEB               => '0',
    O                 => FmcRefClk1_s,
    ODIV2             => open
  );
  
  SfpTxOutClk0Bufg_l : BUFG
  port map
  (
    I => SfpTxOutClk_s,
    O => SfpTxOutClkBuf_s
  );

  QsfpTxOutClk0Bufg_l : BUFG
  port map
  (
    I => QsfpTxOutClk_s,
    O => QsfpTxOutClkBuf_s
  );

  M2CClk0_IBUFDS : IBUFDS
  port map
  (
    O                 => M2CClk0_s,
    I                 => i_M2CClk0P_p,
    IB                => i_M2CClk0N_p
  );
  
  M2CClk0_BUFG : BUFG
  port map
  (
    O                 => M2CClk0Bufg_s,
    I                 => M2CClk0_s
  );
  
  Clkf0Bufg_l : BUFG
  port map
  (
    O => M2CClk0FBBufg_s,
    I => M2CClk0FB_s
  );

  M2CClk0_MMCM  : entity work.mmcm_calib
  generic map
  (
    BANDWIDTH        =>  "LOW",
    COMPENSATION     =>  "ZHOLD",
    CLKFBOUT_MULT_F  =>  8.0,
    DIVCLK_DIVIDE    =>  2,
    CLKFBOUT_PHASE   =>  0.0,
    CLKIN1_PERIOD    =>  6.4,
    CLKIN2_PERIOD    =>  10.0,          -- Not used
    CLKOUT0_DIVIDE_F =>  2.0,
    CLKOUT0_PHASE    =>  0.0,
    CLKOUT1_DIVIDE   =>  2,
    CLKOUT1_PHASE    =>  0.0,
    CLKOUT2_DIVIDE   =>  2,
    CLKOUT2_PHASE    =>  0.0,
    CLKOUT3_DIVIDE   =>  2,
    CLKOUT3_PHASE    =>  0.0         
  )
  port map
  (
    CLKIN1          =>  M2CClk0Bufg_s,
    CLKIN2          =>  '0',
    CLKINSEL        =>  '1',
    CLKFBIN         =>  M2CClk0FBBufg_s,
    CLKOUT0         =>  open,
    CLKOUT0B        =>  open,
    CLKOUT1         =>  open,
    CLKOUT1B        =>  open,
    CLKOUT2         =>  open,
    CLKOUT2B        =>  open,
    CLKOUT3         =>  open,
    CLKOUT3B        =>  open,
    CLKOUT4         =>  open,
    CLKOUT5         =>  open,
    CLKOUT6         =>  open,
    CLKFBOUT        =>  M2CClk0FB_s,
    CLKFBOUTB       =>  open,
    CLKFBSTOPPED    =>  open,
    CLKINSTOPPED    =>  open,
    DO              =>  open,
    DRDY            =>  open,
    DADDR           =>  "0000000",
    DCLK            =>  '0',
    DEN             =>  '0',
    DI              =>  "0000000000000000",
    DWE             =>  '0',
    LOCKED          =>  M2CClk0Status_s,
    PSCLK           =>  '0',
    PSEN            =>  '0',        
    PSINCDEC        =>  '0', 
    PSDONE          =>  open,         
    PWRDWN          =>  '0',
    RST             =>  Reset_s     
  );

  M2CClk1_IBUFDS : IBUFDS
  port map
  (
    O                 => M2CClk1_s,
    I                 => i_M2CClk1P_p,
    IB                => i_M2CClk1N_p
  );

  M2CClk1_BUFG : BUFG
  port map
  (
    O                 => M2CClk1Bufg_s,
    I                 => M2CClk1_s
  );
  
  Clkf1Bufg_l : BUFG
  port map
  (
    O => M2CClk1FBBufg_s,
    I => M2CClk1FB_s
  );

  M2CClk1_MMCM  : entity work.mmcm_calib
  generic map
  (
    BANDWIDTH        =>  "LOW",
    COMPENSATION     =>  "ZHOLD",
    CLKFBOUT_MULT_F  =>  8.0,
    DIVCLK_DIVIDE    =>  2,
    CLKFBOUT_PHASE   =>  0.0,
    CLKIN1_PERIOD    =>  6.4,
    CLKIN2_PERIOD    =>  10.0,          -- Not used
    CLKOUT0_DIVIDE_F =>  2.0,
    CLKOUT0_PHASE    =>  0.0,
    CLKOUT1_DIVIDE   =>  2,
    CLKOUT1_PHASE    =>  0.0,
    CLKOUT2_DIVIDE   =>  2,
    CLKOUT2_PHASE    =>  0.0,
    CLKOUT3_DIVIDE   =>  2,
    CLKOUT3_PHASE    =>  0.0         
  )
  port map
  (
    CLKIN1          =>  M2CClk1Bufg_s,
    CLKIN2          =>  '0',
    CLKINSEL        =>  '1',
    CLKFBIN         =>  M2CClk1FBBufg_s,
    CLKOUT0         =>  open,
    CLKOUT0B        =>  open,
    CLKOUT1         =>  open,
    CLKOUT1B        =>  open,
    CLKOUT2         =>  open,
    CLKOUT2B        =>  open,
    CLKOUT3         =>  open,
    CLKOUT3B        =>  open,
    CLKOUT4         =>  open,
    CLKOUT5         =>  open,
    CLKOUT6         =>  open,
    CLKFBOUT        =>  M2CClk1FB_s,
    CLKFBOUTB       =>  open,
    CLKFBSTOPPED    =>  open,
    CLKINSTOPPED    =>  open,
    DO              =>  open,
    DRDY            =>  open,
    DADDR           =>  "0000000",
    DCLK            =>  '0',
    DEN             =>  '0',
    DI              =>  "0000000000000000",
    DWE             =>  '0',
    LOCKED          =>  M2CClk1Status_s,
    PSCLK           =>  '0',
    PSEN            =>  '0',        
    PSINCDEC        =>  '0', 
    PSDONE          =>  open,         
    PWRDWN          =>  '0',
    RST             =>  Reset_s     
  );


 ------------------------------------------
 -- AXI Registers
 ------------------------------------------
 
  USER_LOGIC_I : entity lyt_axi_qsfp_plus_v1_00_a.axi_qsfp_plus
    generic map
    (
     -- MAP USER GENERICS BELOW THIS LINE ---------------
     --USER generics mapped here
     -- MAP USER GENERICS ABOVE THIS LINE ---------------
     C_S_AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH,
     C_S_AXI_ADDR_WIDTH        => C_S_AXI_ADDR_WIDTH,
     C_S_AXI_MIN_SIZE          => C_S_AXI_MIN_SIZE  ,
     C_USE_WSTRB               => C_USE_WSTRB       ,
     C_DPHASE_TIMEOUT          => C_DPHASE_TIMEOUT  ,
     C_BASEADDR                => C_BASEADDR        ,
     C_HIGHADDR                => C_HIGHADDR        ,
     C_FAMILY                  => C_FAMILY          
    )
    port map
    (
      -- user ports mapping
      i_CoreReset_p                  => '0',
      o_ResetN_p                     => UserResetN_s,
      o_ClkSel_p                     => o_ClkSel_p,
      o_EnClk122_p                   => o_EnClk122_p,
      o_EnClkUser_p                  => o_EnClkUser_p,
      i_FmcRefClk0Status_p           => FmcRefClk0Status_s,
      i_FmcRefClk1Status_p           => FmcRefClk1Status_s,
      i_M2CClk0Status_p              => M2CClk0Status_s,
      i_M2CClk1Status_p              => M2CClk1Status_s,
      o_Qsfp0RxPolarity_p            => Qsfp0RxPolarity_s,
      iv8_Qsfp0RxErrorCount_p        => v8_Qsfp0RxErrorCount_s,
      o_Qsfp0ResetErrCnt_p           => Qsfp0ResetErrCnt_s,
      ov3_Qsfp0LoopBack_p            => v3_Qsfp0LoopBack_s,
      o_Qsfp0TxPrbsForceErr_p        => Qsfp0TxPrbsForceErr_s,
      i_Qsfp0RxPllLkDet_p            => Qsfp0RxPllLkDet_s,
      i_Qsfp0TxResetDone_p           => Qsfp0TxResetDone_s,
      i_Qsfp0RxResetDone_p           => Qsfp0RxResetDone_s,
      i_Qsfp0RxValid_p               => Qsfp0RxValid_s,
      o_Qsfp1RxPolarity_p            => Qsfp1RxPolarity_s,
      iv8_Qsfp1RxErrorCount_p        => v8_Qsfp1RxErrorCount_s,
      o_Qsfp1ResetErrCnt_p           => Qsfp1ResetErrCnt_s,
      ov3_Qsfp1LoopBack_p            => v3_Qsfp1LoopBack_s,
      o_Qsfp1TxPrbsForceErr_p        => Qsfp1TxPrbsForceErr_s,
      i_Qsfp1RxPllLkDet_p            => Qsfp1RxPllLkDet_s,
      i_Qsfp1TxResetDone_p           => Qsfp1TxResetDone_s,
      i_Qsfp1RxResetDone_p           => Qsfp1RxResetDone_s,
      i_Qsfp1RxValid_p               => Qsfp1RxValid_s,
      o_Qsfp2RxPolarity_p            => Qsfp2RxPolarity_s,
      iv8_Qsfp2RxErrorCount_p        => v8_Qsfp2RxErrorCount_s,
      o_Qsfp2ResetErrCnt_p           => Qsfp2ResetErrCnt_s,
      ov3_Qsfp2LoopBack_p            => v3_Qsfp2LoopBack_s,
      o_Qsfp2TxPrbsForceErr_p        => Qsfp2TxPrbsForceErr_s,
      i_Qsfp2RxPllLkDet_p            => Qsfp2RxPllLkDet_s,
      i_Qsfp2TxResetDone_p           => Qsfp2TxResetDone_s,
      i_Qsfp2RxResetDone_p           => Qsfp2RxResetDone_s,
      i_Qsfp2RxValid_p               => Qsfp2RxValid_s,
      o_Qsfp3RxPolarity_p            => Qsfp3RxPolarity_s,
      iv8_Qsfp3RxErrorCount_p        => v8_Qsfp3RxErrorCount_s,
      o_Qsfp3ResetErrCnt_p           => Qsfp3ResetErrCnt_s,
      ov3_Qsfp3LoopBack_p            => v3_Qsfp3LoopBack_s,
      o_Qsfp3TxPrbsForceErr_p        => Qsfp3TxPrbsForceErr_s,
      i_Qsfp3RxPllLkDet_p            => Qsfp3RxPllLkDet_s,
      i_Qsfp3TxResetDone_p           => Qsfp3TxResetDone_s,
      i_Qsfp3RxResetDone_p           => Qsfp3RxResetDone_s,
      i_Qsfp3RxValid_p               => Qsfp3RxValid_s,
      o_Sfp0RxPolarity_p             => Sfp0RxPolarity_s,
      iv8_Sfp0RxErrorCount_p         => v8_Sfp0RxErrorCount_s,
      o_Sfp0ResetErrCnt_p            => Sfp0ResetErrCnt_s,
      ov3_Sfp0LoopBack_p             => v3_Sfp0LoopBack_s,
      o_Sfp0TxPrbsForceErr_p         => Sfp0TxPrbsForceErr_s,
      i_Sfp0RxPllLkDet_p             => Sfp0RxPllLkDet_s,
      i_Sfp0TxResetDone_p            => Sfp0TxResetDone_s,
      i_Sfp0RxResetDone_p            => Sfp0RxResetDone_s,
      i_Sfp0RxValid_p                => Sfp0RxValid_s,
      o_Sfp1RxPolarity_p             => Sfp1RxPolarity_s,
      iv8_Sfp1RxErrorCount_p         => v8_Sfp1RxErrorCount_s,
      o_Sfp1ResetErrCnt_p            => Sfp1ResetErrCnt_s,
      ov3_Sfp1LoopBack_p             => v3_Sfp1LoopBack_s,
      o_Sfp1TxPrbsForceErr_p         => Sfp1TxPrbsForceErr_s,
      i_Sfp1RxPllLkDet_p             => Sfp1RxPllLkDet_s,
      i_Sfp1TxResetDone_p            => Sfp1TxResetDone_s,
      i_Sfp1RxResetDone_p            => Sfp1RxResetDone_s,
      i_Sfp1RxValid_p                => Sfp1RxValid_s,
      
      -- Bus Protocol Ports mapping --
      S_AXI_ACLK                => S_AXI_ACLK    ,
      S_AXI_ARESETN             => S_AXI_ARESETN ,
      S_AXI_AWADDR              => S_AXI_AWADDR  ,
      S_AXI_AWVALID             => S_AXI_AWVALID ,
      S_AXI_WDATA               => S_AXI_WDATA   ,
      S_AXI_WSTRB               => S_AXI_WSTRB   ,
      S_AXI_WVALID              => S_AXI_WVALID  ,
      S_AXI_BREADY              => S_AXI_BREADY  ,
      S_AXI_ARADDR              => S_AXI_ARADDR  ,
      S_AXI_ARVALID             => S_AXI_ARVALID ,
      S_AXI_RREADY              => S_AXI_RREADY  ,
      S_AXI_ARREADY             => S_AXI_ARREADY ,
      S_AXI_RDATA               => S_AXI_RDATA   ,
      S_AXI_RRESP               => S_AXI_RRESP   ,
      S_AXI_RVALID              => S_AXI_RVALID  ,
      S_AXI_WREADY              => S_AXI_WREADY  ,
      S_AXI_BRESP               => S_AXI_BRESP   ,
      S_AXI_BVALID              => S_AXI_BVALID  ,
      S_AXI_AWREADY             => S_AXI_AWREADY  
    );
 
 end IMP;

