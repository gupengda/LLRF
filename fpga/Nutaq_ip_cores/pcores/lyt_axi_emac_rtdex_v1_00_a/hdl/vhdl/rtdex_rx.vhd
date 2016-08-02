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
--------------------------------------------------------------------------------
-- Notes / Assumptions :
-- Description: RDTEx Rx inferface
-- Khalid Bensadek 
-- 2012/05
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library lyt_axi_emac_rtdex_v1_00_a;
use lyt_axi_emac_rtdex_v1_00_a.rtdex_defines.all;
use lyt_axi_emac_rtdex_v1_00_a.rtdex_pkg.all;

entity rtdex_rx is
   generic(         
          NumberChannels_g 		: integer range 1 to 8 := 1;
          C_RXMEM               : integer := 4096;
          StatsCntrs_g		  	: integer range 0 to 1 := 1;
          FlowCtrlEn_g			: integer range 0 to 1 := 0;
          big_Endian_g			: integer range 0 to 1 := 0
          );
   port(
         -- Config & status signals from/to axi registers --
		 iv8_RxStartNewTransfer_p   : in  std_logic_vector(7 downto 0);
		 ov32_RxBadFrameCnt_p       : out std_logic_vector(31 downto 0);
		 ov32_RxFrameLostCntCh0_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh1_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh2_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh3_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh4_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh5_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh6_p   : out std_logic_vector(31 downto 0);
         ov32_RxFrameLostCntCh7_p   : out std_logic_vector(31 downto 0);
         iv8_RxFifoReset_p          : in  std_logic_vector(7 downto 0);  -- SW Reset/Flush for a given RTDEx RX FIFO
         i_RxReset_p                : in  std_logic;                     -- SW Reset for the whole RTDEx RX component         
         ov32_RxConfigInfo_p        : out std_logic_vector(31 downto 0);
         iv32_RxTimeout2DropFrm_p	: in std_logic_vector(31 downto 0);
         ov32_RcvdFrameCntCh0_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh1_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh2_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh3_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh4_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh5_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh6_p		: out std_logic_vector(31 downto 0);
		 ov32_RcvdFrameCntCh7_p		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh0_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh1_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh2_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh3_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh4_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh5_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh6_p 		: out std_logic_vector(31 downto 0);
		 ov32_RxDropdFrmsCh7_p 		: out std_logic_vector(31 downto 0);
		 ov3_RxErrStatus_p			: out std_logic_vector(2 downto 0);
		 iv15_RxFifoFullThrCh0_p	: in std_logic_vector(14 downto 0);
		 iv15_RxFifoEmptyThrCh0_p	: in std_logic_vector(14 downto 0);
		 ov8_RxFifoUnderrun_p		: out std_logic_vector(7 downto 0);
		 
		 
         --- AXI STR side ---
         RTDEX_RXD_ACLK       : in  std_logic;                          --  AXI-Stream Receive Data Clk    
         RTDEX_RXD_ARESET     : in  std_logic;                          --  AXI-Stream Receive Data Reset  
         RTDEX_RXD_TVALID     : in std_logic;                           --  AXI-Stream Receive Data Valid  
         RTDEX_RXD_TREADY     : out  std_logic;                         --  AXI-Stream Receive Data Ready  
         RTDEX_RXD_TLAST      : in std_logic;                           --  AXI-Stream Receive Data Last   
         RTDEX_RXD_TKEEP      : in std_logic_vector(3 downto 0);        --  AXI-Stream Receive Data Keep   
         V32_RTDEX_RXD_TDATA  : in std_logic_vector(31 downto 0);       --  AXI-Stream Receive Data Data   
                                                                                                            
         RTDEX_RXS_ACLK       : in  std_logic;                          --  AXI-Stream Receive Status Clk  
         RTDEX_RXS_ARESET     : in  std_logic;                          --  AXI-Stream Receive Status Reset
         RTDEX_RXS_TVALID     : in std_logic;                           --  AXI-Stream Receive Status Valid
         RTDEX_RXS_TREADY     : out  std_logic;                         --  AXI-Stream Receive Status Ready
         RTDEX_RXS_TLAST      : in std_logic;                           --  AXI-Stream Receive Status Last 
         RTDEX_RXS_TKEEP      : in std_logic_vector(3 downto 0);        --  AXI-Stream Receive Status Keep 
         V32_RTDEX_RXS_TDATA  : in std_logic_vector(31 downto 0);       --  AXI-Stream Receive Status Data
         
         --
         o_SendPause_p		  : out std_logic;				 
		 ov16_PauseVal_p	  : out std_logic_vector(15 downto 0);
         
         --- User side ---
         i_RxUserClk_p        : in std_logic;
         o_RxReadyCh0_p       : out std_logic;
         i_RxReCh0_p          : in std_logic;
         ov32_RxDataCh0_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh0_p   : out std_logic;
         o_RxReadyCh1_p       : out std_logic;
         i_RxReCh1_p          : in std_logic;
         ov32_RxDataCh1_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh1_p   : out std_logic;
         o_RxReadyCh2_p       : out std_logic;
         i_RxReCh2_p          : in std_logic;
         ov32_RxDataCh2_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh2_p   : out std_logic;
         o_RxReadyCh3_p       : out std_logic;
         i_RxReCh3_p          : in std_logic;
         ov32_RxDataCh3_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh3_p   : out std_logic;
         o_RxReadyCh4_p       : out std_logic;
         i_RxReCh4_p          : in std_logic;
         ov32_RxDataCh4_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh4_p   : out std_logic;
         o_RxReadyCh5_p       : out std_logic;
         i_RxReCh5_p          : in std_logic;
         ov32_RxDataCh5_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh5_p   : out std_logic;
         o_RxReadyCh6_p       : out std_logic;
         i_RxReCh6_p          : in std_logic;
         ov32_RxDataCh6_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh6_p   : out std_logic;
         o_RxReadyCh7_p       : out std_logic;
         i_RxReCh7_p          : in std_logic;
         ov32_RxDataCh7_p     : out std_logic_vector(31 downto 0);
         o_RxDataValidCh7_p   : out std_logic
        );
