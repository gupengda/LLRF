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
-- Description: Go from AXI data format to EMAC data format.
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

entity rtdex_tx is
   generic(         
          NumberChannels_g 		: integer range 1 to 8 := 1;
          C_TXMEM          		: integer := 4096;
          SuportJumboFrames_g 	: integer range 0 to 1 := 1;
          StatsCntrs_g		  	: integer range 0 to 1 := 1;
          big_Endian_g			: integer range 0 to 1 := 0
          );
   port(
         -- config & status signals from/to axi registers --
         iv32_RemoteEndMacAddrH_p 	: in  std_logic_vector(31 downto 0); 
         iv16_RemoteEndMacAddrL_p 	: in  std_logic_vector(15 downto 0); 		   
         iv32_LocalEndMacAddrH_p 	: in  std_logic_vector(31 downto 0); 
         iv16_LocalEndMacAddrL_p 	: in  std_logic_vector(15 downto 0);         
         ov32_TxConfigInfo_p     	: out std_logic_vector(31 downto 0);
         i_Mode_p					: in std_logic;
         iv8_TxChFrsBurst_p			: in std_logic_vector(7 downto 0);
                           
         iv15_FrameSizeCh0_p 		: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh0_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh1_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh1_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh2_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh2_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh3_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh3_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh4_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh4_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh5_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh5_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh6_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh6_p   	: in std_logic_vector(31 downto 0);
         
         iv15_FrameSizeCh7_p      	: in std_logic_vector(14 downto 0);
         iv32_TransferSizeCh7_p   	: in std_logic_vector(31 downto 0);
         
         i_TxReset_p             	: in  std_logic;
         iv8_TxFifoReset_p       	: in  std_logic_vector(7 downto 0);      
         iv32_FrameGap_p         	: in std_logic_vector(31 downto 0);         
         iv8_StartNewTransfer_p  	: in  std_logic_vector(7 downto 0);
         ov8_TxFifoOverrun_p		: out  std_logic_vector(7 downto 0);
		
         --- AXI STR side ---         
         RTDEX_STR_TXD_ACLK      : in  std_logic;                               
         RTDEX_STR_TXD_ARESETN   : in  std_logic;                           
         RTDEX_STR_TXD_TVALID    : out  std_logic;                          
         RTDEX_STR_TXD_TREADY    : in std_logic;                            
         RTDEX_STR_TXD_TLAST     : out  std_logic;                          
         RTDEX_STR_TXD_TKEEP     : out  std_logic_vector(3 downto 0);       
         RTDEX_STR_TXD_TDATA     : out  std_logic_vector(31 downto 0);      
         
         RTDEX_STR_TXC_ACLK      : in  std_logic;                           
         RTDEX_STR_TXC_ARESETN   : in  std_logic;                           
         RTDEX_STR_TXC_TVALID    : out  std_logic;                          
         RTDEX_STR_TXC_TREADY    : in std_logic;                            
         RTDEX_STR_TXC_TLAST     : out  std_logic;                          
         RTDEX_STR_TXC_TKEEP     : out  std_logic_vector(3 downto 0);       
         RTDEX_STR_TXC_TDATA     : out  std_logic_vector(31 downto 0);      
         
         --- User side ---
         i_TxUserClk_p           : in std_logic;
         
         i_TxWeCh0_p             : in std_logic;
         o_TxReadyCh0_p          : out std_logic;
         iv32_TxDataCh0_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh0_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh0_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh1_p             : in std_logic;
         o_TxReadyCh1_p          : out std_logic;
         iv32_TxDataCh1_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh1_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh1_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh2_p             : in std_logic;
         o_TxReadyCh2_p          : out std_logic;
         iv32_TxDataCh2_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh2_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh2_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh3_p             : in std_logic;
         o_TxReadyCh3_p          : out std_logic;
         iv32_TxDataCh3_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh3_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh3_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh4_p             : in std_logic;
         o_TxReadyCh4_p          : out std_logic;
         iv32_TxDataCh4_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh4_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh4_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh5_p             : in std_logic;
         o_TxReadyCh5_p          : out std_logic;
         iv32_TxDataCh5_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh5_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh5_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh6_p             : in std_logic;
         o_TxReadyCh6_p          : out std_logic;
         iv32_TxDataCh6_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh6_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh6_p : out std_logic_vector(31 downto 0);
         
         i_TxWeCh7_p             : in std_logic;
         o_TxReadyCh7_p          : out std_logic;
         iv32_TxDataCh7_p        : in std_logic_vector(31 downto 0);
         ov32_TxFifoCountCh7_p   : out std_logic_vector(31 downto 0);
         ov32_NbrSentFramesCh7_p : out std_logic_vector(31 downto 0)
        );
end rtdex_tx;

architecture rtdex_tx_behav of rtdex_tx is

-- Use to avoid unrelated LUT packing with other components
attribute keep_hierarchy : string;                         
attribute keep_hierarchy of rtdex_tx_behav : architecture is "true";
 
 
  
signal TxdRxResetDly1_s : std_logic;
signal TxcRxResetDly1_s : std_logic;
signal SysRstn_s      : std_logic;

