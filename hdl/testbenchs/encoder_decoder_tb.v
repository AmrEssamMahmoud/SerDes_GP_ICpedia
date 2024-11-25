module encoder_decoder_tb ();
    
    reg BitCLK_10, Reset, DataK;
    wire [9:0] Parallel_10;
    wire [7:0] RxParallel_8;
    reg [7:0] TxParallel_8;

    encoder encoder(.BitCLK_10(BitCLK_10), .Reset(Reset), .TxDataK(DataK), .TxParallel_8(TxParallel_8), .TxParallel_10(Parallel_10));
    decoder decoder(.BitCLK_10(BitCLK_10), .Reset(Reset), .RxDataK(DataK), .RxParallel_8(RxParallel_8), .RxParallel_10(Parallel_10));

    always #5 BitCLK_10 = ~BitCLK_10;

    initial begin
        BitCLK_10 = 0;
        Reset = 0;
        DataK = 0;
        TxParallel_8 = 0;
        #20
        Reset = 1;
        #10
        TxParallel_8 = 61;
        #10
        TxParallel_8 = 153;
        #10
        TxParallel_8 = 13;
        #10
        TxParallel_8 = 95;
        #10
        TxParallel_8 = 186;
        #10
        TxParallel_8 = 130;
        #10
        TxParallel_8 = 68;
        #10

        $stop();
        
    end

endmodule