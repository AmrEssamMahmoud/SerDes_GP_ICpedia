module channel(
    input clk,               // Clock signal
    input real channel_in,   // Input signal
    output real channel_out  // Filtered output signal
);
    real out_prev = 0.0;         // Internal state to store the previous output
    real in_prev = 0.0;           // Internal state to store the previous input   

    always @(posedge clk) begin
        // y[n] = 0.01042 * u[n-1] + 0.9896 * y[n-1]
        out_prev <= 0.01042 * in_prev + 0.9896 * out_prev;
        in_prev <= channel_in;
    end

    assign channel_out = out_prev;

endmodule
