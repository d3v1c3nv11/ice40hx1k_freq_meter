
fmeter.bin: fmeter_rtl.v fmeter_pin.pcf
	yosys -q -p "synth_ice40 -blif fmeter_rtl.blif" fmeter_rtl.v
	arachne-pnr -d 1k -P vq100 -p fmeter_pin.pcf fmeter_rtl.blif -o fmeter_rtl.txt
	icepack fmeter_rtl.txt fmeter.bin

upload:
	iceprog -S fmeter.bin
flash:
	iceprog fmeter.bin	

clean:
	rm -f fmeter_rtl.blif fmeter_rtl.txt fmeter_rtl.ex fmeter.bin
