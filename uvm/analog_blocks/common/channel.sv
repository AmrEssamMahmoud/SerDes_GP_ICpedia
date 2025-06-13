module channel(
    input clk,               // Clock signal
    input real channel_in,   // Input signal
    output real channel_out  // Filtered output signal
);
    real out_prev = 0.0;         // Internal state to store the previous output
    real in_prev = 0.0;           // Internal state to store the previous input   
    real frequency = 830e6;
    real c1 = 2.7182818284 ** (-1.2566370614e-11 * frequency);
    real c2 = 1 - c1;

    always @(posedge clk) begin
        // y[n] = 0.01042 * u[n-1] + 0.9896 * y[n-1]
        out_prev <= c2 * in_prev + c1 * out_prev;
        in_prev <= channel_in;
    end

    assign channel_out = out_prev;

endmodule
