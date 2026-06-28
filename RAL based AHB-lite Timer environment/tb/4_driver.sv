package driver_pkg;
  import uvm_pkg::*;
  import item_pkg::*;
  import shared_package::*;
  `include "uvm_macros.svh"

  class driver extends uvm_driver #(item, item);
    `uvm_component_utils(driver)

    virtual IF ip_vif;
    item txn, RSP, data_RSP;  // to hold the current item and response for pipelining purposes
    item txn_q[$];  // queue to hold the items for pipelining purposes
    item pending_txn;  // to hold the item for pipelining purposes
    semaphore lock_pipe = new(
        1
    );  // this stops another transaction from starting until the current transaction has completed the data phae
    event data_phase_starting;
    bit ready = 1;

    function new(string name = "driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      data_RSP = item::type_id::create("data_RSP");
      fork
        forever begin
          txn = item::type_id::create("txn");
          RSP = item::type_id::create("RSP");
          seq_item_port.get(txn);
          if (txn.HTRANS == SEQ || txn.HTRANS == NONSEQ) begin
            `uvm_info("DRIVER", $sformatf("Starting new transaction with HADDR = %0h", txn.HADDR),
                      UVM_LOW)
            // `uvm_info("DRIVER", $sformatf("HREADYOUT is 1 im calling address phase"), UVM_LOW)
            while(! ip_vif.HREADYOUT) begin 
            ready = 0; 
            Address_phase(ip_vif, txn);  // drive the address phase signals and wait for its data phase to 
            //complete before starting the new address phase
            end
            ready = 1;
            Address_phase(ip_vif, txn);
            txn_q.push_back(txn);  // push the item into the queue
          end else begin
            // `uvm_info("DRIVER", $sformatf("Starting Normal txn - No Access - right now"), UVM_LOW)
            if(! ip_vif.HREADYOUT) ready = 0; else ready = 1;
            drive_address_phase(ip_vif, txn);
            // drive_data_phase(ip_vif, txn);
            @(posedge ip_vif.clk);
            // `uvm_info("DRIVER", $sformatf("Finishing Normal txn - No Access - right now"), UVM_LOW)
            RSP.set_id_info(txn);
            capture_outputs(ip_vif, RSP);
            if(!txn.no_response) seq_item_port.put(RSP);
          end
        end
        forever begin  //always executing
          @(data_phase_starting);
          `uvm_info("DRIVER", $sformatf("data phase startED"), UVM_LOW)
          data_RSP = txn_q.pop_front();
          // `uvm_info("DRIVER", $sformatf("setting data signals"), UVM_LOW)
          if (data_RSP.HWRITE) drive_data_phase(ip_vif, data_RSP);
          else begin 
            if(about_to_read) begin ip_vif.HREADY =0; 
            about_to_read = 0;
            end
          end
          @(posedge ip_vif.clk);
          `uvm_info("DRIVER", $sformatf("waiting HREADYOUT for ack"), UVM_LOW)
          wait (ip_vif.HREADYOUT);  // wait for the data phase to complete
          // RSP.set_id_info(txn);
          // RSP.copy(txn);
          capture_outputs(ip_vif, data_RSP);
          // `uvm_info("DRIVER", $sformatf("capturing outputs of txn and setting the RSP in seq_item_port"), UVM_LOW)
          if(!data_RSP.no_response) seq_item_port.put(data_RSP);
          // `uvm_info("DRIVER", $sformatf("releasing the lock on the pipeline"), UVM_LOW)
          lock_pipe.put(1);  //put the key to release the pipeline at end of data phase
        end
      join
    endtask

    task Address_phase(virtual IF vif, item itm);
      // `uvm_info("DRIVER", $sformatf("setting the CMD signals now"), UVM_LOW)
      drive_address_phase(vif, itm);
      @(posedge vif.clk);
      // `uvm_info("DRIVER", $sformatf("locking the pipeline"), UVM_LOW)
      lock_pipe.get(1);  // acquire the lock to start the data phase
      release_address_phase(vif, itm);
      // `uvm_info("DRIVER", $sformatf("data phase starting"), UVM_LOW)
      if(ready)->data_phase_starting;
      else lock_pipe.put(1);
    endtask

    task drive_address_phase(virtual IF vif, item itm);
      vif.HRESETn = itm.HRESETn;
      vif.HSEL = itm.HSEL;
      vif.HADDR = itm.HADDR;
      // vif.HWDATA = itm.HWDATA;
      vif.HWRITE = itm.HWRITE;
      vif.HSIZE = itm.HSIZE;
      vif.HBURST = itm.HBURST;
      vif.HPROT = itm.HPROT;
      vif.HTRANS = itm.HTRANS;
      if(ready) vif.HREADY = itm.HREADY;
    endtask

    task release_address_phase(virtual IF vif, item itm);
      vif.HTRANS = IDLE;
    endtask

    task drive_data_phase(virtual IF vif, item itm);
      vif.HWDATA = itm.HWDATA;
    endtask

    task capture_outputs(virtual IF vif, item RSP);
      RSP.HRESP = vif.HRESP;
      RSP.HREADYOUT = vif.HREADYOUT;
      RSP.HRDATA = vif.HRDATA;
      RSP.tint = vif.tint;

      RSP.HRESETn = vif.HRESETn;
      RSP.HSEL = vif.HSEL;
      RSP.HADDR = vif.HADDR;
      RSP.HWRITE = vif.HWRITE;
      RSP.HSIZE = vif.HSIZE;
      RSP.HBURST = vif.HBURST;
      RSP.HPROT = vif.HPROT;
      RSP.HTRANS = vif.HTRANS;
      RSP.HREADY = vif.HREADY;
      RSP.HWDATA = vif.HWDATA;

    endtask

  endclass
endpackage
