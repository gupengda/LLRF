
# Validate the Existence of BINGEN (For the binaryGenerator)
if {[info exists env(BINGEN)]} {  
  set netlistDestCores $env(BinaryDir)/pcores
  set coresDir $env(BinaryDir)  
} else {  
  set netlistDestCores $env(ADPROOT)/fpga/Nutaq_ip_cores/pcores
  set coresDir $env(ADPROOT)/fpga/netlist  
}
set srcCore1 $coresDir/fifo_async_w64_d16.ngc



set destcore $netlistDestCores/lyt_pps_sync_v1_00_a


set netlistRep $destcore/netlist


file mkdir $netlistRep


file copy -force $srcCore1 $netlistRep


set netlistRep $destcore/netlist
