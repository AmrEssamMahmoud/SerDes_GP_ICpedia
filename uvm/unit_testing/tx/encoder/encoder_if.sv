import enums::*;
interface encoder_if (BitCLK_10);
    input BitCLK_10;
    bit Reset;
    bit TxDataK;
    data_symbol TxParallel_8;
    bit [9:0] TxParallel_10;
    
    modport DUT (
        input BitCLK_10, Reset, TxDataK, TxParallel_8,
        output TxParallel_10
    );

endinterface