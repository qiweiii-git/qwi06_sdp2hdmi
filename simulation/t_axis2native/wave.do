onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axis -radix unsigned /t_axis2native/axis_i/tdata
add wave -noupdate -expand -group axis /t_axis2native/axis_i/tlast
add wave -noupdate -expand -group axis /t_axis2native/axis_i/tready
add wave -noupdate -expand -group axis /t_axis2native/axis_i/tuser
add wave -noupdate -expand -group axis /t_axis2native/axis_i/tvalid
add wave -noupdate -expand -group {vtg
} /t_axis2native/vtg_i/hsync
add wave -noupdate -expand -group {vtg
} /t_axis2native/vtg_i/vsync
add wave -noupdate -expand -group {vtg
} /t_axis2native/vtg_i/active
add wave -noupdate -expand -group {vtg
} /t_axis2native/vtg_i/hblank
add wave -noupdate -expand -group {vtg
} /t_axis2native/vtg_i/vblank
add wave -noupdate -expand -group {vtg
} /t_axis2native/vtg_i/vtg_ce
add wave -noupdate /t_axis2native/u_axis2native/vtg_sof
add wave -noupdate /t_axis2native/u_axis2native/rden
add wave -noupdate -radix unsigned /t_axis2native/u_axis2native/fifo_tdata
add wave -noupdate /t_axis2native/u_axis2native/fifo_tlast
add wave -noupdate /t_axis2native/u_axis2native/fifo_tuser
add wave -noupdate -expand -group {out
} -radix unsigned /t_axis2native/natv_o/data
add wave -noupdate -expand -group {out
} -radix unsigned /t_axis2native/natv_o/hsync
add wave -noupdate -expand -group {out
} -radix unsigned /t_axis2native/natv_o/vsync
add wave -noupdate -expand -group {out
} -radix unsigned /t_axis2native/natv_o/active
add wave -noupdate -expand -group {out
} -radix unsigned /t_axis2native/natv_o/hblank
add wave -noupdate -expand -group {out
} -radix unsigned /t_axis2native/natv_o/vblank
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38330177068 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 169
configure wave -valuecolwidth 99
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {38228585847 fs} {38435065477 fs}
