package sequence_pkg;
  import uvm_pkg::*;
  import item_pkg::*;
  import shared_package::*;
  import reg_block_pkg::*;
  `include "uvm_macros.svh"
  // Base sequence class
  class reset_seq extends uvm_sequence #(item, item);
    `uvm_object_utils(reset_seq)
    item itm;
    item RSP;
    //___________________________________________________________________________________________________________
    // VARS if needed
    //___________________________________________________________________________________________________________

    function new(string name = "sequence");
      super.new(name);
    endfunction

    task body;
      repeat (5) begin
        itm = item::type_id::create("itm");
        start_item(itm);
        // constraint on/off
        assert (itm.randomize() with {HRESETn == 0;}) finish_item(itm);
        RSP = item::type_id::create("RSP");
        get_response(RSP);  // get response from the driver
      end
        itm = item::type_id::create("itm");
        start_item(itm);
        // constraint on/off
        assert (itm.randomize() with {HRESETn == 1;}) finish_item(itm);
        RSP = item::type_id::create("RSP");
        get_response(RSP);  // get response from the driver
      `uvm_info("RESET_SEQ", $sformatf("RESET SEQUENCE =================================================== DONE"), UVM_LOW)
      // ==========================================================================================================
    endtask
  endclass
  class base_seq extends uvm_sequence #(item, item);
    `uvm_object_utils(base_seq)
    item itm;
    item RSP;
    //___________________________________________________________________________________________________________
    // VARS if needed
    int cycles;
    //___________________________________________________________________________________________________________

    function new(string name = "sequence");
      super.new(name);
    endfunction

    task body;
      repeat (cycles) begin
        itm = item::type_id::create("itm");
        start_item(itm);
        // constraint on/off
        assert (itm.randomize() with {HRESETn == 1;}) finish_item(itm);
        RSP = item::type_id::create("RSP");
        get_response(RSP);  // get response from the driver
      end
      `uvm_info("BASE_SEQ", $sformatf("BASE SEQUENCE =================================================== DONE"), UVM_LOW)
      // ==========================================================================================================
    endtask
  endclass
  //___________________________________________________________________________________________________________
  class base_reg_seq extends uvm_reg_sequence;
    `uvm_object_utils(base_reg_seq)
    item      itm;
    reg_block BLOCK;
    //___________________________________________________________________________________________________________
    // VARS if needed
    uvm_reg register_name;
    uvm_reg_data_t Val;
    command_t operation;
    //___________________________________________________________________________________________________________

    function new(string name = "sequence");
      super.new(name);
    endfunction

    task body;
      uvm_status_e   status;
      uvm_reg_data_t value;
      if (model == null) `uvm_fatal("REG_SEQ", "model is null! set reg_seq.model before start")

      $cast(BLOCK, model);
      if (BLOCK == null) `uvm_fatal("REG_SEQ", "cast failed! wrong reg_block type passed")
      // ==========================================================================================================
      `uvm_info("REG_SEQ", $sformatf("about to %s the %s register",operation.name(),register_name.get_name()), UVM_LOW)
      if(operation == WRITE) 
        write_reg(register_name, status, Val);
      else 
      begin
        read_reg(register_name, status, value);
        `uvm_info("REG_SEQ", $sformatf("the value read is = %h", value), UVM_LOW)
      end
      `uvm_info("REG_SEQ", $sformatf("%s done, status = %s",operation.name(), status.name()), UVM_LOW)
      `uvm_info("REG_SEQ", "REG SEQUENCE =================================================== DONE", UVM_LOW)
      // ==========================================================================================================
    endtask
  endclass

  class Txn_seq extends uvm_sequence #(item, item);
    `uvm_object_utils(Txn_seq)
    item itm;
    item RSP;
    //___________________________________________________________________________________________________________
    // VARS if needed
    command_t operation;
    logic [31:0] HADDR;
    logic [31:0] HWDATA;
    //___________________________________________________________________________________________________________

    function new(string name = "sequence");
      super.new(name);
    endfunction

    task body;
        itm = item::type_id::create("itm");
        // RSP = item::type_id::create("RSP");
        start_item(itm);
        // constraint on/off
        itm.HRESETn.rand_mode(0);
        itm.HRESETn = 1;
        itm.no_response = 1;
        itm.command = operation;
        itm.HADDR = HADDR;
        itm.HWDATA = HWDATA;
        assert (itm.randomize()) 
        if((!itm.HWRITE) && itm.HSEL && (itm.HTRANS == NONSEQ || itm.HTRANS == SEQ))
        about_to_read = 1; else about_to_read = 0;
        finish_item(itm);
        // get_response(RSP);  // get response from the driver
      // =============================================================
    endtask

    task set (input command_t operation, input logic [31:0] HADDR = 32'h0, input logic [31:0] HWDATA = 32'h0);
      this.operation = operation;
      this.HADDR = HADDR;
      this.HWDATA = HWDATA;    
    endtask
  endclass
endpackage

