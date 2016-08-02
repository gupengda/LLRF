# Validate the Existence of BINGEN (For the binaryGenerator)
if {[info exists env(BINGEN)]} {
  set packagesfilesDir $env(BINGENCHECKOUTDIR)/projets/adp/fpga/packages
  set netlistDestCores $env(BinaryDir)/pcores
  set coresDir $env(BinaryDir)
  set miscDir $env(BINGENCHECKOUTDIR)projets/adp/fpga/cores_src/misc
} else {
  set packagesfilesDir $env(ADPROOT)/fpga/packages
  set netlistDestCores $env(ADPROOT)/fpga/Nutaq_ip_cores/pcores
  set coresDir $env(ADPROOT)/fpga/netlist
  set miscDir $env(ADPROOT)/fpga/cores_src/misc
}

set srcCore1 $packagesfilesDir/mi125_pkg.vhd
set srcCore2 $coresDir/mi125_wrapper.ngc
set srcCore3 $miscDir/pulse2pulse.vhd

set destcore $netlistDestCores/lyt_axi_mi125_v1_00_a

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist

file mkdir $vhdlRep
file mkdir $netlistRep

file copy -force $srcCore1 $vhdlRep
file copy -force $srcCore2 $netlistRep
file copy -force $srcCore3 $vhdlRep

set vhdlRep $destcore/hdl/vhdl
set netlistRep $destcore/netlist
set dataSrc $destcore/data

