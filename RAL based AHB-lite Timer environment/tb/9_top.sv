//`timescale 1ns/1ps
import cfg_pkg::*;
import test_pkg::*;
import uvm_pkg ::*;
`include "uvm_macros.svh"

module top ();
bit clk;

always #1 clk=~clk;

 IF  ip_if (clk);
 ahb3lite_timer ref_ip (ip_if);

 //bind DUT  SVA_module sva (_if.DUT);

initial 
begin
     $dumpfile("waves.vcd");
    $dumpvars(0, top);
uvm_config_db #(virtual IF ):: set(null,"uvm_test_top","ref_if_key",ip_if);

run_test("test");
end


endmodule 
