--------------------------------------------------------------------------------
--
--    ****                              *
--   ******                            ***
--   *******                           ****
--   ********    ****  ****     **** *********    ******* ****    ***********
--   *********   ****  ****     **** *********  **************  *************
--   **** *****  ****  ****     ****   ****    *****    ****** *****     ****
--   ****  ***** ****  ****     ****   ****   *****      ****  ****      ****
--  ****    *********  ****     ****   ****   ****       ****  ****      ****
--  ****     ********  ****    *****  ****    *****     *****  ****      ****
--  ****      ******   ***** ******   *****    ****** *******  ****** *******
--  ****        ****   ************    ******   *************   *************
--  ****         ***     ****  ****     ****      *****  ****     *****  ****
--                                                                       ****
--          I N N O V A T I O N  T O D A Y  F O R  T O M M O R O W       ****
--                                                                        ***
--
--------------------------------------------------------------------------------
-- File : lyt_pps_sync.vhd
--------------------------------------------------------------------------------
-- Description : PPS clock sync core
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2013 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log: lyt_pps_sync.vhd,v $
-- Revision 1.4  2013/09/11 19:31:22  khalid.bensadek
-- fixed a glitches in sync module & fixed a bug in moving sum logic & added cross domain one register to ease timings
--
-- Revision 1.3  2013/09/04 15:24:58  khalid.bensadek
-- added logic for moving sum
--
-- Revision 1.2  2013/08/29 17:55:00  khalid.bensadek
-- Added FIFO and other logic for clock domaine crossing
--
-- Revision 1.1  2013/08/01 20:28:01  khalid.bensadek
-- Fisrt commit: tested with Radio420 only.
--
--
--------------------------------------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_signed.all;
use IEEE.STD_LOGIC_MISC.all;

library lyt_pps_sync_v1_00_a;
	use lyt_pps_sync_v1_00_a.all;

entity lyt_pps_sync is
  generic
  (
    v16_CoreId_g 	: std_logic_vector(15 downto 0):=x"CC01";
    v16_VersNbr_g	: std_logic_vector(15 downto 0):=x"0200"        
  );
  port
  (
  	i_SysClk_p				: in  std_logic;	-- Microcontroller system clock: 100 Mhz
  	i_FmcClk_p				: in  std_logic;	-- FMC clock under correction
  	i_Pps_p					: in  std_logic;	-- PPS signal from external GPS  	
	-- Regs CTRL & Status
    ov32_CoreIdVers_p		: out std_logic_vector(31 downto 0);
  	iv32_FmcClkVal_p		: in  std_logic_vector(31 downto 0);	-- FMC expected clock frequency
  	iv32_ProgDelay_p		: in  std_logic_vector(31 downto 0);	-- Prog delay for moving window
  	i_CoreReset_p			: in  std_logic;
  	i_RstUponRead_p			: in  std_logic;
  	i_RstAcc_p				: in  std_logic;
  	i_CoreEnable_p			: in  std_logic;
  	i_MovingSumEna_p		: in  std_logic;
  	i_MovingSumRst_p		: in  std_logic;
  	i_DiffAccRead_p			: in std_logic;		-- Read ack signal for ov32_DiffAcc_p register
  	ov32_PpsCnt_p			: out std_logic_vector(31 downto 0);	-- PPS count: FMC clock cycles count between two successives PPS pules 
  	ov32_DiffAcc_p			: out std_logic_vector(31 downto 0)		-- FMC frequency difference accumulated value

  );
end entity lyt_pps_sync;

