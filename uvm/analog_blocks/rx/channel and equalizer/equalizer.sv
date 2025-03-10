module equalizer (
    input clk,                // Clock signal
    input real equalizer_in,  // Input signal (filtered by the channel)
    output real equalizer_out, // Equalized output signal (after quantization)
);

    real in_prev = 0.0; // Register to store the previous input
    real in_prev_prev = 0.0; // Register to store the previous of previous input
    real out_prev = 0.0; // Register to store the previous output
    real out_prev_prev = 0.0; // Register to store the previous of previous output
    real out;
    always @(posedge clk) begin
        // y[n] = 1.946 y[n-1] - 0.9464 y[n-2] + 0.1259 u[n-1] - 0.1252 u[n-2]
        out <= 1.946 * out_prev - 0.9464 * out_prev_prev + 0.1259 * in_prev - 0.1252 * in_prev_prev;

        in_prev <= equalizer_in  ; // Update the previous input
        in_prev_prev <= in_prev; // Update the previous of previous input

        out_prev <= out ; // Update the previous output
        out_prev_prev <= out_prev ; // Update the previous of previous output
        
        if (out >= 0.49427) begin
          equalizer_out <= 1;
        end else begin
          equalizer_out <= 0;
        end
    end

endmodule