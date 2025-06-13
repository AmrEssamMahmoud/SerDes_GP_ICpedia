module receiver_status (
    input underflow,
    input overflow,
    input skip_added,
    input skip_removed,
    input Disparity_Error,
    input Decode_Error,
    input receiver_detected,
    output [2:0] rx_status
);
    //Design of Receiver status module 
    reg [2:0] RXSTATUS;
    always @(*) begin
        if (skip_added) begin
            RXSTATUS <= 3'b001;
        end 
        if (skip_removed) begin
            RXSTATUS <= 3'b010;
        end
        if (receiver_detected) begin
            RXSTATUS <= 3'b011;
        end
        if(Decode_Error) begin 
            RXSTATUS<=3'b100;
        end         
        if(overflow)begin
            RXSTATUS <= 3'b101;
        end
        if (underflow) begin
            RXSTATUS <= 3'b110;
        end
        if(Disparity_Error) begin 
            RXSTATUS<=3'b111;
        end
        if (!skip_added 
        && !skip_removed 
        && !receiver_detected
        && !Decode_Error
        && !overflow
        && !underflow
        && !Disparity_Error
        ) begin
            RXSTATUS <= 3'b000;
        end
    end
    assign rx_status = RXSTATUS;
endmodule