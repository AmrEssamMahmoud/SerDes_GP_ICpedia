package PISO_monitor_pkg; 
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;

class PISO_monitor extends uvm_monitor ;
`uvm_component_utils(PISO_monitor)

PISO_sequence_item mon_seq_item;
virtual PISO_Interface PISO_vif;
uvm_analysis_port #(PISO_sequence_item) mon_ap;

function new ( string name = "PISO_monitor" , uvm_component parent = null );
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap",this);
endfunction

task run_phase (uvm_phase phase);

super.run_phase(phase);
forever begin
    mon_seq_item = PISO_sequence_item::type_id::create("mon_seq_item");
    @(negedge PISO_vif.clk);
    mon_seq_item.rst_n = PISO_vif.rst_n ;
    mon_seq_item.parallel_in = PISO_vif.parallel_in ;
    mon_seq_item.serial_out = PISO_vif.serial_out ;
    mon_ap.write(mon_seq_item);
    `uvm_info("run_phase",$sformatf("Transaction Broadcasting %s",mon_seq_item.convert2string()),UVM_HIGH);
end

endtask



endclass

endpackage