
package sequence_piso;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_piso::*;
    import enums::*;

    class sequence_piso extends uvm_sequence #(sequence_item_piso);
        `uvm_object_utils(sequence_piso)

        sequence_item_piso sequence_item;

        function new(string name = "sequence_piso");
            super.new(name);
        endfunction : new

        virtual task body();
            repeat(1000) begin
                sequence_item = sequence_item_piso::type_id::create("sequence_item");
                start_item(sequence_item);
                assert(sequence_item.randomize());
                finish_item(sequence_item);
            end
        endtask : body

    endclass
endpackage