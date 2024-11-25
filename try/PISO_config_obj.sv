package PISO_config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class PISO_config_obj extends uvm_object ;
`uvm_object_utils(PISO_config_obj)

virtual PISO_Interface PISO_vif;

function new ( string name = "PISO_config_obj");
super.new(name);
endfunction

endclass

endpackage