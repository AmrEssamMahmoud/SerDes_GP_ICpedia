module decoder_tb ();
    
    reg BitCLK_10, Reset, RxDataK;
    reg [9:0] RxParallel_10;
    wire [7:0] RxParallel_8;

    decoder decoder(.BitCLK_10(BitCLK_10), .Reset(Reset), .RxDataK(RxDataK), .RxParallel_8(RxParallel_8), .RxParallel_10(RxParallel_10));

    always #5 BitCLK_10 = ~BitCLK_10;

    initial begin
        BitCLK_10 = 0;
        Reset = 0;
        RxParallel_10 = 0;
        RxDataK = 0;
        #20
        Reset = 1;
        #10
        RxParallel_10 = 10'b0001100010; //D.8.4
        #10
        RxParallel_10 = 10'b1110000101; //D.7.2
        #10
        RxParallel_10 = 10'b1011001000; //D.13.7
        #10
        RxParallel_10 = 10'b0010110111; //D.20.7
        #10
        RxParallel_10 = 10'b0100011000; //K.29.7
        #10

        $stop();
    end

endmodule