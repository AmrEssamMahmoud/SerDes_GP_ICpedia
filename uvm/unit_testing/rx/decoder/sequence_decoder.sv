
package sequence_decoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_decoder::*;
    import enums::*;

    class sequence_decoder extends uvm_sequence #(sequence_item_decoder);
        `uvm_object_utils(sequence_decoder)

        sequence_item_decoder sequence_item;

        function new(string name = "sequence_decoder");
            super.new(name);
        endfunction : new

        virtual task body();
            repeat(1000) begin
                sequence_item = sequence_item_decoder::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage