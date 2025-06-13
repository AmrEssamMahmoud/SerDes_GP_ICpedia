interface rx_statusifc(input bit clk);
    bit underflow;
    bit overflow;
    bit skip_added;
    bit skip_removed;
    bit Disparity_Error;
    bit Decode_Error;
    bit receiver_detected;
    logic [2:0] rx_status;
    modport driver (
        input underflow,
        input overflow,
        input skip_added,
        input skip_removed,
        input Disparity_Error,
        input Decode_Error,
        input receiver_detected,
        input [2:0] rx_status
    );
    modport monitor (
        output underflow,
        output overflow,
        output skip_added,
        output skip_removed,
        output Disparity_Error,
        output Decode_Error,
        output receiver_detected,
        output [2:0] rx_status
    );
    modport scoreboard (
        input underflow,
        input overflow,
        input skip_added,
        input skip_removed,
        input Disparity_Error,
        input Decode_Error,
        input receiver_detected,
        input [2:0] rx_status
    );
    modport dut(
        input underflow,
        input overflow,
        input skip_added,
        input skip_removed,
        input Disparity_Error,
        input Decode_Error,
        input receiver_detected,
        output [2:0] rx_status
    );
endinterface