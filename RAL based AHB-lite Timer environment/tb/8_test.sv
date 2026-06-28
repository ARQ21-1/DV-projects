package test_pkg;
  import uvm_pkg::*;
  import env_pkg::*;
  import cfg_pkg::*;
  import sequence_pkg::*;
  import reg_block_pkg::*;
  import shared_package::*;
  `include "uvm_macros.svh"

  class test extends uvm_test;
    `uvm_component_utils(test)
    env envi;
    cfg_obj CFG;
    virtual IF vif;
    virtual IF ip_vif;

    reset_seq rst_seq;
    base_seq seq;
    base_reg_seq reg_seq;
    Txn_seq txn_seq;
    request_t pipe_reqs[$];

    reg_block  BLOCK;

    function new(string name = "test", uvm_component parent = null);
      super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      envi = env  ::  type_id ::  create("envi", this);
      CFG = cfg_obj ::  type_id ::  create("CFG", this);

      reg_seq = base_reg_seq  ::  type_id :: create("reg_seq", this);
      seq = base_seq  ::  type_id :: create("seq", this);
      rst_seq = reset_seq  ::  type_id :: create("rst_seq", this);
      txn_seq = Txn_seq  ::  type_id :: create("txn_seq", this);
      
      BLOCK = reg_block :: type_id::create( "BLOCK" );
      BLOCK.build(); 

      if (!uvm_config_db#(virtual IF)::get(this, "", "ref_if_key", CFG.ip_vif))
        `uvm_fatal("build_phase", "test - unable to get the reference virtual interface from config DB");

       CFG.active = UVM_ACTIVE ; // by default active is set to active, if passive env is required it should be set to passive in test
        CFG.BLOCK = BLOCK;
      uvm_config_db#(cfg_obj)::set(this, "*", "CFG_key", CFG);

    endfunction


    task run_phase(uvm_phase phase);
      super.run_phase(phase);

      `uvm_info ("run_phase","base_reg_seq started ",UVM_LOW);
      phase.raise_objection(this);
      rst_seq.start(envi.agt.sqr);

      reg_seq.model = BLOCK; // pass the reg_block handle to the sequence
      access_reg(BLOCK.prescale_reg, WRITE, PRSCL); // set the prescaler value
      access_reg(BLOCK.prescale_reg, READ);

      do_nothing(10); // do nothing for 10 cycles

      access_reg(BLOCK.timecmp_reg, WRITE, TIMEOUT); // enable the timer at index 0
      access_reg(BLOCK.ienable_reg, WRITE, TIMER_UT); // enable the interrupt for the timer at index 0
      do_nothing((TIMEOUT+1)*PRSCL);
      `uvm_info ("run_phase","base_reg_seq finished ",UVM_LOW);
      
      rst_seq.start(envi.agt.sqr);
      // now to test the pipelining of transactions and change the prescaler value
      /* NOTE: the pipelining is done via different sequence (not a reg sequence) because the base_reg_seq waits for the response 
      of each transaction before sending the next one, but in real life we might have a scenario where we want to send 
      multiple transactions without waiting for the response of each one, so we can use the 
      Txn_seq for that which doesn't wait for the response of each transaction before sending the next one

      the following code is equivalent to what is done in the base_reg_seq
      the only difference is that the transactions here are gonna be sent without waiting for the response of each one,
      */ 
      make_req(.operation(WRITE), .HADDR(PRESCALE), .HWDATA(PRSCL));
      make_req(.operation(READ), .HADDR(PRESCALE), .HWDATA(PRSCL));
      make_req(.operation(WRITE), .HADDR(TIMECMP), .HWDATA(TIMEOUT[31:0]));
      // make_req(.operation(WRITE), .HADDR(TIMECMP+4), .HWDATA(TIMEOUT[63:32]));
      make_req(10); // this is equivalent to do_nothing for 10 cycles
      make_req(.operation(WRITE), .HADDR(IENABLE), .HWDATA(TIMER_UT));
      make_req((TIMEOUT+1)*PRSCL);

      pipe_txns(); // this flushes the pipe according to the order of the requests given above

      phase.drop_objection(this);
      `uvm_info ("run_phase","Pipeline_seq finished ",UVM_LOW);

    endtask

    task access_reg(uvm_reg register_name , command_t operation , uvm_reg_data_t Val = 'h0);
      reg_seq.operation = operation;
      reg_seq.register_name = register_name; 
      reg_seq.Val = Val; 
      reg_seq.start(envi.agt.sqr);
    endtask
    task do_nothing(int cycles);
      seq.cycles = cycles;
      seq.start(envi.agt.sqr);
    endtask
    task pipe_txns();
    request_t request;
    while(pipe_reqs.size()!= 0) begin 
      request = pipe_reqs.pop_front();
      txn_seq.set(request.operation, request.addr, request.data);
      txn_seq.start(envi.agt.sqr);
    end
    endtask
    task automatic make_req( input int reps = 0, input command_t operation = NO_OP,
                             input logic [31:0] HADDR = 'h0, input logic [31:0] HWDATA = 'h0 );

      if(operation != NO_OP) pipe_reqs.push_back('{operation, HADDR, HWDATA});
      else begin 
        repeat(reps)
        pipe_reqs.push_back('{operation, HADDR, HWDATA}); 
      end
    endtask

  endclass
endpackage

