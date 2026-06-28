package cfg_pkg;
import uvm_pkg ::*;
import reg_block_pkg::*;

`include "uvm_macros.svh"

class cfg_obj extends uvm_object;
`uvm_object_utils(cfg_obj)

virtual IF ip_vif;

uvm_active_passive_enum active ; //if a passive env is required it should be set to passive in test, by default it is active 

reg_block BLOCK; // if register model is required it can be added in cfg and can be accessed by agent and driver through cfg

function new(string name = "cfg_obj");
super.new(name);
endfunction 

endclass 
endpackage 
