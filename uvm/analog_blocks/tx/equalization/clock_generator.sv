module clock_generator (
    input clk,
    output clock_with_shift
);

    bit [8:0] shift = 0;
    always @(posedge clk) shift = shift + 10;
    // bit [3:0] counter = 0;
    // always @(posedge clk) begin
    //     counter = counter + 1;
    //     if (counter == 0) begin
    //         shift = shift + 1;
    //     end
    // end

    phase_interpolator phase_interpolator(.clk(clk), .phase_shift(shift), .recovered_clock(clock_with_shift));

endmodule