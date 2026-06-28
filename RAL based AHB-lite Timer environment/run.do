.main clear
vlib work
vlog -f sv_files.txt +cover -covercells
vsim -voptargs=+acc work.top -cover  -classdebug -uvmcontrol=all -l report.txt -solvefaildebug=2

coverage save database.ucdb -onexit -du ahb3lite_timer

vcd add -r /top_tb/ref_ip/*
run 0
do wave.do
run -all
coverage exclude -du ahb3lite_timer -code t 
vcover report database.ucdb -details -annotate -all -output coverage_report.txt
					