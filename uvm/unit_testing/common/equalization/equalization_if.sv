import enums::*;
interface equalization_if (TxBitCLK);
    input TxBitCLK;
    bit Reset;
    bit Serial_in, Serial_out;
    
    modport DUT (
        input TxBitCLK, Serial_in,
        output Serial_out
    );

endinterface