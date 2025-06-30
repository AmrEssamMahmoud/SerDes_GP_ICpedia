module receiver_status (
    input underflow,
    input overflow,
    input skip_added,
    input skip_removed,
    input Disparity_Error,
    input Decode_Error,
    output reg [2:0] rx_status
);

    always @(*) begin
        if (skip_added) begin
            rx_status <= 3'b001;
        end else if (skip_removed) begin
            rx_status <= 3'b010;
        end else if (Decode_Error) begin 
            rx_status <= 3'b100;
        end else if (overflow) begin
            rx_status <= 3'b101;
        end else if (underflow) begin
            rx_status <= 3'b110;
        end else if (Disparity_Error) begin 
            rx_status <= 3'b111;
        end else begin
            rx_status <= 3'b011; // the default case is that the receiver is always detected
        end
    end

endmodule