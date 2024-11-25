module PISO_tb();
  reg[9:0] TxParallel_10;
  reg BitCLK;
  reg Reset;
  wire Serial;
  
  always #5 BitCLK=~BitCLK;
  PISO dut(.TxParallel_10(TxParallel_10),.BitCLK(BitCLK),.Reset(Reset),.Serial(Serial));
  
  initial begin
    BitCLK=0;
    Reset = 0;
    TxParallel_10 = 10'b1001010010;
    #20
    Reset = 1;
    TxParallel_10 = 10'b1001011011;
    #100
    TxParallel_10 = 10'b0111111110;
    #100
    TxParallel_10 = 10'b0101010101;
    $stop();
  end
  endmodule