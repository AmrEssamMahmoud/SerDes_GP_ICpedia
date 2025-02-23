package env;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `ifdef SERDES_TOP
        import agent_serdes_top::*;
    `else
        import agent_block::*;
    `endif

    `ifdef SERDES_TOP
        import scoreboard_serdes_top::*;
    `elsif ENCODER
        import scoreboard_encoder::*;
        import coverage_encoder ::*;
    `elsif PISO
        import scoreboard_piso::*;
    `elsif SIPO
        import scoreboard_sipo::*;
    `elsif DECODER
        import scoreboard_decoder::*;
    `elsif CDR
        import scoreboard_cdr::*;
    `endif
    
    class env extends uvm_env;
        `uvm_component_utils(env)
        
        `ifdef SERDES_TOP
            agent_serdes_top_in agent_serdes_top_in_i;
            agent_serdes_top_out agent_serdes_top_out_i;
        `else
            agent_block agent_block_i;
        `endif
        
        `ifdef SERDES_TOP
            scoreboard_serdes_top scoreboard_serdes_top_i;
        `elsif ENCODER
            scoreboard_encoder scoreboard_i;
            coverage_encoder coverage_i;
        `elsif PISO
            scoreboard_piso scoreboard_i;
        `elsif SIPO
            scoreboard_sipo scoreboard_i;
        `elsif DECODER
            scoreboard_decoder scoreboard_i;
        `elsif CDR
            scoreboard_cdr scoreboard_i;
        `endif        
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            `ifdef SERDES_TOP
                agent_serdes_top_in_i = agent_serdes_top_in::type_id::create("agent_serdes_top_in_i", this);
                agent_serdes_top_out_i = agent_serdes_top_out::type_id::create("agent_serdes_top_out_i", this);
            `else
                agent_block_i = agent_block::type_id::create("agent_block_i", this);
            `endif

            `ifdef SERDES_TOP
                scoreboard_serdes_top_i = scoreboard_serdes_top::type_id::create("scoreboard_serdes_top_i", this);            
            `elsif ENCODER
                scoreboard_i = scoreboard_encoder::type_id::create("scoreboard_i", this);
                coverage_i = coverage_encoder::type_id::create("coverage_i", this);
            `elsif PISO
                scoreboard_i = scoreboard_piso::type_id::create("scoreboard_i", this);
            `elsif SIPO
                scoreboard_i = scoreboard_sipo::type_id::create("scoreboard_i", this);
            `elsif DECODER
                scoreboard_i = scoreboard_decoder::type_id::create("scoreboard_i", this);
            `elsif CDR
                scoreboard_i = scoreboard_cdr::type_id::create("scoreboard_i", this);
            `endif
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
        `ifdef SERDES_TOP
            agent_serdes_top_in_i.monitor_serdes_top_in_i.item_collected_port.connect(scoreboard_serdes_top_i.scoreboard_top_in);
            agent_serdes_top_out_i.monitor_serdes_top_out_i.item_collected_port.connect(scoreboard_serdes_top_i.scoreboard_top_out);
        `else
            agent_block_i.monitor_block_i.item_collected_port.connect(scoreboard_i.scoreboard_block);
        `endif
        // agent_block_i.monitor_block_i.item_collected_port.connect(coverage_i.cov_export_in);
        endfunction : connect_phase
        
    endclass 
endpackage