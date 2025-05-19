import uvm_pkg::*;
`include "uvm_macros.svh"
class rx_statusconfig extends uvm_object;
  `uvm_object_utils(rx_statusconfig)

  // Declare the configuration fields
  bit [9:0] data_in;
  bit [9:0] data_out;

  // Constructor
  function new(string name = "rx_status_config");
    super.new(name);
  endfunction

  // Copy method
  function void do_copy(uvm_object rhs);
    rx_statusconfig rhs_config;
    if (!$cast(rhs_config, rhs)) begin
      `uvm_fatal("COPY", "Cannot copy to non-rx_status_config")
    end
    this.data_in = rhs_config.data_in;
    this.data_out = rhs_config.data_out;
  endfunction
    
endclass