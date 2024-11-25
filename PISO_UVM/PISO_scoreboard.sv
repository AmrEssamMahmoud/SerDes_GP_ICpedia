package PISO_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;
import PISO_config_obj_pkg::*;
class PISO_scoreboard extends uvm_scoreboard;
`uvm_component_utils(PISO_scoreboard)

PISO_sequence_item scoreboard_seq_item;
bit serial_out_ref;
int correct_count=0;
int error_count = 0;

uvm_analysis_export #(PISO_sequence_item) scoreboard_export;
uvm_tlm_analysis_fifo #(PISO_sequence_item) scoreboard_PISO;

function new ( string name = "PISO_scoreboard" , uvm_component parent = null );
    super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    scoreboard_export = new("scoreboard_export",this);
    scoreboard_PISO = new("scoreboard_PISO",this);
endfunction

function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    scoreboard_export.connect(scoreboard_PISO.analysis_export);
endfunction

task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        scoreboard_PISO.get(scoreboard_seq_item);
        check_data(scoreboard_seq_item);
    end
endtask


task reference_model (PISO_sequence_item sb_seq_item) ;
    if(!sb_seq_item.rst_n)
        serial_out_ref =0;
    else 
        serial_out_ref=sb_seq_item.parallel_in[0];
endtask

task check_data (PISO_sequence_item sb_seq_item) ;
reference_model(sb_seq_item);
if(serial_out_ref == sb_seq_item.serial_out) begin
    correct_count = correct_count + 1;
end
else begin
    error_count = error_count + 1;
    $display("Error: at %0t ns  Expected serial_out = 0x%0h  ,serial_out = 0x%0h ", $time, serial_out_ref, sb_seq_item.serial_out);
    $display("Transaction details at %0t ns: rst_n = %0b, parallel_in = 0x%0h, serial_out = 0x%0h",$time, sb_seq_item.rst_n, sb_seq_item.parallel_in, sb_seq_item.serial_out);
end

endtask

function void report_phase (uvm_phase phase);

super.report_phase(phase);
`uvm_info("report_phase",$sformatf("Total Number of Successful Transactions = %0d",correct_count),UVM_MEDIUM);
`uvm_info("report_phase",$sformatf("Total Number of Failed Transactions = %0d",error_count),UVM_MEDIUM);
endfunction


endclass

endpackage