class rx_agent extends uvm_agent;
  `uvm_component_utils(rx_agent)

  // Declare the interface
  rx_statusifc ifc;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ifc = rx_statusifc::type_id::create("ifc", this);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ifc = rx_statusifc::type_id::create("ifc", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ifc.connect(ifc.dut);
  endfunction
    
endclass