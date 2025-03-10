interface sipo_if (BitCLK);
    input BitCLK;
    bit Reset;
    bit Serial;
    bit [9:0] RxParallel_10;

    modport DUT (
        input BitCLK, Reset, Serial,
        output RxParallel_10
    );

endinterface