import enums::*;
interface equalization_top_if (BitCLK, BitCLK_10);
    input BitCLK, BitCLK_10;
    bit Reset;
    bit TxDataK, RxDataK, Serial_in, Serial_out, Decode_Error, Disparity_Error;
    data_symbol TxParallel_8, RxParallel_8;

    modport DUT (
        input BitCLK, BitCLK_10, Reset, TxDataK, Serial_in, TxParallel_8,
        output RxDataK, RxParallel_8, Serial_out, Decode_Error, Disparity_Error
    );

endinterface