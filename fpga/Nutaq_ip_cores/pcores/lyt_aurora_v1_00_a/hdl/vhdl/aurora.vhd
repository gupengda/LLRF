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
-- File : aurora_top.vhd
--------------------------------------------------------------------------------
-- Description : Top Level Aurora Core with Fifos
--------------------------------------------------------------------------------
-- Notes / Assumptions :
--------------------------------------------------------------------------------
-- Copyright (c) 2013 Nutaq inc.
--------------------------------------------------------------------------------
-- $Log:
--
--
--------------------------------------------------------------------------------

-- Library declarations
library ieee;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_1164.all;
library unisim;
  use unisim.vcomponents.all;
library work;

entity lyt_aurora is
generic
(
  AURORA_SPEED           : integer              := 0;
  USER_DATA_WIDTH        : integer              := 16;
  AURORA_WIDTH           : integer              := 128
);
port (

--FIFO INTERFACE
i_Fifo_User_Clock_p                               : IN  STD_LOGIC;                                     --User clock that will clock the fifos data
ov_Fifo_RX_Data_p                                 : OUT STD_LOGIC_VECTOR(USER_DATA_WIDTH-1 downto 0);  --Data received by the Aurora link
iv_Fifo_TX_Data_p                                 : IN  STD_LOGIC_VECTOR(USER_DATA_WIDTH-1 downto 0);  --Data to be sent by the Aurora link
i_RX_Fifo_Read_Enable_p                           : IN  STD_LOGIC;                                     --Read enable of the Fifo
i_TX_Fifo_Write_Enable_p                          : IN  STD_LOGIC;                                     --Write enable of the Fifo
i_Aurora_Start_nStop_p                            : IN  STD_LOGIC;                                     --Start/Stop the Aurora stream
o_RX_Data_Valid_p                                 : OUT STD_LOGIC;                                     --Data ready to be read
o_TX_Fifo_Ready_p                                 : OUT STD_LOGIC;                                     --Data ready to be sent

--RX_FIFO_STATUS
o_RX_Fifo_Overflow_p                              : OUT STD_LOGIC;                                     --Fifo Overflow Flag
o_RX_Fifo_Full_p                                  : OUT STD_LOGIC;                                     --Fifo Full Flag
o_RX_Fifo_Prog_Almost_Full_p                      : OUT STD_LOGIC;                                     --Fifo Programmable Almost Full Flag
o_RX_Fifo_Prog_Almost_Empty_p                     : OUT STD_LOGIC;                                     --Fifo Programmable Almost empty Flag
o_RX_Fifo_Empty_p                                 : OUT STD_LOGIC;                                     --Fifo Empty Flag
o_RX_Fifo_Underflow_p                             : OUT STD_LOGIC;                                     --Fifo Underflow Flag
--RX_FIFO_DATA_COUNT
ov16_RX_Fifo_Write_Data_Count_p                   : OUT STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Write DataCount
ov16_RX_Fifo_Read_Data_Count_p                    : OUT STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Read DataCount
--RX_FIFO_THRESHOLD
iv16_RX_Fifo_Prog_Almost_Full_Threshold_p         : IN  STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Programmable Almost Full Flag
iv16_RX_Fifo_Prog_Almost_Empty_Threshold_p        : IN  STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Programmable Almost Empty Flag
--RX_FIFO_CTRL
i_RX_Fifo_Reset_p                                 : IN  STD_LOGIC;                                     --Reset the Fifo interface and content

--TX_FIFO_STATUS
o_TX_Fifo_Overflow_p                              : OUT STD_LOGIC;                                     --Fifo Overflow Flag
o_TX_Fifo_Full_p                                  : OUT STD_LOGIC;                                     --Fifo Full Flag
o_TX_Fifo_Prog_Almost_Full_p                      : OUT STD_LOGIC;                                     --Fifo Programmable Almost Full Flag
o_TX_Fifo_Prog_Almost_Empty_p                     : OUT STD_LOGIC;                                     --Fifo Programmable Almost empty Flag
o_TX_Fifo_Empty_p                                 : OUT STD_LOGIC;                                     --Fifo Empty Flag
o_TX_Fifo_Underflow_p                             : OUT STD_LOGIC;                                     --Fifo Underflow Flag
--TX_FIFO_DATA_COUNT
ov16_TX_Fifo_Write_Data_Count_p                   : OUT STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Write DataCount
ov16_TX_Fifo_Read_Data_Count_p                    : OUT STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Read DataCount
--TX_FIFO_THRESHOLD
iv16_TX_Fifo_Prog_Almost_Full_Threshold_p         : IN  STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Programmable Almost Full Flag
iv16_TX_Fifo_Prog_Almost_Empty_Threshold_p        : IN  STD_LOGIC_VECTOR(15 downto 0);                 --Fifo Programmable Almost Empty Flag
--TX_FIFO_CTRL
i_TX_Fifo_Reset_p                                 : IN  STD_LOGIC;                                     --Reset the Fifo interface and content

--AURORA INTERFACE
ov32_Aurora_CoreID_p                              : OUT STD_LOGIC_VECTOR(31 downto 0);                 --Aurora Core ID and version
--AURORA GTX
iv4_Aurora_GTX_RX_p                               : IN  STD_LOGIC_VECTOR(3 downto 0);                  --Aurora GTX RX Lanes
iv4_Aurora_GTX_RX_n                               : IN  STD_LOGIC_VECTOR(3 downto 0);                  --
ov4_Aurora_GTX_TX_p                               : OUT STD_LOGIC_VECTOR(3 downto 0);                  --Aurora GTX TX Lanes
ov4_Aurora_GTX_TX_n                               : OUT STD_LOGIC_VECTOR(3 downto 0);                  --
--AURORA GTX CLOCK
i_Aurora_GTX_CLK_p                                : IN  STD_LOGIC;                                     --Aurora GTX Clock Input
i_Aurora_GTX_CLK_n                                : IN  STD_LOGIC;                                     --
--AURORA_STATUS
o_Aurora_Hard_Error_p                             : OUT STD_LOGIC;                                     --Aurora Hardware Error Flag
o_Aurora_Soft_Error_p                             : OUT STD_LOGIC;                                     --Aurora Soft Error Flag
o_Aurora_Channel_Up_p                             : OUT STD_LOGIC;                                     --Aurora 4x Channel Up flag
ov4_Aurora_Lanes_Up_p                             : OUT STD_LOGIC_VECTOR(3 downto 0);                  --Aurora Lanes Up Flag inside the Channel
ov32_Aurora_Reg1_Receive_Data_Count_p             : OUT STD_LOGIC_VECTOR(31 downto 0);                 --Aurora statistic for received data
ov32_Aurora_Reg2_Transmit_Data_Count_p            : OUT STD_LOGIC_VECTOR(31 downto 0);                 --Aurora statistic for transmitted data
--AURORA_CTRL
i_Aurora_Reset_p                                  : IN  STD_LOGIC;                                     --Aurora Reset
iv32_Aurora_Reg0_Control_p                        : IN  STD_LOGIC_VECTOR(31 downto 0);                 --Aurora Reset
ov32_Aurora_Reg0_Control_p                        : OUT STD_LOGIC_VECTOR(31 downto 0)                  --Aurora Reset

);
end lyt_aurora;

