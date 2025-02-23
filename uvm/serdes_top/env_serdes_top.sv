package env_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import scoreboard::*;
    import agent_top::*;
    
    class env_top extends uvm_env;
        `uvm_component_utils(env_top)
        
        agent_top_in agent_top_in_i;
        agent_top_out agent_top_out_i;
        scoreboard scoreboard_i;
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent_top_in_i = agent_top_in::type_id::create("agent_top_in_i", this);
            agent_top_out_i = agent_top_out::type_id::create("agent_top_out_i", this);
            scoreboard_i = scoreboard::type_id::create("scoreboard_i", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            agent_top_in_i.monitor_top_in_i.item_collected_port.connect(scoreboard_i.scoreboard_top_in);
            agent_top_out_i.monitor_top_out_i.item_collected_port.connect(scoreboard_i.scoreboard_top_out);
        endfunction : connect_phase
        
    endclass 
endpackage