architecture rtl of lyt_pps_sync is

 component fifo_async_w64_d16
  port (
    rst 	: IN STD_LOGIC;
    wr_clk 	: IN STD_LOGIC;
    rd_clk 	: IN STD_LOGIC;
    din 	: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    wr_en 	: IN STD_LOGIC;
    rd_en 	: IN STD_LOGIC;
    dout 	: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    full 	: OUT STD_LOGIC;
    empty 	: OUT STD_LOGIC
  );
 end component;
  
 signal AccReset_s			: std_logic;
 signal CoreResetTmp_s		: std_logic;
 signal CoreReset_s			: std_logic;
 signal RstAccTmp_s			: std_logic;
 signal RstAcc_s			: std_logic;
 signal DiffAccReadTmp1_s	: std_logic;
 signal DiffAccReadTmp2_s	: std_logic;
 signal DiffAccReadTmp3_s	: std_logic;
 signal DiffAccRead_s		: std_logic;
 signal PpsTmp_s			: std_logic;
 signal PpsRedge_s			: std_logic;
 signal Pps_clean_s			: std_logic;
 signal u32_PpsCount_s		: unsigned(31 downto 0); 
 signal u32_PpsCnt_s		: unsigned(31 downto 0);
 signal u32_FmcClkVal_s		: unsigned(31 downto 0);
 signal v32_FmcClkDelta_s	: std_logic_vector(31 downto 0);
 signal v32_AccValue_s		: std_logic_vector(31 downto 0); 
 signal v32_SignalStretch_s	: std_logic_vector(31 downto 0);
 signal DiffAccReadStrched_s : std_logic;
 signal v64_din_s			: std_logic_vector(63 downto 0);
 signal v64_dout_s			: std_logic_vector(63 downto 0);
 signal FmcClkDeltaValid_s  : std_logic;
 signal v32_MovingSumVal_s	: std_logic_vector(31 downto 0);
 signal v32_CTEValue_s		: std_logic_vector(31 downto 0);
 signal ProgDlyRst_s		: std_logic;
 signal MovingSumRst_s		: std_logic;
 signal RstUponRead_s 	 	: std_logic;
 signal CoreEnable_s  	 	: std_logic;
 signal MovingSumEna_s	 	: std_logic;
 signal v4_ProgDelay_s	 	: std_logic_vector(3 downto 0);
 signal v32_FmcClkVal_s	 	: std_logic_vector(31 downto 0);
 
 
  
 -- For dbg. To be removed --
 -- attribute keep_hierarchy : string;
 -- attribute keep_hierarchy of rtl : architecture is "true";
 
 -- attribute keep : string;
 -- attribute keep of Pps_clean_s : signal is "true";
 -- attribute keep of PpsRedge_s : signal is "true";
 -- attribute keep of AccReset_s : signal is "true";
 -- attribute keep of MovingSumRst_s : signal is "true";
 -- end for dbg --