end rtdex_rx;

architecture rtdex_rx_behav of rtdex_rx is

-- Use to avoid unrelated LUT packing with other components
attribute keep_hierarchy : string;                         
attribute keep_hierarchy of rtdex_rx_behav : architecture is "true";
 
 component rtdex_rx_core
	port(
		RTDEX_RXD_ACLK				: in std_logic;
		V32_RTDEX_RXD_TDATA			: in std_logic_vector(31 downto 0);
		RTDEX_RXD_TKEEP				: in std_logic_vector(3 downto 0);
		RTDEX_RXD_TVALID			: in std_logic;
		RTDEX_RXD_TLAST				: in std_logic;
		RTDEX_RXD_TREADY			: out std_logic;
		i_sysRst_p					: in std_logic;
		--
		iv32_rxtimeout2dropfrm_p	: in std_logic_vector(31 downto 0);
		iv8_RxStartNewTransfer_p	: in std_logic_vector(7 downto 0);		
		oa8u32_FrameNumber_p		: out array8_u32_t;		
		ov8_RxFrameCompleted_p		: out std_logic_vector(7 downto 0);
		o_RtdexBadFrame_p			: out std_logic;
		ov8_RtdexDropedFrame_p		: out std_logic_vector(7 downto 0);
		--
		iv8_ChFifoNotFull_p			: in std_logic_vector(7 downto 0);
		ia8u14_ChFifoFreeSpcae_p	: in array8_u15_t;
		ov8_ChWr_en_p				: out std_logic_vector(7 downto 0);		
		--
		iv8_ProgFull_p				: in std_logic_vector(7 downto 0);		
		o_SendPause_p				: out std_logic;				
		ov16_PauseVal_p				: out std_logic_vector(15 downto 0)
		);
		
 end component;
 

signal a8u32_LostFrameCnt_s     : array8_u32_t;
signal a8u32_RcvdFramesCnt_s    : array8_u32_t;
signal a8u32_FrameNumber_s	  	: array8_u32_t;
signal a8u32_FrmNbrExpected_s   	: array8_u32_t;

signal v8_RxFrameCompleted_s  : std_logic_vector(7 downto 0);
signal v8_ChAlmostFull_s      : std_logic_vector(7 downto 0);
signal v8_underflow_s         : std_logic_vector(7 downto 0);

attribute keep : string;                         
 --attribute keep of v8_progFull_s : signal is "true";
 --attribute keep of v8_progEmpty_s : signal is "true";



signal a8v32_RxChData_s     : array8_v32_t;
signal a8v32_ChFifoDout_s   : array8_v32_t;

signal v8_reset_s             : std_logic_vector(7 downto 0);
signal v8_RxChFifoRst_s       : std_logic_vector(7 downto 0);
signal v8_ChWr_en_s           : std_logic_vector(7 downto 0);
signal v8_RxChRe_s            : std_logic_vector(7 downto 0);
signal v8_ChEmpty_s           : std_logic_vector(7 downto 0);
signal v8_RxChDataValid_s     : std_logic_vector(7 downto 0);
signal v8_ChFifoNotFull_s     : std_logic_vector(7 downto 0);
signal v8_RxChReady_s         : std_logic_vector(7 downto 0);
signal RtdexBadFrame_s        : std_logic;
signal v8_RtdexDropedFrame_s  : std_logic_vector(7 downto 0);

