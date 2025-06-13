import uvm_pkg::*;
`include "uvm_macros.svh"
class rx_statusmonitor extends uvm_monitor;
  `uvm_object_utils(rx_statusmonitor)

  // Declare the interface
  rx_statusifc ifc;

  // Constructor
  function new(string name = "rx_statusmonitor");
    super.new(name);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ifc = rx_statusifc::type_id::create("ifc");
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge ifc.clk);
      // Monitor the signals
      $display("Underflow: %b, Overflow: %b, Skip Added: %b, Skip Removed: %b, Disparity Error: %b, Decode Error: %b, Receiver Detected: %b, RX Status: %h",
               ifc.underflow, ifc.overflow, ifc.skip_added, ifc.skip_removed,
               ifc.Disparity_Error, ifc.Decode_Error, ifc.receiver_detected,
               ifc.rx_status);
    end
  endtask
    
endclass