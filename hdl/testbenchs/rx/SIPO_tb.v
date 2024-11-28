module SIPO_tb();
  reg BitCLK;
  reg Reset;
  wire [9:0] RxParallel_10;
  reg Serial;

  always #5 BitCLK=~BitCLK;

  SIPO SIPO(.RxParallel_10(RxParallel_10),.BitCLK(BitCLK),.Reset(Reset),.Serial(Serial));
  
  initial begin
    BitCLK=0;
    Reset = 0;
    Serial = 0;
    #20
    Reset = 1;
    #10
    repeat(100) begin
      Serial = $urandom%10;
      #10;
    end
    $stop();
  end
  endmodule