package PISO_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_sequence_item_pkg::*;

class  PISO_reset_sequence extends uvm_sequence;
`uvm_object_utils(PISO_reset_sequence)
PISO_sequence_item seq_item;

function new ( string name = "PISO_reset_sequence");
super.new(name);
endfunction


task body ;
seq_item = PISO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n = 1'b0 ;
seq_item.parallel_in =10'b0 ;
finish_item(seq_item);;
endtask

endclass

class  PISO_corner_only_sequence extends uvm_sequence;
`uvm_object_utils(PISO_corner_only_sequence);
PISO_sequence_item seq_item;

function new ( string name = "PISO_corner_only_sequence");
super.new(name);
endfunction

task body ;
repeat(1000) begin
seq_item = PISO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.constraint_mode(0);
seq_item.corner_parallel_in.constraint_mode(1);
seq_item.Assert_reset_less_often.constraint_mode(1);
assert(seq_item.randomize());
finish_item(seq_item);;

end

endtask

endclass


class PISO_main_sequence  extends uvm_sequence;
`uvm_object_utils(PISO_main_sequence);
PISO_sequence_item seq_item;

function new ( string name = "PISO_main_sequence");
super.new(name);
endfunction

task body ;
repeat(1000) begin
seq_item = PISO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.constraint_mode(0);
seq_item.random_bit_patterns.constraint_mode(1);
seq_item.Assert_reset_less_often.constraint_mode(1);
assert(seq_item.randomize());
finish_item(seq_item);;
end
endtask

endclass

endpackage