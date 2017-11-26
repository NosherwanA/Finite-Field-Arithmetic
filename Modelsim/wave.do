onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_modular_exponentiator/in_base
add wave -noupdate /tb_modular_exponentiator/in_exponent
add wave -noupdate /tb_modular_exponentiator/in_modulus
add wave -noupdate /tb_modular_exponentiator/out_result
add wave -noupdate /tb_modular_exponentiator/in_clk
add wave -noupdate /tb_modular_exponentiator/in_start
add wave -noupdate /tb_modular_exponentiator/in_reset
add wave -noupdate /tb_modular_exponentiator/out_done
add wave -noupdate /tb_modular_exponentiator/out_busy
add wave -noupdate /tb_modular_exponentiator/DUT/ITERATIONS
add wave -noupdate /tb_modular_exponentiator/DUT/counter
add wave -noupdate /tb_modular_exponentiator/DUT/curr_state
add wave -noupdate /tb_modular_exponentiator/DUT/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 240
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {108860 ps} {225852 ps}
