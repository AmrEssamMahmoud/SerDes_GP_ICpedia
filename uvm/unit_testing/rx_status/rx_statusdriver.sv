`include "uvm_macros.svh"
`include "rx_statussequence_item.sv"
import uvm_pkg::*;
class rx_status_driver extends uvm_driver #(rx_status_seqitem);
  `uvm_component_utils(rx_status_driver)

  // Declare the interface
  rx_statusifc ifc;

  // Constructor
  function new(string name = "rx_status_driver", uvm_component parent = null);
    super.new(name, parent);
    ifc = rx_statusifc::type_id::create("ifc");
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ifc = rx_statusifc::type_id::create("ifc");
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    forever begin
      // Wait for a sequence item to be available
      seq_item_port.get_next_item(m_item);
      // Drive the signals based on the sequence item
      ifc.underflow <= m_item.data_in[0];
      ifc.overflow <= m_item.data_in[1];
      ifc.skip_added <= m_item.data_in[2];
      ifc.skip_removed <= m_item.data_in[3];
      ifc.Disparity_Error <= m_item.data_in[4];
      ifc.Decode_Error <= m_item.data_in[5];
      ifc.receiver_detected <= m_item.data_in[6];
      // Finish the sequence item
      seq_item_port.item_done();
    end
  endtask
    
endclass