proc generate_corelevel_ucf {mhsinst} {


set  filePath [xget_ncf_dir $mhsinst]

   file mkdir    $filePath

   # specify file name
   set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
   set    name_lower [string      tolower    $instname]
   set    fileName   $name_lower
   append filePath   $fileName

   set    position   [xget_hw_parameter_value $mhsinst "C_BOTTOM_POSITION"]
   set    position_lower   [string   tolower   $position]

   # Find FPGA type
   #
   set xmpFileName [glob -type f *{.xmp}*]
   set xmpFile [open $xmpFileName "r"]
   set xmpFileStr [read $xmpFile]
   set data [split $xmpFileStr "\n"]

   set fpgatype 0
   foreach line $data {
        if [string match "Device: xc6vlx240t" $line] {
            set fpgatype 240
        }
        if [string match "Device: xc6vsx315t" $line] {
            set fpgatype 315
        }
        if [string match "Device: xc6vlx550t" $line] {
            set fpgatype 550
        }
        if [string match "Device: xc6vsx475t" $line] {
            set fpgatype 475
        }
    }

   close $xmpFile


   # Open UCF file for writing and delete XDC file (if any)
   set outputFileUcf [open "${filePath}_wrapper.ucf" "w"]
   file delete -force "${filePath}.xdc"

   puts "INFO: Setting timing constaints for ${instname}."



   # Constraints start here...
   #


    if [string match "false" $position_lower] {

        # MI125 #1 (top) constraints

        puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout1_buf\" LOC = BUFGCTRL_X0Y19;"
        puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout2_buf\" LOC = BUFGCTRL_X0Y18;"

        # IODELAY constraints
        puts $outputFileUcf "INST \"*${name_lower}/MI125_Wrapper_INST/DDR_8TO1_32CHAN_RX_INST00/RX_IDELAYCTRL\"               IODELAY_GROUP = FMC_TOP_IODELAY_GRP;"
        puts $outputFileUcf "INST \"*${name_lower}/MI125_Wrapper_INST/DDR_8TO1_32CHAN_RX_INST00/pins\[*\].IODELAY_RX_DATA\"   IODELAY_GROUP = FMC_TOP_IODELAY_GRP;"

        puts $outputFileUcf "INST \"*${name_lower}/MI125_Wrapper_INST/DDR_8TO1_32CHAN_RX_INST00/pins\[24\].IODELAY_RX_DATA\"  IODELAY_GROUP = FMC_BOTTOM_IODELAY_GRP;"
        puts $outputFileUcf "INST \"*${name_lower}/MI125_Wrapper_INST/DDR_8TO1_32CHAN_RX_INST00/pins\[26\].IODELAY_RX_DATA\"  IODELAY_GROUP = FMC_BOTTOM_IODELAY_GRP;"

        # Since the path from IBUFDS to BUFG is not clock dedicated (pin in outer column)
        # force it to be consistent from onebuild to another.
        if {$fpgatype==240} then {
        
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y6;"

            puts $outputFileUcf "NET \"*${name_lower}/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vlx240tff1759;f4bead1b!-1;-222032;-61920;S!0;875;64!1;37;18!\""
            puts $outputFileUcf "\"2;48;126!3;2903;1990!4;1662;2!5;-1853;2149!5;1308;2388!6;-479;26867!7;\""
            puts $outputFileUcf "\"4096;29828!8;0;51448!9;35153;24653!10;150;32644!11;67590;0!12;345;7685!\""
            puts $outputFileUcf "\"13;42292;2370!14;175;1157!15;11041;-207!16;-2786;1810!17;5851;67!18;103;\""
            puts $outputFileUcf "\"680;L!19;14044;120!21;23289;1441!22;15836;564!23;923;274;L!}\";"
            
        }
        if {$fpgatype==315} then {
        
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y6;"

            puts $outputFileUcf "NET \"*axi_mi125_top/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vsx315tff1759;d190c946!-1;-299186;-61920;S!0;875;64!1;37;18!\""
            puts $outputFileUcf "\"2;48;126!3;2903;1990!4;1662;2!5;-1853;2149!5;1308;2388!6;-479;26867!7;\""
            puts $outputFileUcf "\"4096;29828!8;0;51448!9;35153;24653!10;150;32644!11;68044;0!12;345;7685!\""
            puts $outputFileUcf "\"13;68108;0!14;175;1157!15;42580;2370!16;-2786;1810!17;16896;0!18;103;680;\""
            puts $outputFileUcf "\"L!19;11843;1425!21;10501;2023!22;23273;-207!23;15852;-1256!24;923;274;L!}\";"
            
        }
        if {$fpgatype==475} then {
        
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y10;"

            puts $outputFileUcf "NET \"*axi_mi125_top/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vsx475tff1759;a5dc7c84!-1;-299186;3104;S!0;875;64!1;37;18!2;\""
            puts $outputFileUcf "\"48;126!3;2903;1990!4;1662;2!5;-1853;2149!5;6259;-697!6;-479;26867!7;\""
            puts $outputFileUcf "\"11657;3085!8;0;51448!9;4384;29828!10;150;32644!11;35383;24653!12;345;\""
            puts $outputFileUcf "\"7685!13;68044;0!14;175;1157!15;68108;0!16;-2786;1810!17;42350;2370!18;\""
            puts $outputFileUcf "\"103;680;L!19;11843;1425!21;10501;2023!22;23273;-207!23;15852;-1256!24;\""
            puts $outputFileUcf "\"923;274;L!}\";"
            
        }
        if {$fpgatype==550} then {

            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y10;"

            puts $outputFileUcf "NET \"*axi_mi125_top/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vlx550tff1759;1d80802e!-1;-304322;3104;S!0;875;64!1;37;18!2;\""
            puts $outputFileUcf "\"48;126!3;2903;1990!4;1662;2!5;-1853;2149!6;-479;26867!7;0;51448!7;34131;\""
            puts $outputFileUcf "\"24653!8;150;32644!9;67468;0!10;345;7685!11;67136;0!12;175;1157!13;41320;\""
            puts $outputFileUcf "\"2370!14;-2786;1810!15;17414;0!16;103;680;L!17;18760;0!19;11065;761!20;\""
            puts $outputFileUcf "\"19944;5680!21;15852;-1256!22;923;274;L!}\";"
           
        }

    

    } else {

        # IODELAY constraints
        puts $outputFileUcf "INST \"*${name_lower}/MI125_Wrapper_INST/DDR_8TO1_32CHAN_RX_INST00/RX_IDELAYCTRL\"               IODELAY_GROUP = FMC_BOTTOM_IODELAY_GRP;"
        puts $outputFileUcf "INST \"*${name_lower}/MI125_Wrapper_INST/DDR_8TO1_32CHAN_RX_INST00/pins\[*\].IODELAY_RX_DATA\"   IODELAY_GROUP = FMC_BOTTOM_IODELAY_GRP;"

        # MI125 #0 (bottom) constraints

        # Since the path from IBUFDS to BUFG is not clock dedicated (pin in outer column)
        # force it to be consistent from onebuild to another.
        if {$fpgatype==240} then {
    
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout1_buf\" LOC = BUFGCTRL_X0Y17;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout2_buf\" LOC = BUFGCTRL_X0Y16;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y8;"

            puts $outputFileUcf "NET \"*${name_lower}/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vlx240tff1759;dd6391e0!-1;-222032;67352;S!0;875;64!1;37;18!\""
            puts $outputFileUcf "\"2;48;126!3;2903;1990!4;1662;2!5;-2232;-4096!5;-1853;2149!6;7736;-7424!7;\""
            puts $outputFileUcf "\"-479;26867!8;4052;-27688!9;0;51448!10;35153;-26547!11;150;32644!12;42126;\""
            puts $outputFileUcf "\"2370!13;345;7685!14;11701;-5723!15;175;1157!16;39193;-3295!17;-2786;1810!\""
            puts $outputFileUcf "\"18;43646;2370!19;103;680;L!20;23251;1357!22;15874;668!23;923;22;L!}\";"
        }
        if {$fpgatype==315} then {
    
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout1_buf\" LOC = BUFGCTRL_X0Y17;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout2_buf\" LOC = BUFGCTRL_X0Y16;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y8;"

            puts $outputFileUcf "NET \"*${name_lower}/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vsx315tff1759;db1f3566!-1;-299186;67352;S!0;875;64!1;37;18!\""
            puts $outputFileUcf "\"2;48;126!3;2903;1990!4;1662;2!5;-1853;2149!6;-479;26867!6;-479;-25357!7;\""
            puts $outputFileUcf "\"0;51448!8;34131;-26547!9;3628;27784!10;68044;0!11;-100;8936!12;68108;0!\""
            puts $outputFileUcf "\"13;-3033;3609!14;79981;-313!15;175;1157!16;47456;-4496!17;-2786;1810!18;\""
            puts $outputFileUcf "\"128;-9596!19;103;680;L!20;1546;-2936!22;592;-912!23;923;22;L!}\";"

        }
        if {$fpgatype==475} then {
    
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout1_buf\" LOC = BUFGCTRL_X0Y6;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout2_buf\" LOC = BUFGCTRL_X0Y7;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y8;"

            puts $outputFileUcf "NET \"*${name_lower}/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vsx475tff1759;e5a6fd0e!-1;-299186;132376;S!0;875;64!1;37;18!\""
            puts $outputFileUcf "\"2;48;126!3;2903;1990!4;1662;2!5;730;-1824!5;-2042;-6564!6;-3062;-6432!7;\""
            puts $outputFileUcf "\"3394;-11356!8;0;-27752!9;4052;-27688!10;34131;-26547!11;0;-51448!12;\""
            puts $outputFileUcf "\"68044;0!13;-4152;-29848!14;68108;0!15;-3049;-3419!16;79981;-313!17;135;\""
            puts $outputFileUcf "\"-2047!18;47456;-4496!19;-2759;-1039!20;1674;-6380!21;76;-695;L!22;592;\""
            puts $outputFileUcf "\"-856!24;923;496;L!}\";"
            
        }
        if {$fpgatype==550} then {
    
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout1_buf\" LOC = BUFGCTRL_X0Y6;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/clkout2_buf\" LOC = BUFGCTRL_X0Y7;"
            puts $outputFileUcf "INST \"*${name_lower}/U_MMCM_V6_Inst/RX_CLK_BUFR\" LOC = BUFR_X0Y8;"

            puts $outputFileUcf "NET \"*${name_lower}/U_MMCM_V6_Inst/clkin1_s\""
            puts $outputFileUcf "ROUTE=\"{3;1;6vlx550tff1759;80a3e940!-1;-304322;132376;S!0;875;64!1;37;18!\""
            puts $outputFileUcf "\"2;48;126!3;2903;1990!4;1662;2!5;-1853;2149!5;-2042;-6564!6;-479;-25357!7;\""
            puts $outputFileUcf "\"3394;-11356!8;32058;-26852!9;4052;-27688!10;65389;305!11;0;-51448!12;\""
            puts $outputFileUcf "\"67136;0!13;-4152;-29848!14;78785;-313!15;-3049;-3419!16;47456;-4496!17;\""
            puts $outputFileUcf "\"135;-2047!18;0;-12800!19;-2759;-1039!20;1674;-6380!21;76;-695;L!22;592;\""
            puts $outputFileUcf "\"-856!24;923;496;L!}\";"

        }
        
    }


   # Close the UCF file
   close $outputFileUcf

   puts   [xget_ncf_loc_info $mhsinst]


}
