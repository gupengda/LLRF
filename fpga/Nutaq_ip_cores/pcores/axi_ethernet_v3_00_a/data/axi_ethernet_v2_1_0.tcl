###############################################################################
##
## Copyright (c) 2007 Xilinx, Inc. All Rights Reserved.
##
## axi_ethernet_v2_1_0.tcl
##
###############################################################################

## @BEGIN_CHANGELOG EDK_K_SP2
##
## - added more checks for PHY interface ports
##
## @END_CHANGELOG


## @BEGIN_CHANGELOG EDK_Jm
##
## - initial 1.00a version
##
## @END_CHANGELOG

#***--------------------------------***-----------------------------------***
#
#          IPLEVEL_DRC_PROC
#
#***--------------------------------***-----------------------------------***

#-----------------------------------------
# C_TYPE = 0 - Soft TEMAC 10/100 Mbps
# C_TYPE = 1 - Soft TEMAC 10/100/1000 Mbps
# C_TYPE = 2 - V6 Hard TEMAC
#-----------------------------------------
proc check_iplevel_settings {mhsinst} {

    set device  [xget_hw_parameter_value $mhsinst "C_FAMILY" ]
    set type    [xget_hw_parameter_value $mhsinst "C_TYPE"]

    if {[string length $device] == 0} {
  return
    }

    if {[string compare -nocase $device "virtex6"] == 0} {

        # if device is V6, C_TYPE = 0 or 1 or 2

    } elseif {[string compare -nocase $device "virtex6l"] == 0} {
        # if device is V6, C_TYPE = 0 or 1 or 2
    } elseif {[string compare -nocase $device "qvirtex6"] == 0} {
        # if device is V6, C_TYPE = 0 or 1 or 2
    } else {

  # if device is S6, C_TYPE = 0 or C_TYPE = 1
  if {$type != 0 && $type != 1} {

      error "\n The parameter C_TYPE can only be 0 or 1 (soft, licence required) for [string toupper $device] architecture and you are using C_TYPE of $type.\n" "" "mdt_error"

  }
    }
}


#***--------------------------------***------------------------------------***
#
#          SYSLEVEL_DRC_PROC
#
#***--------------------------------***------------------------------------***

# check the connectivity of GMII_*_0 ports
# if  C_PHY_TYPE=1 and C_INCLUDE_IO=1 then
#   ports GMII_* much be connected to a top level net
#
proc check_syslevel_settings { mhsinst } {

    set phy_type   [xget_hw_parameter_value $mhsinst "C_PHY_TYPE"]
    set incld_io   [xget_hw_parameter_value $mhsinst "C_INCLUDE_IO"]

    if {$phy_type == 0 && $incld_io == 1} {

        set portList {MII_TXD MII_TX_EN MII_TX_ER MII_TX_CLK MII_RXD MII_RX_DV MII_RX_ER MII_RX_CLK}

  # MII_* should be connected to top level
        check_ports_connectivity $mhsinst $portList

    }

    if {$phy_type == 1 && $incld_io == 1} {

        set portList {GMII_TXD GMII_TX_EN GMII_TX_ER GMII_TX_CLK MII_TX_CLK GMII_RXD GMII_RX_DV GMII_RX_ER GMII_RX_CLK}

  # GMII_* should be connected to top level
        check_ports_connectivity $mhsinst $portList

    }

    if {$phy_type == 2 && $incld_io == 1} {

        set portList {RGMII_TXD RGMII_TX_CTL RGMII_TXC RGMII_RXD RGMII_RX_CTL RGMII_RXC}

  # RGMII_* should be connected to top level
        check_ports_connectivity $mhsinst $portList

    }

    if {$phy_type == 3 && $incld_io == 1} {

        set portList {RGMII_TXD RGMII_TX_CTL RGMII_TXC RGMII_RXD RGMII_RX_CTL RGMII_RXC}

  # RGMII_* should be connected to top level
        check_ports_connectivity $mhsinst $portList

    }

}

proc check_ports_connectivity {mhsinst portList} {

    foreach portname $portList {

# append portname $ext
        set    globalList [xget_connected_global_ports $mhsinst $portname]

        if { [llength $globalList] == 0 } {

            error  "\n The port $portname is not connected directly to an external port.\n" "" "mdt_error"

        }
    }
}


