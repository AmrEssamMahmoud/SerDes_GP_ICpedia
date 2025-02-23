import enums::*;
interface cdr_top_if (TxBitCLK, TxBitCLK_10, RxBitCLK, RxBitCLK_10);
    input TxBitCLK, TxBitCLK_10;
    input RxBitCLK, RxBitCLK_10;
    bit Reset;
    bit TxDataK, RxDataK, Decode_Error, Disparity_Error, data_clock, phase_clock, recovered_clock;
    bit [8:0] phase_shift;
    data_symbol TxParallel_8, RxParallel_8;

    modport DUT (
        input TxBitCLK, TxBitCLK_10, RxBitCLK, RxBitCLK_10, Reset, TxDataK, TxParallel_8, data_clock, phase_clock, recovered_clock,
        output RxDataK, RxParallel_8, Decode_Error, Disparity_Error, phase_shift
    );

endinterface