package agent_block;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequencer_block::*;
    `ifdef ENCODER
        import sequence_item_encoder::*;
        import driver_encoder::*;
        import monitor_encoder::*;
    `elsif PISO
        import sequence_item_piso::*;
        import driver_piso::*;
        import monitor_piso::*;
    `elsif SIPO
        import sequence_item_sipo::*;
        import driver_sipo::*;
        import monitor_sipo::*;
    `elsif DECODER
        import sequence_item_decoder::*;
        import driver_decoder::*;
        import monitor_decoder::*;
    `endif


    class agent_block extends uvm_agent;
        `uvm_component_utils(agent_block)

        sequencer_block sequencer_block_i;
        `ifdef ENCODER
            driver_encoder driver_block_i;
            monitor_encoder monitor_block_i;
        `elsif PISO
            driver_piso driver_block_i;
            monitor_piso monitor_block_i;
        `elsif SIPO
            driver_sipo driver_block_i;
            monitor_sipo monitor_block_i;
        `elsif DECODER
            driver_decoder driver_block_i;
            monitor_decoder monitor_block_i;
        `endif
    
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sequencer_block_i = sequencer_block::type_id::create("sequencer_block_i", this);
            `ifdef ENCODER
                driver_block_i = driver_encoder::type_id::create("driver_block_i", this);
                monitor_block_i = monitor_encoder::type_id::create("monitor_block_i", this);
            `elsif PISO
                driver_block_i = driver_piso::type_id::create("driver_block_i", this);
                monitor_block_i = monitor_piso::type_id::create("monitor_block_i", this);
            `elsif SIPO
                driver_block_i = driver_sipo::type_id::create("driver_block_i", this);
                monitor_block_i = monitor_sipo::type_id::create("monitor_block_i", this);
            `elsif DECODER
                driver_block_i = driver_decoder::type_id::create("driver_block_i", this);
                monitor_block_i = monitor_decoder::type_id::create("monitor_block_i", this);
            `endif
        endfunction
    
        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
        endfunction : start_of_simulation_phase
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver_block_i.seq_item_port.connect(sequencer_block_i.seq_item_export);        
        endfunction 
    
    endclass
endpackage