module top_module (
    input BitCLK,
    input BitCLK_10,
    input Reset,
    input TxDataK,
    input [7:0] TxParallel_8,
    output RxDataK,
    output Disparity_Error,
    output Decode_Error,
    output [7:0] RxParallel_8
);

    wire [9:0] TxParallel_10, RxParallel_10;
    wire Serial;
    
    encoder encoder(.BitCLK_10(BitCLK_10), .Reset(Reset), .TxParallel_8(TxParallel_8), .TxDataK(TxDataK), .TxParallel_10(TxParallel_10));
    PISO PISO(.BitCLK(BitCLK), .Reset(Reset), .Serial(Serial), .TxParallel_10(TxParallel_10));
    SIPO SIPO(.BitCLK(BitCLK), .Reset(Reset), .Serial(Serial), .RxParallel_10(RxParallel_10));
    decoder decoder(.BitCLK_10(BitCLK_10), .Reset(Reset), .RxParallel_10(RxParallel_10), .RxDataK(RxDataK), .RxParallel_8(RxParallel_8), .Decode_Error(Decode_Error), .Disparity_Error(Disparity_Error));

endmodule
