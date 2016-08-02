
# Validate the Existence of BINGEN (For the binaryGenerator)
if {[info exists env(BINGEN)]} {
  set packagesfilesDir $env(BINGENCHECKOUTDIR)/projets/adp/fpga/packages
  set netlistDestCores $env(BinaryDir)/pcores
  set coresDir $env(BinaryDir)  
} else {
  set packagesfilesDir $env(ADPROOT)/fpga/packages
  set netlistDestCores $env(ADPROOT)/fpga/Nutaq_ip_cores/pcores
  set coresDir $env(ADPROOT)/fpga/netlist  
}
                                         

set srcCore1 $packagesfilesDir/rtdex_pkg.vhd

set NgcCore1 $coresDir/fifo16k_w32_async_fwft_tx.ngc
set NgcCore2 $coresDir/fifo8k_w32_async_fwft_tx.ngc
set NgcCore3 $coresDir/fifo4k_w32_async_fwft_tx.ngc
set NgcCore4 $coresDir/fifo2k_w32_async_fwft_tx.ngc
set NgcCore5 $coresDir/fifo1k_w32_async_fwft_tx.ngc
set NgcCore6 $coresDir/fifo16k_w32_async_rx.ngc
set NgcCore7 $coresDir/fifo8k_w32_async_rx.ngc
set NgcCore8 $coresDir/fifo4k_w32_async_rx.ngc
set NgcCore9 $coresDir/fifo2k_w32_async_rx.ngc
set NgcCore10 $coresDir/fifo1k_w32_async_rx.ngc
set NgcCore11 $coresDir/fifo_w37_d16.ngc
set NgcCore12 $coresDir/fifo_w37_d32.ngc
set NgcCore13 $coresDir/rtdex_tx_core.ngc
set NgcCore14 $coresDir/rtdex_mux_tx.ngc
set NgcCore15 $coresDir/rtdex_mux_rx.ngc
set NgcCore16 $coresDir/rtdex_rx_core.ngc
set NgcCore17 $coresDir/fifo32k_w32_async_rx.ngc
set NgcCore18 $coresDir/fifo32k_w32_async_fwft_tx.ngc
set NgcCore19 $coresDir/rtdex_pause_req_gen.ngc

set destcore $netlistDestCores/lyt_axi_emac_rtdex_v1_00_a

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist


file mkdir $vhdlRep
file mkdir $netlistRep


file copy -force $srcCore1 $vhdlRep
file copy -force $NgcCore1 $netlistRep
file copy -force $NgcCore2 $netlistRep
file copy -force $NgcCore3 $netlistRep
file copy -force $NgcCore4 $netlistRep
file copy -force $NgcCore5 $netlistRep
file copy -force $NgcCore6 $netlistRep
file copy -force $NgcCore7 $netlistRep
file copy -force $NgcCore8 $netlistRep
file copy -force $NgcCore9 $netlistRep
file copy -force $NgcCore10 $netlistRep
file copy -force $NgcCore11 $netlistRep
file copy -force $NgcCore12 $netlistRep
file copy -force $NgcCore13 $netlistRep
file copy -force $NgcCore14 $netlistRep
file copy -force $NgcCore15 $netlistRep
file copy -force $NgcCore16 $netlistRep
file copy -force $NgcCore17 $netlistRep
file copy -force $NgcCore18 $netlistRep
file copy -force $NgcCore19 $netlistRep