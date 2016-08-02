
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

set NgcCore1 $coresDir/fifo32w16d.ngc

set destcore $netlistDestCores/lyt_lvds_sync_v1_00_a

set netlistRep $destcore/netlist

file mkdir $netlistRep

#copy netlist to pcore
file copy -force $NgcCore1 $netlistRep
