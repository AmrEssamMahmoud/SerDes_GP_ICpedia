module cdr_top_module (
    input TxBitCLK, RxBitCLK,
    input TxBitCLK_10, RxBitCLK_10,
    input Reset,
    input TxDataK,
    input [7:0] TxParallel_8,
    input data_clock,
    input phase_clock,
    input recovered_clock,
    output RxDataK,
    output Disparity_Error,
    output Decode_Error,
    output [7:0] RxParallel_8,
    output [8:0] phase_shift
);

    wire [9:0] TxParallel_10, RxParallel_10;
    wire Serial;

    reg [3:0] counter;
    wire recovered_clock_10;
    assign recovered_clock_10 = recovered_clock == 1 ? 1 : 0;
    
    encoder encoder(.BitCLK_10(TxBitCLK_10), .Reset(Reset), .TxParallel_8(TxParallel_8), .TxDataK(TxDataK), .TxParallel_10(TxParallel_10));
    PISO PISO(.BitCLK(TxBitCLK), .Reset(Reset), .Serial(Serial), .TxParallel_10(TxParallel_10));
    SIPO SIPO(.BitCLK(recovered_clock), .Reset(Reset), .Serial(Serial), .RxParallel_10(RxParallel_10));
    decoder decoder(.BitCLK_10(recovered_clock_10), .Reset(Reset), .RxParallel_10(RxParallel_10), .RxDataK(RxDataK), .RxParallel_8(RxParallel_8), .Decode_Error(Decode_Error), .Disparity_Error(Disparity_Error));

    cdr cdr(.Reset(Reset), .Serial(Serial), .data_clock(data_clock), .phase_clock(phase_clock), .recovered_clock(recovered_clock), .phase_shift(phase_shift));

    always @(posedge recovered_clock or negedge Reset) begin
        if (!Reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
