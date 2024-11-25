package PISO_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_scoreboard_pkg::*;
import PISO_agent_pkg::*;
import PISO_coverage_pkg::*;

class  PISO_env extends uvm_env;
`uvm_component_utils(PISO_env)

PISO_agent agent;
PISO_coverage cov;
PISO_scoreboard sb;

function new ( string name = "PISO_env" , uvm_component parent = null );

super.new(name,parent);

endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    cov = PISO_coverage::type_id::create("cov",this);
    sb  = PISO_scoreboard::type_id::create("sb",this);
    agent = PISO_agent::type_id::create("agent",this);
endfunction

function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    agent.agent_ap.connect(sb.scoreboard_export);
    agent.agent_ap.connect(cov.cov_export);
    
endfunction


endclass


endpackage