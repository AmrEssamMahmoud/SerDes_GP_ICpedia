
package sequence_encoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_encoder::*;
    import enums::*;

    class sequence_encoder extends uvm_sequence #(sequence_item_encoder);
        `uvm_object_utils(sequence_encoder)

        sequence_item_encoder sequence_item;

        function new(string name = "sequence_encoder");
            super.new(name);
        endfunction : new

        virtual task body();
            repeat(50) begin
                sequence_item = sequence_item_encoder::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage