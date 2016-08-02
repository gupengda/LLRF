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
-- File        : $Id: gtx_test_wrapper.vhd,v 1.2 2013/03/27 14:58:25 julien.roy Exp $
--------------------------------------------------------------------------------
-- Description : Wrapper for one GTX QUAD with frame generator and checker
--
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--
--------------------------------------------------------------------------------
-- Copyright (c) 2011 Lyrtech RD inc.
--------------------------------------------------------------------------------
-- $Log: gtx_test_wrapper.vhd,v $
-- Revision 1.2  2013/03/27 14:58:25  julien.roy
-- Change gtx core from v1.5 to v1.12
--
-- Revision 1.1  2013/03/25 15:32:19  julien.roy
-- Add AXI QSFP pcore
--
-- Revision 1.2  2011/04/20 16:17:07  jeffrey.johnson
-- Added error counters with reset logic.
--
-- Revision 1.1  2011/03/18 16:06:07  jeffrey.johnson
-- First commit
--
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;


entity gtx_test_wrapper is
  generic 
  (
    -- Reference Clock Frequency
    REF_CLK_FREQ                : integer := 100;
    EXAMPLE_WORDS_IN_BRAM       : integer := 512  -- specifies amount of data in BRAM
  );
  port 
  (
    -- Resets
    i_Reset_p                   : in std_logic;
    i_TxReset_p                 : in std_logic;
    i_RxReset_p                 : in std_logic;
    
    -- GTX clocks
    i_MgtRefClk_p               : in std_logic; 
    o_TxOutClk_p                : out std_logic;
    i_RxUsrClk2_p               : in std_logic;
    i_TxUsrClk2_p               : in std_logic;

    -- GTX tx and rx
    i_RxN_p                     : in std_logic; 
    i_RxP_p                     : in std_logic; 
    o_TxN_p                     : out std_logic;
    o_TxP_p                     : out std_logic;

    -- PLB register section.
    iv3_LoopBack_p              : in std_logic_vector(2 downto 0); 
    o_RxPllLkDet_p              : out std_logic;
    o_RxResetDone_p             : out std_logic;
    o_RxValid_p                 : out std_logic;
    i_RxPolarity_p              : in std_logic; 
    o_TxPllLkDet_p              : out std_logic;
    o_TxResetDone_p             : out std_logic;
    i_TxPrbsForceErr_p          : in std_logic; 
    ov8_RxErrorCount_p          : out std_logic_vector(7 downto 0);
    i_ResetErrCnt_p             : in std_logic
    
  );
end entity gtx_test_wrapper;

architecture Beh of gtx_test_wrapper is

  -- Architecture's local constants, types, signals functions.
  signal SystemRst_s            : std_logic;
                              
  signal TxResetDone_s          : std_logic;
  signal RxResetDone_s          : std_logic;
                              
  signal gtx0_txdata_s          : std_logic_vector(15 downto 0);
  signal gtx0_txcharisk_s       : std_logic_vector(1 downto 0);
  signal gtx0_rxdata_s          : std_logic_vector(15 downto 0);
  signal gtx0_rxcharisk_s		    : std_logic_vector(1 downto 0);
  signal gtx0_rxenmcommaalign_s : std_logic;
  signal gtx0_rxenpcommaalign_s : std_logic;
  signal gtx0_rxenchansync_s    : std_logic;
  signal gtx0_rxchanbondseq_s   : std_logic;
  signal gtx0_rx_system_reset_s : std_logic;
  signal gtx0_matchn_s          : std_logic;
  signal gtx0_error_count_s     : std_logic_vector(7 downto 0);
  signal gtx0_error_count_s_r   : std_logic_vector(7 downto 0);
  
  signal gtx0_txdata_last_s     : std_logic;
  
  signal v8_RxErrorCountDiff_s  : std_logic_vector(7 downto 0);
  signal v8_RxErrorCount_s      : std_logic_vector(7 downto 0);
  
