package PISO_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;

class PISO_coverage extends uvm_component;
`uvm_component_utils(PISO_coverage)

PISO_sequence_item cov_seq_item;
uvm_analysis_export #(PISO_sequence_item) cov_export;
uvm_tlm_analysis_fifo #(PISO_sequence_item) cov_PISO;


covergroup PISO_cvg;
   // Coverpoint for reset behavior
    coverpoint cov_seq_item.rst_n {
      bins reset_asserted = {0};
      bins reset_deasserted = {1};
   }

   // Coverpoint for parallel input
    coverpoint cov_seq_item.parallel_in {
      bins all_zeros = {10'b0000000000};
      bins all_ones = {10'b1111111111};
      bins alternating_1s = {10'b1010101010};
      bins alternating_0s = {10'b0101010101};
      bins random_data = default; 
   }
      // Coverpoint for serial output
    coverpoint cov_seq_item.serial_out {
      bins serial_out_0 = {0};
      bins serial_out_1 = {1};
   }
    /*
    coverpoint cov_seq_item.bit_count {
      bins bit_count_values[] = {[0:9]}; // Covers all possible bit counts
   }*/
endgroup


function new ( string name = "PISO_coverage" , uvm_component parent = null );

super.new(name,parent);
PISO_cvg=new();
endfunction

function void build_phase(uvm_phase phase) ;
    super.build_phase(phase);
    cov_export = new ("cov_export",this);
    cov_PISO = new ("cov_PISO",this);
endfunction

function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_PISO.analysis_export);
endfunction

task run_phase (uvm_phase phase);

super.run_phase(phase);
forever begin
    cov_PISO.get(cov_seq_item);
    PISO_cvg.start();
    PISO_cvg.sample();
end
endtask
    
endclass

endpackage