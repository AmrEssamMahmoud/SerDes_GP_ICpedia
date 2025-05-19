import uvm_pkg::*;
`include "uvm_macros.svh"
class rx_status_seqitem extends uvm_sequence_item;
  `uvm_object_utils(rx_status_sequence_item)

  // Declare the sequence item fields
  bit [9:0] data_in;
  bit [9:0] data_out;

  // Constructor
  function new(string name = "rx_status_sequence_item");
    super.new(name);
  endfunction

  // Copy method
  function void do_copy(uvm_object rhs);
    rx_status_seqitem rhs_seq;
    if (!$cast(rhs_seq, rhs)) begin
      `uvm_fatal("COPY", "Cannot copy to non-rx_status_sequence_item")
    end
    this.data_in = rhs_seq.data_in;
    this.data_out = rhs_seq.data_out;
  endfunction
    
endclass