signal v32_RxBadFrameCnt_s    : unsigned(31 downto 0);

signal RxResetDly1_s : std_logic;
signal sysRst_s      : std_logic;

signal a8u32_DropdFramesCnt_s  : array8_u32_t;

signal RxBadFrmErr_s	: std_logic;
signal RxLostFrmErr_s	: std_logic;
signal RxDropdFrmErr_s	: std_logic;
signal v8_FrmLostErr_s : std_logic_vector(7 downto 0);
signal v8_RxDropdFrmErr_s : std_logic_vector(7 downto 0);

signal a8v14_ChFifoWrCnt_s : array8_v15_t; 
signal a8u14_ChFifoFreeSpcae_s : array8_u15_t;

signal StatisticCntEnabled_s	: std_logic;
signal PauseReqSendCapab_s		: std_logic;
signal v6_FifoDepthInfo_s 		: std_logic_vector(5 downto 0);

signal v15_progFullThreshNegate_s,
	   v15_progFullThreshAssert_s		: std_logic_vector(14 downto 0);
	   
signal v8_progFull_s	: std_logic_vector(7 downto 0);	   

--**************************** Constants definition ******************************************
constant SecurityBuffer_c : integer:=4;
constant ChFifoSize_c : unsigned(14 downto 0):= to_unsigned((C_RXMEM - SecurityBuffer_c),15); 
--********************************************************************************************

  -- attribute MAX_FANOUT                  : string;
  -- attribute MAX_FANOUT of v8_RxChRe_s   : signal is "5";
 
