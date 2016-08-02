
------------------------------------------------------------------------------
-- Filename:          lyt_axi_sfp_plus.vhd
-- Version:           v1_00_a
-- Description:       Top level design, instantiates library components and
--                    user logic.
-- Create by:         Xilinx IPIF Wizard
-- Modified by:       Nutaq reggenutil.
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Copyright (c) 2013 Nutaq RD Inc.  All rights reserved.
------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_misc.all;

library unisim;
  use unisim.vcomponents.all;

library lyt_axi_sfp_plus_v1_00_a;
  use lyt_axi_sfp_plus_v1_00_a.all;


-------------------------------------------------------------------------------
-- Entity Section
-------------------------------------------------------------------------------
entity lyt_axi_sfp_plus is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------
    ClkDivider_g                   : integer := 4;
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
    i_MgtRefClkP_p                 : in std_logic;
    i_MgtRefClkN_p                 : in std_logic;

    i_FmcRefClk1P_p                : in std_logic;
    i_FmcRefClk1N_p                : in std_logic;

    i_M2CClk0P_p                   : in std_logic;
    i_M2CClk0N_p                   : in std_logic;

    i_M2CClk1P_p                   : in std_logic;
    i_M2CClk1N_p                   : in std_logic;

    iv4_GtxRxInAP_p                : in std_logic_vector(3 downto 0);
    iv4_GtxRxInAN_p                : in std_logic_vector(3 downto 0);

    ov4_GtxTxOutAP_p               : out std_logic_vector(3 downto 0);
    ov4_GtxTxOutAN_p               : out std_logic_vector(3 downto 0);

    iv4_GtxRxInBP_p                : in std_logic_vector(3 downto 0);
    iv4_GtxRxInBN_p                : in std_logic_vector(3 downto 0);

    ov4_GtxTxOutBP_p               : out std_logic_vector(3 downto 0);
    ov4_GtxTxOutBN_p               : out std_logic_vector(3 downto 0);

    o_MDC_p                        : out std_logic;
    i_MDIO_p                       : in std_logic;
    o_MDIO_p                       : out std_logic;
    o_MDIODisable_p                : out std_logic;

    o_ResetN_p                     : out std_logic;
    o_ClkSel_p                     : out std_logic;
    o_EnClk156_p                   : out std_logic;
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
    -- DO NOT EDIT ABOVE THIS LINE --
  );

  attribute MAX_FANOUT                     : string;
  attribute SIGIS                          : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN    : signal is "10000";
  attribute SIGIS of S_AXI_ACLK            : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN         : signal is "Rst";

