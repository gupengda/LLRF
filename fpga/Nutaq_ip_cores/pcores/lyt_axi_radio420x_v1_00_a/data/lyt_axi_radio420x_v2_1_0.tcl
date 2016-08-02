
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



set srcCore1 $coresDir/radio420x_fifo1k_18b_async.ngc
#calibration netlist
set srcCore2 $coresDir/radio420x_iqcomp12b_netlist.ngc
set srcCore3 $coresDir/radio420x_rxerrorfunc12b_netlist_cw.ngc


set destcore $netlistDestCores/lyt_axi_radio420x_v1_00_a

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist

file mkdir $vhdlRep
file mkdir $netlistRep


file copy -force $srcCore1 $netlistRep

file copy -force $srcCore2 $netlistRep
file copy -force $srcCore3 $netlistRep

set ucfFile4 "lyt_axi_radio420x_ch2_lx240_sx315_v2_1_0.ucf" 
set ucfFile3 "lyt_axi_radio420x_ch2_lx550_sx475_v2_1_0.ucf" 
set ucfFile2 "lyt_axi_radio420x_ch1_lx240_sx315_v2_1_0.ucf" 
set ucfFile1 "lyt_axi_radio420x_ch1_lx550_sx475_v2_1_0.ucf" 

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist
set dataSrc $destcore/data

set srcUcf4 $dataSrc/$ucfFile4 
set srcUcf3 $dataSrc/$ucfFile3 
set srcUcf2 $dataSrc/$ucfFile2 
set srcUcf1 $dataSrc/$ucfFile1 
set dstUcf ucf

file mkdir $dstUcf

file copy -force $srcUcf4 $dstUcf/$ucfFile4
file copy -force $srcUcf3 $dstUcf/$ucfFile3
file copy -force $srcUcf2 $dstUcf/$ucfFile2
file copy -force $srcUcf1 $dstUcf/$ucfFile1



proc generate_corelevel_ucf {mhsinst} {

    set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set    channel2   [xget_hw_parameter_value $mhsinst "C_FMCRADIO_CH2"]
    set    ipname     [xget_hw_option_value    $mhsinst "IPNAME"]
    set    name_lower [string   tolower   $instname]
    set    radioCh2   [string   tolower   $channel2]
    set    folderName [string   tolower   $instname]
    append folderName "_wrapper"
    set    folderName implementation/$folderName 
    file   mkdir      $folderName    
    set    fileName   $name_lower
    append fileName   "_wrapper.ucf"
    set    filePath   $folderName/$fileName

    # Open a file for writing
    set    outputFile [open $filePath "w"]

    set xmpFileName [glob -type f *{.xmp}*]
    
    set xmpFile [open $xmpFileName "r"]
    
    set xmpFileStr [read $xmpFile]
    
    set data [split $xmpFileStr "\n"]
    
    set deviceFileName "" 
    
    if [string match "0" $radioCh2] {
      set deviceFileName "./ucf/lyt_axi_radio420x_ch1_"
    } else {
      set deviceFileName "./ucf/lyt_axi_radio420x_ch2_"
    }
    
    foreach line $data {
        if [string match "Device: xc6vlx240t" $line] {
          append deviceFileName "lx240_sx315_v2_1_0.ucf"  
        } 
        if [string match "Device: xc6vsx315t" $line] {
          append deviceFileName "lx240_sx315_v2_1_0.ucf"  
        } 
        if [string match "Device: xc6vlx550t" $line] {
          append deviceFileName "lx550_sx475_v2_1_0.ucf"  
        }
        if [string match "Device: xc6vsx475t" $line] {   
          append deviceFileName "lx550_sx475_v2_1_0.ucf" 
        }
    }   
    
    set inputFile1 [open $deviceFileName "r"]
    
    
    puts $outputFile [read $inputFile1]
    
    # Close the file
    close $outputFile
    close $xmpFile
    close $inputFile1
    puts  [xget_ncf_loc_info $mhsinst]    
    

}