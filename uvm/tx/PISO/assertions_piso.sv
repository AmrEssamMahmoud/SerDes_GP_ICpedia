module assertions_piso (piso_if.DUT _if);
    
    //*****************************//
    // TODO: Write Assertions Here //
    // Assertion for Reset Behavior
assert property (@(negedge _if.Reset) disable iff (!_if.Reset) (_if.TxParallel_10 == 10'b0 && _if.bit_count == 4'b0))
  else $fatal("Reset assertion failed: TxParallel_10 or bit_count not reset to zero.");
// Assertion for Bit Counter Behavior
assert property (@(posedge _if.BitCLK) disable iff (!_if.Reset)
  (_if.bit_count >= 0 && _if.bit_count <= 9) // bit_count should be within the range 0-9
  && (_if.bit_count == 0 || (_if.bit_count == $past(_if.bit_count) - 1))) 
  else $fatal("Bit counter assertion failed: bit_count did not decrement correctly.");
// Assertion for Serial Output Behavior
assert property (@(posedge _if.BitCLK) disable iff (!_if.Reset)
  (_if.Serial == _if.TxParallel_10[_if.bit_count])) 
  else $fatal("Serial output mismatch: Serial did not match the shifted parallel data.");
// Assertion for BitCLK Behavior
assert property (@(posedge _if.BitCLK) disable iff (!_if.Reset)
  $stable(_if.TxParallel_10)) 
  else $fatal("BitCLK assertion failed: Parallel data should remain stable during each clock cycle.");
// Assertion to ensure no shifting happens when Reset is active
assert property (@(posedge _if.BitCLK) disable iff (_if.Reset)
  (_if.Serial == 0)) // Serial should not change when Reset is active
  else $fatal("Shift should not occur when Reset is active.");
// Assertion for Full Shift Completion
assert property (@(posedge _if.BitCLK) disable iff (!_if.Reset)
  (_if.bit_count == 0) ##1 (_if.Serial == TxParallel_10[0]) // Ensure all data has been shifted out when bit_count is 0
  else $fatal("Full shift assertion failed: Data did not shift completely.");

    //*****************************//

endmodule