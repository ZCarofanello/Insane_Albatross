onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /PIController_tb/clk
add wave -noupdate -radix sfixed /PIController_tb/set_point
add wave -noupdate -radix sfixed /PIController_tb/sample
add wave -noupdate -radix sfixed /PIController_tb/gain_p
add wave -noupdate -radix sfixed /PIController_tb/gain_i
add wave -noupdate -radix sfixed /PIController_tb/acc_in
add wave -noupdate -radix sfixed /PIController_tb/delta_time
add wave -noupdate -radix sfixed /PIController_tb/result
add wave -noupdate -radix sfixed /PIController_tb/acc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1000 ns}