begin

	RTDEx_RxCoreMachine : rtdex_rx_core
	port map(
		RTDEX_RXD_ACLK				=> RTDEX_RXD_ACLK		,
		V32_RTDEX_RXD_TDATA			=> V32_RTDEX_RXD_TDATA	,
		RTDEX_RXD_TKEEP				=> RTDEX_RXD_TKEEP		,
		RTDEX_RXD_TVALID			=> RTDEX_RXD_TVALID	    ,
		RTDEX_RXD_TLAST				=> RTDEX_RXD_TLAST		,
		RTDEX_RXD_TREADY			=> RTDEX_RXD_TREADY	   ,
		i_sysRst_p					=> sysRst_s,
		--
		iv32_rxtimeout2dropfrm_p	=> iv32_rxtimeout2dropfrm_p,
		iv8_RxStartNewTransfer_p	=> iv8_RxStartNewTransfer_p,		
		oa8u32_FrameNumber_p		=> a8u32_FrameNumber_s     ,
		ov8_RxFrameCompleted_p		=> v8_RxFrameCompleted_s   ,
		o_RtdexBadFrame_p			=> RtdexBadFrame_s         ,
		ov8_RtdexDropedFrame_p		=> v8_RtdexDropedFrame_s   ,
		--
		iv8_ChFifoNotFull_p			=> v8_ChFifoNotFull_s   ,
		ia8u14_ChFifoFreeSpcae_p	=> a8u14_ChFifoFreeSpcae_s,
		ov8_ChWr_en_p				=> v8_ChWr_en_s,
		iv8_ProgFull_p				=> v8_progFull_s,		
		o_SendPause_p				=> o_SendPause_p,		
		ov16_PauseVal_p				=> ov16_PauseVal_p
		);

 -----------------------------------------------------------------------
 -- Reset handeling
 -----------------------------------------------------------------------
 process(RTDEX_RXD_ACLK)
 begin
   if rising_edge(RTDEX_RXD_ACLK) then
      RxResetDly1_s <= i_RxReset_p;      
   end if;
 end process;

 -- system reset
 sysRst_s <= RTDEX_RXD_ARESET and not(RxResetDly1_s);
 
 FifoFreeSpace_gen: for i in 0 to MaxChannelNb_c - 1 generate 
 	-- FIFO free space (in 4 bytes word) = FIFO size - FIFO Write counte:
 	a8u14_ChFifoFreeSpcae_s(i) <= ChFifoSize_c - unsigned(a8v14_ChFifoWrCnt_s(i));
 end generate FifoFreeSpace_gen;	
   
 -----------------------------------------------------------------------
 --- RTDEx channels FIFO --- 
 -----------------------------------------------------------------------
 ChGen: for i in 0 to (NumberChannels_g - 1) generate   
 
   v8_ChFifoNotFull_s(i)   <= not(v8_ChAlmostFull_s(i));
         
   v8_RxChReady_s(i) <=  not(v8_ChEmpty_s(i));   
      
   Fifo1K: if C_RXMEM = 1024 generate    
      U0_ChanFifo: fifo1k_w32_async_rx
       PORT MAP (
         rst => v8_RxChFifoRst_s(i),
         wr_clk => RTDEX_RXD_ACLK,
         rd_clk => i_RxUserClk_p,
         din => V32_RTDEX_RXD_TDATA,
         wr_en => v8_ChWr_en_s(i),
         rd_en => v8_RxChRe_s(i),
         prog_full_thresh_assert => v15_progFullThreshAssert_s(9 downto 0),
    	 prog_full_thresh_negate => v15_progFullThreshNegate_s(9 downto 0),
         dout => a8v32_ChFifoDout_s(i),
         full => open,
         almost_full => v8_ChAlmostFull_s(i),         
         empty => v8_ChEmpty_s(i),
         valid => v8_RxChDataValid_s(i),
         underflow => v8_underflow_s(i),
         wr_data_count => a8v14_ChFifoWrCnt_s(i)(9 downto 0),
         prog_full => v8_progFull_s(i)
       );
       
       a8v14_ChFifoWrCnt_s(i)(14 downto 10) <= (others=>'0');
       
   end generate Fifo1K;
   
   
   Fifo2K: if C_RXMEM = 2048 generate    
      U0_ChanFifo: fifo2k_w32_async_rx
       PORT MAP (
         rst => v8_RxChFifoRst_s(i),
         wr_clk => RTDEX_RXD_ACLK,
         rd_clk => i_RxUserClk_p,
         din => V32_RTDEX_RXD_TDATA,
         wr_en => v8_ChWr_en_s(i),
         rd_en => v8_RxChRe_s(i),
         prog_full_thresh_assert => v15_progFullThreshAssert_s(10 downto 0),
    	 prog_full_thresh_negate => v15_progFullThreshNegate_s(10 downto 0),
         dout => a8v32_ChFifoDout_s(i),
         full => open,
         almost_full => v8_ChAlmostFull_s(i),         
         empty => v8_ChEmpty_s(i),
         valid => v8_RxChDataValid_s(i),
         underflow => v8_underflow_s(i),
         wr_data_count => a8v14_ChFifoWrCnt_s(i)(10 downto 0),
         prog_full => v8_progFull_s(i)
       );
       
       a8v14_ChFifoWrCnt_s(i)(14 downto 11) <= (others=>'0');
       
   end generate Fifo2K;
   
   Fifo4K: if C_RXMEM = 4096 generate    
      U0_ChanFifo: fifo4k_w32_async_rx
       PORT MAP (
         rst => v8_RxChFifoRst_s(i),
         wr_clk => RTDEX_RXD_ACLK,
         rd_clk => i_RxUserClk_p,
         din => V32_RTDEX_RXD_TDATA,
         wr_en => v8_ChWr_en_s(i),
         rd_en => v8_RxChRe_s(i),
         prog_full_thresh_assert => v15_progFullThreshAssert_s(11 downto 0),
    	 prog_full_thresh_negate => v15_progFullThreshNegate_s(11 downto 0),
         dout => a8v32_ChFifoDout_s(i),
         full => open,
         almost_full => v8_ChAlmostFull_s(i),         
         empty => v8_ChEmpty_s(i),
         valid => v8_RxChDataValid_s(i),
         underflow => v8_underflow_s(i),
         wr_data_count => a8v14_ChFifoWrCnt_s(i)(11 downto 0),
         prog_full => v8_progFull_s(i)
       );
       
       a8v14_ChFifoWrCnt_s(i)(14 downto 12) <= (others=>'0');
       
   end generate Fifo4K;
   
   Fifo8K: if C_RXMEM = 8192 generate    
      U0_ChanFifo: fifo8k_w32_async_rx
       PORT MAP (
         rst => v8_RxChFifoRst_s(i),
         wr_clk => RTDEX_RXD_ACLK,
         rd_clk => i_RxUserClk_p,
         din => V32_RTDEX_RXD_TDATA,
         wr_en => v8_ChWr_en_s(i),
         rd_en => v8_RxChRe_s(i),
         prog_full_thresh_assert => v15_progFullThreshAssert_s(12 downto 0),
		 prog_full_thresh_negate => v15_progFullThreshNegate_s(12 downto 0),
         dout => a8v32_ChFifoDout_s(i),
         full => open,
         almost_full => v8_ChAlmostFull_s(i),         
         empty => v8_ChEmpty_s(i),
         valid => v8_RxChDataValid_s(i),
         underflow => v8_underflow_s(i),
         wr_data_count => a8v14_ChFifoWrCnt_s(i)(12 downto 0),
         prog_full => v8_progFull_s(i)
       );
       
       a8v14_ChFifoWrCnt_s(i)(14 downto 13) <= (others=>'0');
       
   end generate Fifo8K;
 
   Fifo16K: if C_RXMEM = 16384 generate    
      U0_ChanFifo: fifo16k_w32_async_rx
       PORT MAP (
         rst => v8_RxChFifoRst_s(i),
         wr_clk => RTDEX_RXD_ACLK,
         rd_clk => i_RxUserClk_p,
         din => V32_RTDEX_RXD_TDATA,
         wr_en => v8_ChWr_en_s(i),
         rd_en => v8_RxChRe_s(i),
         prog_full_thresh_assert => v15_progFullThreshAssert_s(13 downto 0),
    	 prog_full_thresh_negate => v15_progFullThreshNegate_s(13 downto 0),
         dout => a8v32_ChFifoDout_s(i),
         full => open,
         almost_full => v8_ChAlmostFull_s(i),         
         empty => v8_ChEmpty_s(i),
         valid => v8_RxChDataValid_s(i),
         underflow => v8_underflow_s(i),
         wr_data_count => a8v14_ChFifoWrCnt_s(i)(13 downto 0),
         prog_full => v8_progFull_s(i)
       );
       
      a8v14_ChFifoWrCnt_s(i)(14) <= '0';
      
   end generate Fifo16K;
   
   Fifo32K: if C_RXMEM = 32768 generate    
      U0_ChanFifo: fifo32k_w32_async_rx
       PORT MAP (
         rst => v8_RxChFifoRst_s(i),
         wr_clk => RTDEX_RXD_ACLK,
         rd_clk => i_RxUserClk_p,
         din => V32_RTDEX_RXD_TDATA,
         wr_en => v8_ChWr_en_s(i),
         rd_en => v8_RxChRe_s(i),
         prog_full_thresh_assert => v15_progFullThreshAssert_s,
    	 prog_full_thresh_negate => v15_progFullThreshNegate_s,
         dout => a8v32_ChFifoDout_s(i),
         full => open,
         almost_full => v8_ChAlmostFull_s(i),
         empty => v8_ChEmpty_s(i),
         valid => v8_RxChDataValid_s(i),
         underflow => v8_underflow_s(i),
         wr_data_count => a8v14_ChFifoWrCnt_s(i),
         prog_full => v8_progFull_s(i)    	 
       );
   end generate Fifo32K;
   
   -- Little indian: convenient for pc architecture
	 LittleEndianGen: if big_Endian_g = 0 generate 
	 	a8v32_RxChData_s(i) <= a8v32_ChFifoDout_s(i);
	 end generate LittleEndianGen;
	  
	 -- Big Endian: swape bytes
	 BigEndianGen: if big_Endian_g = 1 generate 
	 	a8v32_RxChData_s(i)(31 downto 24) <= a8v32_ChFifoDout_s(i)(7 downto 0);  
	 	a8v32_RxChData_s(i)(23 downto 16) <= a8v32_ChFifoDout_s(i)(15 downto 8); 
	 	a8v32_RxChData_s(i)(15 downto 8)  <= a8v32_ChFifoDout_s(i)(23 downto 16);
	 	a8v32_RxChData_s(i)(7 downto 0)   <= a8v32_ChFifoDout_s(i)(31 downto 24); 	
	 end generate BigEndianGen;
  
 end generate ChGen;
 
 -----------------------------------------------------------------------
 -- Regs to aid timings
 -----------------------------------------------------------------------
 process(RTDEX_RXD_ACLK)
 begin
 	if rising_edge(RTDEX_RXD_ACLK) then
 		v15_progFullThreshAssert_s <= iv15_RxFifoFullThrCh0_p;
 		v15_progFullThreshNegate_s <= iv15_RxFifoEmptyThrCh0_p;
 	end if;
 end process;		
 
 --*************** Statistic counter gen *******************************--
 IncludeStatCnts_gen :if StatsCntrs_g = 1 generate 
 -----------------------------------------------------------------------
 -- Received Frames counter: counts completed Rxed frames for the host
 -- to know. Reset to 0 when starting new transfer. In case of continous
 -- xfer, the counter will simply wrapp-around. In this case, the host can
 -- still at least check that the counter is moving.
 -----------------------------------------------------------------------  
 RcvdFramesCnt_gen: for i in 0 to (NumberChannels_g - 1) generate
 	process(RTDEX_RXD_ACLK)
	 begin
	 	if rising_edge(RTDEX_RXD_ACLK) then
			if sysRst_s = '0' then
				a8u32_RcvdFramesCnt_s(i) <= (others=>'0');			
			else
				if v8_RxFrameCompleted_s(i) = '1' then
					a8u32_RcvdFramesCnt_s(i) <= a8u32_RcvdFramesCnt_s(i) + 1;
				end if;	
			end if;
		end if;
	 end process;
 end generate RcvdFramesCnt_gen;
 
 -- Tie unused channel's counters to gnd
 UnusedRcvdFramesCnt_CondGen: if NumberChannels_g /= MaxChannelNb_c generate
 	UnusedRcvdFramesCnt_gen: for i in NumberChannels_g to (MaxChannelNb_c-1) generate
 		a8u32_RcvdFramesCnt_s(i) <= (others=>'0');
 	end generate UnusedRcvdFramesCnt_gen;
 end generate UnusedRcvdFramesCnt_CondGen;	
 
 -----------------------------------------------------------------------
 -- Check if a frame was lost: compare the counters, actual with 
 -- expected one.
 -----------------------------------------------------------------------  
 LostFrmCnt_gen: for i in 0 to (NumberChannels_g - 1) generate  
 process(RTDEX_RXD_ACLK)
 begin
   if rising_edge(RTDEX_RXD_ACLK) then
		if sysRst_s = '0' then
		   a8u32_FrmNbrExpected_s(i) <= (others=>'0');
		   a8u32_LostFrameCnt_s(i) 	 <= (others=>'0');
		   v8_FrmLostErr_s(i)  <= '0';
		else
								   
		   if v8_RxFrameCompleted_s(i) = '1' then
		      if (a8u32_FrameNumber_s(i) /= a8u32_FrmNbrExpected_s(i)) then
		         -- Frame lost for the current channel, increment the counter.
		         a8u32_LostFrameCnt_s(i) <= a8u32_LostFrameCnt_s(i) + 1;
		         -- Load Expected counter with the actual received frame number + 1.
		         a8u32_FrmNbrExpected_s(i) <= a8u32_FrameNumber_s(i) + 1;
		         v8_FrmLostErr_s(i)  <= '1';
		      else
		      	   -- Increment for next frame to come
		      	   a8u32_FrmNbrExpected_s(i) <= a8u32_FrmNbrExpected_s(i) + 1;		      	   
		      end if;
		   end if;	
		   	   
		end if;
	end if;
 end process;
 
 end generate LostFrmCnt_gen;	
 
 -- Latched error status bit if Frame Lost in ANY channel
 RxLostFrmErr_s <= or_reduce(v8_FrmLostErr_s);	
  
 -- Tie unused channel's counters to gnd
 UnusedFrameNbCompare_gen_CondGen: if NumberChannels_g /= MaxChannelNb_c generate
 	UnusedFrameNbCompare_gen: for i in NumberChannels_g to (MaxChannelNb_c - 1) generate
 		a8u32_FrmNbrExpected_s(i) <= (others=>'0');
 		a8u32_LostFrameCnt_s(i) <= (others=>'0');
 		v8_FrmLostErr_s(i)  <= '0';
 	end generate UnusedFrameNbCompare_gen;
 end generate UnusedFrameNbCompare_gen_CondGen;
 
 -----------------------------------------------------------------------
 --- Bad Frames counter
 ----------------------------------------------------------------------- 
 process(RTDEX_RXD_ACLK)
 begin
   if rising_edge(RTDEX_RXD_ACLK) then
		if sysRst_s = '0' then
		   v32_RxBadFrameCnt_s <= (others=>'0');
		   RxBadFrmErr_s <= '0';
		else
			   
		   if (RtdexBadFrame_s = '1') then		   
		      v32_RxBadFrameCnt_s <= v32_RxBadFrameCnt_s + 1;
		      RxBadFrmErr_s <= '1';
		   end if;
		   
		end if;
	end if;
 end process;

 -----------------------------------------------------------------------
 -- Droped Frames counter per channel
 -----------------------------------------------------------------------  
 DropedFramesCnt_gen: for i in 0 to (NumberChannels_g - 1) generate
 	process(RTDEX_RXD_ACLK)
	 begin
	 	if rising_edge(RTDEX_RXD_ACLK) then
			if sysRst_s = '0' then
				a8u32_DropdFramesCnt_s(i) <= (others=>'0');			
				v8_RxDropdFrmErr_s(i) <= '0';
			else
				if v8_RtdexDropedFrame_s(i) = '1' then
					a8u32_DropdFramesCnt_s(i) <= a8u32_DropdFramesCnt_s(i) + 1;
					v8_RxDropdFrmErr_s(i) <= '1';
				end if;	
			end if;
		end if;
	 end process;
 end generate DropedFramesCnt_gen;
 
 RxDropdFrmErr_s <= or_reduce(v8_RxDropdFrmErr_s);
 
 -- Tie unused channel's counters to gnd
 UnusedDropedFramesCnt_CondGen: if NumberChannels_g /= MaxChannelNb_c generate
 	UnusedDropedFramesCnt_gen: for i in NumberChannels_g to (MaxChannelNb_c-1) generate
 		a8u32_DropdFramesCnt_s(i) <= (others=>'0');
 		v8_RxDropdFrmErr_s(i) <= '0';
 	end generate UnusedDropedFramesCnt_gen;
 end generate UnusedDropedFramesCnt_CondGen;
  
 end generate IncludeStatCnts_gen;
  
  -- If Stats counters are not included:	 
  NoStatCnts_gen :if StatsCntrs_g = 0 generate
  
  	Loop_gen : for i in 0 to (MaxChannelNb_c - 1) generate  	 
  		a8u32_RcvdFramesCnt_s(i) 	<= x"DEADBEEF";
  		a8u32_LostFrameCnt_s(i)  	<= x"DEADBEEF";
  		a8u32_DropdFramesCnt_s(i)	<= x"DEADBEEF";
  	end generate Loop_gen;	 	  	
  	
	v32_RxBadFrameCnt_s <= x"DEADBEEF";	
	RxLostFrmErr_s 		<= '0';  	
	RxBadFrmErr_s 		<= '0';
	RxDropdFrmErr_s 	<= '0';	 			
	 
 end generate NoStatCnts_gen;
 
 --*************** End Statistic counter gen ******************************--
   
 -----------------------------------------------------------------------
 -- FIFO data info
 ----------------------------------------------------------------------- 
 Fifo1k_gen: if C_RXMEM = 1024 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(1,6));
 end generate Fifo1k_gen;
 
 Fifo2k_gen: if C_RXMEM = 2048 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(2,6));
 end generate Fifo2k_gen;
 
 Fifo4k_gen: if C_RXMEM = 4096 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(4,6));
 end generate Fifo4k_gen;
 
 Fifo8k_gen: if C_RXMEM = 8192 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(8,6));
 end generate Fifo8k_gen;
 
 Fifo16k_gen: if C_RXMEM = 16384 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(16,6));
 end generate Fifo16k_gen;
 
 Fifo32k_gen: if C_RXMEM = 32768 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(32,6));
 end generate Fifo32k_gen;
 
 ---
 NoStatisticCnt_gen: if StatsCntrs_g = 0 generate
 	StatisticCntEnabled_s <= '0';
 end generate NoStatisticCnt_gen;
 
 StatisticCnt_gen: if StatsCntrs_g = 1 generate
 	StatisticCntEnabled_s <= '1';
 end generate StatisticCnt_gen;
 
 NoPauseReq_gen: if FlowCtrlEn_g = 0 generate
 	PauseReqSendCapab_s <= '0';
 end generate NoPauseReq_gen;
 
 PauseReq_gen: if FlowCtrlEn_g = 1 generate
 	PauseReqSendCapab_s <= '1';
 end generate PauseReq_gen;
 -----------------------------------------------------------------------
 --- Output ports ---
 -----------------------------------------------------------------------  
  
 -- Don't care for RXS (Status data), so we set TREADY to 1 & ignore RXS inputs
 RTDEX_RXS_TREADY <= '1'; 
 
 ov32_RxBadFrameCnt_p         <= std_logic_vector(v32_RxBadFrameCnt_s);
 
 ov32_RxFrameLostCntCh0_p     <= std_logic_vector(a8u32_LostFrameCnt_s(0));
 ov32_RxFrameLostCntCh1_p     <= std_logic_vector(a8u32_LostFrameCnt_s(1));
 ov32_RxFrameLostCntCh2_p     <= std_logic_vector(a8u32_LostFrameCnt_s(2));
 ov32_RxFrameLostCntCh3_p     <= std_logic_vector(a8u32_LostFrameCnt_s(3));
 ov32_RxFrameLostCntCh4_p     <= std_logic_vector(a8u32_LostFrameCnt_s(4));
 ov32_RxFrameLostCntCh5_p     <= std_logic_vector(a8u32_LostFrameCnt_s(5));
 ov32_RxFrameLostCntCh6_p     <= std_logic_vector(a8u32_LostFrameCnt_s(6));
 ov32_RxFrameLostCntCh7_p     <= std_logic_vector(a8u32_LostFrameCnt_s(7));
 
 ov32_RxConfigInfo_p          <= x"00000" & PauseReqSendCapab_s & StatisticCntEnabled_s & v6_FifoDepthInfo_s & std_logic_vector(to_unsigned(NumberChannels_g,4));
 
 --- user IOs ---
 v8_RxChFifoRst_s(0) <= i_RxReset_p or iv8_RxFifoReset_p(0);
 v8_RxChFifoRst_s(1) <= i_RxReset_p or iv8_RxFifoReset_p(1);
 v8_RxChFifoRst_s(2) <= i_RxReset_p or iv8_RxFifoReset_p(2);
 v8_RxChFifoRst_s(3) <= i_RxReset_p or iv8_RxFifoReset_p(3);
 v8_RxChFifoRst_s(4) <= i_RxReset_p or iv8_RxFifoReset_p(4);
 v8_RxChFifoRst_s(5) <= i_RxReset_p or iv8_RxFifoReset_p(5);
 v8_RxChFifoRst_s(6) <= i_RxReset_p or iv8_RxFifoReset_p(6);
 v8_RxChFifoRst_s(7) <= i_RxReset_p or iv8_RxFifoReset_p(7);
 
 
 o_RxReadyCh0_p <= v8_RxChReady_s(0);
 o_RxReadyCh1_p <= v8_RxChReady_s(1);
 o_RxReadyCh2_p <= v8_RxChReady_s(2);
 o_RxReadyCh3_p <= v8_RxChReady_s(3);
 o_RxReadyCh4_p <= v8_RxChReady_s(4);
 o_RxReadyCh5_p <= v8_RxChReady_s(5);
 o_RxReadyCh6_p <= v8_RxChReady_s(6);
 o_RxReadyCh7_p <= v8_RxChReady_s(7);
 
     
 v8_RxChRe_s(0) <= i_RxReCh0_p;       
 v8_RxChRe_s(1) <= i_RxReCh1_p;
 v8_RxChRe_s(2) <= i_RxReCh2_p;
 v8_RxChRe_s(3) <= i_RxReCh3_p;
 v8_RxChRe_s(4) <= i_RxReCh4_p;
 v8_RxChRe_s(5) <= i_RxReCh5_p;
 v8_RxChRe_s(6) <= i_RxReCh6_p;
 v8_RxChRe_s(7) <= i_RxReCh7_p;
 
 ov32_RxDataCh0_p <= a8v32_RxChData_s(0); 
 ov32_RxDataCh1_p <= a8v32_RxChData_s(1); 
 ov32_RxDataCh2_p <= a8v32_RxChData_s(2); 
 ov32_RxDataCh3_p <= a8v32_RxChData_s(3); 
 ov32_RxDataCh4_p <= a8v32_RxChData_s(4); 
 ov32_RxDataCh5_p <= a8v32_RxChData_s(5); 
 ov32_RxDataCh6_p <= a8v32_RxChData_s(6); 
 ov32_RxDataCh7_p <= a8v32_RxChData_s(7); 
 
 o_RxDataValidCh0_p <= v8_RxChDataValid_s(0); 
 o_RxDataValidCh1_p <= v8_RxChDataValid_s(1); 
 o_RxDataValidCh2_p <= v8_RxChDataValid_s(2); 
 o_RxDataValidCh3_p <= v8_RxChDataValid_s(3); 
 o_RxDataValidCh4_p <= v8_RxChDataValid_s(4); 
 o_RxDataValidCh5_p <= v8_RxChDataValid_s(5); 
 o_RxDataValidCh6_p <= v8_RxChDataValid_s(6); 
 o_RxDataValidCh7_p <= v8_RxChDataValid_s(7);
 
 ov32_RcvdFrameCntCh0_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(0));
 ov32_RcvdFrameCntCh1_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(1));
 ov32_RcvdFrameCntCh2_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(2));
 ov32_RcvdFrameCntCh3_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(3));
 ov32_RcvdFrameCntCh4_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(4));
 ov32_RcvdFrameCntCh5_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(5));
 ov32_RcvdFrameCntCh6_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(6));
 ov32_RcvdFrameCntCh7_p <= std_logic_vector(a8u32_RcvdFramesCnt_s(7));
 
 ov32_RxDropdFrmsCh0_p <= std_logic_vector(a8u32_DropdFramesCnt_s(0));
 ov32_RxDropdFrmsCh1_p <= std_logic_vector(a8u32_DropdFramesCnt_s(1));
 ov32_RxDropdFrmsCh2_p <= std_logic_vector(a8u32_DropdFramesCnt_s(2));
 ov32_RxDropdFrmsCh3_p <= std_logic_vector(a8u32_DropdFramesCnt_s(3));
 ov32_RxDropdFrmsCh4_p <= std_logic_vector(a8u32_DropdFramesCnt_s(4));
 ov32_RxDropdFrmsCh5_p <= std_logic_vector(a8u32_DropdFramesCnt_s(5));
 ov32_RxDropdFrmsCh6_p <= std_logic_vector(a8u32_DropdFramesCnt_s(6));
 ov32_RxDropdFrmsCh7_p <= std_logic_vector(a8u32_DropdFramesCnt_s(7));
 
 ov3_RxErrStatus_p(0) <= RxBadFrmErr_s;
 ov3_RxErrStatus_p(1) <= RxLostFrmErr_s;
 ov3_RxErrStatus_p(2) <= RxDropdFrmErr_s;
 
 ov8_RxFifoUnderrun_p <= v8_underflow_s;
 
end rtdex_rx_behav;