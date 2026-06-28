onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group REF_MODEL /top/ip_if/clk
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HADDR
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HBURST
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HCLK
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HPROT
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HRDATA
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HREADY
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HREADYOUT
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HRESETn
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HRESP
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HSEL
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HSIZE
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HTRANS
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HWDATA
add wave -noupdate -expand -group REF_MODEL /top/ip_if/HWRITE
add wave -noupdate -expand -group REF_MODEL /top/ip_if/tint
add wave -noupdate -expand -group ref_internal /top/ref_ip/ahb_addr
add wave -noupdate -expand -group ref_internal /top/ref_ip/ahb_be
add wave -noupdate -expand -group ref_internal /top/ref_ip/ahb_rd
add wave -noupdate -expand -group ref_internal /top/ref_ip/ahb_we
add wave -noupdate -expand -group ref_internal /top/ref_ip/BE_SIZE
add wave -noupdate -expand -group ref_internal /top/ref_ip/count_enable
add wave -noupdate -expand -group ref_internal /top/ref_ip/enabled
add wave -noupdate -expand -group ref_internal /top/ref_ip/HADDR
add wave -noupdate -expand -group ref_internal /top/ref_ip/HBURST
add wave -noupdate -expand -group ref_internal /top/ref_ip/HCLK
add wave -noupdate -expand -group ref_internal /top/ref_ip/HPROT
add wave -noupdate -expand -group ref_internal /top/ref_ip/HRDATA
add wave -noupdate -expand -group ref_internal /top/ref_ip/HREADY
add wave -noupdate -expand -group ref_internal /top/ref_ip/HREADYOUT
add wave -noupdate -expand -group ref_internal /top/ref_ip/HRESETn
add wave -noupdate -expand -group ref_internal /top/ref_ip/HRESP
add wave -noupdate -expand -group ref_internal /top/ref_ip/HSEL
add wave -noupdate -expand -group ref_internal /top/ref_ip/HSIZE
add wave -noupdate -expand -group ref_internal /top/ref_ip/HTRANS
add wave -noupdate -expand -group ref_internal /top/ref_ip/HWDATA
add wave -noupdate -expand -group ref_internal /top/ref_ip/HWRITE
add wave -noupdate -expand -group ref_internal /top/ref_ip/IENABLE
add wave -noupdate -expand -group ref_internal /top/ref_ip/ienable_rd
add wave -noupdate -expand -group ref_internal /top/ref_ip/ienable_wr
add wave -noupdate -expand -group ref_internal /top/ref_ip/IPENDING
add wave -noupdate -expand -group ref_internal /top/ref_ip/IPENDING_IENABLE
add wave -noupdate -expand -group ref_internal /top/ref_ip/ipending_rd
add wave -noupdate -expand -group ref_internal /top/ref_ip/ipending_wr
add wave -noupdate -expand -group ref_internal /top/ref_ip/PRESCALE
add wave -noupdate -expand -group ref_internal /top/ref_ip/prescale_cnt
add wave -noupdate -expand -group ref_internal /uvm_root/uvm_test_top/envi/scb/prescaled_counter
add wave -noupdate -expand -group ref_internal /top/ref_ip/prescale_reg
add wave -noupdate -expand -group ref_internal /top/ref_ip/prescale_wr
add wave -noupdate -expand -group ref_internal /top/ref_ip/RESERVED
add wave -noupdate -expand -group ref_internal /top/ref_ip/TIME
add wave -noupdate -expand -group ref_internal /top/ref_ip/TIME_MSB
add wave -noupdate -expand -group ref_internal /top/ref_ip/time_reg
add wave -noupdate -expand -group ref_internal /uvm_root/uvm_test_top/envi/scb/time_reg
add wave -noupdate -expand -group ref_internal /top/ref_ip/TIMECMP
add wave -noupdate -expand -group ref_internal /top/ref_ip/TIMECMP_MSB
add wave -noupdate -expand -group ref_internal /top/ref_ip/timecmp_reg
add wave -noupdate -expand -group ref_internal /top/ref_ip/timer_idx_reg
add wave -noupdate -expand -group ref_internal /top/ref_ip/tint
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/error_count
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/HRDATA_ref
add wave -noupdate -expand -group {dut vs scb} /top/ip_if/HRDATA
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/HRDATA_counter
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/HREADYOUT_ref
add wave -noupdate -expand -group {dut vs scb} /top/ip_if/HREADYOUT
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/HREADYOUT_counter
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/tint_ref
add wave -noupdate -expand -group {dut vs scb} /top/ip_if/tint
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/tint_counter
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/ienable_rd
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/ienable_wr
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/ipending_rd
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/ipending_wr
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/timecmp_reg
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/prescale_reg
add wave -noupdate -expand -group {dut vs scb} /top/ref_ip/time_reg
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/ienable_reg
add wave -noupdate -expand -group {dut vs scb} -expand /uvm_root/uvm_test_top/envi/scb/ipending_reg
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/PRESCALE_reg
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/time_reg
add wave -noupdate -expand -group {dut vs scb} /uvm_root/uvm_test_top/envi/scb/timecmp_reg
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/access_type
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/ADDRESS
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/bad_txn
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/error_count
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/HRDATA_counter
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/HRDATA_ref
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/HREADYOUT_counter
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/HREADYOUT_ref
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/HRESP_counter
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/HRESP_ref
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/ienable_reg
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/index
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/ipending_reg
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/PRESCALE_reg
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/prescaled_counter
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/prsc_en
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/read_ready
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/req
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/time_reg
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/timecmp_reg
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/tint_counter
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/tint_ref
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/total_txns
add wave -noupdate -expand -group SCOREBOARD /uvm_root/uvm_test_top/envi/scb/write_ready
add wave -noupdate /uvm_root/uvm_test_top/envi/scb/ipending
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44 ns} 0} {{Cursor 2} {244 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 214
configure wave -valuecolwidth 100
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
WaveRestoreZoom {30 ns} {137 ns}
