package PISO_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;
import PISO_config_obj_pkg::*;
import PISO_driver_pkg::*;
import PISO_sequencer_pkg::*;
import PISO_monitor_pkg::*;
class PISO_agent extends uvm_agent;
`uvm_component_utils(PISO_agent)
PISO_driver drv;
PISO_monitor mon;
PISO_sequencer sqr;
PISO_config_obj PISO_cfg;
uvm_analysis_port #(PISO_sequence_item) agent_ap;

function new ( string name = "PISO_agent" , uvm_component parent = null );
super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
   drv = PISO_driver::type_id::create("drv",this);
   mon = PISO_monitor::type_id::create("mon",this);
   sqr = PISO_sequencer::type_id::create("sqr",this);
   agent_ap = new  ("agent_ap",this);
   if(!uvm_config_db #(PISO_config_obj)::get(this,"","cfg",PISO_cfg)) begin
    `uvm_fatal("build_phase","Agent unable to get the configuration object from config database");
   end
endfunction

function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    drv.PISO_vif = PISO_cfg.PISO_vif;
    mon.PISO_vif = PISO_cfg.PISO_vif;
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agent_ap);
endfunction


endclass
endpackage