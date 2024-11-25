interface PISO_Interface(clk);
input clk;
logic[9:0] parallel_in;
logic rst_n;
logic serial_out;
logic [3:0] bit_count;
logic [9:0]temp_reg;

modport DUT (input clk, rst_n, parallel_in, output serial_out,bit_count,temp_reg);
property reset;
	@(posedge PISO_if.clk) (!PISO_if.rst_n) |=> (PISO_if.serial_out==0) ;
endproperty

wr_ack_a:assert property (reset);
wr_ack_c:cover property (reset);

endinterface