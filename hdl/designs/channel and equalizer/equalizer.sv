module equalizer #(
    parameter real T = 1.0e-3,  // Sampling period
    parameter real TAU = 1.0e-3 // Time constant (τ = 1/ω_c)
) (
    input  real equalizer_in,  // Input signal (filtered by the channel)
    output real equalizer_out  // Equalized output signal
);

    real x_prev = 0.0; // Register to store the previous input

    always @(equalizer_in) begin
        // y[n] = x[n] + (TAU / T) * (x[n] - x[n-1])
        equalizer_out = equalizer_in + (TAU / T) * (equalizer_in - x_prev);
        x_prev = equalizer_in; // Update the previous input
    end

endmodule