#***--------------------------------***-----------------------------------***
#
#     PLATGEN_SYSLEVEL_UPDATE_PROC
#
#***--------------------------------***-----------------------------------***

## This automatically generates constraints

proc generate_corelevel_ucf {mhsinst} {
    set filePath [xget_ncf_dir $mhsinst]
    file mkdir $filePath

    # specify file name
    set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set    name_lower [string   tolower   $instname]

    set    fileName   $name_lower
    append fileName   "_wrapper.ucf"
    append filePath   $fileName

    # Open a file for writing
    set outputFile [open $filePath "w"]

    set what_is_family [xget_hw_parameter_value $mhsinst "C_FAMILY"]

    set soft_or_hard_temac [xget_hw_parameter_value $mhsinst "C_TYPE"]

    set what_is_phy_interface [xget_hw_parameter_value $mhsinst "C_PHY_TYPE"]

    set avb_present [xget_hw_parameter_value $mhsinst "C_AVB"]

    set include_io [xget_hw_parameter_value $mhsinst "C_INCLUDE_IO"]

    set s6_transceiver [xget_hw_parameter_value $mhsinst "C_TRANS"]

    set axi_lite_aclk_freq [xget_hw_parameter_value $mhsinst "C_S_AXI_ACLK_FREQ_HZ"]
    set axi_lite_aclk_period_ps [expr 1000000000000 / $axi_lite_aclk_freq]

    set axi_stream_tx_aclk_freq [xget_hw_parameter_value $mhsinst "C_AXI_STR_TXC_ACLK_FREQ_HZ"]
    set axi_stream_tx_aclk_period_ps [expr 1000000000000 / $axi_stream_tx_aclk_freq]

    if {[xstrncmp $what_is_family "spartan6"] || [xstrncmp $what_is_family "spartan6t"] || [xstrncmp $what_is_family "spartan6l"] || [xstrncmp $what_is_family "qspartan6t"] || [xstrncmp $what_is_family "aspartan6t"] || [xstrncmp $what_is_family "aspartan6"] || [xstrncmp $what_is_family "qspartan6l"]} {
    puts $outputFile "# axi_ethernet: Base family is spartan6"
        if { $avb_present == 0} {
        puts $outputFile "# axi_ethernet: AVB is not present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 40000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 40000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*mii_interface/mii_txd*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_en\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_er\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 38800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 40000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 40000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*mii_interface/mii_txd*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_en\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_er\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 38800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "PIN \"*CLOCK_INST/BUFGMUX_SPEED_CLK.I1\" TIG;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*gmii_txd*\"  IOB = force;"
                        puts $outputFile "INST \"*gmii_tx_en\" IOB = force;"
                        puts $outputFile "INST \"*gmii_tx_er\" IOB = force;"
                        puts $outputFile "INST \"*rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_gtx\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"RGMII_RXC\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMEGRP \"receiver_clock\" = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"receiver_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_gtx\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "# axi_ethernet: Using Internal GMII to PCS/PMA"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    puts $outputFile "NET \"*/pcspma_clkin\" TNM_NET = \"clkin\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_clkin\" = PERIOD \"clkin\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_gtclkout\" TNM_NET = \"xcvr_clkout\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtpclkout\" = PERIOD \"xcvr_clkout\" 8000 ps HIGH 50 %;"
                    if { [xstrncmp $s6_transceiver "A"]} {
                      puts $outputFile "# axi_ethernet: Using Spartan 6 Transceiver A"
                      puts $outputFile "NET \"*I_GIG_ETH_PCS_PMA_CORE_A/transceiver_inst/rxrecclk0\" TNM_NET = \"rxrecclk0\";"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rxrecclk0\" = PERIOD \"rxrecclk0\" 8 ns;"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_A/transceiver_inst/clock_correction_A/rd_addr_plus1*\" TNM = \"wr_graycode0\";"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_A/transceiver_inst/clock_correction_A/wr_addr_gray*\" TNM = \"wr_graycode0\";"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_A/transceiver_inst/clock_correction_A/rd_addr_gray*\" TNM = \"rd_graycode0\";"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rx0_skew_control1\" = FROM \"wr_graycode0\" TO \"FFS\" 6 ns DATAPATHONLY;"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rx0_skew_control2\" = FROM \"rd_graycode0\" TO \"FFS\" 6 ns DATAPATHONLY;"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_A/transceiver_inst/rxrecclkreclock0/data_sync\" TNM = \"rxrecclk0_sample\";"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_A/transceiver_inst/rxrstreclock0/reset_sync?\" TNM = \"rxrecclk0_sample\";"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rxrecclk0_sample\" = FROM \"FFS\" TO \"rxrecclk0_sample\" 6 ns DATAPATHONLY;"
                    } else {
                      puts $outputFile "# axi_ethernet: Using Spartan 6 Transceiver B"
                      puts $outputFile "NET \"*I_GIG_ETH_PCS_PMA_CORE_B/transceiver_inst/rxrecclk1\" TNM_NET = \"rxrecclk1\";"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rxrecclk1\" = PERIOD \"rxrecclk1\" 8 ns;"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_B/transceiver_inst/clock_correction_B/rd_addr_plus1*\" TNM = \"wr_graycode1\";"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_B/transceiver_inst/clock_correction_B/wr_addr_gray*\" TNM = \"wr_graycode1\";"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_B/transceiver_inst/clock_correction_B/rd_addr_gray*\" TNM = \"rd_graycode1\";"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rx1_skew_control1\" = FROM \"wr_graycode1\" TO \"FFS\" 6 ns DATAPATHONLY;"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rx1_skew_control2\" = FROM \"rd_graycode1\" TO \"FFS\" 6 ns DATAPATHONLY;"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_B/transceiver_inst/rxrecclkreclock1/data_sync\" TNM = \"rxrecclk1_sample\";"
                      puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE_B/transceiver_inst/rxrstreclock1/reset_sync?\" TNM = \"rxrecclk1_sample\";"
                      puts $outputFile "TIMESPEC \"TS_${instname}_rxrecclk1_sample\" = FROM \"FFS\" TO \"rxrecclk1_sample\" 6 ns DATAPATHONLY;"
                    }
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                      puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                      puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "# axi_ethernet: Using Internal GMII to PCS/PMA"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    puts $outputFile "NET \"*/pcspma_clkin\" TNM_NET = \"clkin\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_clkin\" = PERIOD \"clkin\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_gtclkout\" TNM_NET = \"xcvr_clkout\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtpclkout\" = PERIOD \"xcvr_clkout\" 8000 ps HIGH 50 %;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                      puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                      puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: V6 hard TEMAC, C_TYPE = 6, 10/100/1000 Mbps is not supported in spartan6"
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } elseif { $avb_present == 1} {
        puts $outputFile "# axi_ethernet: AVB is present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: V6 hard TEMAC, C_TYPE = 6, 10/100/1000 Mbps is not supported in spartan6"
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } else {
        puts $outputFile "# axi_ethernet: Unsupported C_AVB value $avb_present "
        }
    } elseif  {[xstrncmp $what_is_family "virtex6"] || [xstrncmp $what_is_family "virtex6lx"] || [xstrncmp $what_is_family "virtex6sx"] || [xstrncmp $what_is_family "virtex6hx"] || [xstrncmp $what_is_family "virtex6cx"] || [xstrncmp $what_is_family "virtex6llx"] || [xstrncmp $what_is_family "virtex6lsx"] || [xstrncmp $what_is_family "qvirtex6lx"] || [xstrncmp $what_is_family "qvirtex6sx"] || [xstrncmp $what_is_family "qvirtex6fx"] || [xstrncmp $what_is_family "qvirtex6tx"]} {
    puts $outputFile "# axi_ethernet: Base family is virtex6"
        if { $avb_present == 0} {
        puts $outputFile "# axi_ethernet: AVB is not present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 40000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 40000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*mii_interface/mii_txd*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_en\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_er\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 38800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 40000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 40000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*mii_interface/mii_txd*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_en\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/mii_tx_er\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface/rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 38800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                 } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "PIN \"*CLOCK_INST/BUFGMUX_SPEED_CLK.I1\" TIG;"
                    puts $outputFile "PIN \"*CLOCK_INST/BUFGMUX_SPEED_CLK.CE0\" TIG;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "NET \"REF_CLK\" TNM_NET = \"clk_ref_clk\";"
                    puts $outputFile "TIMEGRP \"ref_clk\" = \"clk_ref_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ref_clk\" = PERIOD \"ref_clk\" 5 ns HIGH 50 %;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*gmii_txd*\"  IOB = force;"
                        puts $outputFile "INST \"*gmii_tx_en\" IOB = force;"
                        puts $outputFile "INST \"*gmii_tx_er\" IOB = force;"
                        puts $outputFile "INST \"*rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_gtx\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_REF_CLK\"     = FROM \"axistream_clk\"  TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_ref_clk\"    TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_REF_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_ref_clk\"    TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"RGMII_RXC\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMEGRP \"receiver_clock\" = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"receiver_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "NET \"REF_CLK\" TNM_NET = \"clk_ref_clk\";"
                    puts $outputFile "TIMEGRP \"ref_clk\" = \"clk_ref_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ref_clk\" = PERIOD \"ref_clk\" 5 ns HIGH 50 %;"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_gtx\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_REF_CLK\"     = FROM \"axistream_clk\"  TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_ref_clk\"    TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_REF_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_ref_clk\"    TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "# axi_ethernet: Using Internal GMII to PCS/PMA"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    puts $outputFile "NET \"*/pcspma_clkin\" TNM_NET = \"mgtrefclk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mgtrefclk\" = PERIOD \"mgtrefclk\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_gtclkout\" TNM_NET = \"xcvr_clkout\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_txoutclk\" = PERIOD \"xcvr_clkout\" 8000 ps HIGH 50 %;"
                    puts $outputFile "# axi_ethernet: Using Virtex 6 Transceiver"
                    puts $outputFile "NET \"*I_GIG_ETH_PCS_PMA_CORE/transceiver_inst/RXRECCLK\" TNM_NET = \"rxrecclk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rxrecclk\" = PERIOD \"rxrecclk\" 8 ns;"
                    puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE/transceiver_inst/rx_elastic_buffer_inst/wr_addr_gray*\" TNM = \"wr_graycode\";"
                    puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE/transceiver_inst/rx_elastic_buffer_inst/rd_addr_gray*\" TNM = \"rd_graycode\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_skew_control1\" = FROM \"wr_graycode\" TO \"FFS\" 14 ns DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_skew_control2\" = FROM \"rd_graycode\" TO \"FFS\" 14 ns DATAPATHONLY;"
                    puts $outputFile "INST \"*I_GIG_ETH_PCS_PMA_CORE/transceiver_inst/rx_elastic_buffer_inst/rd_data*\" TNM = \"fifo_read\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ram_read_false_path\" = FROM \"RAMS\" TO \"fifo_read\" 6 ns DATAPATHONLY;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_userclk2\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    puts $outputFile "NET \"*/pcspma_clkin\" TNM_NET = \"mgtrefclk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mgtrefclk\" = PERIOD \"mgtrefclk\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/pcspma_gtclkout\" TNM_NET = \"xcvr_clkout\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_txoutclk\" = PERIOD \"xcvr_clkout\" 8000 ps HIGH 50 %;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                      puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                      puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                      puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: Using V6 hard TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"phy_clk_tx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_phy_tx\" = \"phy_clk_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_phy_tx\" = PERIOD \"v6_emac_v2_1_clk_phy_tx\" 40000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"phy_clk_rx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_phy_rx\" = \"phy_clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_phy_rx\" = PERIOD \"v6_emac_v2_1_clk_phy_rx\" 40000 ps HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_ref_gtx\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_ref_gtx\" = PERIOD \"v6_emac_v2_1_clk_ref_gtx\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 %;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*mii_interface?rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*mii_interface?rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface?rx_er_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*mii_interface?mii_txd_?\"    IOB = force;"
                        puts $outputFile "INST \"*mii_interface?mii_tx_en\"    IOB = force;"
                        puts $outputFile "INST \"*mii_interface?mii_tx_er\"    IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\"  TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"   TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"phy_clk_rx\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"phy_clk_rx\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"phy_clk_tx\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"phy_clk_tx\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"phy_clk_rx\"     TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"phy_clk_tx\"     TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"phy_clk_rx\"     TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"

                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"phy_clk_rx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_phy_rx\" = \"phy_clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_phy_rx\" = PERIOD \"v6_emac_v2_1_clk_phy_rx\" 7.5 ns HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_ref_gtx\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_ref_gtx\" = PERIOD \"v6_emac_v2_1_clk_ref_gtx\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"phy_clk_tx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_ref_mux\" = \"phy_clk_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_ref_mux\" = PERIOD \"v6_emac_v2_1_clk_ref_mux\" TS_${instname}_v6_emac_v2_1_clk_ref_gtx HIGH 50%;"
                    puts $outputFile "PIN \"*bufgmux_speed_clk.I1\" TIG;"
                    puts $outputFile "PIN \"*bufgmux_speed_clk.CE0\" TIG;"
                    puts $outputFile "NET \"REF_CLK\" TNM_NET = \"clk_ref_clk\";"
                    puts $outputFile "TIMEGRP \"ref_clk\" = \"clk_ref_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ref_clk\" = PERIOD \"ref_clk\" 5 ns HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 %;"
                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                        puts $outputFile "INST \"*gmii_interface/rxd_to_mac*\"  IOB = force;"
                        puts $outputFile "INST \"*gmii_interface/rx_dv_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*gmii_interface/rx_er_to_mac\" IOB = force;"
                        puts $outputFile "INST \"*gmii_interface*gmii_txd_?\"   IOB = force;"
                        puts $outputFile "INST \"*gmii_interface*gmii_tx_en\"   IOB = force;"
                        puts $outputFile "INST \"*gmii_interface*gmii_tx_er\"   IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\"  TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"   TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"phy_clk_rx\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"phy_clk_rx\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"phy_clk_tx\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"phy_clk_tx\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"phy_clk_rx\"     TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"phy_clk_tx\"     TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"phy_clk_rx\"     TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_REF_CLK\"     = FROM \"axistream_clk\"  TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_ref_clk\"    TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_REF_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_ref_clk\"    TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"                  
                    puts $outputFile "NET \"*/tx_mac_aclk*\" TNM_NET = \"phy_clk_tx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_phy_tx\" = \"phy_clk_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_phy_tx\" = PERIOD \"v6_emac_v2_1_clk_phy_tx\" 8 ns HIGH 50%;"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"phy_clk_rx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_phy_rx\" = \"phy_clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_phy_rx\" = PERIOD \"v6_emac_v2_1_clk_phy_rx\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_ref_gtx\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_ref_gtx\" = PERIOD \"v6_emac_v2_1_clk_ref_gtx\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 %;"
                    puts $outputFile "NET \"REF_CLK\" TNM_NET = \"clk_ref_clk\";"
                    puts $outputFile "TIMEGRP \"ref_clk\" = \"clk_ref_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ref_clk\" = PERIOD \"ref_clk\" 5 ns HIGH 50 %;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\"  TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"   TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"phy_clk_rx\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"phy_clk_rx\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"phy_clk_tx\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"phy_clk_tx\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"phy_clk_rx\"     TO \"phy_clk_tx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"phy_clk_tx\"     TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"phy_clk_rx\"     TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"phy_clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_REF_CLK\"     = FROM \"axistream_clk\"  TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_ref_clk\"    TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_REF_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_ref_clk\"    TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/clk_ds\" TNM_NET = \"mgt_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_mgt_clk\" = PERIOD \"mgt_clk\" 8.000 ns HIGH 50 % INPUT_JITTER 50.0ps;"
                    puts $outputFile "NET \"*/gen_sgmii.clk125_out\" TNM_NET = \"clk_gt_clk\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_gt_clk\" = \"clk_gt_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_gt_clk\" = PERIOD \"v6_emac_v2_1_gt_clk\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_axi_clk_out\" TNM_NET = \"clk_user\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_gt_clk_user\" = \"clk_user\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_gt_clk_user\" = PERIOD \"v6_emac_v2_1_gt_clk_user\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 %;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_clk_ref_gtx\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_clk_ref_gtx\" = PERIOD \"v6_emac_v2_1_clk_ref_gtx\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"*v6_gtxwizard_top_inst?RXRECCLK\" TNM_NET = \"clk_rec_clk\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_user_rec_clk\" = \"clk_rec_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_user_rec_clk\" = PERIOD \"v6_emac_v2_1_user_rec_clk\" 8 ns HIGH 50 %;"
                    puts $outputFile "INST \"*v6_gtxwizard_top_inst?rx_elastic_buffer_inst?rd_addr_gray_?\"   TNM = \"rx_elastic_rd_to_wr\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_elastic_rd_to_wr\"         = FROM \"rx_elastic_rd_to_wr\" TO \"clk_rec_clk\"   7.5 ns DATAPATHONLY;"
                    puts $outputFile "INST \"*v6_gtxwizard_top_inst?rx_elastic_buffer_inst?wr_addr_gray_?\"   TNM = \"elastic_metastable\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_elastic_meta_protect\"         = FROM \"elastic_metastable\" 5 ns DATAPATHONLY;"
                    puts $outputFile "INST \"*v6_gtxwizard_top_inst?rx_elastic_buffer_inst?rd_data*\"   TNM = \"fifo_read\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ram_read_false_path\"         = FROM \"RAMS\" TO \"fifo_read\" 8 ns DATAPATHONLY;"
                    puts $outputFile "INST \"*v6_gtxwizard_top_inst?rx_elastic_buffer_inst?rd_wr_addr_gray*\"   TNM = \"rx_graycode\";"
                    puts $outputFile "INST \"*v6_gtxwizard_top_inst?rx_elastic_buffer_inst?rd_occupancy*\"      TNM = \"rx_binary\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_buf_meta_protect\"         = FROM \"rx_graycode\" TO \"rx_binary\" 5 ns DATAPATHONLY;"                    
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\"  TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"   TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_USERCLK\"     = FROM \"axistream_clk\"  TO \"clk_user\"      8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_USERCLK_2_AXISTREAMCLKS\"     = FROM \"clk_user\"       TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_USERCLK\"      = FROM \"axi4lite_clk\"   TO \"clk_user\"      8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_USERCLK_2_AXI4LITECLKS\"      = FROM \"clk_user\"       TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_USERCLK_2_GTX_CLK\"           = FROM \"clk_user\"       TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_USERCLK\"           = FROM \"clk_gtx\"        TO \"clk_user\"      8000  ps DATAPATHONLY;"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/clk_ds\" TNM_NET = \"mgt_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_mgt_clk\" = PERIOD \"mgt_clk\" 8.000 ns HIGH 50 % INPUT_JITTER 50.0ps;"
                    puts $outputFile "NET \"*/gen_1000bx.clk125_out\" TNM_NET = \"glbl125_clk\";"
                    puts $outputFile "TIMEGRP \"v6_emac_v2_1_gt_clk\" = \"glbl125_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_v6_emac_v2_1_gt_clk\" = PERIOD \"v6_emac_v2_1_gt_clk\" 8 ns HIGH 50 %;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 %;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\"  TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"   TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GLBL_125CLK\" = FROM \"axistream_clk\"  TO \"glbl125_clk\"   8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GLBL_125CLK_2_AXISTREAMCLKS\" = FROM \"glbl125_clk\"    TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_GLBL_125CLK\"  = FROM \"axi4lite_clk\"   TO \"glbl125_clk\"   8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GLBL_125CLK_2_AXI4LITECLKS\"  = FROM \"glbl125_clk\"    TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"               
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } elseif { $avb_present == 1} {
        puts $outputFile "# axi_ethernet: AVB is present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: Using V6 hard TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } else {
        puts $outputFile "# axi_ethernet: Unsupported C_AVB value $avb_present "
        }
    } elseif  {[xstrncmp $what_is_family "kintex7"]} {
    puts $outputFile "# axi_ethernet: Base family is kintex7"
        if { $avb_present == 0} {
        puts $outputFile "# axi_ethernet: AVB is not present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"

                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"axi4lite_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_TXC_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXD_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"AXI_STR_RXS_ACLK\" TNM_NET = \"axistream_clk\";"
                    puts $outputFile "NET \"*/rx_mac_aclk_int\" TNM_NET = \"clk_rx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_rx_clk\" = PERIOD \"clk_rx\" 8000 ps HIGH 50 %;"
                    puts $outputFile "PIN \"*CLOCK_INST/BUFGMUX_SPEED_CLK.I1\" TIG;"
                    puts $outputFile "NET \"GTX_CLK\" TNM_NET = \"clk_gtx\";"
                    puts $outputFile "TIMEGRP \"gtx_clock\" = \"clk_gtx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_gtx_clk\" = PERIOD \"gtx_clock\" 8000 ps HIGH 50 %;"
                    puts $outputFile "NET \"*/tx_mac_aclk_int\" TNM_NET = \"clk_tx_mac\";"
                    puts $outputFile "TIMEGRP \"tx_mac_clk\" = \"clk_tx_mac\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_tx_mac_clk\" = PERIOD \"tx_mac_clk\" 8000 ps HIGH 50%;"
                    puts $outputFile "NET \"S_AXI_ACLK\" TNM_NET = \"host_clk\";"
                    puts $outputFile "TIMEGRP \"host\" = \"host_clk\" EXCEPT \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_host_clk\" = PERIOD \"host\" ${axi_lite_aclk_period_ps} PS HIGH 50 % PRIORITY 10;"
                    puts $outputFile "NET \"REF_CLK\" TNM_NET = \"clk_ref_clk\";"
                    puts $outputFile "TIMEGRP \"ref_clk\" = \"clk_ref_clk\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_ref_clk\" = PERIOD \"ref_clk\" 5 ns HIGH 50 %;"

                    if { $include_io == 1} {
                    puts $outputFile "# axi_ethernet: Using IOBs"
                      puts $outputFile "INST \"*gmii_txd*\"  IOB = force;"
                      puts $outputFile "INST \"*gmii_tx_en\" IOB = force;"
                      puts $outputFile "INST \"*gmii_tx_er\" IOB = force;"
                      puts $outputFile "INST \"*rxd_to_mac*\"  IOB = force;"
                      puts $outputFile "INST \"*rx_dv_to_mac\" IOB = force;"
                      puts $outputFile "INST \"*rx_er_to_mac\" IOB = force;"
                    } else {
                    puts $outputFile "# axi_ethernet: Not using IOBs"
                    }
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_REQ_TO_TX\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "INST \"*/FLOW/RX_PAUSE/PAUSE_VALUE_TO_TX*\" TNM=\"flow_rx_to_tx\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_tx_mac\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_flow_rx_to_tx\" = FROM \"flow_rx_to_tx\" TO \"clk_gtx\" 7800 ps DATAPATHONLY;"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN/PHY/ENABLE_REG\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?READY_INT\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?STATE_COUNT*\" TNM = FFS \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_TRISTATE\" TNM = \"mdio_logic\";"
                    puts $outputFile "INST \"*/MANIFGEN?MANAGEN?PHY?MDIO_OUT\" TNM = \"mdio_logic\";"
                    puts $outputFile "TIMESPEC \"TS_${instname}_mdio\" = PERIOD \"mdio_logic\" 400000 ps PRIORITY 0;"
                    if { $axi_stream_tx_aclk_period_ps == $axi_lite_aclk_period_ps} {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are the same so no need for clock domain crossing constraints"
                    } else {
                    puts $outputFile "# axi_ethernet: AXIStream and AXI Lite clocks are not the same so we need clock domain crossing constraints"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_AXI4LITECLKS\" = FROM \"axistream_clk\" TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                        puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_AXISTREAMCLKS\" = FROM \"axi4lite_clk\"  TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    }
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_RX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_rx\"         TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_RX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_rx\"         TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_TX_MAC_ACLK\" = FROM \"axistream_clk\"  TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXISTREAMCLKS\" = FROM \"clk_tx_mac\"     TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITECLKS_2_TX_MAC_ACLK\"  = FROM \"axi4lite_clk\"   TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_AXI4LITECLKS\"  = FROM \"clk_tx_mac\"     TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_GTX_CLK\"     = FROM \"axistream_clk\"  TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_gtx\"        TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_GTX_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_gtx\"        TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_TX_MAC_ACLK\"   = FROM \"clk_rx\"         TO \"clk_tx_mac\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_TX_MAC_ACLK_2_RX_MAC_ACLK\"   = FROM \"clk_tx_mac\"     TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_RX_MAC_ACLK_2_GTX_CLK\"       = FROM \"clk_rx\"         TO \"clk_gtx\"       8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_GTX_CLK_2_RX_MAC_ACLK\"       = FROM \"clk_gtx\"        TO \"clk_rx\"    8000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXISTREAMCLKS_2_REF_CLK\"     = FROM \"axistream_clk\"  TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXISTREAMCLKS\"     = FROM \"clk_ref_clk\"    TO \"axistream_clk\" ${axi_stream_tx_aclk_period_ps} PS DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_AXI4LITE_CLK_2_REF_CLK\"      = FROM \"axi4lite_clk\"   TO \"clk_ref_clk\"   5000  ps DATAPATHONLY;"
                    puts $outputFile "TIMESPEC \"TS_${instname}_REF_CLK_2_AXI4LITE_CLK\"      = FROM \"clk_ref_clk\"    TO \"axi4lite_clk\"  ${axi_lite_aclk_period_ps} PS DATAPATHONLY;"

                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: V6 hard TEMAC, C_TYPE = 6, 10/100/1000 Mbps is not supported in kintex7"
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } elseif { $avb_present == 1} {
        puts $outputFile "# axi_ethernet: AVB is present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: V6 hard TEMAC, C_TYPE = 6, 10/100/1000 Mbps is not supported in kintex7"
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } else {
        puts $outputFile "# axi_ethernet: Unsupported C_AVB value $avb_present "
        }
    } elseif  {[xstrncmp $what_is_family "virtex7"]} {
    puts $outputFile "# axi_ethernet: Base family is virtex7"
        if { $avb_present == 0} {
        puts $outputFile "# axi_ethernet: AVB is not present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: V6 hard TEMAC, C_TYPE = 6, 10/100/1000 Mbps is not supported in virtex7"
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } elseif { $avb_present == 1} {
        puts $outputFile "# axi_ethernet: AVB is present"
            if { $soft_or_hard_temac == 0} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: PHY interface GMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: PHY interface RGMII v2.0 is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: PHY interface SGMII is not supported in soft TEMAC 10/100 Mbps mode"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: PHY interface 1000BASE-X is not supported in soft TEMAC 10/100 Mbps mode"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 1} {
            puts $outputFile "# axi_ethernet: Using soft TEMAC 10/100/1000 Mbps"
                if { $what_is_phy_interface == 0} {
                puts $outputFile "# axi_ethernet: Using PHY interface MII"
                } elseif  { $what_is_phy_interface == 1} {
                puts $outputFile "# axi_ethernet: Using PHY interface GMII"
                } elseif  { $what_is_phy_interface == 3} {
                puts $outputFile "# axi_ethernet: Using PHY interface RGMII v2.0"
                } elseif  { $what_is_phy_interface == 4} {
                puts $outputFile "# axi_ethernet: Using PHY interface SGMII"
                } elseif  { $what_is_phy_interface == 5} {
                puts $outputFile "# axi_ethernet: Using PHY interface 1000BASE-X"
                } else {
                puts $outputFile "# axi_ethernet: Unsupported C_PHY_TYPE value $what_is_phy_interface "
                }
            } elseif  { $soft_or_hard_temac == 2} {
            puts $outputFile "# axi_ethernet: V6 hard TEMAC, C_TYPE = 6, 10/100/1000 Mbps is not supported in virtex7"
            } else {
            puts $outputFile "# axi_ethernet: Unsupported C_TYPE value $soft_or_hard_temac "
            }
        } else {
        puts $outputFile "# axi_ethernet: Unsupported C_AVB value $avb_present "
        }
    } else {
    puts $outputFile "# axi_ethernet: Unsupported C_FAMILY value $what_is_family "
    }
    puts $outputFile "#"
    puts $outputFile "#"
    puts $outputFile "\n"

    # Close the file
    close $outputFile
}
