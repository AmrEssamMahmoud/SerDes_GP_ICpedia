module assertions_buffer (buffer_if.DUT _if);
    
    // assertion for wrtite and read pointer incrementation 
    // assertion for read and write pointer for stalltion in case of skp and for installtion in case of read while empty and write while full
    // assertion for full and empty flags
    // assertion for reset

    localparam COMMA_SYMBOL = 10'h1BC;
    localparam SKIP_SYMBOL = 10'h1A1;

    property overflow;
        @(posedge _if.recovered_clock)
        disable iff(_if.data_out == SKIP_SYMBOL) (
        _if.data_out == $past(_if.data_in, 1) || _if.data_out == $past(_if.data_in, 1) ||
        _if.data_out == $past(_if.data_in, 2) || _if.data_out == $past(_if.data_in, 3) ||
        _if.data_out == $past(_if.data_in, 4) || _if.data_out == $past(_if.data_in, 5) ||
        _if.data_out == $past(_if.data_in, 6) || _if.data_out == $past(_if.data_in, 7) ||
        _if.data_out == $past(_if.data_in, 8) || _if.data_out == $past(_if.data_in, 9) ||
        _if.data_out == $past(_if.data_in, 10) || _if.data_out == $past(_if.data_in, 11) ||
        _if.data_out == $past(_if.data_in, 12) || _if.data_out == $past(_if.data_in, 13) ||
        _if.data_out == $past(_if.data_in, 14) || _if.data_out == $past(_if.data_in, 15) ||
        _if.data_out == $past(_if.data_in, 16));
    endproperty

    property underflow;
        @(posedge _if.local_clock)
        disable iff(_if.data_out == SKIP_SYMBOL) (
        _if.data_out != $past(_if.data_out, 1) && _if.data_out != $past(_if.data_out, 1) &&
        _if.data_out != $past(_if.data_out, 2) && _if.data_out != $past(_if.data_out, 3) &&
        _if.data_out != $past(_if.data_out, 4) && _if.data_out != $past(_if.data_out, 5) &&
        _if.data_out != $past(_if.data_out, 6) && _if.data_out != $past(_if.data_out, 7) &&
        _if.data_out != $past(_if.data_out, 8) && _if.data_out != $past(_if.data_out, 9) &&
        _if.data_out != $past(_if.data_out, 10) && _if.data_out != $past(_if.data_out, 11) &&
        _if.data_out != $past(_if.data_out, 12) && _if.data_out != $past(_if.data_out, 13) &&
        _if.data_out != $past(_if.data_out, 14) && _if.data_out != $past(_if.data_out, 15) &&
        _if.data_out != $past(_if.data_out, 16));
    endproperty

    overflow_assert: assert property (overflow);
    overflow_cover: cover property (overflow);

    underflow_assert: assert property (underflow);
    underflow_cover: cover property (underflow);

endmodule