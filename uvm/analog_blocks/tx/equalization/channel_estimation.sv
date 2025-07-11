module channel_estimation (
    input clk,
    input real data,
    output logic [8:0] guess_frequency
);
    
    bit clock_with_shift, opening_ready;
    real sample, opening;

    clock_generator clock_generator(.clk(clk), .clock_with_shift(clock_with_shift));
    eye_sampler eye_sampler(.clock_with_shift(clock_with_shift), .data(data), .sample(sample));
    eye_calculation eye_calculation(.clock_with_shift(clock_with_shift), .sample(sample), .opening(opening), .opening_ready(opening_ready));
    parameter_update parameter_update(.clock_with_shift(clock_with_shift), .opening(opening), .opening_ready(opening_ready), .guess_frequency(guess_frequency));

endmodule