architecture aurora_top_syn of lyt_aurora is

	----------------------------------------------------------------------------------------------------
	-- Constant declaration
	----------------------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------------------
	--Signal declaration
	----------------------------------------------------------------------------------------------------

signal Aurora_GTX_CLK_s             : std_logic;
signal GTX_fifo_clk_s               : std_logic;
signal TX_Dst_Rdy_n_s               : std_logic;
signal RX_Src_Rdy_n_s               : std_logic;
signal TX_Src_Rdy_n_s               : std_logic;

signal v_Aurora_RX_Data_s           : std_logic_vector(AURORA_WIDTH-1 downto 0);
signal v_Aurora_TX_Data_s           : std_logic_vector(AURORA_WIDTH-1 downto 0);
signal TX_Fifo_Read_Enable_s        : std_logic;
signal RX_Fifo_Write_Enable_s       : std_logic;

signal RX_Fifo_out_valid_s          : std_logic := '0';
signal TX_Fifo_out_valid_s          : std_logic := '0';

signal v16_Freq0_s                  : std_logic_vector(15 downto 0);
signal v16_Freq1_s                  : std_logic_vector(15 downto 0);
signal v16_Freq2_s                  : std_logic_vector(15 downto 0);
signal v16_Freq3_s                  : std_logic_vector(15 downto 0);

signal v32_transmit_count_s         : std_logic_vector(31 downto 0);
signal v32_receive_count_s          : std_logic_vector(31 downto 0);

signal Aurora_Start_nStop_s         : std_logic;
signal Aurora_Reset_s               : std_logic;
signal Aurora_Hard_Error_s          : std_logic;
signal Aurora_Soft_Error_s          : std_logic;
signal Aurora_Channel_Up_s          : std_logic;
signal v4_Aurora_Lanes_Up_s         : std_logic_vector(3 downto 0);
signal TX_Fifo_Reset_s              : std_logic;

