package PISO_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;

class PISO_driver extends uvm_driver #(PISO_sequence_item) ;
`uvm_component_utils(PISO_driver)
PISO_sequence_item driver_seq_item;
virtual PISO_Interface PISO_vif;

function new ( string name = "PISO_driver" , uvm_component parent = null );
super.new(name,parent);
endfunction

task run_phase (uvm_phase phase);
super.run_phase(phase);
forever begin
    driver_seq_item = PISO_sequence_item::type_id::create("driver_seq_item");
    seq_item_port.get_next_item(driver_seq_item);
    PISO_vif.rst_n = driver_seq_item.rst_n ;
    PISO_vif.parallel_in = driver_seq_item.parallel_in ;
    PISO_vif.bit_count = driver_seq_item.bit_count;
    PISO_vif.temp_reg= driver_seq_item.temp_reg;
    @(negedge PISO_vif.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase",driver_seq_item.convert2string(),UVM_HIGH);
end
endtask

endclass

endpackage