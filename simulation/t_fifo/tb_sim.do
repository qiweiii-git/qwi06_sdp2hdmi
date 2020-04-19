do compile.tcl

#Wellav ModelSim
dataset close -all
vsim -t fs -novopt +notimingchecks t_fifo

onerror {resume}
log -r /*

do wave.do

onbreak {resume}

run 10us

#quit -sim