begin


  v6_gtxwizard_v1_12_l : entity work.v6_gtxwizard_v1_12
  generic map
  (
    WRAPPER_SIM_GTXRESET_SPEEDUP    =>      1,

    -- Reference Clock Frequency
    REF_CLK_FREQ                    => REF_CLK_FREQ
  )
  port map
  (
    --_____________________________________________________________________
    --_____________________________________________________________________

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX0_LOOPBACK_IN                => iv3_LoopBack_p,
    GTX0_RXPOWERDOWN_IN             => (others => '0'), -- p.127
    GTX0_TXPOWERDOWN_IN             => (others => '0'), -- p.127
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX0_RXCHARISK_OUT              => gtx0_rxcharisk_s,
    GTX0_RXDISPERR_OUT              => open,
    GTX0_RXNOTINTABLE_OUT           => open,
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX0_RXCHANBONDSEQ_OUT          => gtx0_rxchanbondseq_s,
    GTX0_RXCHBONDI_IN               => (others => '0'),
    GTX0_RXCHBONDLEVEL_IN           => (others => '0'),
    GTX0_RXCHBONDMASTER_IN          => '0',
    GTX0_RXCHBONDO_OUT              => open,
    GTX0_RXCHBONDSLAVE_IN           => '0',
    GTX0_RXENCHANSYNC_IN            => gtx0_rxenchansync_s, -- Channel bonding disabled, p.182
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX0_RXCLKCORCNT_OUT            => open,
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX0_RXBYTEISALIGNED_OUT        => open,
    GTX0_RXBYTEREALIGN_OUT          => open,
    GTX0_RXCOMMADET_OUT             => open,
    GTX0_RXENMCOMMAALIGN_IN         => gtx0_rxenmcommaalign_s, -- p.160
    GTX0_RXENPCOMMAALIGN_IN         => gtx0_rxenpcommaalign_s, -- p.160
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX0_RXDATA_OUT                 => gtx0_rxdata_s,
    GTX0_RXRESET_IN                 => i_RxReset_p, -- p.196
    GTX0_RXUSRCLK2_IN               => i_RxUsrClk2_p, -- p.205
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX0_RXCDRRESET_IN              => '0', -- p.145
    GTX0_RXELECIDLE_OUT             => open,
    GTX0_RXN_IN                     => i_RxN_p,
    GTX0_RXP_IN                     => i_RxP_p,
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX0_RXBUFRESET_IN              => '0', -- p.173
    GTX0_RXBUFSTATUS_OUT            => open,
    GTX0_RXCHANISALIGNED_OUT        => open, -- p.181
    GTX0_RXCHANREALIGN_OUT          => open, -- p.182
    GTX0_RXSTATUS_OUT               => open,
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX0_RXLOSSOFSYNC_OUT           => open,
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX0_GTXRXRESET_IN              => i_Reset_p, -- p.195
    GTX0_MGTREFCLKRX_IN             => i_MgtRefClk_p, -- p.58
    GTX0_PLLRXRESET_IN              => '0', -- p.66
    GTX0_RXPLLLKDET_OUT             => o_RxPllLkDet_p,
    GTX0_RXRATE_IN                  => "00", -- p.145
    GTX0_RXRATEDONE_OUT             => open,
    GTX0_RXRESETDONE_OUT            => RxResetDone_s,
    -------------- Receive Ports - RX Pipe Control for PCI Express -------------
    GTX0_PHYSTATUS_OUT              => open,
    GTX0_RXVALID_OUT                => o_RxValid_p,
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    GTX0_RXPOLARITY_IN              => i_RxPolarity_p,
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX0_TXCHARDISPMODE_IN          => (others => '0'), -- p.85
    GTX0_TXCHARISK_IN               => gtx0_txcharisk_s, -- p.94
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX0_TXDATA_IN(15 downto 1)     => gtx0_txdata_s(15 downto 1), -- p.86
    GTX0_TXDATA_IN(0)               => gtx0_txdata_last_s,
    GTX0_TXOUTCLK_OUT               => o_TxOutClk_p, -- p.104
    GTX0_TXRESET_IN                 => i_TxReset_p, -- p.87
    GTX0_TXUSRCLK2_IN               => i_TxUsrClk2_p, -- p.86
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX0_TXN_OUT                    => o_TxN_p,
    GTX0_TXP_OUT                    => o_TxP_p,
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX0_GTXTXRESET_IN              => i_Reset_p, -- p.87
    GTX0_MGTREFCLKTX_IN             => i_MgtRefClk_p, -- p.58,
    GTX0_PLLTXRESET_IN              => '0', -- p.66
    GTX0_TXPLLLKDET_OUT             => o_TxPllLkDet_p,
    GTX0_TXRATE_IN                  => "00", -- p.116
    GTX0_TXRATEDONE_OUT             => open, -- p.116
    GTX0_TXRESETDONE_OUT            => TxResetDone_s, -- p.87
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX0_TXDEEMPH_IN                => '0', -- p.120
    GTX0_TXDETECTRX_IN              => '0', -- p.127
    GTX0_TXELECIDLE_IN              => '0', -- p.128
    GTX0_TXMARGIN_IN                => (others => '0'), -- p.121
    GTX0_TXPDOWNASYNCH_IN           => '0', -- p.122
    GTX0_TXSWING_IN                 => '0' -- p.123
  );

  
  -- Force an error in the LSB
  gtx0_txdata_last_s <= gtx0_txdata_s(0) xor i_TxPrbsForceErr_p;
  
  -- Reset for the frame generator
  SystemRst_s  <=  (not TxResetDone_s) or i_Reset_p;  

    ------------------------------ Frame Generators ---------------------------
    -- The example design uses Block RAM based frame generators to provide test
    -- data to the GTXs for transmission. By default the frame generators are 
    -- loaded with an incrementing data sequence that includes commas/alignment
    -- characters for alignment. If your protocol uses channel bonding, the 
    -- frame generator will also be preloaded with a channel bonding sequence.
    
    -- You can modify the data transmitted by changing the INIT values of the frame
    -- generator in this file. Pay careful attention to bit order and the spacing
    -- of your control and alignment characters.

    gtx0_frame_gen : entity work.FRAME_GEN
    generic map
    (
        WORDS_IN_BRAM                   =>      EXAMPLE_WORDS_IN_BRAM,
        MEM_00                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_01                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_02                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_03                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_04                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_05                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_06                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_07                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_08                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_09                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_0A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_0B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_0C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_0D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_0E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_0F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_10                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_11                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_12                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_13                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_14                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_15                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_16                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_17                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_18                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_19                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_1A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_1B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_1C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_1D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_1E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_1F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_20                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_21                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_22                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_23                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_24                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_25                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_26                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_27                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_28                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_29                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_2A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_2B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_2C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_2D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_2E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_2F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_30                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_31                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_32                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_33                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_34                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_35                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_36                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_37                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_38                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_39                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_3A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_3B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_3C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_3D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_3E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_3F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEMP_00                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_01                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_02                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_03                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_04                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_05                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_06                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_07                  =>  x"2000000000000000000000000000000000000000000000000000000000000010"
    )
    port map
    (
        -- User Interface
        TX_DATA(39 downto 16)           =>      open,
        TX_DATA(15 downto 0)            =>      gtx0_txdata_s,
 
        TX_CHARISK(3 downto 2)          =>      open,
        TX_CHARISK(1 downto 0)          =>      gtx0_txcharisk_s,
        -- System Interface
        USER_CLK                        =>      i_TxUsrClk2_p,
        SYSTEM_RESET                    =>      SystemRst_s
    );
    


    ---------------------------------- Frame Checkers -------------------------
    -- The example design uses Block RAM based frame checkers to verify incoming  
    -- data. By default the frame generators are loaded with a data sequence that 
    -- matches the outgoing sequence of the frame generators for the TX ports.
    
    -- You can modify the expected data sequence by changing the INIT values of the frame
    -- checkers in this file. Pay careful attention to bit order and the spacing
    -- of your control and alignment characters.
    
    -- When the frame checker receives data, it attempts to synchronise to the 
    -- incoming pattern by looking for the first sequence in the pattern. Once it 
    -- finds the first sequence, it increments through the sequence, and indicates an 
    -- error whenever the next value received does not match the expected value.

    gtx0_rx_system_reset_s <= (not RxResetDone_s) or i_Reset_p;
 
    gtx0_frame_check : entity work.FRAME_CHECK
    generic map
    (
        RX_DATA_WIDTH                   =>      16,
        RXCTRL_WIDTH                    =>      2,
        USE_COMMA                       =>      1,
        CHANBOND_SEQ_LEN                =>      3,
        WORDS_IN_BRAM                   =>      EXAMPLE_WORDS_IN_BRAM,
        CONFIG_INDEPENDENT_LANES        =>      1,
        START_OF_PACKET_CHAR            =>      x"02bc",
        MEM_00                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_01                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_02                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_03                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_04                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_05                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_06                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_07                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_08                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_09                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_0A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_0B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_0C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_0D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_0E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_0F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_10                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_11                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_12                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_13                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_14                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_15                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_16                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_17                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_18                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_19                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_1A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_1B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_1C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_1D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_1E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_1F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_20                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_21                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_22                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_23                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_24                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_25                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_26                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_27                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_28                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_29                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_2A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_2B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_2C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_2D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_2E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_2F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_30                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_31                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_32                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_33                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_34                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_35                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_36                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_37                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEM_38                  =>  x"00000e0d00000c0b00000a09000008070000060500000403000002bc00000100",
        MEM_39                  =>  x"00001e1d00001c1b00001a19000018170000161500001413000012110000100f",
        MEM_3A                  =>  x"00002e2d00002c2b00002a29000028270000262500002423000022210000201f",
        MEM_3B                  =>  x"00003e3d00003c3b00003a39000038370000363500003433000032310000302f",
        MEM_3C                  =>  x"00004e4d00004c4b00004a49000048470000464500004443000042410000403f",
        MEM_3D                  =>  x"00005e5d00005c5b00005a59000058570000565500005453000052510000504f",
        MEM_3E                  =>  x"00006e6d00006c6b00006a69000068670000666500006463000062610000605f",
        MEM_3F                  =>  x"0000bc4a00004a4a00007a79000078770000767500007473000072710000706f",
        MEMP_00                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_01                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_02                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_03                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_04                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_05                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_06                  =>  x"2000000000000000000000000000000000000000000000000000000000000010",
        MEMP_07                  =>  x"2000000000000000000000000000000000000000000000000000000000000010"
    )
    port map
    (
        -- MGT Interface
        RX_DATA                         =>      gtx0_rxdata_s,
		RXCTRL_IN                       =>      gtx0_rxcharisk_s,
        RX_ENMCOMMA_ALIGN               =>      gtx0_rxenmcommaalign_s,
        RX_ENPCOMMA_ALIGN               =>      gtx0_rxenpcommaalign_s,
        RX_ENCHAN_SYNC                  =>      gtx0_rxenchansync_s,
        RX_CHANBOND_SEQ                 =>      gtx0_rxchanbondseq_s,
        -- Control Interface
        INC_IN                          =>      '0',
        INC_OUT                         =>      open,
        PATTERN_MATCH_N                 =>      gtx0_matchn_s,
        RESET_ON_ERROR                  =>      gtx0_matchn_s,
        -- System Interface
        USER_CLK                        =>      i_TxUsrClk2_p,
        SYSTEM_RESET                    =>      gtx0_rx_system_reset_s,
        ERROR_COUNT                     =>      gtx0_error_count_s,
        TRACK_DATA                      =>      open
    );

  -- Process to count errors
  process( i_TxUsrClk2_p )
  begin
    if(i_TxUsrClk2_p'event and i_TxUsrClk2_p = '1') then
      if(i_ResetErrCnt_p = '1' or i_Reset_p = '1')then
        gtx0_error_count_s_r <= gtx0_error_count_s;
        v8_RxErrorCountDiff_s <= (others => '0');
        v8_RxErrorCount_s <= (others => '0');
      else
        gtx0_error_count_s_r <= gtx0_error_count_s;
        v8_RxErrorCountDiff_s <= std_logic_vector( unsigned(gtx0_error_count_s) - unsigned(gtx0_error_count_s_r) );
        v8_RxErrorCount_s <= std_logic_vector( unsigned(v8_RxErrorCount_s) + unsigned(v8_RxErrorCountDiff_s) );
      end if;
    end if;
  end process;
  
  -- Output mapping
  o_TxResetDone_p <= TxResetDone_s;
  o_RxResetDone_p <= RxResetDone_s;
  ov8_RxErrorCount_p <= v8_RxErrorCount_s;

end architecture Beh;