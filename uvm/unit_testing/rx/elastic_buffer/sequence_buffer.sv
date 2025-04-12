
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
            
            repeat(300) begin
                sequence_item = sequence_item_buffer::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
            sequence_item = sequence_item_buffer::type_id::create("sequence_item");
            start_item(sequence_item);
            sequence_item.data_in = 10'h0f9;
            finish_item(sequence_item);
            sequence_item = sequence_item_buffer::type_id::create("sequence_item");
            start_item(sequence_item);
            sequence_item.data_in = 10'h306;
            finish_item(sequence_item);
            repeat(50) begin
                sequence_item = sequence_item_buffer::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage