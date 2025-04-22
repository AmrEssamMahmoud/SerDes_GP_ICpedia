interface buffer_if (recovered_clock, local_clock);
    input recovered_clock, local_clock;
    bit recovered_reset, local_reset, underflow, overflow, skip_added, skip_removed;
    bit [9:0] data_in, data_out;
    
    modport DUT (
        input recovered_clock, recovered_reset, local_clock, local_reset, data_in,
        output data_out, underflow, overflow, skip_added, skip_removed
    );

endinterface