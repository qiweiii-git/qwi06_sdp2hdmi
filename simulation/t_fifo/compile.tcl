# Verilog compile options
set VLOG_OPTS "+acc"
set VLOG_OPTS "$VLOG_OPTS +incdir+../../source/define"

# Verilog source directory list
set VLOG_DIR_LIST [list ]
lappend VLOG_DIR_LIST "../../source/define"

# flush work library, if present
if { [file exists work] } {
    vdel -lib work -all
}
vlib work

# compile Verilog sources
foreach dir ${VLOG_DIR_LIST} {
    eval vlog ${VLOG_OPTS} t_fifo.sv
    eval vlog ${VLOG_OPTS} ../../source/qwicom.sv
}
