package agent_equalization_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_equalization_top::*;
    import sequencer::*;
    import driver_equalization_top::*;
    import monitor_equalization_top::*;

    class agent_equalization_top_in extends uvm_agent;
        `uvm_component_utils(agent_equalization_top_in)

        sequencer sequencer_i;
        driver_equalization_top driver_equalization_top_i;
        monitor_equalization_top_in monitor_equalization_top_in_i;
    
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sequencer_i = sequencer::type_id::create("sequencer_i", this);
            driver_equalization_top_i = driver_equalization_top::type_id::create("driver_equalization_top_i", this);
            monitor_equalization_top_in_i = monitor_equalization_top_in::type_id::create("monitor_equalization_top_in_i", this);
        endfunction
    
        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
        endfunction : start_of_simulation_phase
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver_equalization_top_i.seq_item_port.connect(sequencer_i.seq_item_export);        
        endfunction 
    
    endclass

    class agent_equalization_top_out extends uvm_agent;
        `uvm_component_utils(agent_equalization_top_out)

        monitor_equalization_top_out monitor_equalization_top_out_i;
    
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_equalization_top_out_i = monitor_equalization_top_out::type_id::create("monitor_equalization_top_out_i", this);        
        endfunction
    
        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
        endfunction : start_of_simulation_phase
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction 
    
    endclass
endpackage