end entity lyt_axi_sfp_plus;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of lyt_axi_sfp_plus is

  ------------------------------------------
  -- MDIO controller
  ------------------------------------------

  signal ExtendedAdrsSpc_s              : std_logic;
  signal TransactionDone_s              : std_logic;
  signal TransactionRq_s                : std_logic;
  signal Busy_s                         : std_logic;

  signal v2_TransactionType_s           : std_logic_vector(1 downto 0);

  signal v5_DevAddress_s                : std_logic_vector(4 downto 0);
  signal v5_PortAddress_s               : std_logic_vector(4 downto 0);

  signal v16_Data2Send_s                : std_logic_vector(15 downto 0);
  signal v16_ReceivedData_s             : std_logic_vector(15 downto 0);

  component MdioInterface is
    generic (
      ClkDivider_g                : integer := 4
    );
    port (
      i_Reset_p                   : in std_logic;
      i_clk_p                     : in std_logic;

      i_ExtendedAdrsSpc_p         : in std_logic;

      i_TransactionRq_p           : in std_logic;

      iv2_TransactionType_p       : in std_logic_vector(1 downto 0);

      iv5_PortAddress_p           : in std_logic_vector(4 downto 0);
      iv5_DevAddress_p            : in std_logic_vector(4 downto 0);
      iv16_Data2Send_p            : in std_logic_vector(15 downto 0);

      o_MDC_p                     : out std_logic;
      o_TransactionRqD0_p         : out std_logic;
      o_TransactionDone_p         : out std_logic;
      o_Busy_p                    : out std_logic;

      ov16_ReceivedData_p         : out std_logic_vector(15 downto 0);

      i_MDIO_p                    : in std_logic;
      o_MDIO_p                    : out std_logic;
      o_MDIODisable_p             : out std_logic
    );
  end component MdioInterface;

 ------------------------------------------
 -- XAUI
 ------------------------------------------

  signal Reset_s                 : std_logic;
  signal UserResetN_s            : std_logic;
  signal MgtLoopbackA_s          : std_logic_vector(2 downto 0);
  signal MgtLoopbackB_s          : std_logic_vector(2 downto 0);
  signal ResetErrCnt_s           : std_logic;
  signal EnPktGen_s              : std_logic;
  signal PacketSize_s            : std_logic_vector(19 downto 0);

  signal CntRxValidPacketA_s     : std_logic_vector(15 downto 0);
  signal CntRxCorruptPacketA_s   : std_logic_vector(15 downto 0);

  signal CntRxValidPacketB_s     : std_logic_vector(15 downto 0);
  signal CntRxCorruptPacketB_s   : std_logic_vector(15 downto 0);

  signal FmcRefClk0Status_s      : std_logic;
  signal FmcRefClk1Status_s      : std_logic;
  signal M2CClk0Status_s         : std_logic;
  signal M2CClk1Status_s         : std_logic;

  signal FmcRefClk1_s            : std_logic;
  signal M2CClk0_s               : std_logic;
  signal M2CClk0Bufg_s           : std_logic;
  signal M2CClk1_s               : std_logic;
  signal M2CClk1Bufg_s           : std_logic;
  signal M2CClk0FB_s             : std_logic;
  signal M2CClk0FBBufg_s         : std_logic;
  signal M2CClk1FB_s             : std_logic;
  signal M2CClk1FBBufg_s         : std_logic;
  
  signal S_AXI_ARESET            : std_logic;

