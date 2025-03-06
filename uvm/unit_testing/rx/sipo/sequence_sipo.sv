
package sequence_sipo;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_sipo::*;

    class sequence_sipo extends uvm_sequence #(sequence_item_sipo);
        `uvm_object_utils(sequence_sipo)

        sequence_item_sipo sequence_item;

        function new(string name = "sequence_sipo");
            super.new(name);
        endfunction : new

        virtual task body();
            sequence_item = sequence_item_sipo::type_id::create("sequence_item");
            repeat(1000) begin
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage