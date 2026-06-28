package reg_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
//___________________________________________________________________________________________________________
//                              11
//                             111                                    
//                              11
//                              11
//                             1111
//___________________________________________________________________________________________________________
class PRESCALER extends uvm_reg;
   `uvm_object_utils( PRESCALER )
 
   rand uvm_reg_field prescaler_field;
   
// constraint flavor_color_con {
//       flavor.value != jelly_bean_types::NO_FLAVOR;
//       flavor.value == jelly_bean_types::APPLE -> color.value != jelly_bean_types::BLUE;
//       flavor.value == jelly_bean_types::BLUEBERRY -> color.value == jelly_bean_types::BLUE;
//       flavor.value < = jelly_bean_types::CHOCOLATE;
//    }
 
   function new( string name = "PRESCALER" );
      super.new( .name( name ), .n_bits( 32 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();
      prescaler_field = uvm_reg_field::type_id::create( "prescaler_field" );
      prescaler_field.configure( .parent                 ( this ),
                                 .size                   ( 32   ),
                                 .lsb_pos                ( 0    ),
                                 .access                 ( "RW" ),
                                 .volatile               ( 0    ),
                                 .reset                  ( 0    ),
                                 .has_reset              ( 1    ),
                                 .is_rand                ( 1    ),
                                 .individually_accessible( 0    ) );
   endfunction: build
endclass: PRESCALER
//___________________________________________________________________________________________________________
//                          222222
//                              22                                    
//                          222222                           
//                          22
//                          222222
//___________________________________________________________________________________________________________
class RESERVED extends uvm_reg;
   `uvm_object_utils( RESERVED )
 
   rand uvm_reg_field reserved_field;
   