begin

  S_AXI_ARESET <= (not S_AXI_ARESETN);

  ------------------------------------------
  -- MDIO controller
  ------------------------------------------

  MdioInterface_l : MdioInterface
    generic map(
      ClkDivider_g                => ClkDivider_g
    )
    port map(
      i_Reset_p                   => S_AXI_ARESET,
      i_clk_p                     => S_AXI_ACLK,

      i_ExtendedAdrsSpc_p         => ExtendedAdrsSpc_s,

      i_TransactionRq_p           => TransactionRq_s,

      iv2_TransactionType_p       => v2_TransactionType_s,

      iv5_PortAddress_p           => v5_PortAddress_s,
      iv5_DevAddress_p            => v5_DevAddress_s,
      iv16_Data2Send_p            => v16_Data2Send_s,

      o_MDC_p                     => o_MDC_p,
      o_TransactionRqD0_p         => open,
      o_TransactionDone_p         => TransactionDone_s,
      o_Busy_p                    => Busy_s,

      ov16_ReceivedData_p         => v16_ReceivedData_s,

      i_MDIO_p                    => i_MDIO_p,
      o_MDIO_p                    => o_MDIO_p,
      o_MDIODisable_p             => o_MDIODisable_p
    );


  ------------------------------------------
  -- XAUI
  ------------------------------------------

  XauiLoopBackTest_l : entity work.XauiLoopBackTest
  port map (
    i_Reset_p                   => Reset_s,

    i_MgtRefClkP_p              => i_MgtRefClkP_p,
    i_MgtRefClkN_p              => i_MgtRefClkN_p,

    o_PllLocked_p               => FmcRefClk0Status_s,

    i_LoopbackA_p               => MgtLoopbackA_s,
    i_LoopbackB_p               => MgtLoopbackB_s,
    i_ResetErrCnt_p             => ResetErrCnt_s,
    i_EnPktGen_p                => EnPktGen_s,
    iv20_PacketSize_p           => PacketSize_s,

    iv4_GtxRxInAP_p             => iv4_GtxRxInAP_p,
    iv4_GtxRxInAN_p             => iv4_GtxRxInAN_p,

    ov4_GtxTxOutAP_p            => ov4_GtxTxOutAP_p,
    ov4_GtxTxOutAN_p            => ov4_GtxTxOutAN_p,

    iv4_GtxRxInBP_p             => iv4_GtxRxInBP_p,
    iv4_GtxRxInBN_p             => iv4_GtxRxInBN_p,

    ov4_GtxTxOutBP_p            => ov4_GtxTxOutBP_p,
    ov4_GtxTxOutBN_p            => ov4_GtxTxOutBN_p,

    ov_cntRxValidPacketA_p      => CntRxValidPacketA_s,
    ov_cntRxCorruptPacketA_p    => CntRxCorruptPacketA_s,

    ov_cntRxValidPacketB_p      => CntRxValidPacketB_s,
    ov_cntRxCorruptPacketB_p    => CntRxCorruptPacketB_s
  );

  Reset_s <= S_AXI_ARESET or (not UserResetN_s);
  o_ResetN_p <= UserResetN_s;

  ------------------------------------------
  -- MMCMs for testing clocks
  ------------------------------------------

  FmcRefClk1_IBUFDS_GTXE1 : IBUFDS_GTXE1
  port map
  (
    I                 => i_FmcRefClk1P_p,
    IB                => i_FmcRefClk1N_p,
    CEB               => '0',
    O                 => FmcRefClk1_s,
    ODIV2             => open
  );

  FmcRefClk1_mmcm_i : entity work.MGT_USRCLK_SOURCE_MMCM
  port map
  (
    CLK0_OUT          => open,
    CLK1_OUT          => open,
    CLK2_OUT          => open,
    CLK3_OUT          => open,
    CLK_IN            => FmcRefClk1_s,
    MMCM_LOCKED_OUT   => FmcRefClk1Status_s,
    MMCM_RESET_IN     => Reset_s
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
 -- instantiate User Logic
 ------------------------------------------
  USER_LOGIC_I : entity lyt_axi_sfp_plus_v1_00_a.axi_sfp_plus
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
      -- user_logic entity ports mapping  ---------------
      -- user ports mapping
      i_CoreReset_p                  => '0',
      ov2_TransactionType_p          => v2_TransactionType_s,
      o_ExtendedAdrsSpc_p            => ExtendedAdrsSpc_s,
      i_TransactionRq_p              => Busy_s,
      o_TransactionRq_p              => TransactionRq_s,
      i_TransactionRqRst_p           => TransactionDone_s,
      ov5_RegAddress_p               => v5_DevAddress_s,
      ov5_PortAddress_p              => v5_PortAddress_s,
      iv16_Data_p                    => v16_ReceivedData_s,
      ov16_Data_p                    => v16_Data2Send_s,
      o_ResetN_p                     => UserResetN_s,
      o_ClkSel_p                     => o_ClkSel_p,
      ov20_PacketSize_p              => PacketSize_s,
      o_EnClk156_p                   => o_EnClk156_p,
      o_EnClkUser_p                  => o_EnClkUser_p,
      ov3_MgtLoopbackA_p             => MgtLoopbackA_s,
      ov3_MgtLoopbackB_p             => MgtLoopbackB_s,
      o_ResetErrCnt_p                => ResetErrCnt_s,
      o_EnPktGen_p                   => EnPktGen_s,
      iv16_CntRxValidPacketA_p       => CntRxValidPacketA_s,
      iv16_CntRxCorruptPacketA_p     => CntRxCorruptPacketA_s,
      iv16_CntRxValidPacketB_p       => CntRxValidPacketB_s,
      iv16_CntRxCorruptPacketB_p     => CntRxCorruptPacketB_s,
      i_FmcRefClk0Status_p           => FmcRefClk0Status_s,
      i_FmcRefClk1Status_p           => FmcRefClk1Status_s,
      i_M2CClk0Status_p              => M2CClk0Status_s,
      i_M2CClk1Status_p              => M2CClk1Status_s,
      
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

