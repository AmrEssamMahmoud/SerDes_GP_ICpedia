module encoder_tb ();

    reg BitCLK_10, Reset, TxDataK;
    reg [7:0] TxParallel_8;
    wire [9:0] TxParallel_10;

    encoder encoder(.BitCLK_10(BitCLK_10), .Reset(Reset), .TxDataK(TxDataK), .TxParallel_8(TxParallel_8), .TxParallel_10(TxParallel_10));

    always #5 BitCLK_10 = ~BitCLK_10;

    initial begin
        BitCLK_10 = 0;
        Reset = 0;
        TxParallel_8 = 0;
        TxDataK = 0;
        #20
        Reset = 1;
        #10
        TxParallel_8 = 8'b01010110; //D.22.2
        #10
        TxParallel_8 = 8'b11100101; //D.5.7
        #10
        TxParallel_8 = 8'b10101101; //D.13.5
        #10
        TxParallel_8 = 8'b00110001; //D.17.1
        #10
        TxDataK = 1;
        TxParallel_8 = 8'b11111100; //K.28.7
        #10

        $stop();
    end

endmodule