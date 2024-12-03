package sequence_item_piso;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_piso extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_piso)

        //***************************//
        // TODO: Define Signals Here //
        rand logic [9:0] TxParallel_10;
        //***************************//

        function new (string name = "sequence_item_piso");
            super.new(name);
        endfunction : new

        //******************************//
        // TODO: Define Constraints Here //
        function void randomize_input();
            this.randomize();
        endfunction

        // Print function for debugging
        function string convert2string();
            return $sformatf("TxParallel_10: %b", TxParallel_10);
        endfunction
        //*******************************//

        //*******************************//
        // TODO: Define Covergroups Here //
        covergroup parallel_data_cg;
    coverpoint TxParallel_10 { 
      bins all_data[] = {[0:1023]}; // Covers all possible 10-bit values
    }
  endgroup
  covergroup clk_cg;
    coverpoint BitCLK {
      bins rising_edge = (1); // Tracks rising edge of BitCLK
      bins falling_edge = (0); // Tracks falling edge of BitCLK
    }
  endgroup
  covergroup serial_cg;
    coverpoint Serial {
      bins serial_values[] = {0, 1}; // Covers 0 and 1 for serial output
    }
  endgroup
        //*******************************//

    endclass
endpackage