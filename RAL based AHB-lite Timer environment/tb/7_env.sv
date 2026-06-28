
package env_pkg;
import uvm_pkg ::*;
import coll_pkg ::*;
import agent_pkg::*;
import item_pkg::*;
import cfg_pkg::*;
import scoreboard_pkg::*;
import shared_package::*;

`include "uvm_macros.svh"

class env extends uvm_env;
`uvm_component_utils(env)

 agent      agt;
 cfg_obj    cfg;
 collector  cov;
 scoreboard scb;

 uvm_reg_predictor #(item) predictor; 

function new (string name ="env" , uvm_component parent =null);
super.new(name,parent);
endfunction 

function void build_phase (uvm_phase phase);
super.build_phase (phase);
agt  = agent :: type_id ::create ("agt",this);
cov  = collector :: type_id ::create ("cov",this);
scb  = scoreboard :: type_id ::create("scb",this);
predictor = uvm_reg_predictor #(item):: type_id ::create(  "predictor" , this  );

if (!uvm_config_db#(cfg_obj)::get(this, "", "CFG_key", cfg))
        `uvm_fatal("build_phase", "ENV - unable to get the cfg obj");

endfunction

function void connect_phase (uvm_phase phase);
agt.agt_ap.connect(cov.cov_export);
agt.agt_ap.connect(scb.scb_export);



if ( cfg.BLOCK.get_parent() == null ) begin // if the top-level env
         cfg.BLOCK.reg_map.set_sequencer( .sequencer( agt.sqr ),
                                                        .adapter( agt.adapter ) );      
end

if(use_predictor) begin 
      cfg.BLOCK.reg_map.set_auto_predict( .on( 0 ) );
      predictor.map     = cfg.BLOCK.reg_map;
      predictor.adapter = agt.adapter;
      agt.agt_ap.connect( predictor.bus_in );
end

endfunction  

endclass 
endpackage 