signal RtdexTxd_tvalid_s    : std_logic;  
signal RtdexTxd_tlast_s     : std_logic; 
signal v4_RtdexTxd_tkeep_s  : std_logic_vector(3 downto 0);
signal v32_RtdexTxd_tdata_s : std_logic_vector(31 downto 0);

signal RtdexTxc_tvalid_s    : std_logic;  
signal RtdexTxc_tlast_s     : std_logic; 
signal v4_RtdexTxc_tkeep_s  : std_logic_vector(3 downto 0);
signal v32_RtdexTxc_tdata_s : std_logic_vector(31 downto 0);

signal CurrentCh_s            : integer range 0 to 7;

signal v32_XferSizeCnt_s      : array8_u32_t;
signal a8_u32_SentFramesCnt_s : array8_u32_t;

signal v8_StartNewTransferDly1_s : std_logic_vector(7 downto 0);
signal v8_StartNewTransferDly2_s : std_logic_vector(7 downto 0);
signal v8_StartNewXfer_s : std_logic_vector(7 downto 0);

signal v8_gotEnoughDataToSend_s  : std_logic_vector(7 downto 0);

signal a8v16_RdDataCnt_s      : array8_v16_t;
signal a8v16_TxFifoCount_s    : array8_v16_t;

signal a8v15_FrameSize_s      : array8_v15_t;

signal a8v32_TransferSize_s      : array8_v32_t;
signal a8v32_TxDataCh_s          : array8_v32_t;
signal a8v32_TxDataChD1_s        : array8_v32_t;
signal a8v32_ChFifoDout_s       : array8_v32_t;
signal a8v32_RtdexChData_s       : array8_v32_t;

signal v8_TxWe_s        : std_logic_vector(7 downto 0);
signal v8_TxWeD1_s      : std_logic_vector(7 downto 0);
signal v8_TxReady_s     : std_logic_vector(7 downto 0);
signal v8_ChFifoaFull_s : std_logic_vector(7 downto 0);
signal v8_ChFifoRst_s   : std_logic_vector(7 downto 0);
signal v8_Txdata_Rd_s   : std_logic_vector(7 downto 0);
signal v8_Rd_en_s       : std_logic_vector(7 downto 0);
signal v8_ChFifoempty_s : std_logic_vector(7 downto 0);

signal v8_CurntChXferDone_s   : std_logic_vector(7 downto 0);

signal v8_ActiveChannel_s : std_logic_vector(7 downto 0);
signal v8_ChReq_s : std_logic_vector(7 downto 0);

signal TxcRstn_s : std_logic;
signal GoToNextChan_s : std_logic;

signal v8_LoadTxSentFrmCnt_s : std_logic_vector(7 downto 0);

signal v16_EtherType_s : std_logic_vector(15 downto 0);

signal StatisticCntEnabled_s	: std_logic;
signal v6_FifoDepthInfo_s 		: std_logic_vector(5 downto 0);

signal v8_overflow_s : std_logic_vector(7 downto 0);

component rrarbiter
	generic ( CNT : integer := 7 );
	port (
	clk            : in    std_logic;
	rst_n          : in    std_logic;

	req            : in    std_logic_vector(CNT-1 downto 0);
	ack            : in    std_logic;
	grant          : out   std_logic_vector(CNT-1 downto 0)
	);
end component;

component rtdex_tx_core
 	port(
 	RTDEX_STR_TXC_ACLK			: in std_logic; 
 	RTDEX_STR_TXC_TREADY		: in std_logic;
 	RTDEX_STR_TXD_ACLK			: in std_logic; 
 	RTDEX_STR_TXD_TREADY 		: in std_logic; 
 	i_TxcRstn_p					: in std_logic;
 	i_SysRstn_p					: in std_logic;
 	--
 	iv32_RemoteEndMacAddrH_p 	: in  std_logic_vector(31 downto 0); 
    iv16_RemoteEndMacAddrL_p 	: in  std_logic_vector(15 downto 0); 		   
    iv32_LocalEndMacAddrH_p 	: in  std_logic_vector(31 downto 0); 
    iv16_LocalEndMacAddrL_p 	: in  std_logic_vector(15 downto 0);    
 	ia8v15_FrameSize_p			: in array8_v15_t;
 	ia8v32_TransferSize_p		: in array8_v32_t;
 	iv8_TxChFrsBurst_p			: in std_logic_vector(7 downto 0);
 	iv32_FrameGap_p				: in std_logic_vector(31 downto 0);  
 	i_Mode_p					: in  std_logic; 	
 	iv16_EtherType_p			: in std_logic_vector(15 downto 0);  
 	iv8_ActiveChannel_p			: in std_logic_vector(7 downto 0);
 	iv8_gotEnoughDataToSend_p	: in std_logic_vector(7 downto 0);
 	--
 	ov32_RtdexTxc_tdata_p		: out std_logic_vector(31 downto 0);
 	o_RtdexTxc_tvalid_p			: out std_logic; 	
 	o_RtdexTxc_tlast_p			: out std_logic;
 	ov4_RtdexTxc_tkeep_p		: out std_logic_vector(3 downto 0); 	
 	ov32_RtdexTxd_tdata_p		: out std_logic_vector(31 downto 0);
 	o_RtdexTxd_tvalid_p  		: out std_logic;
 	o_RtdexTxd_tlast_p   		: out std_logic;
 	ov4_RtdexTxd_tkeep_p 		: out std_logic_vector(3 downto 0);
 	--
 	iv8_StartNewTransfer_p		: in  std_logic_vector(7 downto 0);
 	o_CurrentCh_p				: out integer range 0 to 7;
 	o_GoToNextChan_p			: out std_logic;
 	ov8_Txdata_Rd_p				: out std_logic_vector(7 downto 0);
 	ia8v32_RtdexChData_p		: in array8_v32_t;
 	oa8u32_XferSizeCnt_p		: out array8_u32_t;
 	ov8_CurntChXferDone_p		: out std_logic_vector(7 downto 0);
 	ov8_LoadTxSentFrmCnt_p		: out std_logic_vector(7 downto 0)
 	
 	); 
