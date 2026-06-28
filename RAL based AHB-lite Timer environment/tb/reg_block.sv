package reg_block_pkg;
    import uvm_pkg::*;
    import reg_pkg::*;
    `include "uvm_macros.svh"

    class reg_block extends uvm_reg_block;
   `uvm_object_utils( reg_block )
 
   rand PRESCALER prescale_reg;
   rand RESERVED reserved_reg;
   rand IPENDING ipending_reg;
   rand IENABLE ienable_reg;
   rand TIME time_reg;
   rand TIMECMP timecmp_reg;

   uvm_reg_map                reg_map;
 
   function new( string name = "reg_block" );
      super.new( .name( name ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();

      prescale_reg = PRESCALER::type_id::create( "prescale_reg" );
      prescale_reg.configure( .blk_parent( this ) );
      prescale_reg.build();

      reserved_reg = RESERVED::type_id::create( "reserved_reg" );
      reserved_reg.configure( .blk_parent( this ) );
      reserved_reg.build(); 

      ipending_reg = IPENDING::type_id::create( "ipending_reg" );
      ipending_reg.configure( .blk_parent( this ) );
      ipending_reg.build(); 

      ienable_reg = IENABLE::type_id::create( "ienable_reg" );
      ienable_reg.configure( .blk_parent( this ) );
      ienable_reg.build(); 

      time_reg = TIME::type_id::create( "time_reg" ); 
      time_reg.configure( .blk_parent( this ) );
      time_reg.build(); 

      timecmp_reg = TIMECMP::type_id::create( "timecmp_reg" );
      timecmp_reg.configure( .blk_parent( this ) );
      timecmp_reg.build(); 
      
      //___________________________________________________________________________________________________________

      reg_map = create_map( .name( "reg_map" ), .base_addr( 8'h00 ),   // base address of the reg block
                            .n_bytes( 4 ), .endian( UVM_LITTLE_ENDIAN ) );

      reg_map.add_reg( .rg( prescale_reg ), .offset( 32'h00 ), .rights( "RW" ) );
      reg_map.add_reg( .rg( reserved_reg ), .offset( 32'h04 ), .rights( "RW" ) );
      reg_map.add_reg( .rg( ipending_reg  ), .offset( 32'h08 ), .rights( "RO" ) ); 
      reg_map.add_reg( .rg( ienable_reg ), .offset( 32'h0C ), .rights( "RW" ) );
      reg_map.add_reg( .rg( time_reg  ), .offset( 32'h10 ), .rights( "RW" ) ); 
      reg_map.add_reg( .rg( timecmp_reg ), .offset( 32'h18 ), .rights( "RW" ) );
      reg_map.set_auto_predict(0); // disable automatic prediction
      // 32'h18 = 32'b0000_0000_0000_0000_0000_0000_0001_1000
      lock_model(); // finalize the address mapping
   endfunction: build
 
endclass: reg_block
endpackage: reg_block_pkg