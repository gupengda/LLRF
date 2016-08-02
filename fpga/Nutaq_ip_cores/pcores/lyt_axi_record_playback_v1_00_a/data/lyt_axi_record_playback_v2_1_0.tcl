
# Validate the Existence of BINGEN (For the binaryGenerator)
if {[info exists env(BINGEN)]} {
  set packagesfilesDir $env(BINGENCHECKOUTDIR)/projets/adp/fpga/packages
  set coresSrcfilesDir $env(BINGENCHECKOUTDIR)/projets/adp/fpga/cores_src
  set netlistDestCores $env(BinaryDir)/pcores
  set coresDir $env(BinaryDir)
} else {
  set packagesfilesDir $env(ADPROOT)/fpga/packages
  set coresSrcfilesDir $env(ADPROOT)/fpga/cores_src
  set netlistDestCores $env(ADPROOT)/fpga/Nutaq_ip_cores/pcores
  set coresDir $env(ADPROOT)/fpga/netlist
}



set srcCore1 $packagesfilesDir/v6_ddr3_controler_64b_p.vhd
set srcCore2 $packagesfilesDir/recplay_fifos_p.vhd

set srcCore3 $coresDir/v6Ddr3Controler64b.ngc
set srcCore4 $coresDir/fifo_144_to_288.ngc
set srcCore5 $coresDir/fifo_18_to_72.ngc
set srcCore6 $coresDir/fifo_256_to_128.ngc
set srcCore7 $coresDir/fifo_256_to_256.ngc
set srcCore8 $coresDir/fifo_256_to_32.ngc
set srcCore9 $coresDir/fifo_256_to_64.ngc
set srcCore10 $coresDir/fifo_288_to_288.ngc
set srcCore11 $coresDir/fifo_36_to_288.ngc
set srcCore12 $coresDir/fifo_64_to_16.ngc
set srcCore13 $coresDir/fifo_64_to_8.ngc
set srcCore14 $coresDir/fifo_72_to_288.ngc
set srcCore15 $coresDir/fifo_9_to_72.ngc
set srcCore16 $coresDir/fifo128_w32_r256_std_ff.ngc
set srcCore17 $coresDir/fifo64_w256_r32_std_ff.ngc
set srcCore18 $coresDir/mem_controller.ngc
set srcCore20 $coresDir/fifo_d16_w288_fwft_dist.ngc
set srcCore21 $coresDir/fifo_d16_w288_fwft.ngc


set ucfFile2 "lyt_axi_record_playback_lx240_sx315_v2_1_0.ucf" 
set ucfFile1 "lyt_axi_record_playback_lx550_sx475_v2_1_0.ucf" 
set ucfFile3 "lyt_axi_record_playback_lx240_v2_1_0.ucf" 
set ucfFile4 "lyt_axi_record_playback_sx315_v2_1_0.ucf" 
set ucfFile5 "lyt_axi_record_playback_lx550_v2_1_0.ucf" 
set ucfFile6 "lyt_axi_record_playback_sx475_v2_1_0.ucf" 

set destcore $netlistDestCores/lyt_axi_record_playback_v1_00_a

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist
set dataSrc $destcore/data

set srcUcf2 $dataSrc/$ucfFile2 
set srcUcf1 $dataSrc/$ucfFile1 
set srcUcf3 $dataSrc/$ucfFile3 
set srcUcf4 $dataSrc/$ucfFile4 
set srcUcf5 $dataSrc/$ucfFile5 
set srcUcf6 $dataSrc/$ucfFile6 


set dstUcf ucf



file mkdir $vhdlRep
file mkdir $netlistRep
file mkdir $dstUcf

file copy -force $srcCore1 $vhdlRep
file copy -force $srcCore2 $vhdlRep

file copy -force $srcCore3 $netlistRep

file copy -force $srcCore4  $netlistRep
file copy -force $srcCore5  $netlistRep
file copy -force $srcCore6  $netlistRep
file copy -force $srcCore7  $netlistRep
file copy -force $srcCore8  $netlistRep
file copy -force $srcCore9  $netlistRep
file copy -force $srcCore10 $netlistRep
file copy -force $srcCore11 $netlistRep
file copy -force $srcCore12 $netlistRep
file copy -force $srcCore13 $netlistRep
file copy -force $srcCore14 $netlistRep
file copy -force $srcCore15 $netlistRep
file copy -force $srcCore16 $netlistRep
file copy -force $srcCore17 $netlistRep
file copy -force $srcCore18 $netlistRep
file copy -force $srcCore20 $netlistRep
file copy -force $srcCore21 $netlistRep

file copy -force $srcUcf2 $dstUcf/$ucfFile2
file copy -force $srcUcf1 $dstUcf/$ucfFile1
file copy -force $srcUcf3 $dstUcf/$ucfFile3 
file copy -force $srcUcf4 $dstUcf/$ucfFile4 
file copy -force $srcUcf5 $dstUcf/$ucfFile5 
file copy -force $srcUcf6 $dstUcf/$ucfFile6 


proc generate_corelevel_ucf { mhsinst } {
    
    
    set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set    ipname     [xget_hw_option_value    $mhsinst "IPNAME"]
    set    name_lower [string   tolower   $instname]
    set    folderName [string   tolower $instname]
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
    set deviceFileName2 ""     
    
    foreach line $data {
        if [string match "Device: xc6vlx240t" $line] {
          set deviceFileName "./ucf/lyt_axi_record_playback_lx240_sx315_v2_1_0.ucf"
          set deviceFileName2 "./ucf/lyt_axi_record_playback_lx240_v2_1_0.ucf" 
        } 
        
        if [string match "Device: xc6vsx315t" $line] {
          set deviceFileName "./ucf/lyt_axi_record_playback_lx240_sx315_v2_1_0.ucf"  
          set deviceFileName2 "./ucf/lyt_axi_record_playback_sx315_v2_1_0.ucf"           
        } 
        if [string match "Device: xc6vlx550t" $line] {
          set deviceFileName "./ucf/lyt_axi_record_playback_lx550_sx475_v2_1_0.ucf" 
          set deviceFileName2 "./ucf/lyt_axi_record_playback_lx550_v2_1_0.ucf"               
        }
        if [string match "Device: xc6vsx475t" $line] {   
          set deviceFileName "./ucf/lyt_axi_record_playback_lx550_sx475_v2_1_0.ucf" 
          set deviceFileName2 "./ucf/lyt_axi_record_playback_sx475_v2_1_0.ucf"                 
       } }   
    
    set inputFile1 [open $deviceFileName "r"]
    set inputFile2 [open $deviceFileName2 "r"]    
    
    
    puts $outputFile [read $inputFile1]
    puts $outputFile [read $inputFile2]
    
    # Close the file
    close $outputFile
    close $xmpFile
    close $inputFile1
    close $inputFile2    
    puts  [xget_ncf_loc_info $mhsinst]

}
