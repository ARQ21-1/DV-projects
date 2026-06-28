package adapter_pkg;
    import uvm_pkg::*;
    import item_pkg::*;
    import shared_package::*;
    
    `include "uvm_macros.svh"
    
class reg_adapter extends uvm_reg_adapter;
   `uvm_object_utils( reg_adapter )
 
   function new( string name = "" );
      super.new( name );
      supports_byte_enable = 1;
      provides_responses   = 1;
   endfunction: new
 
   virtual function item reg2bus( const ref uvm_reg_bus_op rw );
      item ahb = item::type_id::create("ahb");
      
      if ( rw.kind == UVM_READ )       ahb.command = READ;
      else if ( rw.kind == UVM_WRITE ) ahb.command = WRITE;
      else                             ahb.command = NO_OP;

      if ( rw.kind == UVM_WRITE )
        ahb.HWDATA = rw.data;

        
      ahb.HADDR = rw.addr;
      assert ( ahb.randomize() with {
          HRESETn == 1;
          }
          ) else `uvm_fatal("REG 2 BUS", "Failed to randomize bus item with response OK");
          if((!ahb.HWRITE) && ahb.HSEL && (ahb.HTRANS == NONSEQ || ahb.HTRANS == SEQ))
          about_to_read = 1; else about_to_read = 0;
      return ahb;   
    endfunction: reg2bus

    //___________________________________________________________________________________________________________
 
   virtual function void bus2reg( uvm_sequence_item bus_item,
                                  ref uvm_reg_bus_op rw );
      item ahb;
  
      if ( ! $cast( ahb, bus_item ) ) begin
         `uvm_fatal( get_name(),
                     "bus_item is not of the item type." )
         return;
      end

      
      

      rw.kind = ( ahb.command == READ ) ? UVM_READ : UVM_WRITE;
      if ( ahb.command == READ )
        rw.data = ahb.HRDATA;
      else if ( ahb.command == WRITE )
        rw.data = ahb.HWDATA;

        
      rw.addr = ahb.HADDR;
        // rw.data = { ahb.sour, ahb.sugar_free, ahb.color, ahb.flavor };
      if(ahb.HRESP == 1) rw.status = UVM_NOT_OK;
      else rw.status = UVM_IS_OK;   
    endfunction: bus2reg
 
endclass: reg_adapter
endpackage: adapter_pkg