end component;


begin

 -----------------------------------------------------------------------
 --- Input ports mapping ---                                                     
 ----------------------------------------------------------------------- 
   
 a8v15_FrameSize_s(0)      <= iv15_FrameSizeCh0_p;   
 a8v15_FrameSize_s(1)      <= iv15_FrameSizeCh1_p;   
 a8v15_FrameSize_s(2)      <= iv15_FrameSizeCh2_p;   
 a8v15_FrameSize_s(3)      <= iv15_FrameSizeCh3_p;   
 a8v15_FrameSize_s(4)      <= iv15_FrameSizeCh4_p;   
 a8v15_FrameSize_s(5)      <= iv15_FrameSizeCh5_p;   
 a8v15_FrameSize_s(6)      <= iv15_FrameSizeCh6_p;   
 a8v15_FrameSize_s(7)      <= iv15_FrameSizeCh7_p;   
                                                             
 a8v32_TransferSize_s(0)   <= iv32_TransferSizeCh0_p;
 a8v32_TransferSize_s(1)   <= iv32_TransferSizeCh1_p;
 a8v32_TransferSize_s(2)   <= iv32_TransferSizeCh2_p;
 a8v32_TransferSize_s(3)   <= iv32_TransferSizeCh3_p;
 a8v32_TransferSize_s(4)   <= iv32_TransferSizeCh4_p;
 a8v32_TransferSize_s(5)   <= iv32_TransferSizeCh5_p;
 a8v32_TransferSize_s(6)   <= iv32_TransferSizeCh6_p;
 a8v32_TransferSize_s(7)   <= iv32_TransferSizeCh7_p;
   
 o_TxReadyCh0_p           <= v8_TxReady_s(0);
 o_TxReadyCh1_p           <= v8_TxReady_s(1);
 o_TxReadyCh2_p           <= v8_TxReady_s(2);
 o_TxReadyCh3_p           <= v8_TxReady_s(3);
 o_TxReadyCh4_p           <= v8_TxReady_s(4);
 o_TxReadyCh5_p           <= v8_TxReady_s(5);
 o_TxReadyCh6_p           <= v8_TxReady_s(6);
 o_TxReadyCh7_p           <= v8_TxReady_s(7);
 
 -----------------------------------------------------------------------
 -- This is to help timings in big FPGA. It helps to avoid getting 70% + 
 -- routing delay. The FIFO prog full constant threshold is 4 word bellow
 --  FIFO's real full threshold (It's safe to do that). 
 -----------------------------------------------------------------------
 process(i_TxUserClk_p)
 begin
 	if rising_edge(i_TxUserClk_p) then
    if i_TxReset_p = '1' then
      a8v32_TxDataCh_s(0)       <= (others => '0');
      a8v32_TxDataCh_s(1)       <= (others => '0');
      a8v32_TxDataCh_s(2)       <= (others => '0');
      a8v32_TxDataCh_s(3)       <= (others => '0');
      a8v32_TxDataCh_s(4)       <= (others => '0');
      a8v32_TxDataCh_s(5)       <= (others => '0');
      a8v32_TxDataCh_s(6)       <= (others => '0');
      a8v32_TxDataCh_s(7)       <= (others => '0');
      a8v32_TxDataChD1_s(0)     <= (others => '0');
      a8v32_TxDataChD1_s(1)     <= (others => '0');
      a8v32_TxDataChD1_s(2)     <= (others => '0');
      a8v32_TxDataChD1_s(3)     <= (others => '0');
      a8v32_TxDataChD1_s(4)     <= (others => '0');
      a8v32_TxDataChD1_s(5)     <= (others => '0');
      a8v32_TxDataChD1_s(6)     <= (others => '0');
      a8v32_TxDataChD1_s(7)     <= (others => '0');
      
      v8_TxWe_s                 <= (others => '0');
      v8_TxWeD1_s               <= (others => '0');
    
    else
      a8v32_TxDataCh_s(0)       <= iv32_TxDataCh0_p;
      a8v32_TxDataCh_s(1)       <= iv32_TxDataCh1_p;
      a8v32_TxDataCh_s(2)       <= iv32_TxDataCh2_p;
      a8v32_TxDataCh_s(3)       <= iv32_TxDataCh3_p;
      a8v32_TxDataCh_s(4)       <= iv32_TxDataCh4_p;
      a8v32_TxDataCh_s(5)       <= iv32_TxDataCh5_p;
      a8v32_TxDataCh_s(6)       <= iv32_TxDataCh6_p;
      a8v32_TxDataCh_s(7)       <= iv32_TxDataCh7_p;
      a8v32_TxDataChD1_s        <= a8v32_TxDataCh_s;
   
      v8_TxWe_s(0)              <= i_TxWeCh0_p;
      v8_TxWe_s(1)              <= i_TxWeCh1_p;
      v8_TxWe_s(2)              <= i_TxWeCh2_p;
      v8_TxWe_s(3)              <= i_TxWeCh3_p;
      v8_TxWe_s(4)              <= i_TxWeCh4_p;
      v8_TxWe_s(5)              <= i_TxWeCh5_p;
      v8_TxWe_s(6)              <= i_TxWeCh6_p;
      v8_TxWe_s(7)              <= i_TxWeCh7_p;
      v8_TxWeD1_s               <= v8_TxWe_s;
    end if;
 	end if;
 end process;		
 
 
 process(i_TxUserClk_p)
   begin
   	if rising_edge(i_TxUserClk_p) then
   		v8_TxReady_s <= not(v8_ChFifoaFull_s);     
   	end if;
 end process;
      
 -----------------------------------------------------------------------
 -- Output ports --
 -----------------------------------------------------------------------
 RTDEX_STR_TXD_TVALID <= RtdexTxd_tvalid_s;
 RTDEX_STR_TXD_TLAST  <= RtdexTxd_tlast_s;
 RTDEX_STR_TXD_TKEEP  <= v4_RtdexTxd_tkeep_s;
 
 -- Data is byte swapped --
 RTDEX_STR_TXD_TDATA(31 downto 24)  <= v32_RtdexTxd_tdata_s(7 downto 0);
 RTDEX_STR_TXD_TDATA(23 downto 16)  <= v32_RtdexTxd_tdata_s(15 downto 8);
 RTDEX_STR_TXD_TDATA(15 downto 8)   <= v32_RtdexTxd_tdata_s(23 downto 16);
 RTDEX_STR_TXD_TDATA(7 downto 0)    <= v32_RtdexTxd_tdata_s(31 downto 24);
 
 RTDEX_STR_TXC_TVALID <= RtdexTxc_tvalid_s;
 RTDEX_STR_TXC_TLAST  <= RtdexTxc_tlast_s;
 RTDEX_STR_TXC_TKEEP  <= v4_RtdexTxc_tkeep_s;
 RTDEX_STR_TXC_TDATA  <= v32_RtdexTxc_tdata_s;
 
 ov32_TxConfigInfo_p       <= x"00000" & '0' & StatisticCntEnabled_s & v6_FifoDepthInfo_s & std_logic_vector(to_unsigned(NumberChannels_g,4));
   
 ov32_NbrSentFramesCh0_p <= std_logic_vector(a8_u32_SentFramesCnt_s(0));
 ov32_NbrSentFramesCh1_p <= std_logic_vector(a8_u32_SentFramesCnt_s(1));
 ov32_NbrSentFramesCh2_p <= std_logic_vector(a8_u32_SentFramesCnt_s(2));
 ov32_NbrSentFramesCh3_p <= std_logic_vector(a8_u32_SentFramesCnt_s(3));
 ov32_NbrSentFramesCh4_p <= std_logic_vector(a8_u32_SentFramesCnt_s(4));
 ov32_NbrSentFramesCh5_p <= std_logic_vector(a8_u32_SentFramesCnt_s(5));
 ov32_NbrSentFramesCh6_p <= std_logic_vector(a8_u32_SentFramesCnt_s(6));
 ov32_NbrSentFramesCh7_p <= std_logic_vector(a8_u32_SentFramesCnt_s(7));
 
 ov8_TxFifoOverrun_p <= v8_overflow_s;
   
 -----------------------------------------------------------------------
 -- Reset sampling.
 -----------------------------------------------------------------------
 -- TXD reset
 process(RTDEX_STR_TXD_ACLK)
 begin
   if rising_edge(RTDEX_STR_TXD_ACLK) then
      TxdRxResetDly1_s <= i_TxReset_p;      
   end if;
 end process; 
 SysRstn_s <= RTDEX_STR_TXD_ARESETN and not(TxdRxResetDly1_s);
 
 -- TXC reset
 process(RTDEX_STR_TXC_ACLK)
 begin
   if rising_edge(RTDEX_STR_TXC_ACLK) then
      TxcRxResetDly1_s <= i_TxReset_p;      
   end if;
 end process; 
 TxcRstn_s <= RTDEX_STR_TXC_ARESETN and not(TxcRxResetDly1_s);
 
 -----------------------------------------------------------------------
 -- Support jumbo frame
 ----------------------------------------------------------------------- 
 JumboFrm_gen: if SuportJumboFrames_g = 1 generate
 	process(RTDEX_STR_TXD_ACLK)
 	begin
   		if rising_edge(RTDEX_STR_TXD_ACLK) then
   			if a8v15_FrameSize_s(CurrentCh_s) > JumboFramesMinSize_c then
   				v16_EtherType_s <= v16_JumboFrmType_c;
   			else
   				--v16_EtherType_s <= v16_RegFrmType_c;	
   				v16_EtherType_s <= std_logic_vector( unsigned('0' & a8v15_FrameSize_s(CurrentCh_s)) + unsigned(v16_SubHeaderSize_s));
   			end if;      		
   		end if;
 	end process; 
 end generate JumboFrm_gen;
 
 RegFrm_gen: if SuportJumboFrames_g = 0 generate
 	v16_EtherType_s <= std_logic_vector( unsigned('0' & a8v15_FrameSize_s(CurrentCh_s)) + unsigned(v16_SubHeaderSize_s));
 end generate RegFrm_gen;
 -----------------------------------------------------------------------
 -- Rising edge detector on Tx start new transfer signal
 -----------------------------------------------------------------------
 process(RTDEX_STR_TXC_ACLK)
 begin
   if rising_edge(RTDEX_STR_TXC_ACLK) then
      v8_StartNewTransferDly1_s <= iv8_StartNewTransfer_p;
      v8_StartNewTransferDly2_s <= v8_StartNewTransferDly1_s;      
   end if;
 end process;  
 v8_StartNewXfer_s <= not(v8_StartNewTransferDly2_s) and v8_StartNewTransferDly1_s;
 
 -----------------------------------------------------------------------
 -- Latch Tx start new transfer signal depending on the TX mode
 -----------------------------------------------------------------------
 process(RTDEX_STR_TXC_ACLK)
 begin
   if rising_edge(RTDEX_STR_TXC_ACLK) then
      if TxcRstn_s = '0' then
         v8_ChReq_s <= (others=>'0');         
      else
      
       	case i_Mode_p is
       	
       		when SingleMode_c =>
      			for i in 0 to (NumberChannels_g - 1) loop
      			
      				-- Set signal
      				if v8_StartNewXfer_s(i) = '1' then 
      					v8_ChReq_s(i) <= '1';      					
      				end if;	
      				
      				-- Clear signal
      				if V8_CurntChXferDone_s(i) = '1' then 
      					v8_ChReq_s(i) <= '0';      					
      				end if;	
      				
      			end loop;	
      			
      		when ContinuousMode_c =>
      			v8_ChReq_s <= v8_StartNewTransferDly1_s;
      			      			
      		when others=> null;	-- Impossible to get here.
      			      			
      	end case;		
      end if;	
   end if;
 end process;  
 
 -----------------------------------------------------------------------
 -- Check if there is enough data in the channel FIFO to start RTDEx
 -- ethernet frame transfer. Must have at least one complete frame
 -----------------------------------------------------------------------
 ChekFifoData_gen: for i in 0 to (NumberChannels_g - 1) generate 
 
    Process(RTDEX_STR_TXD_ACLK)
    begin
      if rising_edge(RTDEX_STR_TXD_ACLK) then
         if SysRstn_s = '0' then  
            v8_gotEnoughDataToSend_s(i)<= '0';
         else
         
            -- Frame size is in byte & we send 4 bytes at a time, so divide by 4 (Left-shift by 2)
            if (v8_StartNewTransferDly1_s(i) = '1' and (a8v16_RdDataCnt_s(i) >= ("000" & a8v15_FrameSize_s(i)(14 downto 2)))) then
               v8_gotEnoughDataToSend_s(i) <= '1';
            else
               v8_gotEnoughDataToSend_s(i) <= '0';   
            end if;
            
        end if; 
      end if;
    end process;
 
 end generate ChekFifoData_gen;
 
 -- Tie unused channel's counters to gnd
 UnusedEnghDataTosend_CondGen: if NumberChannels_g /= MaxChannelNb_c generate
 	UnusedEnghDataTosend_Gen: for i in NumberChannels_g to (MaxChannelNb_c-1) generate
 		v8_gotEnoughDataToSend_s(i) <= '0';
 	end generate UnusedEnghDataTosend_Gen;
 end generate UnusedEnghDataTosend_CondGen;
 
 
 --*************** Statistic counter gen *******************************--
 IncludeStatCnts_gen :if StatsCntrs_g = 1 generate  
 -----------------------------------------------------------------------
 -- Number of Sent Frames Counters
 -----------------------------------------------------------------------
 SentFramesCnt_gen: for i in 0 to (NumberChannels_g - 1) generate 
 	process(RTDEX_STR_TXC_ACLK)
	 begin
	 	if rising_edge(RTDEX_STR_TXC_ACLK) then
	 		if TxcRstn_s = '0' then
	 			a8_u32_SentFramesCnt_s(i) <= (others=>'0');
	 		else	 			
	 			if v8_LoadTxSentFrmCnt_s(i) = '1' then	 			
	 				a8_u32_SentFramesCnt_s(i) <= v32_XferSizeCnt_s(i);
	 			end if;	
	 			
	 		end if;
	 	end if;	 
	 end process;
 end generate SentFramesCnt_gen;	 	
 
 -- Tie unused channel's counters to gnd
 UnusedSentFrmsCnt_CondGen: if NumberChannels_g /= MaxChannelNb_c generate
 	UnusedSentFrmsCnt_Gen: for i in NumberChannels_g to (MaxChannelNb_c-1) generate
 		a8_u32_SentFramesCnt_s(i) <= (others=>'0');
 	end generate UnusedSentFrmsCnt_Gen;
 end generate UnusedSentFrmsCnt_CondGen;
 
 -----------------------------------------------------------------------
 -- Number of bytes remaining in TX FIFO
 -- Actual Tx Channel FIFO data count in byte, we left-shift bye 2 to get x4
 ----------------------------------------------------------------------- 
 ov32_TxFifoCountCh0_p <= x"000" & "00" & a8v16_TxFifoCount_s(0) & "00";
 ov32_TxFifoCountCh1_p <= x"000" & "00" & a8v16_TxFifoCount_s(1) & "00";
 ov32_TxFifoCountCh2_p <= x"000" & "00" & a8v16_TxFifoCount_s(2) & "00";
 ov32_TxFifoCountCh3_p <= x"000" & "00" & a8v16_TxFifoCount_s(3) & "00";
 ov32_TxFifoCountCh4_p <= x"000" & "00" & a8v16_TxFifoCount_s(4) & "00";
 ov32_TxFifoCountCh5_p <= x"000" & "00" & a8v16_TxFifoCount_s(5) & "00";
 ov32_TxFifoCountCh6_p <= x"000" & "00" & a8v16_TxFifoCount_s(6) & "00";
 ov32_TxFifoCountCh7_p <= x"000" & "00" & a8v16_TxFifoCount_s(7) & "00";	
 
 end generate IncludeStatCnts_gen;
 
 -- If Stats counters are not included:	 
  NoStatCnts_gen :if StatsCntrs_g = 0 generate
  
  	Loop_gen: for i in 0 to (NumberChannels_g - 1) generate 
  		a8_u32_SentFramesCnt_s(i) <= x"DEADBEEF";  
  	end generate Loop_gen;	
  	
  	ov32_TxFifoCountCh0_p <= x"DEADBEEF";
	ov32_TxFifoCountCh1_p <= x"DEADBEEF";
	ov32_TxFifoCountCh2_p <= x"DEADBEEF";
	ov32_TxFifoCountCh3_p <= x"DEADBEEF";
	ov32_TxFifoCountCh4_p <= x"DEADBEEF";
	ov32_TxFifoCountCh5_p <= x"DEADBEEF";
	ov32_TxFifoCountCh6_p <= x"DEADBEEF";
	ov32_TxFifoCountCh7_p <= x"DEADBEEF";
  	                                                                            	
  end generate NoStatCnts_gen;                                                  
  --*************** End Statistic counter gen ******************************--
  
 -----------------------------------------------------------------------
 -- Channels Round Robin ARbiter needed for multi-channel Tx
 -----------------------------------------------------------------------
 RoundRobinArb_i0: rrarbiter
	generic map( CNT => NumberChannels_g )
	port map(
	clk            => RTDEX_STR_TXC_ACLK,
	rst_n          => TxcRstn_s,

	req            => v8_ChReq_s(NumberChannels_g-1 downto 0),
	ack            => GoToNextChan_s,
	grant          => v8_ActiveChannel_s(NumberChannels_g-1 downto 0)
	);

 
 -----------------------------------------------------------------------
 -- RTDEx TX Core Machine instance
 -----------------------------------------------------------------------
 RTDEx_TxCoreMachine : rtdex_tx_core
 	port map
 		(
 		RTDEX_STR_TXC_ACLK			=> RTDEX_STR_TXC_ACLK	,
 		RTDEX_STR_TXC_TREADY		=> RTDEX_STR_TXC_TREADY	,
 		RTDEX_STR_TXD_ACLK			=> RTDEX_STR_TXD_ACLK   ,
 		RTDEX_STR_TXD_TREADY		=> RTDEX_STR_TXD_TREADY ,
 		i_TxcRstn_p					=> TxcRstn_s            ,
 		i_sysrstn_p					=> SysRstn_s 		    ,
 		--
 		iv32_RemoteEndMacAddrH_p	=> iv32_RemoteEndMacAddrH_p,
 		iv16_RemoteEndMacAddrL_p	=> iv16_RemoteEndMacAddrL_p,
 		iv32_LocalEndMacAddrH_p		=> iv32_LocalEndMacAddrH_p , 
 		iv16_LocalEndMacAddrL_p		=> iv16_LocalEndMacAddrL_p ,
 		ia8v15_FrameSize_p			=> a8v15_FrameSize_s       ,
 		ia8v32_TransferSize_p		=> a8v32_TransferSize_s    ,
 		iv8_TxChFrsBurst_p			=> iv8_TxChFrsBurst_p      ,
 		iv32_FrameGap_p				=> iv32_FrameGap_p         ,
 		i_Mode_p					=> i_Mode_p 		       ,
 		iv16_EtherType_p			=> v16_EtherType_s		   ,
 		iv8_ActiveChannel_p			=> v8_ActiveChannel_s      ,
 		iv8_gotEnoughDataToSend_p	=> v8_gotEnoughDataToSend_s,
 		--
 		ov32_RtdexTxc_tdata_p		=> v32_RtdexTxc_tdata_s,
 		o_RtdexTxc_tvalid_p			=> RtdexTxc_tvalid_s ,		
 		o_RtdexTxc_tlast_p			=> RtdexTxc_tlast_s    ,
 		ov4_RtdexTxc_tkeep_p		=> v4_RtdexTxc_tkeep_s ,
 		ov32_RtdexTxd_tdata_p		=> v32_RtdexTxd_tdata_s,
 		o_RtdexTxd_tvalid_p  		=> RtdexTxd_tvalid_s   ,
 		o_RtdexTxd_tlast_p   		=> RtdexTxd_tlast_s    ,
 		ov4_RtdexTxd_tkeep_p 		=> v4_RtdexTxd_tkeep_s ,
 		--
 		iv8_StartNewTransfer_p		=> v8_StartNewTransferDly1_s,
 		o_CurrentCh_p				=> CurrentCh_s              ,
 		o_GoToNextChan_p			=> GoToNextChan_s           ,
 		ov8_Txdata_Rd_p				=> v8_Txdata_Rd_s           ,
 		ia8v32_RtdexChData_p		=> a8v32_RtdexChData_s		,
 		oa8u32_XferSizeCnt_p		=> v32_XferSizeCnt_s        ,
 		ov8_CurntChXferDone_p		=> v8_CurntChXferDone_s     ,
 		ov8_LoadTxSentFrmCnt_p		=> v8_LoadTxSentFrmCnt_s     		
 		);
 
   
 ---------------------------------------------------------------------------
 -- RTDEx channels FIFO --- 
 -- prog full threshold constant = FIFO_size - 4 words. This gives a 
 -- security space to avoid overruns. User can react late safly at fifo full.
 ---------------------------------------------------------------------------  
 ChFifo_gen: FOR i IN 0 TO (NumberChannels_g - 1) GENERATE
 
   v8_Rd_en_s(i)     <= RTDEX_STR_TXD_TREADY and v8_Txdata_Rd_s(i);
   v8_ChFifoRst_s(i) <= iv8_TxFifoReset_p(i) or not(SysRstn_s); 
   
   Fifo1K: if C_TXMEM = 1024 generate          
       U0_ChanFifo: fifo1k_w32_async_fwft_tx
        PORT MAP (
          rst           => v8_ChFifoRst_s(i),
          wr_clk        => i_TxUserClk_p,
          rd_clk        => RTDEX_STR_TXD_ACLK,
          din           => a8v32_TxDataChD1_s(i),
          wr_en         => v8_TxWeD1_s(i),
          rd_en         => v8_Rd_en_s(i),
          dout          => a8v32_ChFifoDout_s(i),
          full          => open,          
          overflow      => v8_overflow_s(i),
          empty         => v8_ChFifoempty_s(i),          
          rd_data_count => a8v16_RdDataCnt_s(i)(10 downto 0),
          wr_data_count => a8v16_TxFifoCount_s(i)(10 downto 0),
          prog_full		=> v8_ChFifoaFull_s(i)
        );
        
       a8v16_TxFifoCount_s(i)(15 downto 11)	<= (others => '0');
       a8v16_RdDataCnt_s(i)(15 downto 11)   <= (others => '0');
       
    end generate Fifo1K;    
   
    Fifo2K: if C_TXMEM = 2048 generate    
       U0_ChanFifo: fifo2k_w32_async_fwft_tx
        PORT MAP (
          rst           => v8_ChFifoRst_s(i),
          wr_clk        => i_TxUserClk_p,
          rd_clk        => RTDEX_STR_TXD_ACLK,
          din           => a8v32_TxDataChD1_s(i),
          wr_en         => v8_TxWeD1_s(i),
          rd_en         => v8_Rd_en_s(i),
          dout          => a8v32_ChFifoDout_s(i),
          full          => open,        
          overflow      => v8_overflow_s(i),
          empty         => v8_ChFifoempty_s(i),                    
          rd_data_count => a8v16_RdDataCnt_s(i)(11 downto 0),
          wr_data_count => a8v16_TxFifoCount_s(i)(11 downto 0),
          prog_full		=> v8_ChFifoaFull_s(i)
        );
        
       a8v16_TxFifoCount_s(i)(15 downto 12)	<= (others => '0'); 
       a8v16_RdDataCnt_s(i)(15 downto 12)  	<= (others => '0');         
       
    end generate Fifo2K;    
    
    Fifo4K: if C_TXMEM = 4096 generate   
          
       U0_ChanFifo: fifo4K_w32_async_fwft_tx
        PORT MAP (
          rst           => v8_ChFifoRst_s(i),
          wr_clk        => i_TxUserClk_p,
          rd_clk        => RTDEX_STR_TXD_ACLK,
          din           => a8v32_TxDataChD1_s(i),
          wr_en         => v8_TxWeD1_s(i),
          rd_en         => v8_Rd_en_s(i),
          dout          => a8v32_ChFifoDout_s(i),
          full          => open,          
          overflow      => v8_overflow_s(i),
          empty         => v8_ChFifoempty_s(i),                    
          rd_data_count => a8v16_RdDataCnt_s(i)(12 downto 0),
          wr_data_count => a8v16_TxFifoCount_s(i)(12 downto 0),
          prog_full		=> v8_ChFifoaFull_s(i)    
        );
        
        a8v16_TxFifoCount_s(i)(15 downto 13)	<= (others => '0');
        a8v16_RdDataCnt_s(i)(15 downto 13)   	<= (others => '0');        
        
    end generate Fifo4K;
    
    Fifo8K: if C_TXMEM = 8192 generate          
       U0_ChanFifo: fifo8K_w32_async_fwft_tx
        PORT MAP (
          rst           => v8_ChFifoRst_s(i),
          wr_clk        => i_TxUserClk_p,
          rd_clk        => RTDEX_STR_TXD_ACLK,
          din           => a8v32_TxDataChD1_s(i),
          wr_en         => v8_TxWeD1_s(i),
          rd_en         => v8_Rd_en_s(i),
          dout          => a8v32_ChFifoDout_s(i),
          full          => open,          
          overflow      => v8_overflow_s(i),
          empty         => v8_ChFifoempty_s(i),                    
          rd_data_count => a8v16_RdDataCnt_s(i)(13 downto 0),
          wr_data_count => a8v16_TxFifoCount_s(i)(13 downto 0),
          prog_full		=> v8_ChFifoaFull_s(i)    
        );
        
        a8v16_TxFifoCount_s(i)(15 downto 14)	<= (others => '0');        
        a8v16_RdDataCnt_s(i)(15 downto 14)   	<= (others => '0');        
        
    end generate Fifo8K;
    
    Fifo16K: if C_TXMEM = 16384 generate          
       U0_ChanFifo: fifo16K_w32_async_fwft_tx
        PORT MAP (
          rst           => v8_ChFifoRst_s(i),
          wr_clk        => i_TxUserClk_p,
          rd_clk        => RTDEX_STR_TXD_ACLK,
          din           => a8v32_TxDataChD1_s(i),
          wr_en         => v8_TxWeD1_s(i),
          rd_en         => v8_Rd_en_s(i),
          dout          => a8v32_ChFifoDout_s(i),
          full          => open,          
          overflow      => v8_overflow_s(i),
          empty         => v8_ChFifoempty_s(i),                    
          rd_data_count => a8v16_RdDataCnt_s(i)(14 downto 0),
          wr_data_count => a8v16_TxFifoCount_s(i)(14 downto 0),
          prog_full		=> v8_ChFifoaFull_s(i)    
        );       
        
        a8v16_TxFifoCount_s(i)(15)	<= '0';
        a8v16_RdDataCnt_s(i)(15)   	<= '0';
         
    end generate Fifo16K;
    
    Fifo32K: if C_TXMEM = 32768 generate          
       U0_ChanFifo: fifo32K_w32_async_fwft_tx
        PORT MAP (
          rst           => v8_ChFifoRst_s(i),
          wr_clk        => i_TxUserClk_p,
          rd_clk        => RTDEX_STR_TXD_ACLK,
          din           => a8v32_TxDataChD1_s(i),
          wr_en         => v8_TxWeD1_s(i),
          rd_en         => v8_Rd_en_s(i),
          dout          => a8v32_ChFifoDout_s(i),
          full          => open,          
          overflow      => v8_overflow_s(i),
          empty         => v8_ChFifoempty_s(i),                    
          rd_data_count => a8v16_RdDataCnt_s(i),
          wr_data_count => a8v16_TxFifoCount_s(i),
          prog_full		=> v8_ChFifoaFull_s(i)    
        );        
    end generate Fifo32K;
        
    -- Little indian: convenient for pc architecture
	 LittleEndianGen: if big_Endian_g = 0 generate 
	 	a8v32_RtdexChData_s <= a8v32_ChFifoDout_s;
	 end generate LittleEndianGen;
	  
	 -- Big Endian: swape bytes
	 BigEndianGen: if big_Endian_g = 1 generate 
	 	a8v32_RtdexChData_s(i)(31 downto 24) <= a8v32_ChFifoDout_s(i)(7 downto 0);  
	 	a8v32_RtdexChData_s(i)(23 downto 16) <= a8v32_ChFifoDout_s(i)(15 downto 8); 
	 	a8v32_RtdexChData_s(i)(15 downto 8)  <= a8v32_ChFifoDout_s(i)(23 downto 16);
	 	a8v32_RtdexChData_s(i)(7 downto 0)   <= a8v32_ChFifoDout_s(i)(31 downto 24); 	
	 end generate BigEndianGen;
 
 END GENERATE ChFifo_gen;
 -----------------------------------------------------------------------
 -- FIFO data info
 ----------------------------------------------------------------------- 
 Fifo1k_gen: if C_TXMEM = 1024 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(1,6));
 end generate Fifo1k_gen;
 
 Fifo2k_gen: if C_TXMEM = 2048 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(2,6));
 end generate Fifo2k_gen;
 
 Fifo4k_gen: if C_TXMEM = 4096 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(4,6));
 end generate Fifo4k_gen;
 
 Fifo8k_gen: if C_TXMEM = 8192 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(8,6));
 end generate Fifo8k_gen;
 
 Fifo16k_gen: if C_TXMEM = 16384 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(16,6));
 end generate Fifo16k_gen;
 
 Fifo32k_gen: if C_TXMEM = 32768 generate
 	v6_FifoDepthInfo_s <= std_logic_vector(to_unsigned(32,6));
 end generate Fifo32k_gen;
 
 ---
 NoStatisticCnt_gen: if StatsCntrs_g = 0 generate
 	StatisticCntEnabled_s <= '0';
 end generate NoStatisticCnt_gen;
 
 StatisticCnt_gen: if StatsCntrs_g = 1 generate
 	StatisticCntEnabled_s <= '1';
 end generate StatisticCnt_gen;
    
end rtdex_tx_behav;