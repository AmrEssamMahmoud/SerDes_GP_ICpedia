vlib work 
vlog "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/rx_status/rx_statussequence_item.sv"\
 "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/rx_status/rx_statussequence.sv" \
 "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/"\
 "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/"\
 "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/"\
  "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/"\
 "C:/Users/kimot/Desktop/VLSI/Graduation Project/My Work/"\
  +cover -covercells 
vsim -coverage -voptargs=+acc work.alu_seq -cover
add wave *
run -all
coverage save -onexit coverage.ucdb
coverage report -du=DUU -all -details coverage_report.txt 