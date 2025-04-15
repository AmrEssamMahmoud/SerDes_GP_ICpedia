module equalizer (
    input clk,                // Clock signal
    input real equalizer_in,  // Input signal (filtered by the channel)
    input real frequency,
    output real equalizer_out // Equalized output signal (after quantization)
);

    real in_prev = 0.0; // Register to store the previous input
    real in_prev_prev = 0.0; // Register to store the previous of previous input
    real out_prev = 0.0; // Register to store the previous output
    real out_prev_prev = 0.0; // Register to store the previous of previous output
    real c1, c2;

    always @(posedge clk) begin
        // y[n] = 1.424 y[n-1] - 0.5001 y[n-2] + 7.264 u[n-1] - 7.188 u[n-2]
        c1 = 0.0425434079+6019033046.3/frequency;
        c2 = 0.0337683818-6019033046.3/frequency;
        out_prev <= 1.424 * out_prev - 0.5001 * out_prev_prev + c1 * in_prev + c2 * in_prev_prev;
        
        in_prev <= equalizer_in  ; // Update the previous input
        in_prev_prev <= in_prev; // Update the previous of previous input
        out_prev_prev <= out_prev ; // Update the previous of previous output
        
        if (out_prev >= 0.49427) begin
          equalizer_out <= 1;
        end else begin
          equalizer_out <= 0;
        end
    end

endmodule
