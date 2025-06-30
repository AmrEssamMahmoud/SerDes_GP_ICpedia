package env;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `ifdef TOP
        import agent_top::*;
    `elsif EQUALIZATION_TOP
        import agent_equalization_top::*;
    `elsif CDR_TOP
        import agent_cdr_top::*;
    `elsif SERDES_TOP
        import agent_serdes_top::*;
    `elsif BUFFER
        import agent_buffer::*;
    `else
        import agent_block::*;
    `endif

    `ifdef TOP
        import scoreboard_top::*;
    `elsif EQUALIZATION_TOP
        import scoreboard_equalization_top::*;
    `elsif CDR_TOP
        import scoreboard_cdr_top::*;
    `elsif SERDES_TOP
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
    `elsif EQUALIZATION
        import scoreboard_equalization::*;
    `elsif BUFFER
        import scoreboard_buffer::*;
    `endif
    
    class env extends uvm_env;
        `uvm_component_utils(env)
        
        `ifdef TOP
            agent_top_in agent_top_in_i;
            agent_top_out agent_top_out_i;
        `elsif EQUALIZATION_TOP
            agent_equalization_top_in agent_equalization_top_in_i;
            agent_equalization_top_out agent_equalization_top_out_i;
        `elsif CDR_TOP
            agent_cdr_top_in agent_cdr_top_in_i;
            agent_cdr_top_out agent_cdr_top_out_i;
        `elsif SERDES_TOP
            agent_serdes_top_in agent_serdes_top_in_i;
            agent_serdes_top_out agent_serdes_top_out_i;
        `elsif BUFFER
            agent_buffer_in agent_buffer_in_i;
            agent_buffer_out agent_buffer_out_i;
        `else
            agent_block agent_block_i;
        `endif
        
        `ifdef TOP
            scoreboard_top scoreboard_top_i;
        `elsif EQUALIZATION_TOP
            scoreboard_equalization_top scoreboard_equalization_top_i;
        `elsif CDR_TOP
            scoreboard_cdr_top scoreboard_cdr_top_i;
        `elsif SERDES_TOP
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
        `elsif EQUALIZATION
            scoreboard_equalization scoreboard_i;
        `elsif BUFFER
            scoreboard_buffer scoreboard_buffer_i;
        `endif        
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            `ifdef TOP
                agent_top_in_i = agent_top_in::type_id::create("agent_top_in_i", this);
                agent_top_out_i = agent_top_out::type_id::create("agent_top_out_i", this);
            `elsif EQUALIZATION_TOP
                agent_equalization_top_in_i = agent_equalization_top_in::type_id::create("agent_equalization_top_in_i", this);
                agent_equalization_top_out_i = agent_equalization_top_out::type_id::create("agent_equalization_top_out_i", this);
            `elsif CDR_TOP
                agent_cdr_top_in_i = agent_cdr_top_in::type_id::create("agent_cdr_top_in_i", this);
                agent_cdr_top_out_i = agent_cdr_top_out::type_id::create("agent_cdr_top_out_i", this);
            `elsif SERDES_TOP
                agent_serdes_top_in_i = agent_serdes_top_in::type_id::create("agent_serdes_top_in_i", this);
                agent_serdes_top_out_i = agent_serdes_top_out::type_id::create("agent_serdes_top_out_i", this);
            `elsif BUFFER
                agent_buffer_in_i = agent_buffer_in::type_id::create("agent_buffer_in_i", this);
                agent_buffer_out_i = agent_buffer_out::type_id::create("agent_buffer_out_i", this);
            `else
                agent_block_i = agent_block::type_id::create("agent_block_i", this);
            `endif

            `ifdef TOP
                scoreboard_top_i = scoreboard_top::type_id::create("scoreboard_top_i", this);            
            `elsif EQUALIZATION_TOP
                scoreboard_equalization_top_i = scoreboard_equalization_top::type_id::create("scoreboard_equalization_top_i", this);            
            `elsif CDR_TOP
                scoreboard_cdr_top_i = scoreboard_cdr_top::type_id::create("scoreboard_cdr_top_i", this);            
            `elsif SERDES_TOP
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
            `elsif EQUALIZATION
                scoreboard_i = scoreboard_equalization::type_id::create("scoreboard_i", this);
            `elsif BUFFER
                scoreboard_buffer_i = scoreboard_buffer::type_id::create("scoreboard_buffer_i", this);
            `endif
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
        `ifdef TOP
            agent_top_in_i.monitor_top_in_i.item_collected_port.connect(scoreboard_top_i.scoreboard_top_in);
            agent_top_out_i.monitor_top_out_i.item_collected_port.connect(scoreboard_top_i.scoreboard_top_out);
        `elsif EQUALIZATION_TOP
            agent_equalization_top_in_i.monitor_equalization_top_in_i.item_collected_port.connect(scoreboard_equalization_top_i.scoreboard_top_in);
            agent_equalization_top_out_i.monitor_equalization_top_out_i.item_collected_port.connect(scoreboard_equalization_top_i.scoreboard_top_out);
        `elsif CDR_TOP
            agent_cdr_top_in_i.monitor_cdr_top_in_i.item_collected_port.connect(scoreboard_cdr_top_i.scoreboard_top_in);
            agent_cdr_top_out_i.monitor_cdr_top_out_i.item_collected_port.connect(scoreboard_cdr_top_i.scoreboard_top_out);
            agent_cdr_top_out_i.monitor_cdr_top_tx_clock_i.item_collected_port.connect(scoreboard_cdr_top_i.scoreboard_top_cdr_tx_clock);
            agent_cdr_top_out_i.monitor_cdr_top_rx_clock_i.item_collected_port.connect(scoreboard_cdr_top_i.scoreboard_top_cdr_rx_clock);
        `elsif SERDES_TOP
            agent_serdes_top_in_i.monitor_serdes_top_in_i.item_collected_port.connect(scoreboard_serdes_top_i.scoreboard_top_in);
            agent_serdes_top_out_i.monitor_serdes_top_out_i.item_collected_port.connect(scoreboard_serdes_top_i.scoreboard_top_out);
        `elsif BUFFER
            agent_buffer_in_i.monitor_buffer_in_i.item_collected_port.connect(scoreboard_buffer_i.scoreboard_buffer_in);
            agent_buffer_out_i.monitor_buffer_out_i.item_collected_port.connect(scoreboard_buffer_i.scoreboard_buffer_out);
        `else
            agent_block_i.monitor_block_i.item_collected_port.connect(scoreboard_i.scoreboard_block);
        `endif
        // agent_block_i.monitor_block_i.item_collected_port.connect(coverage_i.cov_export_in);
        endfunction : connect_phase
        
    endclass 
endpackage