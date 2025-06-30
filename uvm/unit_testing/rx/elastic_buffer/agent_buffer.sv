package agent_buffer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_buffer::*;
    import sequencer::*;
    import driver_buffer::*;
    import monitor_buffer::*;

    class agent_buffer_in extends uvm_agent;
        `uvm_component_utils(agent_buffer_in)

        sequencer sequencer_i;
        driver_buffer driver_buffer_i;
        monitor_buffer_in monitor_buffer_in_i;
    
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sequencer_i = sequencer::type_id::create("sequencer_i", this);
            driver_buffer_i = driver_buffer::type_id::create("driver_buffer_i", this);
            monitor_buffer_in_i = monitor_buffer_in::type_id::create("monitor_buffer_in_i", this);
        endfunction
    
        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
        endfunction : start_of_simulation_phase
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver_buffer_i.seq_item_port.connect(sequencer_i.seq_item_export);        
        endfunction 
    
    endclass

    class agent_buffer_out extends uvm_agent;
        `uvm_component_utils(agent_buffer_out)

        monitor_buffer_out monitor_buffer_out_i;
    
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_buffer_out_i = monitor_buffer_out::type_id::create("monitor_buffer_out_i", this);        
        endfunction
    
        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
        endfunction : start_of_simulation_phase
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction 
    
    endclass
endpackage