begin

 --- Ouput ports ---
 ov32_CoreIdVers_p 	<= v16_CoreId_g & v16_VersNbr_g;
 ov32_PpsCnt_p		<= v64_dout_s(31 downto 0);
 ov32_DiffAcc_p		<= v64_dout_s(63 downto 32);
 
 ---------------------------------------------------------
 -- Sync ctrl signals with design/FMC clock
 ---------------------------------------------------------
 Syncer_i0: entity lyt_pps_sync_v1_00_a.syncer
	port map(
		i_InClk_p 	=> i_SysClk_p,
		i_InSig_p 	=> i_CoreReset_p,
		i_OutClk_p 	=> i_FmcClk_p,
		i_OutSig_p 	=> CoreReset_s
	);
		
 Syncer_i1: entity lyt_pps_sync_v1_00_a.syncer
	port map(
		i_InClk_p 	=> i_SysClk_p,
		i_InSig_p 	=> i_RstAcc_p,
		i_OutClk_p 	=> i_FmcClk_p,
		i_OutSig_p 	=> RstAcc_s
	);
 
 Syncer_i2: entity lyt_pps_sync_v1_00_a.syncer
	port map(
		i_InClk_p 	=> i_SysClk_p,
		i_InSig_p 	=> i_DiffAccRead_p,
		i_OutClk_p 	=> i_FmcClk_p,
		i_OutSig_p 	=> DiffAccReadStrched_s
	);
	
 Syncer_i3: entity lyt_pps_sync_v1_00_a.syncer
	port map(
		i_InClk_p 	=> i_SysClk_p,
		i_InSig_p 	=> i_MovingSumRst_p,
		i_OutClk_p 	=> i_FmcClk_p,
		i_OutSig_p 	=> MovingSumRst_s
	);

 -- detect rising edge
 DiffAccReadTmp2_s <= DiffAccReadStrched_s;
 process(i_FmcClk_p)
 begin
 	if rising_edge(i_FmcClk_p) then 		
 		DiffAccReadTmp3_s <= DiffAccReadTmp2_s; 		
 	end if;
 end process;
 
 DiffAccRead_s <= DiffAccReadTmp2_s and not(DiffAccReadTmp3_s);
 
 -- Registering input signals to aide timing 
 process(i_FmcClk_p)
 begin
 	if rising_Edge(i_FmcClk_p) then
 		RstUponRead_s 	<= i_RstUponRead_p; 
 	    CoreEnable_s  	<= i_CoreEnable_p;  
 	    MovingSumEna_s	<= i_MovingSumEna_p;
 	    v4_ProgDelay_s	<= iv32_ProgDelay_p(3 downto 0);
 	    v32_FmcClkVal_s	<= iv32_FmcClkVal_p;
 	
 	end if;
 end process;
 
 u32_FmcClkVal_s <= unsigned(v32_FmcClkVal_s);
 ---------------------------------------------------------
 -- Accumulated value (CTE) reset management 
 ---------------------------------------------------------  
 AccReset_s	<= CoreReset_s or RstAcc_s or (RstUponRead_s and DiffAccRead_s);
 
 ---------------------------------------------------------
 -- Digital glitch filter runs at 30.72 MHz clock
 ---------------------------------------------------------
 inst_pps30d72_filter: entity lyt_pps_sync_v1_00_a.lyt_glitch_filter
   generic map(C_INERTIAL_DELAY => 5)	
   port map
   	(
      i_Clk_p  => i_FmcClk_p,
      i_Rst_p  => CoreReset_s,
      i_Din_p  => i_Pps_p,
      o_Dout_p => Pps_clean_s
    );
    
 -------------------------------------------------------
 -- PPS rising_edge detect
 -------------------------------------------------------  
 process(i_FmcClk_p)
 begin
   if rising_edge(i_FmcClk_p) then
     PpsTmp_s <= Pps_clean_s;
   end if;
 end process;
 
 PpsRedge_s <= Pps_clean_s and not(PpsTmp_s);
 
 ----------------------------------------------------------  
 -- PPS counter: counts number of FMC clock cycles between
 -- Two successives PPS pulse.
 ----------------------------------------------------------  
 process(i_FmcClk_p)
 begin
 	if rising_Edge(i_FmcClk_p) then 		 		
 		if PpsRedge_s = '1'then
 			u32_PpsCnt_s <= u32_PpsCount_s; 	-- Register count value
 			u32_PpsCount_s <= (others=>'0'); 	-- Reset the counter  				
 		else
 			u32_PpsCount_s <= u32_PpsCount_s + 1;
 		end if;
 	end if;
 end process;
  
 -------------------------------------------------------  
 -- FMC clock delta calculation. 
 -------------------------------------------------------  
 process(i_FmcClk_p)
 begin
 	if rising_edge(i_FmcClk_p) then
 		FmcClkDeltaValid_s <= '0';
 		if PpsRedge_s = '1' then
 			v32_FmcClkDelta_s <= u32_FmcClkVal_s - u32_PpsCount_s;
 			FmcClkDeltaValid_s <= '1';
 		end if; 		
 	end if;
 end process;
 
 ------------------------------------------------------------
 -- FMC clock delta accumulator. 
 -- This process should be enabled only after PPS is 
 -- detected by the microcontroller to avoif erroneous values
 ------------------------------------------------------------
 process(i_FmcClk_p)
 begin
 	if rising_edge(i_FmcClk_p) then 	
 		if AccReset_s = '1' then
 			v32_AccValue_s <= (others=>'0');
 		elsif CoreEnable_s = '1' then -- Should be enabled only after PPS is detected
 			if FmcClkDeltaValid_s = '1' then
 				v32_AccValue_s <= v32_AccValue_s + v32_FmcClkDelta_s;
 			end if;
 		end if; 		
 	end if;
 end process;
 
 ------------------------------------------------------------
 -- Mouving sum implementation
 ------------------------------------------------------------ 
 progdelay_i0: entity lyt_pps_sync_v1_00_a.progdelay
	port map(
		i_clk_p			=> i_FmcClk_p,
		i_reset_p		=> ProgDlyRst_s,
		iv4_ProgDelay_p => v4_ProgDelay_s,
		i_DlyEna_p		=> FmcClkDeltaValid_s,
		iv32_InSig_p 	=> v32_FmcClkDelta_s,
		ov32_InSig_p	=> v32_MovingSumVal_s
		);
  
 ProgDlyRst_s <= MovingSumRst_s or AccReset_s;
 
 -- Muxer for output reg value	
 process(i_FmcClk_p)
 begin
 	if rising_edge(i_FmcClk_p) then
 		if MovingSumEna_s = '1' then
 			v32_CTEValue_s <= v32_AccValue_s - v32_MovingSumVal_s;
 		else
 			v32_CTEValue_s <= v32_AccValue_s;
 		end if;
 	end if;
 end process;
  	
 ------------------------------------------------------------
 -- Async FiFo for clock domain crossing 
 ------------------------------------------------------------
 SyncFifo_i0 : fifo_async_w64_d16
  PORT MAP (
    rst 	=> i_CoreReset_p,
    wr_clk 	=> i_FmcClk_p,
    rd_clk 	=> i_SysClk_p,
    din 	=> v64_din_s,
    wr_en 	=> '1',
    rd_en 	=> '1',
    dout 	=> v64_dout_s,
    full 	=> open,
    empty 	=> open
  );
  
 v64_din_s <= v32_CTEValue_s & std_logic_vector(u32_PpsCnt_s);

end rtl;