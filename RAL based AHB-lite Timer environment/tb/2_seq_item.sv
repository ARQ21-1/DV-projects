package item_pkg;
  import uvm_pkg::*;
  import shared_package::*;
  `include "uvm_macros.svh"
  class item extends uvm_sequence_item;
    `uvm_object_utils(item)

    //rand vars "not IF signals"

    //___________________________________________________________________________________________________________
    // inputs

    rand logic                  HRESETn;  // in
    rand logic                  HSEL;  // in

    logic      [HADDR_SIZE-1:0] HADDR;  // in
    logic      [HDATA_SIZE-1:0] HWDATA;  // in

    rand logic                       HWRITE;  // in
    rand logic [           2:0] HSIZE;  // in
    rand logic [           2:0] HBURST;  // in
    rand logic      [           3:0] HPROT;  // in
    rand logic [           1:0] HTRANS;  // in
    rand logic                       HREADY;  // in

    //____________________________________________________________________________________________________________
    // outputs 
    logic                       HRESP;  // out
    logic                       HREADYOUT;  // out
    logic      [HDATA_SIZE-1:0] HRDATA;  // out
    logic                       tint;  // out

    // ===========================================================================================================
    // VARS
    command_t command;  // derived field for easier stimulus generation and checking in scoreboard

    logic [HDATA_SIZE-1:0]
        w_data,
        r_data;  // derived fields for easier stimulus generation and checking in scoreboard
    logic [HADDR_SIZE-1:0]
        waddr, raddr;  // derived fields for easier stimulus generation and checking in scoreboard
    bit no_response;
    //____________________________________________________________________________________________________________
    //cosntraints

    constraint rst_cons {
      HRESETn dist {
        0 :/ 2,
        1 :/ 98
      };
    }
    constraint hprot_cons {
      HPROT == 4'b0011;  // data access from non-privileged software
    }
    constraint hready_cons {
      soft HREADY == 1; 
    }

    constraint hsel_cons {
      (command == READ || command == WRITE) -> HSEL == 1;
      (command == NO_OP) -> HSEL == 0;
    }
    constraint htrans_cons { 
      if (command == READ || command == WRITE) {
        HTRANS == NONSEQ;
      } else
      if (command == NO_OP) {HTRANS == IDLE;}
    }

    constraint hsize_cons {
      HSIZE == 3'b010;  // 32 bits for now
    }
    constraint hwrite_cons {
      (command == WRITE) -> HWRITE == 1;
      (command == READ) -> HWRITE == 0;
      (command == NO_OP) -> HWRITE == 1; // or anything really since HSEL will be 0 when NO_OP
    }
    constraint hburst_cons {
      HBURST == 3'b000;  // single beat for now
    }
    // -------------------------------------------------------------------------------------
    function void pre_randomize();
      //
    endfunction

    function void post_randomize();

    endfunction
    // -----------------------------------
    //  Constructor
    // -----------------------------------
    function new();
      command = NO_OP;  // default value for command, can be changed by test/sequence
      no_response = 0;  // default value for no_response, can be changed by sequence

    endfunction
    // -----------------------------------
    // function string convert2string();
    //   return $sformatf("%s ", super.convert2string());
    // endfunction

    // function string convert2string_stimulus();
    //   return $sformatf(
    //       "Time: %t Inputs: sys_rst=%b, clk=%b",
    //       $time,
    //       // Inputs
    //       sys_rst,
    //       clk
    //   );
    // endfunction
  endclass
endpackage
