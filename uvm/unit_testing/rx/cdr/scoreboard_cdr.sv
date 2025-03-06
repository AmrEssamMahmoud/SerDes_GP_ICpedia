package scoreboard_cdr;

import uvm_pkg::*;
`include "uvm_macros.svh"
import sequence_item_cdr::*;

class scoreboard_cdr extends uvm_scoreboard;
  `uvm_component_utils(scoreboard_cdr)

  sequence_item_cdr pkt_item;
  int ref_out; // Reference model output
  int total_correct = 0; // Count of correct outputs
  int total_errors = 0; // Count of errors
  int phase_shift; // DUT phase shift signal
   bit signed [14:0] FIREGS = 0;
  bit signed [14:0] PIREGS = 0;
  // Analysis export and TLM FIFO for communication
  uvm_analysis_export #(sequence_item_cdr) scoreboard_block;
  uvm_tlm_analysis_fifo #(sequence_item_cdr) analysis_fifo;

  // Constructor
  function new(string name = "scoreboard_cdr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scoreboard_block = new("scoreboard_block", this);
    analysis_fifo = new("analysis_fifo", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    scoreboard_block.connect(analysis_fifo.analysis_export);
  endfunction

  // Run phase: Continuously process transactions
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      analysis_fifo.get(pkt_item); // Get a transaction from the FIFO
      check_data(pkt_item); // Check the data
    end
  endtask

  // Reference model: Generate the expected output
 task reference_model(sequence_item_cdr item);
    // if (item.Reset) begin
    //   ref_out = 0; // Reset state
    // end else begin
    //   if ( (item.Dn ^ item.Pn)&& !(item.Pn ^ item.Dn_1))
    //   begin
    //     case (item.gainsel)
    //       2'b00:ref_out=item.phase_shift-1;
    //       2'b01:ref_out=item.phase_shift-2;
    //       2'b11:ref_out=item.phase_shift-4;
    //       default: ref_out=item.phase_shift;
    //     endcase
    //   end
    //   else if (!(item.Dn ^ item.Pn)&& (item.Pn ^ item.Dn_1))
    //   begin
    //     case (item.gainsel)
    //       2'b00:ref_out=item.phase_shift+1;
    //       2'b01:ref_out=item.phase_shift+2;
    //       2'b11:ref_out=item.phase_shift+4;
    //       default: ref_out=item.phase_shift;
    //     endcase
    //   end
    //   else ref_out=phase_shift;
    // end
    bit signed [1:0] input_signal = ((item.Dn ^ item.Pn) && !(item.Pn ^ item.Dn_1)) ? 2'b11 :
                                ((item.Pn ^ item.Dn_1) && !(item.Dn ^ item.Pn)) ? 2'b01 :
                                2'b00;
    // bit signed [1:0] input_signal = item.decision;
    bit [1:0] gainsel = item.gainsel;
    bit Reset = item.Reset;
    bit signed [14:0] FIIP;
    bit signed [5:0] temp;

    // Calculate FIIP based on gainsel
    case (gainsel)
      2'b00: FIIP = input_signal;
      2'b01: FIIP = input_signal << 1;
      2'b10: FIIP = input_signal << 2;
      default: FIIP = input_signal;
    endcase

    // Update FIREGS and PIREGS based on Reset
    if (!Reset) begin
      FIREGS = 0;
      PIREGS = 0;
    end else begin
      FIREGS = FIREGS + FIIP;
      PIREGS = PIREGS + (FIREGS >>> 6) + (input_signal << 3);
    end

    // Calculate the expected output
    ref_out = PIREGS >>> 6;
endtask

  // Check model: Compare DUT output with reference model output
  task check_data(sequence_item_cdr item);
    // Generate the expected output
    reference_model(item);

    // Compare expected vs actual
    if (ref_out == item.phase_shift) begin
      total_correct++;
    end else begin
      total_errors++;
      $display("Design error @ %0t ns: Expected = 0x%0h, Received = 0x%0h",
               $time, ref_out, item.phase_shift);
    end
  endtask

  // Report phase: Summarize results
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("Scoreboard Summary", 
              $sformatf("Correct: %0d, Errors: %0d", total_correct, total_errors),
              UVM_LOW);
  endfunction

endclass

endpackage
