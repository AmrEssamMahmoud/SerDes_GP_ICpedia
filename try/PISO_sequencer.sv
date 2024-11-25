package PISO_sequencer_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;

class  PISO_sequencer extends uvm_sequencer #(PISO_sequence_item);
`uvm_component_utils(PISO_sequencer);

function new ( string name = "PISO_sequencer" , uvm_component parent = null );
super.new(name,parent);
endfunction

endclass
endpackage