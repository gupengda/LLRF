cd /home/clm61942/firmware/DLLRF/DigitalLLRF/perseus6010/edk/
if { [ catch { xload xmp perseus6010_mo1000_mi125_bsdk.xmp } result ] } {
  exit 10
}
xset hdl verilog
run stubgen
exit 0
