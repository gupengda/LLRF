------------------------------------------------------------------------------
-- lyt_axi_lvds_mbdk_gluelogic.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE USER_LOGIC ENTITY.
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          lyt_axi_lvds_mbdk_gluelogic.vhd
-- Version:           1.00.a
-- Description:       Top level design, instantiates library components and user logic.
-- Date:              Fri Nov 09 16:05:11 2012 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
--
--
-- Glue logic for lvds and RtDex LVDS mbdk demo
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lyt_axi_lvds_gluelogic is
  port
  (
		-- rtdex channel 0
		-- from host
		iv32_rtdex_RxDataCh0			: in 		std_logic_vector( 31 downto 0 );
		o_rtdex_RxReCh0				: out	   std_logic;
		i_rtdex_RxDataValidCh0		: in 		std_logic;
		-- to host
		ov32_rtdex_TxDataCh0			: out    std_logic_vector( 31 downto 0 );
		i_rtdex_TxReadyCh0			: in 		std_logic;
		o_rtdex_TxWeCh0				: out 	std_logic;
		-- 
		ov14_UserLvdsGroup0_p		: out 	std_logic_vector( 13 downto 0 );
		ov14_UserLvdsGroup1_p		: out 	std_logic_vector( 13 downto 0 );	
		iv14_UserLvdsGroup0_p		: in 		std_logic_vector( 13 downto 0 );
		iv14_UserLvdsGroup1_p		: in 		std_logic_vector( 13 downto 0 );
		--
		ov2_inWrEn_p 					: out		std_logic_vector( 1  downto 0 ); 
		iv2_inWrAck_p 					: in 		std_logic_vector( 1  downto 0 );
		ov2_outRdEn_p 					: out 	std_logic_vector( 1  downto 0 );
		iv2_outValid_p 				: in 		std_logic_vector( 1  downto 0 );
		iv2_empty_p 					: in 		std_logic_vector( 1  downto 0 );
		iv2_full_p 						: in		std_logic_vector( 1  downto 0 );
		
		clk								: in 		std_logic
  );

end entity lyt_axi_lvds_gluelogic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of lyt_axi_lvds_gluelogic is




signal sv16_rx1DataOut		: std_logic_vector(15 downto 0);
signal sv16_rx2DataOut		: std_logic_vector(15 downto 0);

signal sv16_tx1DataIn		: std_logic_vector(15 downto 0);
signal sv16_tx2DataIn		: std_logic_vector(15 downto 0);

signal rxFifoFull_1, 
		 rxFifoFull_2		   : std_logic;

signal rx1RdEn, rx2RdEn		: std_logic;

signal tx1Full, tx2Full		: std_logic;


signal debugCounter			: unsigned(31 downto 0) := (others => '0');


begin

		-- rtdex -> LVDS on Group 0
		ov14_UserLvdsGroup0_p		<= iv32_rtdex_RxDataCh0( 13 downto 0 );
		ov14_UserLvdsGroup1_p		<= ( others => '0' );
		
		o_rtdex_RxReCh0				<= not iv2_full_p(0);
		ov2_inWrEn_p(0)				<= i_rtdex_RxDataValidCh0;
		ov2_inWrEn_p(1)				<= '0';
				
		-- LVDS -> rtdex on group 1
		ov32_rtdex_TxDataCh0			<= "00" & x"0000" & iv14_UserLvdsGroup1_p;		
		ov2_outRdEn_p(0)				<= '0';
		ov2_outRdEn_p(1)				<= i_rtdex_TxReadyCh0;
		o_rtdex_TxWeCh0				<= iv2_outValid_p(1);





end IMP;
