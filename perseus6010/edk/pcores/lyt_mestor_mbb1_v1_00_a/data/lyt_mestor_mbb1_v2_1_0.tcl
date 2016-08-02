
# Validate the Existence of BINGEN (For the binaryGenerator)
if {[info exists env(BINGEN)]} {
  set coresDir $env(BinaryDir)
  set netlistDestCores $env(BinaryDir)/pcores
} else {
  set netlistDestCores $env(ADPROOT)/fpga/Nutaq_ip_cores/pcores
  set coresDir $env(ADPROOT)/fpga/netlist
}

puts $coresDir

set destcore $netlistDestCores/lyt_mestor_mbb1_v1_00_a

set netlistRep $destcore/netlist
set srcCore1 $coresDir/lyt_mestor_mbb1.ngc

file mkdir $netlistRep

file copy -force $srcCore1 $netlistRep
set ucfFile2 "lyt_mestor_mbb1_lx240_sx315_v2_1_0.ucf" 
set ucfFile1 "lyt_mestor_mbb1_lx550_sx475_v2_1_0.ucf" 

set dataSrc $destcore/data

set srcUcf2 $dataSrc/$ucfFile2 
set srcUcf1 $dataSrc/$ucfFile1 
set dstUcf ucf

file mkdir $dstUcf

file copy -force $srcUcf2 $dstUcf/$ucfFile2
file copy -force $srcUcf1 $dstUcf/$ucfFile1



proc generate_corelevel_ucf {mhsinst} {

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
    
    foreach line $data {
        if [string match "Device: xc6vlx240t" $line] {
          set deviceFileName "./ucf/lyt_mestor_mbb1_lx240_sx315_v2_1_0.ucf"  
        } 
        
        if [string match "Device: xc6vsx315t" $line] {
          set deviceFileName "./ucf/lyt_mestor_mbb1_lx240_sx315_v2_1_0.ucf"  
        } 
        if [string match "Device: xc6vlx550t" $line] {
           set deviceFileName "./ucf/lyt_mestor_mbb1_lx550_sx475_v2_1_0.ucf"  
        }
        if [string match "Device: xc6vsx475t" $line] {   
           set deviceFileName "./ucf/lyt_mestor_mbb1_lx550_sx475_v2_1_0.ucf" 
       } }   
    
    set inputFile1 [open $deviceFileName "r"]
    
    
    puts $outputFile [read $inputFile1]
    
    # Close the file
    close $outputFile
    close $xmpFile
    close $inputFile1
    puts  [xget_ncf_loc_info $mhsinst]    
    

}
