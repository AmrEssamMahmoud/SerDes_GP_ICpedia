module channel #(
    parameter real T = 1.0e-12,  // Sampling period
    parameter real TAU = 200.0e-12 // Time constant (TAU = 1/w_c)
) (
    input clk,               // Clock signal
    input real channel_in,   // Input signal
    output real channel_out  // Filtered output signal
);

    real alpha = T / (T + TAU); // Filter coefficient
    real reg_out = 0.0;         // Internal state to store the previous output

    always @(posedge clk) begin
        // y[n] = alpha * x[n] + (1 - alpha) * y[n-1]
        reg_out <= alpha * channel_in + (1.0 - alpha) * reg_out;
    end

    assign channel_out = reg_out;

endmodule