// constraint flavor_color_con {
//       flavor.value != jelly_bean_types::NO_FLAVOR;
//       flavor.value == jelly_bean_types::APPLE -> color.value != jelly_bean_types::BLUE;
//       flavor.value == jelly_bean_types::BLUEBERRY -> color.value == jelly_bean_types::BLUE;
//       flavor.value < = jelly_bean_types::CHOCOLATE;
//    }
 
   function new( string name = "RESERVED" );
      super.new( .name( name ), .n_bits( 32 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();
      reserved_field = uvm_reg_field::type_id::create( "reserved_field" );
      reserved_field.configure( .parent                 ( this ),
                                 .size                   ( 32   ),
                                 .lsb_pos                ( 0    ),
                                 .access                 ( "RW" ),
                                 .volatile               ( 0    ),
                                 .reset                  ( 0    ),
                                 .has_reset              ( 1    ),
                                 .is_rand                ( 1    ),
                                 .individually_accessible( 0    ) );
   endfunction: build
endclass: RESERVED
//___________________________________________________________________________________________________________
//                          333333
//                              33                                    
//                          333333                           
//                              33
//                          333333
//___________________________________________________________________________________________________________
class IPENDING extends uvm_reg;
   `uvm_object_utils( IPENDING )
 
   rand uvm_reg_field ipending_field;
   
// constraint flavor_color_con {
//       flavor.value != jelly_bean_types::NO_FLAVOR;
//       flavor.value == jelly_bean_types::APPLE -> color.value != jelly_bean_types::BLUE;
//       flavor.value == jelly_bean_types::BLUEBERRY -> color.value == jelly_bean_types::BLUE;
//       flavor.value < = jelly_bean_types::CHOCOLATE;
//    }
 
   function new( string name = "IPENDING" );
      super.new( .name( name ), .n_bits( 32 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();
      ipending_field = uvm_reg_field::type_id::create( "ipending_field" );
      ipending_field.configure( .parent                 ( this ),
                                 .size                   ( 32   ),
                                 .lsb_pos                ( 0    ),
                                 .access                 ( "RO" ),
                                 .volatile               ( 0    ),
                                 .reset                  ( 0    ),
                                 .has_reset              ( 1    ),
                                 .is_rand                ( 1    ),
                                 .individually_accessible( 0    ) );
   endfunction: build
endclass: IPENDING
//___________________________________________________________________________________________________________
//                          44  44
//                          44  44                                    
//                          444444                           
//                              44
//                              44
//___________________________________________________________________________________________________________
class IENABLE extends uvm_reg;
   `uvm_object_utils( IENABLE )
 
   rand uvm_reg_field ienable_field;
   
// constraint flavor_color_con {
//       flavor.value != jelly_bean_types::NO_FLAVOR;
//       flavor.value == jelly_bean_types::APPLE -> color.value != jelly_bean_types::BLUE;
//       flavor.value == jelly_bean_types::BLUEBERRY -> color.value == jelly_bean_types::BLUE;
//       flavor.value < = jelly_bean_types::CHOCOLATE;
//    }
 
   function new( string name = "IENABLE" );
      super.new( .name( name ), .n_bits( 32 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();
      ienable_field = uvm_reg_field::type_id::create( "ienable_field" );
      ienable_field.configure( .parent                 ( this ),
                                .size                   ( 32   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RW" ),
                                .volatile               ( 0    ),
                                 .reset                  ( 0    ),
                                 .has_reset              ( 1    ),
                                 .is_rand                ( 1    ),
                                 .individually_accessible( 0    ) );
   endfunction: build
endclass: IENABLE
//___________________________________________________________________________________________________________
//                          555555
//                          55                                    
//                          555555                           
//                              55
//                          555555
//___________________________________________________________________________________________________________
class TIME extends uvm_reg;
   `uvm_object_utils( TIME )
 
   rand uvm_reg_field TIME_field;
   
// constraint flavor_color_con {
//       flavor.value != jelly_bean_types::NO_FLAVOR;
//       flavor.value == jelly_bean_types::APPLE -> color.value != jelly_bean_types::BLUE;
//       flavor.value == jelly_bean_types::BLUEBERRY -> color.value == jelly_bean_types::BLUE;
//       flavor.value < = jelly_bean_types::CHOCOLATE;
//    }
 
   function new( string name = "TIME" );
      super.new( .name( name ), .n_bits( 64 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();
      TIME_field = uvm_reg_field::type_id::create( "TIME_field" );
      TIME_field.configure( .parent                 ( this ),
                             .size                   ( 64   ),
                             .lsb_pos                ( 0    ),
                             .access                 ( "RW" ),
                             .volatile               ( 0    ),
                             .reset                  ( 0    ),
                             .has_reset              ( 1    ),
                             .is_rand                ( 1    ),
                             .individually_accessible( 0    ) );
   endfunction: build
endclass: TIME
//___________________________________________________________________________________________________________
//                          666666
//                          66                                    
//                          666666                           
//                          66  66
//                          666666
//___________________________________________________________________________________________________________
class TIMECMP extends uvm_reg;
   `uvm_object_utils( TIMECMP )
 
   rand uvm_reg_field timecmp_field;
   
// constraint flavor_color_con {
//       flavor.value != jelly_bean_types::NO_FLAVOR;
//       flavor.value == jelly_bean_types::APPLE -> color.value != jelly_bean_types::BLUE;
//       flavor.value == jelly_bean_types::BLUEBERRY -> color.value == jelly_bean_types::BLUE;
//       flavor.value < = jelly_bean_types::CHOCOLATE;
//    }
 
   function new( string name = "TIMECMP" );
      super.new( .name( name ), .n_bits( 64 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new
 
   virtual function void build();
      timecmp_field = uvm_reg_field::type_id::create( "timecmp_field" );
      timecmp_field.configure( .parent                 ( this ),
                                 .size                   ( 64   ),
                                 .lsb_pos                ( 0    ),
                                 .access                 ( "RW" ),
                                 .volatile               ( 0    ),
                                 .reset                  ( 0    ),
                                 .has_reset              ( 1    ),
                                 .is_rand                ( 1    ),
                                 .individually_accessible( 0    ) );
   endfunction: build
endclass: TIMECMP
endpackage: reg_pkg