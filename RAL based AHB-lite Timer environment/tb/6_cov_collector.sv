package coll_pkg;
  import uvm_pkg::*;
  import item_pkg::*;
  import monitor_pkg::*;
  import shared_package::*;

  `include "uvm_macros.svh"
  class collector extends uvm_component;
    `uvm_component_utils(collector)

    uvm_analysis_export #(item) cov_export;
    uvm_tlm_analysis_fifo #(item) cov_fifo;
    item coll_item;

    covergroup cvrgp; // more to be added later

    ITERRUPT_CP : coverpoint coll_item.tint { 
      bins ITERRUPT = {1'b1};
    }
    RESET_CP : coverpoint coll_item.HRESETn {
      bins RESET_Attempted = {1'b0};
    }
    
    endgroup

    function new(string name = "collector", uvm_component parent = null);
      super.new(name, parent);
      cvrgp = new();
    endfunction

    function void build_phase(uvm_phase phase);
      cov_fifo = new("cov_fifo", this);
      cov_export   = new("cov_export", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        cov_fifo.get(coll_item);
        cvrgp.sample();
      end
    endtask

  endclass
endpackage
