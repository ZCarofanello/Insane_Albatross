onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /speedcontroller_tb/Clk
add wave -noupdate /speedcontroller_tb/rst_n
add wave -noupdate -radix unsigned /speedcontroller_tb/width
add wave -noupdate /speedcontroller_tb/pulse_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1000 ns}