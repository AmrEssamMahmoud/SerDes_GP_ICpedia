module top_module (
    input TxBitCLK, RxBitCLK,
    input TxBitCLK_10, RxBitCLK_10,
    input Reset,
    input TxDataK,
    input Serial_in,
    input [7:0] TxParallel_8,
    input data_clock,
    input phase_clock,
    input recovered_clock,
    output RxDataK,
    output Serial_out,
    output [2:0] rx_status,
    output [7:0] RxParallel_8,
    output [8:0] phase_shift
);

    wire underflow, overflow, skip_added, skip_removed, Disparity_Error, Decode_Error;
    wire [9:0] TxParallel_10, RxParallel_10_unsync, RxParallel_10_sync;

    reg [3:0] counter;
    wire recovered_clock_10;
    
    encoder encoder(
        .BitCLK_10(TxBitCLK_10),
        .Reset(Reset),
        .TxParallel_8(TxParallel_8),
        .TxDataK(TxDataK),
        .TxParallel_10(TxParallel_10)
    );
    
    PISO PISO(
        .BitCLK(TxBitCLK),
        .Reset(Reset),
        .Serial(Serial_out),
        .TxParallel_10(TxParallel_10)
    );
    
    cdr cdr(
        .Reset(Reset),
        .Serial(Serial_in),
        .data_clock(data_clock),
        .phase_clock(phase_clock),
        .recovered_clock(recovered_clock),
        .phase_shift(phase_shift)
    );

    SIPO SIPO(
        .BitCLK(RxBitCLK),
        .Reset(Reset),
        .Serial(Serial_in),
        .RxParallel_10(RxParallel_10_unsync)
    );

    elastic_buffer elastic_buffer(
        .recovered_clock(recovered_clock),
        .local_clock(RxBitCLK),
        .recovered_reset(Reset),
        .local_reset(Reset),
        .data_in(RxParallel_10_unsync),
        .skip_added(skip_added),
        .skip_removed(skip_removed),
        .underflow(underflow),
        .overflow(overflow),
        .data_out(RxParallel_10_sync)
    );

    decoder decoder(
        .BitCLK_10(recovered_clock_10),
        .Reset(Reset),
        .RxParallel_10(RxParallel_10_sync),
        .RxDataK(RxDataK),
        .RxParallel_8(RxParallel_8),
        .Decode_Error(Decode_Error),
        .Disparity_Error(Disparity_Error)
    );

    receiver_status receiver_status (
        .underflow(underflow),
        .overflow(overflow),
        .skip_added(skip_added),
        .skip_removed(skip_removed),
        .Disparity_Error(Disparity_Error),
        .Decode_Error(Decode_Error),
        .rx_status(rx_status)
    );

    assign recovered_clock_10 = counter < 5 ? 1 : 0;
    always @(posedge recovered_clock or negedge Reset) begin
        if (!Reset) begin
            counter <= 0;
        end else begin
            if (counter == 9)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

endmodule
