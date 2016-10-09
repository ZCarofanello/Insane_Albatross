vlib work
vcom -93 -work work ../../src/PIController.vhdl
vcom -93 -work work ../src/PIController_tb.vhdl
vsim -novopt PIController_tb
do PIController.wave.do
run -all