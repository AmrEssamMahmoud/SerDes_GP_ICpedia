import enums::*;
interface top_if (TxBitCLK, TxBitCLK_10, RxBitCLK, RxBitCLK_10);
    input TxBitCLK, TxBitCLK_10;
    input RxBitCLK, RxBitCLK_10;
    bit Reset;
    bit TxDataK, RxDataK, Serial_in, Serial_out, data_clock, phase_clock, recovered_clock;
    bit [2:0] rx_status;
    bit [8:0] phase_shift;
    data_symbol TxParallel_8, RxParallel_8;

    modport DUT (
        input TxBitCLK, TxBitCLK_10, RxBitCLK, RxBitCLK_10, Reset, TxDataK, Serial_in, TxParallel_8, data_clock, phase_clock, recovered_clock,
        output RxDataK, RxParallel_8, Serial_out, rx_status, phase_shift
    );

endinterface