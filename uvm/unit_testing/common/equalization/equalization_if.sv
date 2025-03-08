import enums::*;
interface equalization_if (BitCLK);
    input BitCLK;
    bit Reset;
    bit Serial_in, Serial_out;
    
    modport DUT (
        input BitCLK, Serial_in,
        output Serial_out
    );

endinterface