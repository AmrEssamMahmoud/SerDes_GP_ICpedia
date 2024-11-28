package env_block;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import agent_block::*;
    `ifdef ENCODER
        import scoreboard_encoder::*;
    `elsif PISO
        import scoreboard_piso::*;
    `elsif SIPO
        import scoreboard_sipo::*;
    `elsif DECODER
        import scoreboard_decoder::*;
    `endif

    
    class env_block extends uvm_env;
        `uvm_component_utils(env_block)
        
        agent_block agent_block_i;
        `ifdef ENCODER
            scoreboard_encoder scoreboard_i;
        `elsif PISO
            scoreboard_piso scoreboard_i;
        `elsif SIPO
            scoreboard_sipo scoreboard_i;
        `elsif DECODER
            scoreboard_decoder scoreboard_i;
        `endif        
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent_block_i = agent_block::type_id::create("agent_block_i", this);
            `ifdef ENCODER
                scoreboard_i = scoreboard_encoder::type_id::create("scoreboard_i", this);
            `elsif PISO
                scoreboard_i = scoreboard_piso::type_id::create("scoreboard_i", this);
            `elsif SIPO
                scoreboard_i = scoreboard_sipo::type_id::create("scoreboard_i", this);
            `elsif DECODER
                scoreboard_i = scoreboard_decoder::type_id::create("scoreboard_i", this);
            `endif
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            agent_block_i.monitor_block_i.item_collected_port.connect(scoreboard_i.scoreboard_block);
        endfunction : connect_phase
        
    endclass 
endpackage