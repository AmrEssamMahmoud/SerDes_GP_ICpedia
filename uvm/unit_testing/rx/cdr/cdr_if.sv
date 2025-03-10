interface cdr_if (input bit BitCLK);
    // Inputs 
    logic Reset;               
    logic Dn_1;
    logic Pn;
    logic Dn;
    // Outputs
    logic [1:0] decision;    
    logic [1:0] gainsel;                  

    logic [8:0] phase_shift;    
    // Modport
     modport DUT (
        input BitCLK, Reset, Dn_1,Pn,Dn,
        output phase_shift,gainsel,decision
        //, decision
    );
endinterface