signal TX_Fifo_Overflow_s           : std_logic;
signal TX_Fifo_Underflow_s          : std_logic;
signal TX_Fifo_Full_s               : std_logic;
signal TX_Fifo_Prog_Almost_Full_s   : std_logic;
signal TX_Fifo_Prog_Almost_Empty_s  : std_logic;
signal TX_Fifo_Empty_s              : std_logic;
signal RX_Fifo_Reset_s              : std_logic;

signal RX_Fifo_Overflow_s           : std_logic;
signal RX_Fifo_Underflow_s          : std_logic;
signal RX_Fifo_Full_s               : std_logic;
signal RX_Fifo_Prog_Almost_Full_s   : std_logic;
signal RX_Fifo_Prog_Almost_Empty_s  : std_logic;
signal RX_Fifo_Empty_s              : std_logic;

	----------------------------------------------------------------------------------------------------
	--Component declaration
	----------------------------------------------------------------------------------------------------

begin
                        -- Core      Version
                        --  ID      Maj    Min
  ov32_Aurora_CoreID_p <= X"AAAA" & X"01" & X"00";

  ov32_Aurora_Reg0_Control_p(31 downto 25) <= (others => '0')            ;
  ov32_Aurora_Reg0_Control_p(24)           <= Aurora_Start_nStop_s       ;
  ov32_Aurora_Reg0_Control_p(23)           <= Aurora_Reset_s             ;
  ov32_Aurora_Reg0_Control_p(22)           <= Aurora_Hard_Error_s        ;
  ov32_Aurora_Reg0_Control_p(21)           <= Aurora_Soft_Error_s        ;
  ov32_Aurora_Reg0_Control_p(20)           <= Aurora_Channel_Up_s        ;
  ov32_Aurora_Reg0_Control_p(19 downto 16) <= v4_Aurora_Lanes_Up_s       ;
  ov32_Aurora_Reg0_Control_p(15)           <= TX_Fifo_Reset_s            ;
  ov32_Aurora_Reg0_Control_p(14)           <= '0'                        ;
  ov32_Aurora_Reg0_Control_p(13)           <= TX_Fifo_Overflow_s         ;
  ov32_Aurora_Reg0_Control_p(12)           <= TX_Fifo_Underflow_s        ;
  ov32_Aurora_Reg0_Control_p(11)           <= TX_Fifo_Full_s             ;
  ov32_Aurora_Reg0_Control_p(10)           <= TX_Fifo_Prog_Almost_Full_s ;
  ov32_Aurora_Reg0_Control_p( 9)           <= TX_Fifo_Prog_Almost_Empty_s;
  ov32_Aurora_Reg0_Control_p( 8)           <= TX_Fifo_Empty_s            ;
  ov32_Aurora_Reg0_Control_p( 7)           <= RX_Fifo_Reset_s            ;
  ov32_Aurora_Reg0_Control_p( 6)           <= '0'                        ;
  ov32_Aurora_Reg0_Control_p( 5)           <= RX_Fifo_Overflow_s         ;
  ov32_Aurora_Reg0_Control_p( 4)           <= RX_Fifo_Underflow_s        ;
  ov32_Aurora_Reg0_Control_p( 3)           <= RX_Fifo_Full_s             ;
  ov32_Aurora_Reg0_Control_p( 2)           <= RX_Fifo_Prog_Almost_Full_s ;
  ov32_Aurora_Reg0_Control_p( 1)           <= RX_Fifo_Prog_Almost_Empty_s;
  ov32_Aurora_Reg0_Control_p( 0)           <= RX_Fifo_Empty_s            ;

  o_Aurora_Hard_Error_p                    <= Aurora_Hard_Error_s        ;
  o_Aurora_Soft_Error_p                    <= Aurora_Soft_Error_s        ;
  o_Aurora_Channel_Up_p                    <= Aurora_Channel_Up_s        ;
  ov4_Aurora_Lanes_Up_p                    <= v4_Aurora_Lanes_Up_s       ;
  o_TX_Fifo_Overflow_p                     <= TX_Fifo_Overflow_s         ;
  o_TX_Fifo_Underflow_p                    <= TX_Fifo_Underflow_s        ;
  o_TX_Fifo_Full_p                         <= TX_Fifo_Full_s             ;
  o_TX_Fifo_Prog_Almost_Full_p             <= TX_Fifo_Prog_Almost_Full_s ;
  o_TX_Fifo_Prog_Almost_Empty_p            <= TX_Fifo_Prog_Almost_Empty_s;
  o_TX_Fifo_Empty_p                        <= TX_Fifo_Empty_s            ;
  o_RX_Fifo_Overflow_p                     <= RX_Fifo_Overflow_s         ;
  o_RX_Fifo_Underflow_p                    <= RX_Fifo_Underflow_s        ;
  o_RX_Fifo_Full_p                         <= RX_Fifo_Full_s             ;
  o_RX_Fifo_Prog_Almost_Full_p             <= RX_Fifo_Prog_Almost_Full_s ;
  o_RX_Fifo_Prog_Almost_Empty_p            <= RX_Fifo_Prog_Almost_Empty_s;
  o_RX_Fifo_Empty_p                        <= RX_Fifo_Empty_s            ;

  Aurora_Start_nStop_s                     <= i_Aurora_Start_nStop_p or iv32_Aurora_Reg0_Control_p(24);
  Aurora_Reset_s                           <= i_Aurora_Reset_p       or iv32_Aurora_Reg0_Control_p(23);
  TX_Fifo_Reset_s                          <= i_TX_Fifo_Reset_p      or iv32_Aurora_Reg0_Control_p(15);
  RX_Fifo_Reset_s                          <= i_RX_Fifo_Reset_p      or iv32_Aurora_Reg0_Control_p(7);

  IBUFDS_i :  IBUFDS_GTXE1
  port map (
       I     => i_Aurora_GTX_CLK_p,
       IB    => i_Aurora_GTX_CLK_n,
       CEB   => '0',
       O     => Aurora_GTX_CLK_s,
       ODIV2 => OPEN);

  o_RX_Data_Valid_p                  <= RX_Fifo_out_valid_s;
  o_TX_Fifo_Ready_p                  <= not TX_Fifo_Full_s;

  TX_Fifo_Read_Enable_s  <= not TX_Dst_Rdy_n_s and not TX_Fifo_Empty_s and Aurora_Start_nStop_s;
  RX_Fifo_Write_Enable_s <= not RX_Src_Rdy_n_s and Aurora_Start_nStop_s;

  TX_Src_Rdy_n_s <= TX_Fifo_out_valid_s nand Aurora_Start_nStop_s;

