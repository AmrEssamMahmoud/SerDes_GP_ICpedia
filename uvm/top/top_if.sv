import enums::*;
interface top_if (BitCLK, BitCLK_10);
    input BitCLK, BitCLK_10;
    bit Reset;
    bit TxDataK, RxDataK;
    data_symbol TxParallel_8, RxParallel_8;

    modport DUT (
        input BitCLK, BitCLK_10, Reset, TxDataK, TxParallel_8,
        output RxDataK, RxParallel_8
    );

endinterface