interface buffer_if (rclk, lclk);
    input rclk, lclk;
    bit rrst_n, data_in_vld, full, lrst_n, data_out_vld, empty;
    bit [9:0] data_in, data_out;
    
    modport DUT (
        input rclk, rrst_n, data_in, data_in_vld, lclk, lrst_n,
        output full, data_out, data_out_vld, empty
    );

endinterface