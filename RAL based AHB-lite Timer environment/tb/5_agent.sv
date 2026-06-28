package agent_pkg;
  import uvm_pkg::*;
  
  import cfg_pkg::*;
  import item_pkg::*;

  import driver_pkg::*;
  import monitor_pkg::*;
  import sqr_pkg::*;
  import adapter_pkg::*;
  `include "uvm_macros.svh"

  class agent extends uvm_agent;
    `uvm_component_utils(agent)

    driver drv;
    sequencer sqr;
    monitor mon;
    cfg_obj cfg;
    reg_adapter adapter;
    uvm_analysis_port #(item) agt_ap;

    function new(string name = "agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if (!uvm_config_db#(cfg_obj)::get(this, "", "CFG_key", cfg))
        `uvm_fatal("build_phase", "agent - unable to get the virtual interface");

      if (cfg.active == UVM_ACTIVE) begin
        sqr = sequencer::type_id::create("sqr", this);
        // mon = monitor::type_id::create("mon", this);
        drv = driver::type_id::create("drv", this);
      end // else begin
        mon = monitor::type_id::create("mon", this);
        adapter = reg_adapter::type_id::create("adapter", this);
      //end

      agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);

      if (cfg.active == UVM_ACTIVE) begin
        drv.ip_vif = cfg.ip_vif;//==============================


        // mon.ip_vif = cfg.ip_vif;//==============================
        // mon.mon_ap.connect(agt_ap);
        
        drv.seq_item_port.connect(sqr.seq_item_export);
      end 
      // else begin
        mon.ip_vif = cfg.ip_vif; //==============================
        mon.mon_ap.connect(agt_ap);
      // end
    endfunction
  endclass
endpackage