-----------------------------------------------------------------------------------
-- ReceiveCountPrc : Count the amout of data received by the Aurora core
-----------------------------------------------------------------------------------
  ReceiveCountPrc : process(GTX_fifo_clk_s)
    begin
      if rising_edge(GTX_fifo_clk_s) then
        if(RX_Fifo_Reset_s = '1') then
          v32_receive_count_s <= (others => '0');
        elsif(RX_Src_Rdy_n_s = '0') then                     --Need to be Ready to receive data
          v32_receive_count_s <= v32_receive_count_s + 1;
        end if;
      end if;
  end process ReceiveCountPrc;

-----------------------------------------------------------------------------------
-- TransmitCountPrc : Count the amout of data transferred by the Aurora core
-----------------------------------------------------------------------------------
  TransmitCountPrc : process(GTX_fifo_clk_s)
    begin
      if rising_edge(GTX_fifo_clk_s) then
        if(TX_Fifo_Reset_s = '1') then
          v32_transmit_count_s <= (others => '0');
        elsif((TX_Src_Rdy_n_s nor TX_Dst_Rdy_n_s) = '1') then  --Both need to be Ready to transmit data
          v32_transmit_count_s <= v32_transmit_count_s + 1;
        end if;
      end if;
  end process TransmitCountPrc;

  ov32_Aurora_Reg1_Receive_Data_Count_p  <= v32_receive_count_s;
  ov32_Aurora_Reg2_Transmit_Data_Count_p <= v32_transmit_count_s;

	u_aurora_8b10b_v5_3_wrapper: entity work.aurora_8b10b_v5_3_wrapper
  generic map
  (
    AURORA_SPEED              => AURORA_SPEED,
    DATA_WIDTH                => AURORA_WIDTH
  )
  PORT MAP
  (
		i_User_Clock_p            => i_Fifo_User_Clock_p,
		o_GTX_fifo_clk_p          => GTX_fifo_clk_s,
		ov_RX_Data_p              => v_Aurora_RX_Data_s,
		iv_TX_Data_p              => v_Aurora_TX_Data_s,
		i_TX_Src_Rdy_n            => TX_Src_Rdy_n_s,
		o_TX_Dst_Rdy_n            => TX_Dst_Rdy_n_s,
		o_RX_Src_Rdy_n            => RX_Src_Rdy_n_s,
		iv4_Aurora_GTX_RX_p       => iv4_Aurora_GTX_RX_p,
		iv4_Aurora_GTX_RX_n       => iv4_Aurora_GTX_RX_n,
		ov4_Aurora_GTX_TX_p       => ov4_Aurora_GTX_TX_p,
		ov4_Aurora_GTX_TX_n       => ov4_Aurora_GTX_TX_n,
		i_Aurora_GTX_CLK_p        => Aurora_GTX_CLK_s,
		o_Aurora_Hard_Error_p     => Aurora_Hard_Error_s,
		o_Aurora_Soft_Error_p     => Aurora_Soft_Error_s,
		o_Aurora_Channel_Up_p     => Aurora_Channel_Up_s,
		ov4_Aurora_Lanes_Up_p     => v4_Aurora_Lanes_Up_s,
		i_Aurora_Reset_p          => Aurora_Reset_s
	);

  u_fifo_RX : entity work.generic_fifo
  generic map
  (
    WRITE_WIDTH_g             => 128,
    READ_WIDTH_g              => USER_DATA_WIDTH,
    WRITE_DEPTH_g             => 1024,
    READ_DEPTH_g              => (128/USER_DATA_WIDTH)*1024,
    FIRST_WORD_FALL_THROUGH_g => FALSE
  )
  port map
  (
    i_rst_p                   => RX_Fifo_Reset_s,
    i_wr_clk_p                => GTX_fifo_clk_s,
    i_rd_clk_p                => i_Fifo_User_Clock_p,
    iv_din_p                  => v_Aurora_RX_Data_s,
    i_wr_en_p                 => RX_Fifo_Write_Enable_s,
    i_rd_en_p                 => i_RX_Fifo_Read_Enable_p,
    iv_prog_empty_thresh_p    => iv16_RX_Fifo_Prog_Almost_Empty_Threshold_p,
    iv_prog_full_thresh_p     => iv16_RX_Fifo_Prog_Almost_Full_Threshold_p,
    ov_dout_p                 => ov_Fifo_RX_Data_p,
    o_full_p                  => RX_Fifo_Full_s,
    o_overflow_p              => RX_Fifo_Overflow_s,
    o_empty_p                 => RX_Fifo_Empty_s,
    o_valid_p                 => RX_Fifo_out_valid_s,
    o_underflow_p             => RX_Fifo_Underflow_s,
    ov_rd_data_count_p        => ov16_RX_Fifo_Read_Data_Count_p,
    ov_wr_data_count_p        => ov16_RX_Fifo_Write_Data_Count_p,
    o_prog_full_p             => RX_Fifo_Prog_Almost_Full_s,
    o_prog_empty_p            => RX_Fifo_Prog_Almost_Empty_s,
    o_almost_full_p           => open
  );

  u_fifo_TX : entity work.generic_fifo
  generic map
  (
    WRITE_WIDTH_g             => USER_DATA_WIDTH,
    READ_WIDTH_g              => 128,
    WRITE_DEPTH_g             => (128/USER_DATA_WIDTH)*1024,
    READ_DEPTH_g              => 1024,
    FIRST_WORD_FALL_THROUGH_g => TRUE
  )
  port map
  (
    i_rst_p                   => TX_Fifo_Reset_s,
    i_wr_clk_p                => i_Fifo_User_Clock_p,
    i_rd_clk_p                => GTX_fifo_clk_s,
    iv_din_p                  => iv_Fifo_TX_Data_p,
    i_wr_en_p                 => i_TX_Fifo_Write_Enable_p,
    i_rd_en_p                 => TX_Fifo_Read_Enable_s,
    iv_prog_empty_thresh_p    => iv16_TX_Fifo_Prog_Almost_Empty_Threshold_p,
    iv_prog_full_thresh_p     => iv16_TX_Fifo_Prog_Almost_Full_Threshold_p,
    ov_dout_p                 => v_Aurora_TX_Data_s,
    o_full_p                  => TX_Fifo_Full_s,
    o_overflow_p              => TX_Fifo_Overflow_s,
    o_empty_p                 => TX_Fifo_Empty_s,
    o_valid_p                 => TX_Fifo_out_valid_s,
    o_underflow_p             => TX_Fifo_Underflow_s,
    ov_rd_data_count_p        => ov16_TX_Fifo_Read_Data_Count_p,
    ov_wr_data_count_p        => ov16_TX_Fifo_Write_Data_Count_p,
    o_prog_full_p             => TX_Fifo_Prog_Almost_Full_s,
    o_prog_empty_p            => TX_Fifo_Prog_Almost_Empty_s,
    o_almost_full_p           => open
  );

end aurora_top_syn;
