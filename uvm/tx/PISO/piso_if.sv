import enums::*;
interface piso_if (BitCLK);
    input BitCLK;
    bit Reset;
    bit Serial;
    bit [9:0] TxParallel_10;
    
    modport DUT (
        input BitCLK, Reset, TxParallel_10,
        output Serial
    );

endinterface