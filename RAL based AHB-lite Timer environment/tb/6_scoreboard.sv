package scoreboard_pkg;
  import uvm_pkg::*;
  import item_pkg::*;
  import shared_package::*;
  import ahb3lite_pkg::*;
  `include "uvm_macros.svh"
  class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_export #(item) scb_export;
    uvm_tlm_analysis_fifo #(item) scb_fifo;
    item itm;
    
// reference model variables --------------------------------------------------------------------------------
logic HRESP_ref,HREADYOUT_ref,tint_ref;
logic [HDATA_SIZE-1:0] HRDATA_ref,PRESCALE_reg,ipending_reg,ipending,ienable_reg;
logic [(HDATA_SIZE*2)-1:0] time_reg,timecmp_reg[TIMERS];
logic [HADDR_SIZE-1:0] ADDRESS;
command_t access_type;
int total_txns;
int error_count,tint_counter,HRESP_counter,HREADYOUT_counter,HRDATA_counter;
int index,prescaled_counter;
bit bad_txn,write_ready,write_req,read_ready,req,prsc_en,time_pulse,check_read_data;

// ========================================================================================================================
//  REFERENCE MODEL FUNCTION
// ========================================================================================================================
    task reference_model(item itm);
    

      HRESP_ref = HRESP_OKAY; //Never an error
      if(!HREADYOUT_ref) check_read_data = 1; else check_read_data = 0;

      get_req(itm); // this should set if the current bus is requesting a read or write or idle 
      
      if(!itm.HRESETn) begin 
        reset_ref_model();
      end else begin
        HREADYOUT_ref = 1;
        
        timer_tick();
        count_prescaled();

        if(write_req) begin 
          if(write_ready) begin 
          write_to_reg(itm.HWDATA, ADDRESS);
          write_ready = 0; write_req = 0;
          end else write_ready = 1;

        end
        if(read_ready&&HREADYOUT_ref) begin
            read_ready =0;
            HREADYOUT_ref = 0;
            read_from_reg(ADDRESS);
        end

        if( req && itm.HREADY) begin
          if(access_type == WRITE) begin
            write_req = 1; // wait for the address
            ADDRESS = itm.HADDR;
          end else if(access_type == READ) begin
            read_ready = 1; // wait for the address
            ADDRESS = itm.HADDR;
          end
        end 
        
        check_interrupt();
        
      end

    endtask
//___________________________________________________________________________________________________________
// ==================================================
//  FOLLOW UP FUNCTIONS / TASKS
// ==================================================
  task get_req(item itm);

    req = ((itm.HRESETn) && itm.HSEL && (itm.HTRANS == HTRANS_NONSEQ || itm.HTRANS == HTRANS_SEQ));

    if(itm.HWRITE && req) access_type = WRITE;
    else if(!itm.HWRITE && req) access_type = READ;
    else access_type = NO_OP;

  endtask

  task write_to_reg(logic [HDATA_SIZE-1:0] data, logic [HADDR_SIZE-1:0] addr);
    // write to the register at the given address
    case({addr[HADDR_SIZE-1:2],2'b00})
      PRESCALE: begin 
        PRESCALE_reg = data;
        prsc_en = 1'b1;
      end

      RESERVED: ;

      IPENDING: ;

      IENABLE: begin 
        ienable_reg = data;
      end
      
      TIME: begin 
        time_reg[31:0] = data;
      end

      TIME_MSB: begin 
        time_reg[63:32] = data;
      end

      default: begin 
        calc_index(addr);
        case(addr[2])
          1'b0: timecmp_reg[index][31:0] = data;
          1'b1: timecmp_reg[index][63:32] = data;
        endcase
        ipending[index] = 0;
      end
    endcase
  endtask

  task calc_index(logic [HADDR_SIZE-1:0] addr);
  logic [HADDR_SIZE-1:0] local_addr;
    local_addr = addr - TIMECMP;
    index = local_addr / 8;
  endtask

  task read_from_reg(logic [HADDR_SIZE-1:0] addr);
    // read from the register at the given address
    case({addr[HADDR_SIZE-1:2],2'b00})
      PRESCALE: begin 
        HRDATA_ref = PRESCALE_reg;
      end

      RESERVED: HRDATA_ref = 0;

      IPENDING: begin 
        HRDATA_ref = ipending_reg;
      end

      IENABLE: begin 
        HRDATA_ref = ienable_reg;
      end
      
      TIME: begin 
        HRDATA_ref = time_reg[31:0];
      end

      TIME_MSB: begin 
        HRDATA_ref = time_reg[63:32];
      end

      default: begin 
        calc_index(addr);
        case(addr[2])
          1'b0: HRDATA_ref = timecmp_reg[index][31:0];
          1'b1: HRDATA_ref = timecmp_reg[index][63:32];
        endcase
      end
    endcase
  endtask

  task count_prescaled();
    time_pulse = 0; 
    // increment the prescaled counter
    if(prsc_en) begin 
      if(prescaled_counter == 0) begin 
        time_pulse = 1;
        prescaled_counter = PRESCALE_reg;
      end else begin 
      prescaled_counter = prescaled_counter - 1;
      end 
    end else begin 
      prescaled_counter = PRESCALE_reg; 
    end


  endtask

  task timer_tick;
    if(time_pulse) 
      time_reg = time_reg + 1;
  endtask

  task check_interrupt();
    // check if an interrupt has occurred
    if( |(ipending_reg & ienable_reg)) begin
      tint_ref = 1;
    end else begin
      tint_ref = 0;
    end

    ipending_reg = ipending;

    for(int i = 0; i<TIMERS; i++) begin
    if (time_reg == timecmp_reg[i]) begin 
      ipending[i] = 1;
    end 
    end

  endtask


  task reset_ref_model();
    HRESP_ref = 0;
    HREADYOUT_ref = 1;
    HRDATA_ref = 0;
    tint_ref = 0;
    prescaled_counter = 0; // default prescale
    ipending = 0;
    ienable_reg = 0;
    time_reg = 0;
    for(int i = 0; i < TIMERS; i++) begin
      timecmp_reg[i] = 0;
    end
    PRESCALE_reg = 0;
    read_ready = 0;
    prsc_en = 0;
    write_ready = 0;
    check_read_data = 0;
  endtask
// ========================================================================================================================
//  REPORT PHASE FUNCTIONS
// ========================================================================================================================
/*  FUNCTION > check_txn
    Check the data in the transaction against the reference model
    This function is called from the run_phase of the scoreboard
    It compares the signals in the transaction with the reference model values
    and reports any mismatches using UVM error messages.
    The function also keeps track of the number of transactions and errors.
*/  //______________________________________________________
    //______________________________________________________
    function void check_txn(item itm);
      total_txns++;

      // Check outputs against reference model
      if (tint_ref !== itm.tint) begin
      tint_counter++;
      bad_txn = 1;
      `uvm_error("CHECK", $sformatf("tint --- Transaction %0d failed @ %t , tint_ref = %0d, tint = %0d", total_txns, $time, tint_ref, itm.tint))
      end
      if (HRESP_ref !== itm.HRESP) begin
      HRESP_counter++;
      bad_txn = 1;
      `uvm_error("CHECK", $sformatf("HRESP --- Transaction %0d failed @ %t , HRESP_ref = %0d, HRESP = %0d", total_txns, $time, HRESP_ref, itm.HRESP))
      end
      if (HREADYOUT_ref !== itm.HREADYOUT) begin
      HREADYOUT_counter++;
      bad_txn = 1;
      `uvm_error("CHECK", $sformatf("HREADYOUT --- Transaction %0d failed @ %t , HREADYOUT_ref = %0d, HREADYOUT = %0d", total_txns, $time, HREADYOUT_ref, itm.HREADYOUT))
      end
      if (HRDATA_ref !== itm.HRDATA && check_read_data) begin
      HRDATA_counter++;
      bad_txn = 1;
      `uvm_error("CHECK", $sformatf("HRDATA --- Transaction %0d failed @ %t , HRDATA_ref = %0d, HRDATA = %0d", total_txns, $time, HRDATA_ref, itm.HRDATA))
      end
       
      if (bad_txn) begin
        error_count++;
        // `uvm_error("CHECK", $sformatf("Transaction %0d failed @ %t", total_txns, $time))
        bad_txn = 0;
      end
    endfunction
    //___________________________________________________________________________________________________________
    // additional report/debug functions 
    //___________________________________________________________________________________________________________

    function new(string name = "scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      scb_export = new("scb_export", this);
      scb_fifo   = new("scb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      scb_export.connect(scb_fifo.analysis_export);
    endfunction

    function void report_phase(uvm_phase phase);
      `uvm_info("REPORT", $sformatf("Total Transactions: %0d", total_txns), UVM_MEDIUM)
      `uvm_info("REPORT", $sformatf("Total Failed Transactions: %0d", error_count), UVM_MEDIUM)
      `uvm_info("REPORT", $sformatf("tint mismatches: %0d", tint_counter), UVM_MEDIUM)
      `uvm_info("REPORT", $sformatf("HRESP mismatches: %0d", HRESP_counter), UVM_MEDIUM)
      `uvm_info("REPORT", $sformatf("HREADYOUT mismatches: %0d", HREADYOUT_counter), UVM_MEDIUM)
      `uvm_info("REPORT", $sformatf("HRDATA mismatches: %0d", HRDATA_counter), UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
      forever begin
        scb_fifo.get(itm);
        reference_model(itm);
        check_txn(itm);
      end
    endtask


  endclass
endpackage
