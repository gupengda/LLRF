proc generate_core {mhsinst} {


    set pcoreName "./pcores/lyt_async_fifo_v1_00_a/netlist"
    set ngcFileDest $pcoreName/async_fifo.ngc
    set cgpFile $pcoreName/coregen.cgp
    set xcoFile $pcoreName/async_fifo.xco

    set ngcBuilded [file exists $ngcFileDest]

    if {$ngcBuilded != 1} {
       puts "Calling coregen to build async_fifo.ngc\n"
       puts "It may take a while.\n"
       set result [catch {exec coregen -p $cgpFile -b $xcoFile -intstyle xflow}]
       puts "Coregen Done\n"
    }


}
