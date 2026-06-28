package monitor_pkg;
  import uvm_pkg::*;
  import item_pkg::*;
  import shared_package::*;
  `include "uvm_macros.svh"


  class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    item itm;
    virtual IF ip_vif; 
    uvm_analysis_port #(item) mon_ap;

    function new(string name = "monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap", this);
    endfunction


    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        itm = item::type_id::create("itm");

        // Wait for clock edge
        @(negedge ip_vif.HCLK); // or ip_vif.HCLK doesn't matter 


          capture(ip_vif, itm); 

        // send transaction to scoreboard
        mon_ap.write(itm);
      end
    endtask

    task capture(virtual IF vif, item itm);
    
      itm.HRESETn = vif.HRESETn;      // 1
      // itm.HCLK = vif.HCLK;            // 2
      itm.HSEL = vif.HSEL;            // 3
      itm.HADDR = vif.HADDR;          // 4
      itm.HWDATA = vif.HWDATA;        // 5
      itm.HWRITE = vif.HWRITE;        // 6
      itm.HSIZE = vif.HSIZE;          // 7
      itm.HBURST = vif.HBURST;        // 8
      itm.HPROT = vif.HPROT;          // 9
      itm.HTRANS = vif.HTRANS;        // 10
      itm.HREADY = vif.HREADY;        // 11
      itm.HRESP = vif.HRESP;          // 12
      itm.HREADYOUT = vif.HREADYOUT;  // 13
      itm.HRDATA = vif.HRDATA;        // 14
      itm.tint    = vif.tint;         // 15
    endtask

  endclass
endpackage

