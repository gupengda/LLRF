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
--
--------------------------------------------------------------------------------
-- Copyright (c) 2012 Lyrtech RD inc.
-- TODO = legal notice
--------------------------------------------------------------------------------
-- $Log: 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


package emac_rtdex_pkg is

 -- Type def.
 type array8_32_t is array(7 downto 0) of std_logic_vector(31 downto 0);
 type array8_8_t  is array(7 downto 0) of std_logic_vector(7 downto 0);
 type array8_15_t is array(7 downto 0) of std_logic_vector(14 downto 0);
 type array8_12_t is array(7 downto 0) of std_logic_vector(11 downto 0);
 type array8_14_t is array(7 downto 0) of std_logic_vector(13 downto 0);
 
 type array8_4_t is array(7 downto 0) of std_logic_vector(3 downto 0);
 type array8_13_t is array(7 downto 0) of std_logic_vector(12 downto 0);
 
 -- component declaration
 component emac_rtdex_rx_dec
 port( i_ClientEmacRxClientClkin_p   : in std_logic;
         i_EmacReset_p                 : in std_logic;
         iv3_NbChannel_p               : in std_logic_vector(2 downto 0);
         iv48_SourceMacAddr_p          : in std_logic_vector(47 downto 0);
         iv8_ProtIdCh0_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh1_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh2_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh3_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh4_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh5_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh6_p               : in std_logic_vector(7 downto 0);
         iv8_ProtIdCh7_p               : in std_logic_vector(7 downto 0);
         i_EmacClientRxFrameDrop_p     : in std_logic;
         i_ClientEmacRxDvld_p          : in std_logic;
         iv8_EmacClientRxd_p           : in std_logic_vector(7 downto 0);
         i_RxResetD2_p                 : in std_logic;
         ov8_ChannelId_p               : out std_logic_vector(7 downto 0);
         o_HeaderPassed_p              : out std_logic;
         ov8_FrameLost_p               : out std_logic_vector(7 downto 0);
         ov8_incexpectedframe_p        : out std_logic_vector(7 downto 0);
         iv8_32_ExpectedFrameNbr_p     : in array8_32_t
        );
end component emac_rtdex_rx_dec;

component emac_rtdex_tx_dec
   port(i_ClientEmacTxClientClkin_p    : in std_logic;
        iv8_TxUsrReset_p               : in std_logic_vector(7 downto 0);
        i_EmacClientTxAck_p            : in std_logic;
        iv48_DestMacAddr_p             : in std_logic_vector(47 downto 0);
        iv48_SourceMacAddr_p           : in std_logic_vector(47 downto 0);
        ov8_CurrentChannel_p           : out std_logic_vector(7 downto 0);
        i_AtLeastOneStart_p            : in std_logic;
        i_StartCondition_p             : in std_logic;
        iv8_HasEnoughDataToSend_p      : in std_logic_vector(7 downto 0);
        iv32_FrameGap_p                : in std_logic_vector(31 downto 0);
        iv8_SizeSet_p                  : in std_logic_vector(7 downto 0);
        i_EmacReset_p                  : in std_logic;
        o_ClientEmacTxDvld_p           : out std_logic;
        i_TxResetD2_p                  : in std_logic;
        iv3_NbChannel_p                : in std_logic_vector(2 downto 0);
        o_ClientEmacTxUnderrun_p       : out std_logic;
        ov8_FifoRdEn_p                 : out std_logic_vector(7 downto 0);
        ov8_IncFrameNumber_p           : out std_logic_vector(7 downto 0);
        ov8_ClientEmacTxd_p            : out std_logic_vector(7 downto 0);
        iv8_ProtIdCh0_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh1_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh2_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh3_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh4_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh5_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh6_p                : in std_logic_vector(7 downto 0);
        iv8_ProtIdCh7_p                : in std_logic_vector(7 downto 0);
        ov8_TxUsrResetD2_p             : out std_logic_vector(7 downto 0);
        iv8_32_FrameNumber_p           : in array8_32_t;
        iv8_8_FifoDataOut_p            : in array8_8_t;
        iv8_15_CurrFrameSize_p         : in array8_15_t         
        );
end component emac_rtdex_tx_dec;
 

end emac_rtdex_pkg;