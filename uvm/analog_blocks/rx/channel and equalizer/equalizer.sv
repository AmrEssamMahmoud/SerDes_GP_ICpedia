module equalizer (
    input clk,                // Clock signal
    input real equalizer_in,  // Input signal (filtered by the channel)
    output real equalizer_out // Equalized output signal
);

    real in_prev = 0.0; // Register to store the previous input
    real in_prev_prev = 0.0; // Register to store the previous of previous input
    real out_prev = 0.0; // Register to store the previous output
    real out_prev_prev = 0.0; // Register to store the previous of previous output
    real out;

    always @(posedge clk) begin
        // y[n] = 0.4421 y[n-1] - 0.03657 y[n-2] + 2.003 u[n-1] - 1.409 u[n-2]
        out <= 0.4421*out_prev - 0.03657*out_prev_prev + 2.003*in_prev - 1.409*in_prev_prev;

        in_prev_prev <= equalizer_in; // Update the previous of previous input
        in_prev <= in_prev_prev ; // Update the previous input

        out_prev_prev <= equalizer_out; // Update the previous of previous output
        out_prev <= out_prev_prev; // Update the previous output

        if (out>0.49) begin
          equalizer_out <= 1;
        end else begin
          equalizer_out <= 0;
        end
    end

endmodule