package sequence_item_sipo;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_sipo extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_sipo)

        static int disparity = -1;

        rand encoded_data_p data_positive;
        rand encoded_data_n data_negative;
        bit [9:0] serial_in;
        bit [9:0] parallel_out;

        function new (string name = "sequence_item_sipo");
            super.new(name);
        endfunction : new

        function void post_randomize();
            int ones, zeros;

            bit [9:0] randomized_data [2] = '{data_negative, data_positive};
            serial_in = randomized_data[(disparity+1)/2];

            ones = $countones(serial_in);
            zeros = 10 - ones;
            disparity = disparity + ones - zeros;
        endfunction

        //*******************************//
        // TODO: Define Covergroups Here //
        //*******************************//

    endclass
endpackage