module assertions_cdr(
    cdr_if.DUT _if
);

sequence reset_seq1;
    !_if.Reset; // Reset signal is not active
endsequence

sequence reset_seq2;
    (_if.phase_shift == 0); // Phase shift must be 0 during reset
endsequence

property reset_prop;
    @(posedge _if.BitCLK)
    reset_seq1 |=> reset_seq2; // When Reset is deasserted, phase_shift should be 0
endproperty

// Assertion for Reset Behavior
RESET_ASSERT: assert property (reset_prop)
    else $display("Reset Assertion Failed: phase_shift is not 0 during Reset");

// Coverage for Reset Behavior
COVER_RESET: cover property (reset_prop)
    $display("Reset coverage triggered");

// sequence no_transition_seq1;
//     (_if.Reset==1 &&  (((_if.Dn ^ _if.Pn) && (_if.Pn ^ _if.Dn_1))|| (!(_if.Dn ^ _if.Pn) && !(_if.Pn ^ _if.Dn_1)))); // No transition condition
// endsequence

// sequence no_transition_seq2;
//     (_if.phase_shift == $past(_if.phase_shift)); // Phase shift remains unchanged
// endsequence

// property no_transition_prop;
//     @(posedge _if.BitCLK)
//     no_transition_seq1 |-> no_transition_seq2;
// endproperty

// // Assertion for No Transition
// NO_TRANSITION_ASSERT: assert property (no_transition_prop)
//     else $display("Phase Shift Assertion Failed for No Transition");

// // Coverage for No Transition
// COVER_NO_TRANSITION: cover property (no_transition_prop)
//     $display("No transition coverage triggered");

// sequence early_seq1;
//     (_if.Reset && ((_if.Dn ^ _if.Pn) && !(_if.Pn ^ _if.Dn_1))); // Early transition condition
//  //(_if.Reset && (_if.decision==2'b11));//دي او اللي فوقيها المفروض ينفعوا
// endsequence

// sequence early_seq2;
//     (_if.phase_shift == (
//         (_if.gainsel == 0) ? ($past(_if.phase_shift) - 1) :
//         (_if.gainsel == 1) ? ($past(_if.phase_shift) - 2) :
//         ($past(_if.phase_shift) - 4))); //دي او نفس طريقة الشيفت اللي تحت
// endsequence

// property early_prop;
//     @(posedge _if.BitCLK)
//     early_seq1 |-> early_seq2;
// endproperty

// // Assertion for Early Transition
// EARLY_ASSERT: assert property (early_prop)
//     else $display("Phase Shift Assertion Failed for Early Transition");

// // Coverage for Early Transition
// COVER_EARLY: cover property (early_prop)
//     $display("Early transition coverage triggered");

// sequence late_seq1;
//     (_if.Reset && ((_if.Dn ^ _if.Pn) && !(_if.Pn ^ _if.Dn_1))); // Late transition condition
// endsequence

// sequence late_seq2;
//     (_if.phase_shift == $past(_if.phase_shift) + (3'b001<<_if.gainsel)); // Phase shift increases by 1
// endsequence

// property late_prop;
//     @(posedge _if.BitCLK)
//     late_seq1 |-> late_seq2;
// endproperty

// // Assertion for Late Transition
// LATE_ASSERT: assert property (late_prop)
//     else $display("Phase Shift Assertion Failed for Late Transition");

// // Coverage for Late Transition
// COVER_LATE: cover property (late_prop)
//     $display("Late transition coverage triggered");

endmodule
