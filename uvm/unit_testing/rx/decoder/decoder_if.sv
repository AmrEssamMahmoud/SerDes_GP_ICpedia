import enums::*;
interface decoder_if (BitCLK_10);
    input BitCLK_10;
    bit Reset;
    bit RxDataK;
    bit Disparity_Error;
    bit Decode_Error;
    data_symbol RxParallel_8;
    bit [9:0] RxParallel_10;
    
    modport DUT (
        input BitCLK_10, Reset, RxParallel_10,
        output RxDataK, RxParallel_8, Decode_Error, Disparity_Error
    );

endinterface