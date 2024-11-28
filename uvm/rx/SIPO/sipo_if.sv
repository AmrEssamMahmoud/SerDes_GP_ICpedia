import enums::*;
interface sipo_if (BitCLK);
    input BitCLK;
    bit Reset;
    bit Serial;
    bit Comma;
    bit [9:0] RxParallel_10;

    modport DUT (
        input BitCLK, Reset, Serial, Comma,
        output RxParallel_10
    );

endinterface