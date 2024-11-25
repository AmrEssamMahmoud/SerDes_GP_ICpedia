package PISO_sequence_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class PISO_sequence_item extends uvm_sequence_item ;
`uvm_object_utils(PISO_sequence_item)

rand bit rst_n;
rand bit [9:0] parallel_in;
logic serial_out;

// Constraints // 

constraint Assert_reset_less_often {
                    rst_n dist {1:=98 ,0:=2};
} 


constraint random_bit_patterns {
   parallel_in dist {
      10'b0000000000 :/ 10, 
      10'b1111111111 :/ 10,  
      10'b1010101010 :/ 10,  
      10'b0101010101 :/ 10,  
      [10'b0000000001 : 10'b1111111110] :/ 60
   };
}


constraint corner_parallel_in {
   parallel_in inside {10'b0000000000, 10'b1111111111, 10'b1010101010, 10'b0101010101};
}





function new ( string name = "PISO_sequence_item");
  super.new(name);
endfunction

function string convert2string ();
return $sformatf("%s rst_n = 0b%0b,  parallel_in = 0b%0b, serial_out = 0b%0b",super.convert2string(),rst_n, parallel_in, serial_out);
endfunction

function string convert2string_stimulus ();
return $sformatf("rst_n = 0b%0b,  parallel_in = 0b%0b",rst_n, parallel_in);
endfunction



endclass


endpackage