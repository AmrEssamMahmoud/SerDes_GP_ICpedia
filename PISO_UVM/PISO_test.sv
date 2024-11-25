package PISO_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;
import PISO_sequence_pkg::*;
import PISO_env_pkg::*;
import PISO_config_obj_pkg::*;

class PISO_test extends uvm_test;
`uvm_component_utils(PISO_test)

PISO_config_obj PISO_cfg;
PISO_env env;
PISO_reset_sequence reset_seq;
PISO_main_sequence main_seq;
PISO_corner_only_sequence corner_seq;

function new (string name = "PISO_test" , uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);
env = PISO_env::type_id::create("env",this);
PISO_cfg = PISO_config_obj::type_id::create("PISO_cfg");
reset_seq = PISO_reset_sequence::type_id::create("reset_seq");
corner_seq = PISO_corner_only_sequence::type_id::create("corner_seq");
main_seq = PISO_main_sequence::type_id::create("main_seq");

if(! uvm_config_db #(virtual PISO_Interface)::get(this,"","PISO_IF",PISO_cfg.PISO_vif)) begin
    `uvm_fatal("build_phase","Test faild to get the virtual interface from configuration database");
end

uvm_config_db #(PISO_config_obj)::set(this , "*" , "cfg" ,PISO_cfg);

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);

`uvm_info("run_phase","Reset Asserted",UVM_LOW);
reset_seq.start(env.agent.sqr);
`uvm_info("run_phase","Reset Deasserted",UVM_LOW);

`uvm_info("run_phase","corner Sequence has Started",UVM_LOW);
corner_seq.start(env.agent.sqr);
`uvm_info("run_phase","corner Sequence has Ended",UVM_LOW);

`uvm_info("run_phase","main_seq has Started",UVM_LOW);
main_seq.start(env.agent.sqr);
`uvm_info("run_phase","main_seq has Ended",UVM_LOW);

phase.drop_objection(this);


endtask



endclass

endpackage