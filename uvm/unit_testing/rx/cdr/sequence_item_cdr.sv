package sequence_item_cdr;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    // import enums::*;
    
    class sequence_item_cdr extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_cdr)

        //***************************//
        // TODO: Define Signals Here //
        //***************************//
         
        // Inputs 
        rand bit Reset;           
        rand bit Dn_1,Pn,Dn; 
        bit BitCLK;
        bit [8:0] phase_shift; 

        

        // Internal
        bit [1:0] decision;    
        bit [1:0] gainsel;                  

        // function new(string name = "sequence_item_CDR");
        //     super.new(name);
        // endfunction : new
        //*******************************//
        // TODO: Define Constraints Here //
        //*******************************//
         constraint reset_inactive_mostly {
            Reset dist {0 := 2, 1 := 98}; 
        }
        constraint valid_input_range {
            !(Dn_1 == 1 && Pn == 0 && Dn == 1); 
            !(Dn_1 == 0 && Pn == 1 && Dn == 0); 
        }
       
        // constraint decision_c { 
        //     decision inside {2'b00, 2'b01, 2'b11}; 
        //     }
        // constraint gainsel_c { 
        //     gainsel inside {2'b00, 2'b01, 2'b10, 2'b11}; 
        //     } 
        //*******************************//
        // Define Covergroups Here       //
        //*******************************//

        // Covergroup for phase shift output
        covergroup phase_shift_cg;
            option.per_instance = 1;
            coverpoint phase_shift {
                bins low = {[0:127]};
                bins mid = {[128:383]};
                bins high = {[384:511]};
            }
        endgroup

        // Covergroup for input signals
        covergroup cg_CDR ;

            coverpoint Reset {
                bins active = {1}; 
                bins inactive = {0}; 
            }

            coverpoint Dn_1 {
                bins high_ = {1}; 
                bins low_ = {0}; 
            }
            
            coverpoint Pn {
                bins high_ = {1}; 
                bins low_  = {0}; 
            }

            coverpoint Dn {
                bins high_ = {1}; 
                bins low_  = {0};            
            }

            cross Dn_1,Pn,Dn;
            
        endgroup

        // covergroup internal_signals_cg;
        //     option.per_instance = 1;
        //     coverpoint decision {
        //         bins aligned = {2'b00}; 
        //         bins late    = {2'b01};
        //         bins early   = {2'b11};
        //     }
        //     coverpoint gainsel {
        //         bins gain_00 = {2'b00};
        //         bins gain_01 = {2'b01}; 
        //         bins gain_10 = {2'b10}; 
        //         bins gain_11 = {2'b11}; 
        //     }
        // endgroup

        
        function new(string name = "sequence_item_CDR");
            super.new(name);
            phase_shift_cg = new();
            cg_CDR = new();
            //internal_signals_cg = new();
        endfunction 

        
        function void sample();
            phase_shift_cg.sample();
            cg_CDR.sample();
            //internal_signals_cg.sample();
        endfunction 

        //*******************************//
        // Utility Functions             //
        //*******************************//

        // Convert object to string for logging (includes all signals)
        function string convert2string();
            return $sformatf("Dn_1 = 0b%0b, Pn = 0b%0b, Dn = 0b%0b,phase_shift=0b%08b, Reset = 0b%0b",
                Dn_1,Pn,Dn,phase_shift, Reset);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("Dn_1 = 0b%0b, Pn = 0b%0b, Dn = 0b%0b, Reset = 0b%0b", Dn_1,Pn,Dn, Reset);
        endfunction 
    endclass
endpackage