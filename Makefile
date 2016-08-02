TOP := $(CURDIR)
PROJECT_DIR = $(TOP)/perseus6010/edk/

export ADPROOT=$(CURDIR)

EDK = /dls_sw/FPGA/Xilinx/13.4/ISE_DS/settings64.sh

RUN_EDK = source $(EDK) && cd $(PROJECT_DIR)


default : fpga

fpga:
	$(RUN_EDK) && \
	    make -f perseus6010_mo1000_mi125_bsdk.make bits && \
	    make -f perseus6010_mo1000_mi125_bsdk.make init_bram
clean:
	$(RUN_EDK) && \
	    make -f perseus6010_mo1000_mi125_bsdk.make clean
	rm -rf perseus6010/edk/__xps/DDR3_SDRAM/
	rm -f perseus6010/edk/__xps/perseus6010_mo1000_mi125_bsdk_routed
	rm -f perseus6010/edk/*.log
	rm -f perseus6010/edk/perseus6010_mo1000_mi125_bsdk.log.bak
	rm -f perseus6010/edk/platgen.opt
	rm -f perseus6010/edk/xmsgprops.lst
	rm -f perseus6010/edk/xflow.his

.PHONY: fpga clean
