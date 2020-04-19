onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/RST
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/WRCLK
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/WRENA
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/WRDAT
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/WRLEV
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/RDCLK
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/RDENA
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/RDDAT
add wave -noupdate -radix hexadecimal /t_fifo/u_fifo/RDLEV
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9986951449 fs} 0}
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
WaveRestoreZoom {9985051141 fs} {10000786783 fs}
