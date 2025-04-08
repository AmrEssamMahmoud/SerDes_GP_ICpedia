
package sequence_buffer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_buffer::*;
    import enums::*;

    class sequence_buffer extends uvm_sequence #(sequence_item_buffer);
        `uvm_object_utils(sequence_buffer)

        sequence_item_buffer sequence_item;

        function new(string name = "sequence_buffer");
            super.new(name);
        endfunction : new

        virtual task body();
            repeat(10) begin
                sequence_item = sequence_item_buffer::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage