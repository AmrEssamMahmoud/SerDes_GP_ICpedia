
package sequence_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_top::*;
    import enums::*;

    class sequence_top extends uvm_sequence #(sequence_item_top);
        `uvm_object_utils(sequence_top)

        sequence_item_top sequence_item;

        function new(string name = "sequence_top");
            super.new(name);
        endfunction : new

        virtual task body();
            sequence_item = sequence_item_top::type_id::create("sequence_item");
            sequence_item.input_data = D_28_1;
            sequence_item.tx_data_k = 1;
            start_item(sequence_item);
            assert(sequence_item);
            finish_item(sequence_item);
            repeat(50) begin
                sequence_item = sequence_item_top::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage