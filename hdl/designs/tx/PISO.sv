module PISO(
  input wire[9:0] TxParallel_10,
  input wire BitCLK,
  input wire Reset,
  output wire Serial
  );
reg[9:0] temp_reg;  //temp_reg to hold the input parallel data
reg [3:0] bit_count; //couter to keep track the number of input bits
//shifting the input bits to serialize them 
always @(posedge BitCLK or negedge Reset) begin
  if(!Reset)begin
      temp_reg<=10'b0;
      bit_count<=0;
  end 
  else begin
      if (bit_count == 0) begin
      temp_reg<=TxParallel_10; 
      bit_count<=9;     
      end
      else begin
      temp_reg<=temp_reg>>1;
      bit_count<=bit_count-1;
      end
  end
end
assign Serial = temp_reg[0];
endmodule