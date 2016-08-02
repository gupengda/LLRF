
# Validate the Existence of BINGEN (For the binaryGenerator)
if {[info exists env(BINGEN)]} {
  set packagesfilesDir $env(BINGENCHECKOUTDIR)/projets/adp/fpga/packages
  set netlistDestCores $env(BinaryDir)/pcores
  set coresDir $env(BinaryDir)
  set mmcmDir $env(BINGENCHECKOUTDIR)projets/adp/fpga/cores_src/mmcm_calib
} else {
  set packagesfilesDir $env(ADPROOT)/fpga/packages
  set netlistDestCores $env(ADPROOT)/fpga/Nutaq_ip_cores/pcores
  set coresDir $env(ADPROOT)/fpga/netlist
  set mmcmDir   $env(ADPROOT)/fpga/cores_src/mmcm_calib
}

set srcCore1 $packagesfilesDir/Bustestout_wrapper_p.vhd
set srcCore2 $coresDir/Bustestout_wrapper.ngc

set destcore $netlistDestCores/lyt_BusTestOut_v1_00_a

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist

file mkdir $vhdlRep
file mkdir $netlistRep


file copy -force $srcCore1 $vhdlRep
file copy -force $srcCore2 $netlistRep
