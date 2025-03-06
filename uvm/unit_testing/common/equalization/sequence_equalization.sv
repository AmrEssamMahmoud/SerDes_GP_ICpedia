
package sequence_equalization;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_equalization::*;
    import enums::*;

    class sequence_equalization extends uvm_sequence #(sequence_item_equalization);
        `uvm_object_utils(sequence_equalization)

        sequence_item_equalization sequence_item;

        function new(string name = "sequence_equalization");
            super.new(name);
        endfunction : new

        virtual task body();
            repeat(50) begin
                sequence_item = sequence_item_equalization::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage