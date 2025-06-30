module elastic_buffer (
    input recovered_clock, local_clock, recovered_reset, local_reset,
    input [9:0] data_in,
    output skip_added, skip_removed, underflow, overflow,
    output [9:0] data_out
);

    // Buffer size parameters
    localparam BUFFER_DEPTH = 16;
    localparam ADDRESS_WIDTH = 4;
    
    // SKP handling thresholds
    localparam HALF_FULL = 8;
    localparam ADD_THRESHOLD = 5;
    localparam REMOVE_THRESHOLD = 10;

    wire [ADDRESS_WIDTH:0] write_pointer_async;
    wire [ADDRESS_WIDTH:0] read_pointer_async;

    wire [ADDRESS_WIDTH:0] write_pointer_sync;
    wire [ADDRESS_WIDTH:0] read_pointer_sync;

    buffer_memory #(
        .BUFFER_DEPTH(BUFFER_DEPTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) buffer_memory (
        .recovered_clock(recovered_clock),
        .recovered_reset(recovered_reset),
        .local_clock(local_clock),
        .local_reset(local_reset),
        .write_pointer(write_pointer_async[ADDRESS_WIDTH-1:0]),
        .read_pointer(read_pointer_async[ADDRESS_WIDTH-1:0]),
        .data_in(data_in),
        .data_out(data_out)
    );

    buffer_write #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) buffer_write (
        .recovered_clock(recovered_clock),
        .recovered_reset(recovered_reset),
        .data_in(data_in),
        .read_pointer_sync(read_pointer_sync),
        .write_pointer_async(write_pointer_async),
        .skip_removed(skip_removed),
        .overflow(overflow)
    );

    buffer_read #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) buffer_read (
        .local_clock(local_clock),
        .local_reset(local_reset),
        .data_out(data_out),
        .write_pointer_sync(write_pointer_sync),
        .read_pointer_async(read_pointer_async),
        .skip_added(skip_added),
        .underflow(underflow)
    );

    synchronizer #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) synchronizer_write (
        .clock(recovered_clock),
        .reset(recovered_reset),
        .pointer_async(read_pointer_async),
        .pointer_sync(read_pointer_sync)
    );

    synchronizer #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) synchronizer_read (
        .clock(local_clock),
        .reset(local_reset),
        .pointer_async(write_pointer_async),
        .pointer_sync(write_pointer_sync)
    );

endmodule