module equalizer #(parameter NOOFBITS = 32,parameter K1=1,parameter K2=1,parameter K3=1, parameter K4=1)(
    input [NOOFBITS-1:0] ip_sig,//we assume that this is a 32 bit unsigned number shifted by 31 bits 
    //So for example if [1010000000...] is actually 1.01000
    output reg [NOOFBITS-1:0] op_sig,
    input clk,
    input rst
);
/*	K1= B(1+1/wT)/((1+tau1/T)*(1+tau2/T)) 
*   K2= B(1/wT)/((1+tau1/T)*(1+tau2/T))
*	K3= (tau1/T+tau2/T+(tau2/T*tau1/T))/((1+tau1/T)*(1+tau2/T))
*	K4= (tau2/T*tau1/T)
*/
reg [NOOFBITS-1:0] prev_ip;
reg [NOOFBITS-1:0] prev_op;
reg [NOOFBITS-1:0] prev_op_bytwoclkcycles;
always @(posedge clk) begin
    if (!rst) begin
        prev_ip<=ip_sig;
        prev_op<=op_sig;
        prev_op_bytwoclkcycles<=prev_op;
        op_sig<=(K1*ip_sig) - (K2*prev_ip) + (K3*prev_op)-(K4*prev_op_bytwoclkcycles);
    end
    else begin
    op_sig<=32'b0;
    prev_ip<=32'b0;
    prev_op<=32'b0;
    prev_op_bytwoclkcycles<=32'b0;
    end
end
endmodule