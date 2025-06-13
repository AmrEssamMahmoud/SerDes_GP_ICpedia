`include "uvm_macros.svh"
`include "rx_statussequence_item.sv"
class rx_statussequence extends uvm_sequence #(rx_status);
  `uvm_object_utils(rx_statussequence)

  // Declare the sequence item
  rx_status m_item;

  // Constructor
  function new(string name = "rx_statussequence");
    super.new(name);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_item = rx_status::type_id::create("m_item");
  endfunction

  // Body phase
  task body();
    // Start the sequence item
    start_item(m_item);
    // Set the values for the sequence item
    m_item.data = 8'hFF;
    m_item.valid = 1;
    // Finish the sequence item
    finish_item(m_item);
  endtask    
endclass