
package sequence_cdr_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_cdr_top::*;

    class sequence_cdr_top extends uvm_sequence #(sequence_item_cdr_top);
        `uvm_object_utils(sequence_cdr_top)

        sequence_item_cdr_top sequence_item;

        function new(string name = "sequence_cdr_top");
            super.new(name);
        endfunction : new

        virtual task body();
            repeat(300) begin
                sequence_item = sequence_item_cdr_top::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage