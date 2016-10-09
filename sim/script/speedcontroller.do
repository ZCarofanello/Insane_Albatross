vlib work
vcom -93 -work work ../../src/SpeedController.vhdl
vcom -93 -work work ../src/SpeedController_tb.vhdl
vsim -novopt SpeedController_tb
do speedcontroller.wave.do
run -all
