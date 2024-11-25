interface top_if (BitCLK, BitCLK_10_Tx, BitCLK_10_Rx);
    input BitCLK, BitCLK_10_Tx, BitCLK_10_Rx;
    logic Reset;
    logic TxDataK, RxDataK;
    logic TxParallel_8, RxParallel_8;
endinterface